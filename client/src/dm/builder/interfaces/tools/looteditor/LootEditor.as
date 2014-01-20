package dm.builder.interfaces.tools.looteditor {
	
	import com.bit101.components.ComboBox;
	import com.bit101.components.InputText;
	import com.bit101.components.List;
	import com.bit101.components.PushButton;
	import dm.builder.interfaces.BuilderLabel;
	import dm.builder.interfaces.SearchListWithCategories;
	import dm.builder.interfaces.WindowManager;
	import dm.game.managers.MyManager;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import utils.AMFPHP;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class LootEditor extends SearchListWithCategories {
		
		private var label_ti:InputText;
		private var spawnPeriod_ti:InputText;
		private var dialog_list:List;
		private var idValue_lbl:BuilderLabel;
		private var category_cb:ComboBox;
		
		public function LootEditor(parent:DisplayObjectContainer) {
			_width = 450;			
			super(parent, "Loot editor", 2);
			categoriesLoadedSignal.add(onCategories);
			refreshLootList();
		}
		
		private function onCategories(response:Object):void {
			category_cb.items = categoryFilter_cb.items;
		}
		
		private function refreshLootList():void {
			var amfphp:AMFPHP = new AMFPHP(onLoot).xcall("dm.Loot.getUserLoot", MyManager.instance.id);
		}
		
		private function onLoot(response:Object):void {
			items = response as Array;
		}
		
		override protected function createGUI():void {
			super.createGUI();
			
			item_list.addEventListener(Event.SELECT, onLootSelect);
			
			var label_lbl:BuilderLabel = new BuilderLabel(_body, item_list.x + item_list.width + 50, 10, _("Label") + ": ");
			//label_lbl.textAlign = "right";
			label_ti = new InputText(_body, label_lbl.x + label_lbl.textWidth + 5, label_lbl.y);
			
			var id_lbl:BuilderLabel = new BuilderLabel(_body, label_ti.x + label_ti.width + 15, label_ti.y, "Id: ");
			idValue_lbl = new BuilderLabel(_body, id_lbl.x + id_lbl.textWidth + 5, id_lbl.y, "0");
			
			var category_lbl:BuilderLabel = new BuilderLabel(_body, label_lbl.x, label_lbl.y + 25, _("Category") + ": ");
			category_lbl.width = category_lbl.textWidth;
			category_lbl.textAlign = "right";
			category_cb = new ComboBox(_body, category_lbl.x + category_lbl.textWidth + 5, category_lbl.y);
			
			label_lbl.width = category_lbl.width;
			label_lbl.textAlign = "right";
			label_ti.x = category_cb.x;
			
			var spawnPeriod_lbl:BuilderLabel = new BuilderLabel(_body, category_lbl.x, category_lbl.y + 30, "Spawn period (minutes): ");
			spawnPeriod_ti = new InputText(_body, spawnPeriod_lbl.x + spawnPeriod_lbl.textWidth + 5, spawnPeriod_lbl.y);
			
			var dialogs_lbl:BuilderLabel = new BuilderLabel(_body, spawnPeriod_lbl.x, spawnPeriod_ti.y + 30, "Loot dialogs: ");
			dialog_list = new List(_body, dialogs_lbl.x, dialogs_lbl.y + 20);
			
			var addDialog_btn:PushButton = new PushButton(_body, dialog_list.x + dialog_list.width + 5, dialog_list.y, _("Add"), onAddDialogBtn);
			addDialog_btn.width = 70;
			
			var removeDialog_btn:PushButton = new PushButton(_body, addDialog_btn.x, addDialog_btn.y + 30, _("Remove"), onRemoveDialogBtn);
			removeDialog_btn.width = addDialog_btn.width;
			
			var addLoot_btn:PushButton = new PushButton(_body, item_list.x, item_list.y + item_list.height + 10, _("Add"), onAddLootBtn);
			addLoot_btn.width = 20;
			
			var save_btn:PushButton = new PushButton(_body, _width * 0.5, item_list.y + item_list.height + 10, _("Save"), onSaveBtn);
			save_btn.x -= save_btn.width * 0.5;
			
			bodyHeight += 50;
		}
		
		private function onLootSelect(e:Event):void {
			if (item_list.selectedItem) {
				label_ti.text = item_list.selectedItem.label;
				spawnPeriod_ti.text = item_list.selectedItem.spawn_period;
				dialog_list.items = item_list.selectedItem.dialogs;
				idValue_lbl.text = item_list.selectedItem.id;
				
				for each (var item:Object in category_cb.items)
					if (item.id == item_list.selectedItem.category_id)
						category_cb.selectedItem = item;
			}
		}
		
		private function onAddLootBtn(e:MouseEvent):void {
			item_list.addItemAt( { id: 0, label: "New loot", period: 0, dialogs: [] }, 0);
			item_list.selectedIndex = 0;
		}
		
		private function onSaveBtn(e:MouseEvent):void {
			if (label_ti.text == "") {
				WindowManager.instance.dispatchMessage("Enter loot label.");
				return;
			}
			
			var dialogIds:Array = new Array();
			for each (var dialog:Object in dialog_list.items)
				dialogIds.push(dialog.id);
			
			var loot:Object = {id: item_list.selectedItem.id, label: label_ti.text, spawn_period: spawnPeriod_ti.text, dialogIds: dialogIds, category_id: category_cb.selectedItem.id};
			var amfphp:AMFPHP = new AMFPHP(onLootSaved).xcall("dm.Loot.saveLoot", loot, MyManager.instance.id);
		}
		
		private function onLootSaved(response:Object):void {
			trace(response);
			refreshLootList();
		}
		
		private function onAddDialogBtn(e:MouseEvent):void {
			var dialogList:DialogList = new DialogList(parent);
			dialogList.dialogSelectedSignal.add(onDialogAdd);
		}
		
		private function onDialogAdd(dialog:Object):void {
			if (dialog_list.items.indexOf(dialog) < 0)
				dialog_list.addItem(dialog);
		}
		
		private function onRemoveDialogBtn(e:MouseEvent):void {
			dialog_list.removeItem(dialog_list.selectedItem);
		}
	}

}