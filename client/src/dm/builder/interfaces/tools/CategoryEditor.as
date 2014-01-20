package dm.builder.interfaces.tools {
	
	import com.bit101.components.ComboBox;
	import com.bit101.components.InputText;
	import com.bit101.components.List;
	import com.bit101.components.PushButton;
	import dm.builder.interfaces.BuilderLabel;
	import dm.builder.interfaces.BuilderWindow;
	import dm.game.managers.MyManager;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import utils.AMFPHP;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class CategoryEditor extends BuilderWindow {
		
		private var objectType_cb:ComboBox;
		private var _categories:Array;
		private var category_list:List;
		private var label_ti:InputText;
		
		public function CategoryEditor(parent:DisplayObjectContainer) {
			super(parent, _("Category manager"), 300);
			var amfphp:AMFPHP = new AMFPHP(onObjectTypes).xcall("dm.ObjectPermissions.getObjectTypes");
		}
		
		private function onObjectTypes(response:Object):void {
			objectType_cb.items = response as Array;
			objectType_cb.selectedIndex = 0;
			
			var amfphp:AMFPHP = new AMFPHP(onCategories).xcall("dm.Category.getAllCategories");
		}
		
		private function onCategories(response:Object):void {
			_categories = response as Array;
			onObjectTypeSelect(null);
		}
		
		override protected function createGUI():void {
			objectType_cb = new ComboBox(_body, 10, 10);
			objectType_cb.addEventListener(Event.SELECT, onObjectTypeSelect);
			category_list = new List(_body, objectType_cb.x, objectType_cb.y + 30);
			category_list.addEventListener(Event.SELECT, onCategorySelect);
			
			var add_btn:PushButton = new PushButton(_body, category_list.x, category_list.y + category_list.height + 10, _("Add"), onAddBtn);
			add_btn.width = 50;
			
			var label_lbl:BuilderLabel = new BuilderLabel(_body, objectType_cb.x + objectType_cb.width + 20, objectType_cb.y, _("Label") + ": ");
			label_ti = new InputText(_body, label_lbl.x, label_lbl.y + 30);
			
			var save_btn:PushButton = new PushButton(_body, label_ti.x, add_btn.y, _("Save"), onSaveBtn);
		}
		
		private function onCategorySelect(e:Event):void {
			label_ti.text = category_list.selectedItem.label;
		}
		
		private function onSaveBtn(e:Event):void {
			category_list.selectedItem.label = label_ti.text;
			var amfphp:AMFPHP = new AMFPHP(onCategorySaved).xcall("dm.Category.saveCategory", category_list.selectedItem, MyManager.instance.id);
		}
		
		private function onCategorySaved(response:Object):void {
			trace(response);
			var amfphp:AMFPHP = new AMFPHP(onCategories).xcall("dm.Category.getAllCategories");
		}
		
		private function onAddBtn(e:Event):void {
			category_list.addItemAt({label: "New category", object_type_id: objectType_cb.selectedItem.id, id: 0}, 0);
			category_list.selectedIndex = 0;
		}
		
		private function onObjectTypeSelect(e:Event):void {
			category_list.removeAll();
			for each (var category:Object in _categories)
				if (category.object_type_id == objectType_cb.selectedItem.id)
					category_list.addItem(category);
		
		}
	}

}