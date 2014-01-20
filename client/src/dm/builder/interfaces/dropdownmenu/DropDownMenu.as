package dm.builder.interfaces.dropdownmenu {
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author
	 */
	public class DropDownMenu extends Sprite {
		
		private var _itemData:Vector.<Object> = new Vector.<Object>;
		private var _itemViews:Vector.<Item> = new Vector.<Item>;
		private var _style:MenuStyle;
		private var _tf:TextField;
		
		// polnaja lazha
		private var falseMouseDownEvent:Boolean = true;
		
		public function DropDownMenu(parent:DisplayObjectContainer, name:String = "") {
			parent.addChild(this);
			_style = new MenuStyle();
			
			draw();
			
			createLabel(name);
			
			setupListeners();
		}
		
		private function createLabel(label:String):void {
			_tf = new TextField();
			_tf.selectable = false;
			_tf.width = _style.width;
			_tf.text = label;
			addChild(_tf);
			
			_tf.setTextFormat(_style.textFormat);
			
			_tf.y = _style.height * 0.5 - _tf.textHeight * 0.5 - 3;
		}
		
		private function setupListeners():void {
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		private function onMouseDown(e:MouseEvent):void {
			showItems();
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);
			function onStageMouseDown(e:MouseEvent):void {
				//trace("DropDownMenu.onMouseDown.onStageMouseDown(): falsebullshit " + falseMouseDownEvent);
				if (!falseMouseDownEvent) {
					addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
					if (stage != null) {
						stage.removeEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);
					}
					hideItems();
					falseMouseDownEvent = true;
				} else
					falseMouseDownEvent = false;
			}
		}
		
		private function hideItems():void {
			for each (var item:Item in _itemViews) {
				item.destroy();
			}
			_itemViews.length = 0;
		}
		
		private function draw():void {
			graphics.lineStyle(_style.lineThickness, _style.lineColor, _style.lineAlpha);
			graphics.beginFill(_style.bgColor, _style.bgAlpha);
			graphics.drawRect(0, 0, _style.width, _style.height);
			graphics.endFill();
		}
		
		public function addItem(data:Object):void {
			_itemData.push(data);
		}
		
		private function showItems():void {
			//trace("DropDownMenu.showItems(): Showing " + _itemData.length + " items");
			for (var i:int = 0; i < _itemData.length; i++) {
				var item:Item = new Item(this, _itemData[i]);
				item.y = _style.height + 2 + i * item.style.height;
				_itemViews.push(item);
			}
		}
	
	}
}