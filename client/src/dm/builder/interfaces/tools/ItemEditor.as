package dm.builder.interfaces.tools {
	
	import com.bit101.components.CheckBox;
	import com.bit101.components.ColorChooser;
	import com.bit101.components.ComboBox;
	import com.bit101.components.InputText;
	import com.bit101.components.PushButton;
	import com.bit101.components.TextArea;
	import dm.builder.interfaces.BuilderLabel;
	import dm.builder.interfaces.FunctionsAndConditions;
	import dm.builder.interfaces.SearchListWithCategories;
	import dm.builder.interfaces.WindowManager;
	import dm.game.managers.MyManager;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import utils.AMFPHP;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class ItemEditor extends SearchListWithCategories {
		
		private var label_ti:InputText;
		private var description_ti:TextArea;
		private var color_cc:ColorChooser;
		private var icon_cb:ComboBox;
		private var idValue_lbl:BuilderLabel;
		private var functionsAndConditions:FunctionsAndConditions;
		private var useCount_ti:InputText;
		private var cooldown_ti:InputText;
		private var category_cb:ComboBox;
		private var price_ti:InputText;
		private var isSellable_cb:CheckBox;
		
		public function ItemEditor(parent:DisplayObjectContainer) {
			_width = 500;
			super(parent, "Item editor", 3);
			categoriesLoadedSignal.add(onCategories);
			bodyHeight += 390;
			refreshItemList();
		}
		
		private function onCategories(response:Object):void {
			category_cb.items = categoryFilter_cb.items;
		}
		
		private function refreshItemList():void {
			var amfphp:AMFPHP = new AMFPHP(onItems).xcall("dm.Item.getUserItems", MyManager.instance.id);
		}
		
		private function onItems(response:Object):void {
			items = response as Array;
		}
		
		override protected function onSelect(e:Event):void {
			if (item_list.selectedItem.id != 0)
				var amfphp:AMFPHP = new AMFPHP(onItemInfo).xcall("dm.Item.getItemById", item_list.selectedItem.id);
			else
				clearData();
		}
		
		private function clearData():void {
			idValue_lbl.text = "0";
			label_ti.text = "";
			icon_cb.selectedIndex = 0;
			description_ti.text = "";
			color_cc.value = 0xFFFFFF;
			price_ti.text = "0";
			isSellable_cb.selected = true;
			functionsAndConditions.clearLists();
		}
		
		private function onItemInfo(response:Object):void {
			var item:Object;
			label_ti.text = response.label;
			idValue_lbl.text = response.id;
			for each (item in icon_cb.items)
				if (item == response.icon)
					icon_cb.selectedIndex = icon_cb.items.indexOf(item);
			for each (item in category_cb.items)
					if (item.id == response.category_id)
						category_cb.selectedItem = item;
			description_ti.text = response.description;
			color_cc.value = uint(response.color);
			price_ti.text = response.price;
			isSellable_cb.selected = Boolean(int(response.is_sellable));
			useCount_ti.text = response.number_of_uses;
			cooldown_ti.text = response.cooldown;
			functionsAndConditions.setConditions(response.conditions);
			functionsAndConditions.setFunctions(response.functions);
		}
		
		override protected function createGUI():void {
			super.createGUI();
			
			item_list.height += 330;
			
			var addItem_btn:PushButton = new PushButton(_body, item_list.x, item_list.y + item_list.height + 5, _("Add"), onAddItemBtn);
			
			var maxLabelWidth:Number = 77;
			
			var label_lbl:BuilderLabel = new BuilderLabel(_body, item_list.x + item_list.width + 20, 10, "Label: ");
			label_lbl.width = maxLabelWidth;
			label_lbl.textAlign = "right";
			label_ti = new InputText(_body, label_lbl.x + label_lbl.width + 5, label_lbl.y);
			
			var id_lbl:BuilderLabel = new BuilderLabel(_body, label_ti.x + label_ti.width + 15, label_ti.y, "Id: ");
			idValue_lbl = new BuilderLabel(_body, id_lbl.x + id_lbl.textWidth + 5, id_lbl.y, "0");
			
			var category_lbl:BuilderLabel = new BuilderLabel(_body, label_lbl.x, label_lbl.y + 25, _("Category") + ": ");
			category_lbl.width = maxLabelWidth;
			category_lbl.textAlign = "right";
			category_cb = new ComboBox(_body, category_lbl.x + category_lbl.width + 5, category_lbl.y);
			
			var icon_lbl:BuilderLabel = new BuilderLabel(_body, category_lbl.x, category_lbl.y + 30, "Icon: ");
			icon_lbl.width = maxLabelWidth;
			icon_lbl.textAlign = "right";
			icon_cb = new ComboBox(_body, icon_lbl.x + icon_lbl.width + 5, icon_lbl.y);
			icon_cb.items = ["book", "brush", "chicken", "coffee", "dvd", "fork", "gift", "keys", "notes", "pc", "phone", "pliers", "q", "trash", "trumpet", "tshirt", "wallet", "resources", "streams", "relationship", "channels", "cost", "segment", "activities", "partners", "proposition", "diplomas"];
			icon_cb.selectedIndex = 0;
			
			var description_lbl:BuilderLabel = new BuilderLabel(_body, icon_lbl.x, icon_lbl.y + 30, _("Description") + ": ");
			description_lbl.width = maxLabelWidth;
			description_lbl.textAlign = "right";
			description_ti = new TextArea(_body, description_lbl.x + description_lbl.width + 5, description_lbl.y);
			
			var useCount_lbl:BuilderLabel = new BuilderLabel(_body, description_lbl.x, description_ti.y + description_ti.height + 10, _("Number of uses") + ": ");
			useCount_lbl.width = maxLabelWidth;
			useCount_lbl.textAlign = "right";
			useCount_ti = new InputText(_body, useCount_lbl.x + useCount_lbl.width + 5, useCount_lbl.y, "0");
			useCount_ti.width = 30;
			useCount_ti.restrict = "0-9";
			
			var cooldown_lbl:BuilderLabel = new BuilderLabel(_body, useCount_ti.x + useCount_ti.width + 10, useCount_lbl.y, _("Cooldown") + ": ");
			cooldown_ti = new InputText(_body, cooldown_lbl.x + cooldown_lbl.textWidth + 5, cooldown_lbl.y, "0");
			cooldown_ti.width = 30;
			cooldown_ti.restrict = "0-9";
			
			var color_lbl:BuilderLabel = new BuilderLabel(_body, useCount_lbl.x, cooldown_ti.y + cooldown_ti.height + 20, _("Color") + ": ");
			color_lbl.width = maxLabelWidth;
			color_lbl.textAlign = "right";
			color_cc = new ColorChooser(_body, color_lbl.x + color_lbl.width + 5, color_lbl.y);
			color_cc.usePopup = true;
			color_cc.value = 0xFFFFFF;
			
			var isSellable_lbl:BuilderLabel = new BuilderLabel(_body, color_lbl.x, color_lbl.y + 30, _("Is sellable") + ": ");
			isSellable_lbl.width = maxLabelWidth;
			isSellable_lbl.textAlign = "right";
			isSellable_cb = new CheckBox(_body, isSellable_lbl.x + isSellable_lbl.width + 5, isSellable_lbl.y + 5, "");
			
			var price_lbl:BuilderLabel = new BuilderLabel(_body, isSellable_cb.x + isSellable_cb.width + 20, isSellable_lbl.y, _("Price") + ": ");
			price_ti = new InputText(_body, price_lbl.x + price_lbl.textWidth + 5, price_lbl.y, "0");
			price_ti.width = 100;
			price_ti.restrict = "0-9";
			
			functionsAndConditions = new FunctionsAndConditions(_body, new Point(isSellable_lbl.x + 50, isSellable_lbl.y + 20));
			functionsAndConditions.hideHeader();
			
			var save_btn:PushButton = new PushButton(_body, _width * 0.5, price_lbl.y + 10 + functionsAndConditions.height + 30, _("Save"), onSaveBtn);
			save_btn.x -= save_btn.width * 0.5;
		}

		
		private function onAddItemBtn(e:MouseEvent):void {
			item_list.addItemAt({id: 0, label: "New item"}, 0);
			item_list.selectedIndex = 0;
		}
		
		private function onSaveBtn(e:MouseEvent):void {
			if (label_ti.text == "") {
				WindowManager.instance.dispatchMessage("Enter interaction label.");
				return;
			}
			var item:Object = {id: item_list.selectedItem.id, label: label_ti.text, icon: icon_cb.selectedItem, description: description_ti.text, useCount: useCount_ti.text, cooldown: cooldown_ti.text, color: color_cc.value, is_sellable: int(isSellable_cb.selected), price: price_ti.text, functionIds: functionsAndConditions.getFunctionIds(), conditionIds: functionsAndConditions.getConditionIds(), category_id: category_cb.selectedItem.id};
			var amfphp:AMFPHP = new AMFPHP(onItemSaved).xcall("dm.Item.saveItem", item, MyManager.instance.id);
		}
		
		private function onItemSaved(response:Object):void {
			trace(response);
			refreshItemList();
		}
	
	}

}