package dm.builder.interfaces.tools {
	
	import com.bit101.components.ComboBox;
	import com.bit101.components.InputText;
	import com.bit101.components.PushButton;
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
	public class InteractionEditor extends SearchListWithCategories {
		
		private var label_ti:InputText;
		private var idValue_lbl:BuilderLabel;
		private var functionsAndConditions:FunctionsAndConditions;
		private var category_cb:ComboBox;
		
		public function InteractionEditor(parent:DisplayObjectContainer) {
			_width = 420;
			super(parent, "Interaction editor", 4);
			bodyHeight += 140;
			
			categoriesLoadedSignal.add(onCategories);
			refreshInteractionList();
		}
		
		private function onCategories(response:Object):void {
			category_cb.items = categoryFilter_cb.items;
		}
		
		private function refreshInteractionList():void {
			var amfphp:AMFPHP = new AMFPHP(onInteractions).xcall("dm.Interaction.getUserInteractions", MyManager.instance.id);
		}
		
		private function onInteractions(response:Object):void {
			items = response as Array;
		}
		
		override protected function onSelect(e:Event):void {
			if (item_list.selectedItem.id != 0) {
				var amfphp:AMFPHP = new AMFPHP(onInteractionInfo).xcall("dm.Interaction.getInteractionById", item_list.selectedItem.id);
			} else
				clearData();
		}
		
		private function onInteractionInfo(response:Object):void {
			label_ti.text = response.label;
			idValue_lbl.text = response.id;
			functionsAndConditions.setConditions(response.conditions);
			functionsAndConditions.setFunctions(response.functions);
			
			for each (var item:Object in category_cb.items)
					if (item.id == response.category_id)
						category_cb.selectedItem = item;
		}
		
		private function clearData():void {
			label_ti.text = "";
			functionsAndConditions.clearLists();
		}
		
		override protected function createGUI():void {
			super.createGUI();
			
			item_list.height += 90;
			
			var addInteraction_btn:PushButton = new PushButton(_body, item_list.x, item_list.y + item_list.height + 5, _("Add"), onAddInteractionBtn);
			addInteraction_btn.width = 50;
			
			var label_lbl:BuilderLabel = new BuilderLabel(_body, item_list.x + item_list.width + 20, 10, "Label: ");
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
			
			functionsAndConditions = new FunctionsAndConditions(_body, new Point(category_lbl.x, category_lbl.y + 10));
			functionsAndConditions.hideHeader();
			
			var save_btn:PushButton = new PushButton(_body, _width * 0.5, functionsAndConditions.y + functionsAndConditions.height + 60, _("Save"), onSaveBtn);
			save_btn.x -= save_btn.width * 0.5;
		}
		
		private function onAddInteractionBtn(e:MouseEvent):void {
			item_list.addItemAt({id: 0, label: "New interaction"}, 0);
			item_list.selectedIndex = 0;
		}
		
		private function onSaveBtn(e:MouseEvent):void {
			if (label_ti.text == "") {
				WindowManager.instance.dispatchMessage("Enter interaction label.");
				return;
			}
			var interaction:Object = {id: item_list.selectedItem.id, label: label_ti.text, functionIds: functionsAndConditions.getFunctionIds(), conditionIds: functionsAndConditions.getConditionIds(), category_id: category_cb.selectedItem.id};
			var amfphp:AMFPHP = new AMFPHP(onInteractionSaved).xcall("dm.Interaction.saveInteraction", interaction, MyManager.instance.id);
		}
		
		private function onInteractionSaved(response:Object):void {
			trace(response);
			WindowManager.instance.dispatchMessage("Interaction saved.");
			refreshInteractionList();
		}
	
	}

}