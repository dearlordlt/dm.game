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
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.net.URLRequest;
	 
	public class PhraseMiniPreview extends Sprite  
	{
		private var holder:*;
		public var bg_holder:Sprite;
		public var current_node:Object;
		public var subject_label:TextField; 
		public var phrase_label:TextField; 
		public var image_holder:Sprite; 
		public var image_bg_holder:Sprite; 
		public var image_loader:Loader;
		
		public function PhraseMiniPreview() {
			this.addEventListener(Event.ADDED, thisWasAdded);
		}
		
		private function thisWasAdded(e:Event):void {
			this.removeEventListener(Event.ADDED, thisWasAdded);
			holder = this.parent;
			bg_holder = new Sprite();
			drawRoundRect(bg_holder, 400, 120, 20, 20, 20, 20, 0, 0x000000, 0xFFFFFF, 0.9);
			this.addChild(bg_holder);
			
			bg_holder.graphics.lineStyle(1, 0x5A7582)
			bg_holder.graphics.drawRect(20, 20, 80, 80);
			bg_holder.graphics.moveTo(120, 45);
			bg_holder.graphics.lineTo(bg_holder.width - 20 , 45);
			image_holder = new Sprite();
			this.addChild(image_holder);
			image_holder.x = 21;
			image_holder.y = 21;
			image_bg_holder = new Sprite();
			image_holder.addChild(image_bg_holder);
			image_bg_holder.graphics.beginFill(0xFFFFFF,1);
			image_bg_holder.graphics.drawRect(0, 0, 79, 79);
			image_bg_holder.graphics.endFill();
			
			subject_label= new TextField(); 
			var format1:TextFormat = new TextFormat();
			format1.font="Arial";
			format1.size = 14;
			format1.color = 0x5A7582;
			format1.bold = true;
			subject_label.autoSize = "left";
			subject_label.text = "";  
			subject_label.name = "text_field";
			subject_label.defaultTextFormat = format1;
			subject_label.setTextFormat(format1);
			subject_label.selectable = false;  
			subject_label.mouseEnabled = false;
			subject_label.x = 120;
			subject_label.y = 20;
			this.addChild(subject_label);
			
			phrase_label= new TextField(); 
			var format2:TextFormat = new TextFormat();
			format2.font="Arial";
			format2.size = 12;
			format2.color = 0x5A7582;
			format2.bold = false;
			phrase_label.autoSize = "left";
			phrase_label.multiline = true;
			phrase_label.wordWrap = true;
			phrase_label.width = bg_holder.width - 140;
			phrase_label.text = "";  
			phrase_label.name = "text_field";
			phrase_label.defaultTextFormat = format2;
			phrase_label.setTextFormat(format2);
			phrase_label.selectable = false;  
			phrase_label.mouseEnabled = false;
			phrase_label.x = 120;
			phrase_label.y = 50;
			this.addChild(phrase_label);
			
			image_loader = new Loader();
			image_holder.addChild(image_loader);
			image_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeLoadingImage);
			this.visible = false;
		}
		
		public function showMiniPreview(node:Object):void {
			this.current_node = node;
			this.visible = true;
			subject_label.text = current_node.info.subject;
			var str:String = current_node.info.text;	
			if(str.length > 130){
					str = str.slice(0,130);
					str += "...";
			}
			phrase_label.text = str;
			
			/*
			
			*/
			var myList:Array = new Array();
			myList = [
				"http://findicons.com/files/icons/1072/face_avatars/300/a05.png",
				"http://png-1.findicons.com/files/icons/1072/face_avatars/300/i04.png",
				"http://png-4.findicons.com/files/icons/1072/face_avatars/300/fh01.png",
				"http://png-1.findicons.com/files/icons/1072/face_avatars/300/g01.png",
			];
			var img:String = getRandomElementOf(myList)as String;
			image_loader.load(new URLRequest(img));	
		}
		
		private function getRandomElementOf(array:Array):Object {
			var idx:int=Math.floor(Math.random() * array.length);
			return array[idx];
		}
		
		private function completeLoadingImage(event:Event):void {
            image_loader.scaleX = 1;
            image_loader.scaleY = 1;
			var ratio:Number = image_loader.width > image_loader.height?(image_bg_holder.width / image_loader.width):(image_bg_holder.height /image_loader.height);
			image_loader.scaleX = ratio;
            image_loader.scaleY = ratio;
			image_loader.x = image_bg_holder.width / 2 - image_loader.width / 2;
			image_loader.y = image_bg_holder.height / 2 - image_loader.height / 2;
        }
		
		
		public function hideMiniPreview():void {
			this.visible = false;
		}
		
		private  function drawRoundRect(spr:Sprite, w:Number , h:Number, tl:Number, tr:Number, bl:Number, br:Number, thick:Number, borderColor:Number, bgColor:Number, trans:Number ):void {
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