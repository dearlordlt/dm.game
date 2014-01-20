package dm.builder.interfaces.tools.dialogeditor
{

	/**
	* ...
	* @author Darius Dauskurdis dariusdxd@gmail.com
	*/

	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Rectangle;
	
	public class Slidebar extends Sprite 
	{

		//kartais gali buti taip, jog scrolas apacioja, bet pats contentas dar ne visas paslinkes i virsu. Tai reiškia, kad jau scrolo mygtukas yra per mazas. Reikia didinti crollo auksti
		//arba mažinti contento auksti.
		public var _dragging:Boolean = false;
		public var _minThumbHeight:Number = 10;
		public var _maxThumbHeight:Number;
		public var _dragY:Number;
		public var _dragH:Number;
		public var ratio:Number;
		public var _bar:Sprite;
		public var _thumb:Sprite;
		public var _thumb_background:Sprite;
		public var showing_area:Sprite;
		public var content:Sprite;
		public var btn_up:Sprite;
		public var btn_down:Sprite;
		public var scroll_icon:scrollIcon = new scrollIcon;
		public var scroll_step:Number = 5;
		
		public function Slidebar(showing_area:Sprite, content:Sprite) {
			this.showing_area = showing_area;
			this.content = content;
			this.addEventListener(Event.ADDED, thisWasAdded);
		}
		
		private function thisWasAdded(e:Event):void {
			this.removeEventListener(Event.ADDED, thisWasAdded);

			btn_up = new Sprite;
			btn_up.graphics.lineStyle(1, 0x5A7582);
			btn_up.graphics.beginFill(0x89AFC2);
			btn_up.graphics.drawRect(0,0,19,19);
			btn_up.graphics.endFill();
			this.addChild(btn_up);
			var btn_up_icon:arrowIcon = new arrowIcon;
			btn_up.addChild(btn_up_icon);
			btn_up_icon.x = btn_up.width / 2 - btn_up_icon.width / 2 + 2;
			btn_up_icon.y = btn_up.height / 2 - btn_up_icon.height / 2 + 2;
			btn_up.x = showing_area.x + showing_area.width - 1;
			btn_up.y = showing_area.y;
			btn_up.buttonMode = true;
			btn_up.addEventListener(MouseEvent.MOUSE_DOWN, upOnMouseDown);
			btn_up.addEventListener(MouseEvent.MOUSE_UP, upOnMouseUp);
			btn_down = new Sprite;
			btn_down.graphics.lineStyle(1, 0x5A7582);
			btn_down.graphics.beginFill(0x89AFC2);
			btn_down.graphics.drawRect(0,0,19,19);
			btn_down.graphics.endFill();
			this.addChild(btn_down);
			var btn_down_icon:arrowIcon = new arrowIcon;
			btn_down.addChild(btn_down_icon);
			btn_down_icon.rotation = 180;
			btn_down_icon.x = btn_down.width / 2 - btn_down_icon.width / 2 + 2;
			btn_down_icon.y = btn_down.height / 2 - btn_down_icon.height / 2 + 2;
			btn_down.x = showing_area.x + showing_area.width - 1;
			btn_down.buttonMode = true;
			btn_down.addEventListener(MouseEvent.MOUSE_DOWN, downOnMouseDown);
			btn_down.addEventListener(MouseEvent.MOUSE_UP, downOnMouseUp);
			var mc_bar:Sprite = new Sprite();
			mc_bar.graphics.beginFill(0x5A7582);
			mc_bar.graphics.drawRect(0,0,20,400);
			mc_bar.graphics.endFill();
			this.addChild(mc_bar);
			_thumb_background = new Sprite();
			_thumb_background.graphics.beginFill(0x89afc2);
			_thumb_background.graphics.drawRect(0,0,20,50);
			_thumb_background.graphics.endFill();
			_thumb = new Sprite;
			this.addChild(_thumb);
			_thumb.addChild(_thumb_background);
			_thumb.buttonMode = true;
			_bar = mc_bar;
			_thumb.addChild(scroll_icon);
			showing_area.x = content.x;
			showing_area.y = content.y;
			_bar.x = showing_area.x + showing_area.width-1;
			_bar.y = showing_area.y + btn_up.height;
			_bar.height = showing_area.height - btn_up.height - btn_down.height;
			_thumb.x = _bar.x;
			_thumb.y = _bar.y;
			content.mask = showing_area;
			_dragY = _bar.y;
			_dragH = _bar.height;
			_maxThumbHeight = _bar.height;
			ratio = showing_area.height / (content.height + 5);
			_thumb_background.height = _bar.height * ratio;
			if (_thumb_background.height < _minThumbHeight) {
				_thumb_background.height = _minThumbHeight;
			} else if (_thumb_background.height > _maxThumbHeight) {
				_thumb_background.height = _maxThumbHeight;
			}
			scroll_icon.x = _thumb.width / 2-2;
			scroll_icon.y = _thumb.height / 2;
			btn_down.y = _bar.y + _bar.height;
			enable();
		}
		
		private function upOnMouseDown(event:MouseEvent):void {
			this.addEventListener(Event.ENTER_FRAME, scrollUp)
		}
		
		private function scrollUp(event:Event):void {
			if (_thumb.y>=0) {
				if ((_thumb.y - _bar.y) < scroll_step) {
					_thumb.y = _bar.y;
				}else {
					_thumb.y -= scroll_step;
				}
			}
			ratio = ((_thumb.y - _bar.y) / _bar.height);
			content.y = -(ratio * (content.height + 2)) + _bar.y - btn_up.height;
			if (content.height < showing_area.height) {
				content.y = 0;
			}
			scroll_icon.y = _thumb.height / 2;
		}
		
		private function upOnMouseUp(event:MouseEvent):void {
			this.removeEventListener(Event.ENTER_FRAME, scrollUp);
		}
		
		private function downOnMouseDown(event:MouseEvent):void {
			this.addEventListener(Event.ENTER_FRAME, scrollDown)
		}
		
		private function scrollDown(event:Event):void {
			if (_thumb.y <= (_bar.y + _bar.height-_thumb.height)) {
				if ((_bar.y + _bar.height - _thumb.height)-_thumb.y < scroll_step) {
					_thumb.y = _bar.y + _bar.height - _thumb.height;
				}else {
					_thumb.y += scroll_step;
				}
			}
			ratio = ((_thumb.y - _bar.y) / _bar.height);
			content.y = -(ratio * (content.height + 2)) + _bar.y - btn_up.height;
			if (content.y<(-content.height +showing_area.y + showing_area.height)) {
				content.y = -content.height +showing_area.y + showing_area.height;
			}
			if (content.height < showing_area.height) {
				content.y = 0;
			}
			scroll_icon.y = _thumb.height / 2;
		}
		
		private function downOnMouseUp(event:MouseEvent):void {
			this.removeEventListener(Event.ENTER_FRAME, scrollDown);
		}
		
		public function updateSliderbar():void {
			content.y = 0;
			_bar.y = showing_area.y + btn_up.height;
			_bar.height = showing_area.height - btn_up.height - btn_down.height;
			_thumb.y = _bar.y;
			_dragY = _bar.y;
			_dragH = _bar.height;
			_maxThumbHeight = _bar.height;
			ratio = showing_area.height / (content.height + 5);
			_thumb_background.height = _bar.height * ratio;
			if (_thumb_background.height < _minThumbHeight) {
				_thumb_background.height = _minThumbHeight;
			} else if (_thumb_background.height > _maxThumbHeight) {
				_thumb_background.height = _maxThumbHeight;
			}
			scroll_icon.x = _thumb.width / 2;
			scroll_icon.y = _thumb.height / 2;
			btn_down.y = _bar.y + _bar.height;
		}

		private function enable():void {
			_thumb.addEventListener(MouseEvent.MOUSE_DOWN,thumbMouseDown);
			parent.addEventListener(MouseEvent.MOUSE_UP,thumbMouseUp);
		}
		
		private function thumbMouseDown(evt:MouseEvent):void {
			parent.addEventListener(MouseEvent.MOUSE_MOVE,thumbMouseMove);
			_thumb.startDrag(false,new Rectangle(_thumb.x,_dragY,0,_dragH-_thumb.height+1));
		}
		
		private function thumbMouseUp(evt:MouseEvent):void {
			parent.removeEventListener(MouseEvent.MOUSE_MOVE,thumbMouseMove);
			_thumb.stopDrag();
			_dragging = false;
			if ((_bar.y + _bar.height - _thumb.height)-_thumb.y < scroll_step) {
				_thumb.y = _bar.y + _bar.height - _thumb.height;
			}
			ratio = ((_thumb.y - _bar.y) / _bar.height);
			content.y = -(ratio * (content.height + 2)) + _bar.y - btn_up.height;
			if (content.y<(-content.height +showing_area.y + showing_area.height)) {
				content.y = -content.height +showing_area.y + showing_area.height;
			}
			if (content.height < showing_area.height) {
				content.y = 0;
			}
		}
		
		private function thumbMouseMove(evt:MouseEvent):void {
			_dragging = true;
			ratio = ((_thumb.y - _bar.y) / _bar.height);
			content.y = -(ratio * (content.height + 2)) + _bar.y - btn_up.height;
			if (content.y<(-content.height +showing_area.y + showing_area.height)) {
				content.y = -content.height +showing_area.y + showing_area.height;
			}
			if (content.height < showing_area.height) {
				content.y = 0;
			}
			scroll_icon.y = _thumb.height / 2;
		}
	}
}