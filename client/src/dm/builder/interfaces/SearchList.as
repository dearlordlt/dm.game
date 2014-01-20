package dm.builder.interfaces {
	import com.bit101.components.InputText;
	import com.bit101.components.List;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SearchList extends BuilderWindow {
		
		protected var search_ti:InputText;
		protected var _items:Array;
		protected var item_list:List;
		
		public function SearchList(parent:DisplayObjectContainer, name:String, items:Array = null) {
			if (_width == 0)
				_width = 180;
				
			_items = items;
				
			super(parent, name, _width, 200);
		}
		
		override protected function createGUI():void {
			search_ti = new InputText(_body, 15, 15, "", onChange);
			search_ti.width = 150;
			
			item_list = new List(_body, search_ti.x, search_ti.y + 20);
			item_list.width = search_ti.width;
			item_list.height = 150;
			item_list.addEventListener(Event.SELECT, onSelect);
			items = _items;
		}
		
		protected function onSelect(e:Event):void {
		
		}
		
		protected function onChange(e:Event):void {
			item_list.removeAll();
			
			for each (var item:Object in _items)
				if (String(item.label).indexOf(search_ti.text) == 0)
					item_list.addItem(item);
		}
		
		protected function set items(value:Array):void {
			if (value != null) {
				_items = value;
				item_list.items = _items.concat();
				item_list.selectedIndex = 0;
			} else
				item_list.removeAll();
		}
	
	}

}