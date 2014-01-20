package dm.builder.interfaces.dropdownmenu {
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author
	 */
	public class MenuStyle {
		
		public var width:Number;
		public var height:Number;
		
		public var lineThickness:Number;
		public var lineColor:uint;
		public var lineAlpha:Number;
		
		public var bgColor:uint;
		public var bgAlpha:Number;
		
		public var textFormat:TextFormat;
		
		public function MenuStyle() {
			
			width = 200;
			height = 20;
			
			lineThickness = 1;
			lineColor = 0xCCCCCC;
			lineAlpha = 1;
			
			bgColor = 0x464646;
			bgAlpha = 1;
			
			textFormat = new TextFormat("Arial", 10, 0xCCCCCC);
			textFormat.align = TextFormatAlign.CENTER;
		}
	
	}
}