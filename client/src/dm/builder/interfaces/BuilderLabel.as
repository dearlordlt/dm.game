package dm.builder.interfaces {
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author
	 */
	public class BuilderLabel extends TextField {
		
		public function BuilderLabel(parent:DisplayObjectContainer, xPos:Number, yPos:Number, text:String) {
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
			
			var format:TextFormat = new TextFormat("Arial", 10, 0xCCCCCC );
			format.letterSpacing = 1;
			return format;
		}
		
		override public function set text(value:String):void {
			super.text = value;
			setTextFormat(textFormat);
		}
	
	}

}