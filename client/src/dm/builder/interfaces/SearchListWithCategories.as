package dm.builder.interfaces {
	import com.bit101.components.CheckBox;
	import com.bit101.components.ComboBox;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import net.richardlord.ash.signals.Signal1;
	import utils.AMFPHP;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class SearchListWithCategories extends SearchList {
		
		public var categoriesLoadedSignal:Signal1 = new Signal1(Object);
		protected var categoryFilter_cb:ComboBox;
		private var showAll_cb:CheckBox;
		
		public function SearchListWithCategories(parent:DisplayObjectContainer, name:String, objectTypeId:int, items:Array = null) {
			var amfphp:AMFPHP = new AMFPHP(onCategories).xcall("dm.Category.getAllCategories");
			
			super(parent, name, null);
			
			function onCategories(response:Object):void {				
				for each (var category:Object in response)
					if (category.object_type_id == objectTypeId)
						categoryFilter_cb.addItem(category);
				categoryFilter_cb.selectedIndex = 0;
				categoriesLoadedSignal.dispatch(response);
			}
		}
		
		override protected function createGUI():void {
			super.createGUI();
			
			item_list.y += 30;
			
			categoryFilter_cb = new ComboBox(_body, search_ti.x, search_ti.y + 25);
			categoryFilter_cb.addEventListener(Event.SELECT, onChange);
			showAll_cb = new CheckBox(_body, categoryFilter_cb.x + categoryFilter_cb.width + 5, categoryFilter_cb.y + 4, " show all", onShowAllCbSelect);
		}
		
		private function onShowAllCbSelect(e:Event):void {
			categoryFilter_cb.enabled = !showAll_cb.selected;
			onChange(null);
		}
		
		override protected function onChange(e:Event):void {
			item_list.removeAll();
			
			for each (var item:Object in _items) {
				if (!showAll_cb.selected && item.category_id != categoryFilter_cb.selectedItem.id)
					continue;
				
				if (String(item.label).indexOf(search_ti.text) == 0)
					item_list.addItem(item);
			}
		}
	
	}

}