package dm.builder.interfaces.dropdownmenu {
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author
	 */
	public class Item extends Sprite {
		
		private var _menu:DropDownMenu;
		private var _style:ItemStyle;
		private var _tf:TextField;
		private var _data:Object;
		
		private var _index:int;
		
		public function Item(menu:DropDownMenu, data:Object) {
			_menu = menu;
			_menu.addChild(this);
			
			_data = data;
			_style = new ItemStyle();
			draw();
			
			createLabel(data.label);
			
			setupListeners();
		}
		
		private function createLabel(label:String):void {
			_tf = new TextField();
			_tf.selectable = false;
			_tf.width = _style.width;
			_tf.text = label;
			addChild(_tf);
			
			_tf.setTextFormat(_style.textFormat);
			_tf.y = _style.height * 0.5 - _tf.textHeight * 0.5 - 2;
		}
		
		private function setupListeners():void {
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		private function onMouseDown(e:MouseEvent):void {
			//trace("MenuItem.onMouseDown()");
			//e.stopImmediatePropagation();
			//try {
				_data.onClick();
			/*} catch (e:Error) {
				if (e.errorID == 1006)
					trace("No function was assigned to this item.");
				else
					throw(e);
			}*/
		}
		
		private function draw():void {
			graphics.lineStyle(_style.lineThickness, _style.lineColor, _style.lineAlpha);
			graphics.beginFill(_style.bgColor, _style.bgAlpha);
			graphics.drawRect(0, 0, _style.width, _style.height);
			graphics.endFill();
		}
		
		public function get style():ItemStyle {
			return _style;
		}
		
		public function set style(value:ItemStyle):void {
			_style = value;
			graphics.clear();
			draw();
		}
		
		public function get tf():TextField {
			return _tf;
		}
		
		public function get index():int {
			return _index;
		}
		
		public function set index(value:int):void {
			_index = value;
		}
		
		public function destroy():void {
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_menu.removeChild(this);
		}
	
	}
}