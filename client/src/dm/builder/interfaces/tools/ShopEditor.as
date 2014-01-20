package dm.builder.interfaces.tools {
	import com.bit101.components.CheckBox;
	import com.bit101.components.InputText;
	import com.bit101.components.List;
	import com.bit101.components.PushButton;
	import dm.builder.interfaces.BuilderLabel;
	import dm.builder.interfaces.SearchList;
	import dm.game.managers.MyManager;
	import dm.game.windows.alert.Alert;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import utils.AMFPHP;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class ShopEditor extends SearchList {
		private var label_ti:InputText;
		private var sellProc_ti:InputText;
		private var buyProc_ti:InputText;
		private var idValue_lbl:BuilderLabel;
		private var allItem_list:List;
		private var isBuying_cb:CheckBox;
		private var shopItem_list:List;
		private var addItem_btn:PushButton;
		private var removeItem_btn:PushButton;
		
		private var _allItems:Array;
		
		public function ShopEditor(parent:DisplayObjectContainer) {
			_width = 500;
			
			super(parent, "Shop editor");
		}
		
		override public function initialize():void {
			super.initialize();
			
			new AMFPHP(onAllItems).xcall("dm.Item.getUserItems", MyManager.instance.id);
			new AMFPHP(onShops).xcall("dm.Shop.getUserShops", MyManager.instance.id);
		}
		
		private function onShopItemSelect(e:Event):void {
			removeItem_btn.enabled = true;
		}
		
		private function onAllItemSelect(e:Event):void {
			addItem_btn.enabled = true;
		}
		
		private function onShopSelect(e:Event):void {
			allItem_list.items = _allItems.concat();
			if (item_list.selectedItem.id != 0)
				new AMFPHP(onShopData).xcall("dm.Shop.getShopById", item_list.selectedItem.id);
			else
				clearData();
		}
		
		private function onShopData(response:Object):void {
			label_ti.text = response.label;
			idValue_lbl.text = response.id;
			sellProc_ti.text = response.sell_proc;
			buyProc_ti.text = response.buy_proc;
			
			isBuying_cb.selected = Boolean(int(response.is_buying));
			
			if (response.items)
				shopItem_list.items = response.items;
			else 
				shopItem_list.removeAll();
		}
		
		private function clearData():void {
			label_ti.text = "";
			idValue_lbl.text = "";
			sellProc_ti.text = "0";
			buyProc_ti.text = "0";
			isBuying_cb.selected = false;
			
			shopItem_list.removeAll();
			
			addItem_btn.enabled = false;
			removeItem_btn.enabled = false;
		}
		
		private function onShops(response:Object):void {
			items = response as Array;
		}
		
		private function onAllItems(response:Object):void {
			_allItems = response as Array;
			allItem_list.items = _allItems.concat();
		}
		
		override protected function createGUI():void {
			super.createGUI();
			
			bodyHeight += 80;
			item_list.height += 50;
			
			var maxLabelWidth:Number = 77;
			
			var label_lbl:BuilderLabel = new BuilderLabel(_body, item_list.x + item_list.width + 20, 10, "Label: ");
			label_lbl.width = maxLabelWidth;
			label_lbl.textAlign = "right";
			label_ti = new InputText(_body, label_lbl.x + label_lbl.width + 5, label_lbl.y);
			
			var id_lbl:BuilderLabel = new BuilderLabel(_body, label_ti.x + label_ti.width + 15, label_ti.y, "Id: ");
			idValue_lbl = new BuilderLabel(_body, id_lbl.x + id_lbl.textWidth + 5, id_lbl.y, "0");
			
			var sellProc_lbl:BuilderLabel = new BuilderLabel(_body, label_lbl.x, label_lbl.y + 30, "Sell %: ");
			sellProc_lbl.width = maxLabelWidth;
			sellProc_lbl.textAlign = "right";
			sellProc_ti = new InputText(_body, sellProc_lbl.x + sellProc_lbl.width + 5, sellProc_lbl.y);
			sellProc_ti.width = 50;
			
			var buyProc_lbl:BuilderLabel = new BuilderLabel(_body, sellProc_ti.x + sellProc_ti.width + 20, sellProc_ti.y, "Buy %: ");
			buyProc_ti = new InputText(_body, buyProc_lbl.x + buyProc_lbl.textWidth + 5, buyProc_lbl.y);
			buyProc_ti.width = 50;
			
			var isBuying_lbl:BuilderLabel = new BuilderLabel(_body, sellProc_lbl.x, sellProc_lbl.y + 30, "Is buying: ");
			isBuying_lbl.width = maxLabelWidth;
			isBuying_lbl.textAlign = "right";
			isBuying_cb = new CheckBox(_body, isBuying_lbl.x + isBuying_lbl.width + 5, isBuying_lbl.y + 5);
			
			var allItems_lbl:BuilderLabel = new BuilderLabel(_body, isBuying_lbl.x + 20, isBuying_lbl.y + 30, "All items: ");
			allItem_list = new List(_body, allItems_lbl.x, allItems_lbl.y + 20);
			
			var shopItems_lbl:BuilderLabel = new BuilderLabel(_body, allItems_lbl.x + 130, allItems_lbl.y, "Shop items: ");
			shopItem_list = new List(_body, shopItems_lbl.x, shopItems_lbl.y + 20);
			
			addItem_btn = new PushButton(_body, allItem_list.x + allItem_list.width + 5, allItem_list.y + 20, ">", onAddItemBtn);
			addItem_btn.width = 20;
			removeItem_btn = new PushButton(_body, addItem_btn.x, addItem_btn.y + 40, "<", onRemoveItemBtn);
			removeItem_btn.width = addItem_btn.width;
			
			var add_btn:PushButton = new PushButton(_body, item_list.x, item_list.y + item_list.height + 5, _("Add"), onAddBtn);
			add_btn.width = 60;
			
			var save_btn:PushButton = new PushButton(_body, allItem_list.x, allItem_list.y + allItem_list.height + 20, _("Save"), onSaveBtn);
			save_btn.x = allItems_lbl.x + allItems_lbl.width;
			
			item_list.addEventListener(Event.SELECT, onShopSelect);
			allItem_list.addEventListener(Event.SELECT, onAllItemSelect);
			shopItem_list.addEventListener(Event.SELECT, onShopItemSelect);
		}
		
		private function onAddBtn(e:Event):void {
			item_list.addItemAt({id: 0, label: "New shop"}, 0);
			item_list.selectedIndex = 0;
		}
		
		private function onSaveBtn(e:Event):void {
			if (int(buyProc_ti.text) < 0 && int(buyProc_ti.text) > 100) {
				Alert.show("Buy % should be between 0 and 100");
				buyProc_ti.text = "";
				stage.focus = buyProc_ti;
				return;
			}
			
			var shop:Object = {id: item_list.selectedItem.id, label: label_ti.text, sell_proc: sellProc_ti.text, buy_proc: buyProc_ti.text, is_buying: int(isBuying_cb.selected), itemIds: []};
			for each (var item:Object in shopItem_list.items)
				shop.itemIds.push(item.id);
			new AMFPHP(onShopSave).xcall("dm.Shop.saveShop", shop, MyManager.instance.id);
		}
		
		private function onShopSave(response:Object):void {
			trace(response);
			new AMFPHP(onShops).xcall("dm.Shop.getUserShops", MyManager.instance.id);			
		}
		
		private function onRemoveItemBtn(e:Event):void {
			allItem_list.addItem(shopItem_list.selectedItem);
			shopItem_list.removeItemAt(shopItem_list.selectedIndex);
		}
		
		private function onAddItemBtn(e:Event):void {
			shopItem_list.addItem(allItem_list.selectedItem);
			allItem_list.removeItemAt(allItem_list.selectedIndex);
		}
	}

}