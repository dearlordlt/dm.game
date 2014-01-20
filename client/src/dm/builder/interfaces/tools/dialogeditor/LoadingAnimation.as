package dm.builder.interfaces.tools.dialogeditor   
{
	/**
	 * ...
	 * @author Darius Dauskurdis dariusdxd@gmail.com
	 * 
	 * 
	 * 
	 */
	
	import flash.display.Sprite;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.events.TimerEvent;
	 
	 
	public class LoadingAnimation extends Sprite
	{
		
		/*private var _anim:Sprite;
		private var _rotate:Number = 0;
		private var _animTimer:Timer;
		private var _animColor:Number;
		private var _animBgColor:Number;
		private var l_anim_holder:Sprite;
		private var bg_rect:Sprite;
		private var is_created:Boolean = false;*/
		
		public var opacity_value:Number;
		public var bgcolor:Number;
		public var loader_color:Number;
		public var bg_holder:Sprite;
		public var loader:Sprite; 
		public var is_active:Boolean; 
		public var anim_timer:Timer;
		public var opacity_anim_timer:Timer;
		
		
		public function LoadingAnimation(opacity_value:Number = 1, bgcolor:Number = 0xFFFFFF,  loader_color:Number = 0x000000)
		{
			this.opacity_value = opacity_value;
			this.bgcolor = bgcolor;
			this.loader_color = loader_color;
			bg_holder = new Sprite();
			bg_holder.graphics.beginFill(bgcolor);
			bg_holder.graphics.drawRect(0,0,1,1);
			bg_holder.graphics.endFill();
			bg_holder.alpha = opacity_value;
			this.addChild(bg_holder);
			loader = new Sprite()
			for(var i:uint = 0; i <= 12; i++){
				var theShape:Sprite = drawStarTriange();
					theShape.rotation = (i * 30);
					theShape.alpha = 0 + (1/12 * i);
				loader.addChild(theShape);
			}
			this.addChild(loader);
			this.visible = false;
			anim_timer = new Timer(70);
			opacity_anim_timer = new Timer(70);
		}
		
		private function drawStarTriange():Sprite{
			var shape:Sprite = new Sprite();
				shape.graphics.beginFill(loader_color, 1);
				shape.graphics.moveTo(-1, -12);
				shape.graphics.lineTo(2, -12);
				shape.graphics.lineTo(1, -5);
				shape.graphics.lineTo(0, -5);
				shape.graphics.lineTo(-1, -12);
				shape.graphics.endFill();
			return shape;
		}
		
		public function showLoadinAnimation(w:Number = 1920, h:Number = 1080):void {
			is_active = true;
			bg_holder.width = w;
			bg_holder.height = h;
			this.visible = true;
			loader.x = bg_holder.width / 2;
			loader.y = bg_holder.height / 2;
			anim_timer.addEventListener(TimerEvent.TIMER, rotateLoader);
			anim_timer.start();
		}
		
		public function hideLoadinAnimation():void {
			opacity_anim_timer.addEventListener(TimerEvent.TIMER, changeLoaderOpacity);
			opacity_anim_timer.start();
		}
		
		private function rotateLoader(evt:TimerEvent):void {
			loader.rotation = loader.rotation + 30;
			if(loader.rotation== 360)loader.rotation = 0;
		}
		
		private function changeLoaderOpacity(evt:TimerEvent):void {
			this.alpha = this.alpha - 0.1;
			if (this.alpha < 0) {
				this.alpha = 0;
			}
			if (this.alpha == 0) {
				opacity_anim_timer.stop();
				opacity_anim_timer.removeEventListener(TimerEvent.TIMER, changeLoaderOpacity);
				is_active = false;
				this.visible = false;
				bg_holder.width = 1;
				bg_holder.height = 1;
				anim_timer.stop();
				anim_timer.removeEventListener(TimerEvent.TIMER, rotateLoader);
			}
			
		}
		
		
	}

}