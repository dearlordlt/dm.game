package dm.minigames.artgame {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.filters.GlowFilter;
	import flash.events.MouseEvent;
	import flash.geom.*;
	
	/**
	 * ...
	 * @author Darius Dauskurdis dariusdxd@gmail.com
	 */
	public class ArtGame extends Sprite {
		
		public var main_parent:*;
		public var m_window_holder:MovieClip;
		public var m_window_background:MovieClip;
		public var m_window_content_holder:MovieClip;
		public var m_window_title:TextField;
		public var m_window_title_holder:MovieClip;
		public var m_window_title_background:MovieClip;
		public var close_btn:close_circle;
		public var close_circle_rad:Number = 6;
		public var m_window_padding:Number = 10;
		public var window_width:Number = 300;
		public var t_format:TextFormat;
		public var title_padding_hor:Number = 20;
		public var title_padding_ver:Number = 5;
		public var title_corner:Number = 10;
		
		private var _mode:String;
		
		public function ArtGame(mode:String = "frontend"):void {
			_mode = mode;
			
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			main_parent = this.parent;
			m_window_holder = new MovieClip;
			this.addChild(m_window_holder);
			m_window_background = new MovieClip;
			m_window_holder.addChild(m_window_background);
			m_window_background.addEventListener(MouseEvent.MOUSE_DOWN, m_window_background_mouseDown)
			m_window_background.addEventListener(MouseEvent.MOUSE_UP, m_window_background_mouseUp);
			
			var glow:GlowFilter = new GlowFilter();
			glow.quality = 3;
			glow.blurX = 5;
			glow.blurY = 5;
			glow.color = 0xaaaaaa;
			m_window_background.filters = [glow];
			
			close_btn = new close_circle;
			m_window_holder.addChild(close_btn);
			m_window_title_holder = new MovieClip;
			m_window_holder.addChild(m_window_title_holder);
			m_window_title_holder.mouseEnabled = false;
			m_window_title_holder.mouseChildren = false;
			//close_btn.addEventListener(MouseEvent.CLICK, close_btn_click);
			m_window_content_holder = new MovieClip;
			m_window_holder.addChild(m_window_content_holder);
			
			m_window_title_background = new MovieClip;
			m_window_title_holder.addChild(m_window_title_background);
			m_window_title = new TextField;
			m_window_title_holder.addChild(m_window_title);

			var art_game_environment_obj:art_game_environment = new art_game_environment(_mode);
			m_window_content_holder.addChild(art_game_environment_obj);
			update_m_window();
		
			//change_window_title("DAILĖ");
		
		}
		
		private function m_window_background_mouseDown(event:MouseEvent):void {
			this.startDrag();
		}
		
		private function m_window_background_mouseUp(event:MouseEvent):void {
			this.stopDrag();
		}
		
		private function update_close_btn():void {
			close_btn.x = m_window_content_holder.width + 2 * m_window_padding;
			close_btn.y = close_circle_rad;
		}
		
		public function update_m_window():void {
			m_window_content_holder.y = m_window_title_holder.y + m_window_title_holder.height + m_window_padding;
			m_window_content_holder.x = m_window_padding;
			update_m_window_background();
			update_close_btn();
			//trace(m_window_content_holder.height)
		}
		
		public function change_window_title(title:String):void {
			add_m_window_title(title);
			m_window_content_holder.y = m_window_title_holder.y + m_window_title_holder.height + m_window_padding;
			m_window_content_holder.x = m_window_padding;
			update_m_window_background();
			update_close_btn();
		}
		
		private function get_content_size(val:Number):Number {
			var entry:Number
			var resize_obj_1:Object = m_window_content_holder.getChildAt(0);
			if (resize_obj_1.numChildren > 0) {
				var resize_obj_2:Object = resize_obj_1.getChildAt(0);
				if (resize_obj_2.numChildren > 0) {
					for (var i:uint = 0; i < resize_obj_2.numChildren; i++) {
						var resize_obj_3:Object = resize_obj_2.getChildAt(i);
						if (resize_obj_3.numChildren > 0) {
							var resize_obj_4:Object = resize_obj_3.getChildAt(0);
							if (val == 0) {
								entry = resize_obj_4.width;
							} else {
								entry = resize_obj_4.height;
							}
						}
					}
					
				}
			}
			return entry;
		}
		
		private function update_m_window_background():void {
			var w_f_c_c:Number = close_circle_rad; //window frame close circle
			var w_f_c:Number = 10; //window frame corner
			var max_content_width:Number;
			if (m_window_content_holder.width >= m_window_title_holder.width) {
				max_content_width = m_window_content_holder.width + 2 * m_window_padding;
			} else {
				max_content_width = m_window_title_holder.width + 2 * m_window_padding;
			}
			var w_f_w:Number = m_window_content_holder.width + 2 * m_window_padding; //window frame width
			var w_f_h:Number = m_window_content_holder.y + get_content_size(1) + m_window_padding - close_circle_rad; //window frame height
			//var w_f_h:Number = m_window_content_holder.height - close_circle_rad;
			m_window_background.graphics.clear();
			m_window_background.graphics.lineStyle(1, 0xFFFFFF);
			m_window_background.graphics.beginFill(0xFFFFFF, 0.5);
			m_window_background.graphics.moveTo(0, w_f_c + close_circle_rad);
			m_window_background.graphics.curveTo(0, 0 + close_circle_rad, w_f_c, 0 + close_circle_rad);
			m_window_background.graphics.lineTo(w_f_w - close_circle_rad, 0 + close_circle_rad);
			m_window_background.graphics.curveTo(w_f_w - close_circle_rad, -close_circle_rad + close_circle_rad, w_f_w, -close_circle_rad + close_circle_rad);
			m_window_background.graphics.curveTo(w_f_w + close_circle_rad, -close_circle_rad + close_circle_rad, w_f_w + close_circle_rad, 0 + close_circle_rad);
			m_window_background.graphics.curveTo(w_f_w + close_circle_rad, close_circle_rad + close_circle_rad, w_f_w, w_f_c_c + close_circle_rad);
			m_window_background.graphics.lineTo(w_f_w, w_f_h - w_f_c + close_circle_rad);
			m_window_background.graphics.curveTo(w_f_w, w_f_h + close_circle_rad, w_f_w - w_f_c, w_f_h + close_circle_rad);
			m_window_background.graphics.lineTo(w_f_c, w_f_h + close_circle_rad);
			m_window_background.graphics.curveTo(0, w_f_h + close_circle_rad, 0, w_f_h - w_f_c + close_circle_rad);
			m_window_background.graphics.endFill();
			m_window_background.alpha = 0.5;
		}
		
		private function add_m_window_title(title_val:String):void {
			t_format = new TextFormat();
			t_format.font = "Arial";
			t_format.size = 14;
			t_format.color = 0xFFFFFF;
			m_window_title.autoSize = "left";
			m_window_title.selectable = false;
			m_window_title.multiline = true;
			m_window_title.mouseEnabled = false;
			m_window_title.defaultTextFormat = t_format;
			m_window_title.text = title_val.toUpperCase();
			m_window_title.x = title_padding_hor;
			m_window_title.y = title_padding_ver;
			m_window_title_holder.x = m_window_padding;
			m_window_title_holder.y = close_circle_rad;
			if (m_window_title.width > (window_width - 2 * m_window_padding - close_circle_rad - 2 * title_padding_hor - 10)) {
				m_window_title.wordWrap = true;
				m_window_title.width = window_width - 2 * m_window_padding - close_circle_rad - 2 * title_padding_hor - 10;
			}
			
			m_window_title_background.graphics.clear();
			drawRoundRect(m_window_title_background, m_window_title.width + title_padding_hor * 2, m_window_title.height + title_padding_ver * 2, 0, 0, title_corner, title_corner, 0, 0x000000, 0xF05A23, 1);
			draw_title_shadow();
		}
		
		private function drawRoundRect(m_clip:MovieClip, w:Number, h:Number, tl:Number, tr:Number, bl:Number, br:Number, thick:Number, borderColor:Number, bgColor:Number, trans:Number):void {
			if (thick != 0)
				m_clip.graphics.lineStyle(thick, borderColor);
			m_clip.graphics.beginFill(bgColor, trans);
			m_clip.graphics.moveTo(0, tl);
			m_clip.graphics.curveTo(0, 0, tl, 0);
			m_clip.graphics.lineTo(w - tr, 0);
			m_clip.graphics.curveTo(w, 0, w, tr);
			m_clip.graphics.lineTo(w, h - br);
			m_clip.graphics.curveTo(w, h, w - br, h);
			m_clip.graphics.lineTo(bl, h);
			m_clip.graphics.curveTo(0, h, 0, h - bl);
			m_clip.graphics.endFill();
		}
		
		private function draw_title_shadow():void {
			var fillType:String = "linear";
			var colors:Array = [0xC84E0C, 0xF05A23];
			var alphas:Array = [1, 1];
			var ratios:Array = [0, 255];
			var matr:Matrix = new Matrix();
			matr.createGradientBox(m_window_title_background.width, 6, Math.PI / 2, 3, 0);
			m_window_title_background.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr);
			m_window_title_background.graphics.moveTo(0, 0);
			m_window_title_background.graphics.lineTo(m_window_title_background.width, 0);
			m_window_title_background.graphics.lineTo(m_window_title_background.width, 6);
			m_window_title_background.graphics.lineTo(0, 6);
			m_window_title_background.graphics.endFill();
		}
	
	}

}