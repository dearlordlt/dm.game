package dm.builder.interfaces.tools.dialogeditor  
{
	/**
	 * ...
	 * @author Darius Dauskurdis dariusdxd@gmail.com
	 */
	
	import flash.display.Sprite; 
	import flash.events.*; 
	import flash.text.TextField;
    import flash.text.TextFieldType;
    import flash.text.TextFormat;
	
	public class Btn  extends Sprite  
	{
		public var button_default:Sprite;
		public var button_hover:Sprite;
		
		public function Btn(
							btn_text:String = "unknown",
							btn_width:Number = 200,
							btn_height:Number = 50,
							btn_text_height:Number = 20,
							btn_text_color:Number = 0xFF0000,
							btn_text_bold:Boolean = true,
							btn_bg_color:Number = 0x00FF00,
							btn_bg_alpha:Number = 1,
							btn_line_thickness:Number = 1,
							btn_line_color:Number = 0xFF0000,
							btn_line_alpha:Number = 1,
							btn_hover_text_color:Number = 0x00FF00,
							btn_hover_bg_color:Number = 0xFF0000,
							btn_hover_line_color:Number = 0x00FF00,
							btn_cornerRadius:Number = 10 ) {
			this.buttonMode = true;	
			
			button_default = new Sprite;				
			button_default.name = "button_default";				
			this.addChild(button_default);						
			drawRoundRect(button_default, btn_width, btn_height, btn_cornerRadius, btn_cornerRadius, btn_cornerRadius, btn_cornerRadius, btn_line_thickness, btn_line_color, btn_line_alpha, btn_bg_color, btn_bg_alpha)
			addText(button_default, btn_text, btn_text_height, btn_text_color, btn_text_bold)

			button_hover = new Sprite;				
			button_hover.name = "button_hover";				
			this.addChild(button_hover);						
			drawRoundRect(button_hover, btn_width, btn_height, btn_cornerRadius, btn_cornerRadius, btn_cornerRadius, btn_cornerRadius, btn_line_thickness, btn_hover_line_color, btn_line_alpha, btn_hover_bg_color, btn_bg_alpha)					
			addText(button_hover, btn_text, btn_text_height, btn_hover_text_color, btn_text_bold)
			button_hover.visible = false;
			
			this.addEventListener(MouseEvent.ROLL_OVER, itemRollOver);
			this.addEventListener(MouseEvent.ROLL_OUT, itemRollOut);
		}
		
		
		private function itemRollOver(event:MouseEvent):void{
			button_default.visible = false;
			button_hover.visible = true;
		}
		
		private function itemRollOut(event:MouseEvent):void{
			button_default.visible = true;
			button_hover.visible = false;
		}
		
		private  function addText(spr:Sprite, item_text:String = "unknown", text_size:Number = 16, text_color:Number = 0x00FF00, text_bold:Boolean = false):void {
			var obj_txt:TextField = new TextField(); 
			spr.addChild(obj_txt);
			var format1:TextFormat = new TextFormat();
			format1.font="Arial";
			format1.size = text_size;
			format1.color = text_color;
			format1.bold = text_bold;
			obj_txt.autoSize = "left";
			obj_txt.text = item_text;  
			obj_txt.name = "text_field";
			obj_txt.setTextFormat(format1); 
			obj_txt.x = spr.width/2-obj_txt.width/2;
			obj_txt.y = spr.height/2-obj_txt.height/2;
			obj_txt.selectable = false;  
			obj_txt.mouseEnabled = false;
		}
		
		private  function drawRoundRect(spr:Sprite, w:Number , h:Number, tl:Number, tr:Number, bl:Number, br:Number, thick:Number, borderColor:Number,  borderAlpha:Number, bgColor:Number, trans:Number ):void {
			if (thick != 0) spr.graphics.lineStyle(thick, borderColor);
			spr.graphics.beginFill(bgColor, trans);
			spr.graphics.moveTo( 0, tl );
			spr.graphics.curveTo( 0, 0, tl, 0 );
			spr.graphics.lineTo(w - tr, 0);
			spr.graphics.curveTo( w, 0, w, tr );
			spr.graphics.lineTo(w, h - br);
			spr.graphics.curveTo( w, h, w - br, h );
			spr.graphics.lineTo(bl, h);
			spr.graphics.curveTo( 0, h, 0, h - bl );
			spr.graphics.endFill();
		}					
		
	}

}