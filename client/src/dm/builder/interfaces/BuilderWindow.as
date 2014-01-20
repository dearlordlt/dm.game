package dm.builder.interfaces {
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import org.as3commons.lang.ObjectUtils;
	import ucc.ui.window.NativeWindowBase;
	import ucc.ui.window.WindowsManager;
	import ucc.util.ObjectUtil;
	
	/**
	 * Builder window
	 * @version $Id: BuilderWindow.as 200 2013-08-01 12:52:12Z zenia.sorocan $
	 */
	public class BuilderWindow extends NativeWindowBase {
		
		protected var _width:Number;
		
		protected var windowLabel:String;
		
		public const HEADER_HEIGTH:Number = 20;
		
		private var _bodyHeight:Number;
		
		public var movable:Boolean = true;
		
		private var _header:Sprite;
		
		protected var _body:Sprite;
		
		private var minimize_btn:Sprite;
		
		private var maximize_btn:Sprite;
		
		protected var close_btn:Sprite;
		
		private var componentName_lbl:BuilderLabel;
		
		protected var _dummy:Sprite;
		
		public static const EVENT_HEIGHT_CHANGE:String = "heightChange";
		
		/**
		 * Class constructor
		 * ATTENTION!!!: There and in other subclasses always assign constructor parameters to class members BEFORE calling constructor!
		 * @param	parent
		 * @param	name
		 * @param	width
		 * @param	bodyHeight
		 */
		public function BuilderWindow(parent:DisplayObjectContainer, name:String = "BaseComponent", width:Number = 210, bodyHeight:Number = 200) {
			this._width = width;
			this._bodyHeight = bodyHeight;
			this.windowLabel = name;
			if (parent && ObjectUtils.getClassName(parent) == "dm.builder.Builder") {
				parent = WindowsManager.getInstance().getDefaultParentContainer();
			}
			super(parent);
			// WindowsManager.getInstance().addWindowToManager( this, parent, [ name, width, bodyHeight ] )
		}
		
		protected function createDummy():void {
			if (_dummy != null) {
				destroyDummy();
			}
			_dummy = new Sprite();
			_body.addChild(_dummy);
			_dummy.graphics.lineStyle(1, 0xCCCCCC);
			_dummy.graphics.beginFill(0x464646);
			_dummy.graphics.drawRect(0, 0, _width, bodyHeight);
			_dummy.graphics.endFill();
		}
		
		protected function destroyDummy():void {
			_body.removeChild(_dummy);
		}
		
		public function hideButtons():void {
			minimize_btn.visible = false;
			close_btn.visible = false;
		}
		
		public function hideHeader():void {
			_header.visible = false;
		}
		
		private function setupListeners():void {
			_header.addEventListener(MouseEvent.MOUSE_DOWN, onHeaderMouseDown);
			
			minimize_btn.addEventListener(MouseEvent.CLICK, onMinimizeBtn);
			maximize_btn.addEventListener(MouseEvent.CLICK, onMaximizeBtn);
			close_btn.addEventListener(MouseEvent.CLICK, onCloseBtn);
		}
		
		private function onHeaderMouseDown(e:MouseEvent):void {
			if (movable) {
				stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				startDrag();
			}
			
			function onMouseUp(e:MouseEvent):void {
				stopDrag();
				stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
		}
		
		private function onMaximizeBtn(e:MouseEvent):void {
			minimized = false;
			dispatchEvent(new Event(EVENT_HEIGHT_CHANGE));
		}
		
		private function onMinimizeBtn(e:MouseEvent):void {
			minimized = true;
			dispatchEvent(new Event(EVENT_HEIGHT_CHANGE));
		}
		
		override public function draw():void {
			super.draw();
			createHeader();
			drawBody();
			setupListeners();
			this.createGUI();
		}
		
		/**
		 * Create GUI. Leave this method empty for override.
		 */
		protected function createGUI():void {
		
		}
		
		private function createHeader():void {
			_header = new Sprite();
			addChild(_header);
			
			_header.graphics.lineStyle(1, 0xCCCCCC);
			
			_header.graphics.beginFill(0x464646);
			_header.graphics.drawRect(0, 0, _width, HEADER_HEIGTH);
			_header.graphics.endFill();
			
			componentName_lbl = new BuilderLabel(_header, 3, 2, "");
			componentName_lbl.width = _width;
			
			createBtns();
			
			this.label = this.windowLabel;
		
		}
		
		private function createBtns():void {
			// minimize_btn
			minimize_btn = new Sprite();
			_header.addChild(minimize_btn);
			
			minimize_btn.graphics.lineStyle(1, 0xCCCCCC);
			
			minimize_btn.graphics.beginFill(0x000000, 0);
			minimize_btn.graphics.drawRect(0, 0, 10, 10);
			
			minimize_btn.graphics.moveTo(3, 5);
			minimize_btn.graphics.lineTo(8, 5);
			
			minimize_btn.x = _width - 30;
			minimize_btn.y = 5;
			
			// maximize_btn
			maximize_btn = new Sprite();
			_header.addChild(maximize_btn);
			
			maximize_btn.graphics.lineStyle(1, 0xCCCCCC);
			
			maximize_btn.graphics.beginFill(0x000000, 0);
			maximize_btn.graphics.drawRect(0, 0, 10, 10);
			
			maximize_btn.graphics.drawRect(3, 3, 4, 4);
			maximize_btn.graphics.moveTo(4, 4);
			maximize_btn.graphics.lineTo(8, 4);
			
			maximize_btn.x = _width - 30;
			maximize_btn.y = 5;
			
			maximize_btn.visible = false;
			
			// destroy_btn
			close_btn = new Sprite();
			_header.addChild(close_btn);
			
			close_btn.graphics.lineStyle(1, 0xCCCCCC);
			
			close_btn.graphics.beginFill(0x000000, 0);
			close_btn.graphics.drawRect(0, 0, 10, 10);
			
			close_btn.graphics.moveTo(3, 3);
			close_btn.graphics.lineTo(8, 8);
			close_btn.graphics.moveTo(3, 8);
			close_btn.graphics.lineTo(8, 3);
			
			close_btn.x = _width - 15;
			close_btn.y = 5;
		}
		
		private function drawBody():void {
			if (_body == null) {
				_body = new Sprite();
				addChild(_body);
				_body.y = HEADER_HEIGTH + 2;
			}
			
			_body.graphics.clear();
			
			_body.graphics.lineStyle(1, 0xCCCCCC);
			
			_body.graphics.beginFill(0x464646);
			_body.graphics.drawRect(0, 0, _width, _bodyHeight);
			_body.graphics.endFill();
			
			_body.graphics.lineStyle(1, 0xCCCCCC);
		}
		
		protected function onCloseBtn(e:MouseEvent):void {
			destroy();
		}
		
		override public function destroy():void {
			_header.removeEventListener(MouseEvent.MOUSE_DOWN, onHeaderMouseDown);
			
			minimize_btn.removeEventListener(MouseEvent.CLICK, onMinimizeBtn);
			maximize_btn.removeEventListener(MouseEvent.CLICK, onMaximizeBtn);
			close_btn.removeEventListener(MouseEvent.CLICK, onCloseBtn);
			
			super.destroy();
		
		}
		
		public function set minimized(value:Boolean):void {
			minimize_btn.visible = !value;
			maximize_btn.visible = value;
			_body.visible = !value;
		}
		
		public function get minimized():Boolean {
			return !minimize_btn.visible;
		}
		
		public function get curHeight():Number {
			return (minimized) ? HEADER_HEIGTH : HEADER_HEIGTH + _bodyHeight;
		}
		
		public function set bodyHeight(value:Number):void {
			_bodyHeight = value;
			drawBody();
			dispatchEvent(new Event(EVENT_HEIGHT_CHANGE));
		}
		
		public function set label(value:String):void {
			componentName_lbl.text = value;
		}
		
		public function get bodyHeight():Number {
			return _bodyHeight;
		}
		
		public function get body():Sprite {
			return _body;
		}
	
	}
}