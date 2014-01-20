package dm.game.windows {
	
	import dm.game.Main;
	import fl.controls.Label;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import ucc.ui.style.DynamicStyleManager;
	
	/**
	 * Tooltip component
	 * @version $Id: Tooltip.as 183 2013-07-09 07:19:03Z zenia.sorocan $
	 */
	public class Tooltip extends Sprite {
		
		/** Glow filter*/
		private static var glowFilter:GlowFilter = new GlowFilter(0, 0.5, 10, 10, 1);
		
		/** Text format */
		private static var textFormat:TextFormat;
		
		/** Text field */
		private var textField:Label;
		
		/** Target DO */
		protected var _targetDO:DisplayObject;
		
		/** Text function */
		protected var textFunction : Function;
		
		/** id */
		protected var id : String;
		
		private static var _tooltipsToObjects:Dictionary = new Dictionary();
		
		/**
		 * Static constructor
		 */
		{
			staticInit();
		}
		
		private static function staticInit():void {
			var font:Font = new dmItalic();
			textFormat = new TextFormat(font.fontName, 16, 0xFFFFFF);
		}
		
		public static function getObjectTooltip(displayObject:DisplayObject):Tooltip {
			return _tooltipsToObjects[displayObject];
		}
		
		/**
		 * Set tooltip for specified display object
		 * @param	target
		 * @param	text
		 */
		public static function setTooltip(targetDO:DisplayObject, text:String, textFunction : Function = null, id : String = null ):void {
			_tooltipsToObjects[targetDO] = new Tooltip(targetDO, text, textFunction );
		}
		
		/**
		 * (Constructor)
		 * - Returns a new Tooltip instance
		 * @param	targetDO
		 * @param	text			text to display. If function callback is specified it override text
		 * @param	textFunction	function to execute to get text for tooltip
		 * @param	id				unique id of tooltip. Used with function displayTooltipById()
		 */
		public function Tooltip(targetDO:DisplayObject, text:String, textFunction : Function = null, id : String = null ) {
			this.id = id;
			this.textFunction = textFunction;
			_targetDO = targetDO;
			Main.getInstance().addChild(this);
			
			this.textField = new Label();
			this.textField.autoSize = TextFieldAutoSize.LEFT;
			textField.wordWrap = true;
			textField.x = textField.y = 10;
			this.addChild(this.textField);
			
			visible = false;
			this.text = text;
			_targetDO.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
			_targetDO.addEventListener(Event.REMOVED_FROM_STAGE, onTargetRemoved);
		}
		
		/**
		 * On target removed. GC.
		 */
		private function onTargetRemoved(e:Event):void {
			_targetDO.removeEventListener(Event.REMOVED_FROM_STAGE, onTargetRemoved);
			destroy();
		}
		
		/**
		 * On mouse over
		 */
		private function onMouseOver(e:MouseEvent):void {
			visible = true;
			this.update();
			this.onMouseMove(e);
			_targetDO.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
			_targetDO.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);
			Main.getInstance().setChildIndex(this, Main.getInstance().numChildren - 1);
		}
		
		/**
		 * Update tooltip
		 */
		private function update () : void {
			if ( this.textFunction ) {
				this.text = this.textFunction();
			}
		}
		
		/**
		 * On move out
		 */
		private function onMouseOut(e:MouseEvent):void {
			this.visible = false;
			_targetDO.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		/**
		 * On mouse move
		 */
		private function onMouseMove(e:MouseEvent):void {
			this.x = e.stageX - this.width * 0.5;
			// x = parent.mouseX - width * 0.5;
			this.y = e.stageY + 20;
		}
		
		/**
		 * Draw tooltip boundaries
		 * // TODO: embed this in design
		 */
		private function draw(w:Number, h:Number):void {
			
			if (DynamicStyleManager.getStyleForClass(Tooltip, "outlineFunction")) {
				var func:Function = DynamicStyleManager.getStyleForClass(Tooltip, "outlineFunction");
				func(w, h, this);
			} else {
				this.defaultOutlineFunction(w, h, this);
			}
		
		}
		
		private function defaultOutlineFunction(w:Number, h:Number, target:Sprite):void {
			
			target.graphics.clear();
			target.graphics.lineStyle(1, 0xFFFFFF);
			target.graphics.beginFill(0x909294);
			target.graphics.drawRoundRect(0, 0, w, h, 15, 15);
			target.graphics.endFill();
			target.graphics.beginFill(0x909294);
			target.graphics.moveTo(width * 0.5 - 7, 1);
			target.graphics.lineTo(width * 0.5, -10);
			target.graphics.lineTo(width * 0.5 + 7, 1);
			target.graphics.lineStyle(1, 0x909294);
			target.graphics.lineTo(width * 0.5 + 10, 1);
			target.graphics.endFill();
			
			target.filters = [glowFilter];
		}
		
		/**
		 * Set tooltip text
		 */
		public function set text(text:String):void {
			textField.text = text;
			textField.validateNow();
			textField.drawNow();
			this.draw(textField.width + 20, textField.height + 20);
		}
		
		/**
		 * Get tooltip text
		 */
		public function get text():String {
			return textField.text;
		}
		
		/**
		 * Clean up instance
		 */
		public function destroy():void {
			
			for (var displayObject:Object in _tooltipsToObjects)
				if (_tooltipsToObjects[displayObject] == this)
					delete _tooltipsToObjects[displayObject];
			
			_targetDO.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			_targetDO.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			Main.getInstance().removeChild(this);
		}
	
	}

}
