package dm.game.windows {
	import flash.display.DisplayObjectContainer;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author
	 */
	public class DmLabel extends TextField {
		
		public function DmLabel(parent:DisplayObjectContainer, xPos:Number, yPos:Number, text:String) {
			parent.addChild(this);
			selectable = false;
			x = xPos;
			y = yPos;
			this.text = text;
			
			multiline = true;
			wordWrap = true;
			
			setTextFormat(textFormat);
		}
		
		public function set textAlign(align:String):void {
			var format:TextFormat = textFormat;
			format.align = align;
			
			setTextFormat(format);
		}
		
		private function get textFormat():TextFormat {
			var font:Font = new dmLight();
			var format:TextFormat = new TextFormat(font.fontName, 12, 0xFFFFFF);
			return format;
		}
		
		override public function set text(value:String):void {
			super.text = value;
			setTextFormat(textFormat);
		}
	
	}

}