package dm.game.effects {
	import com.greensock.TweenLite;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * In game text
	 * @version $Id: FadingTextEffect.as 212 2013-09-26 05:52:06Z rytis.alekna $
	 */
	public class FadingTextEffect extends Sprite {
		
		[Embed(source="/../bin-debug/assets/fonts/HelvNeueCondDDB-Medium.otf",fontName="dmMedium",mimeType="application/x-font",fontWeight="normal",fontStyle="italic",unicodeRange="U+0020-007E,U+0104-0105,U+010C-010D,U+0116-0119,U+012E-012F,U+0160-0161,U+016A-016B,U+0172-0173,U+017D",advancedAntiAliasing="true",embedAsCFF="false")]
		private var dmMedium:Class;
		
		/** Fade area width */
		private static const FADE_AREA_WIDTH:Number = 100;
		
		/** Text mask */
		private var textMaskDO		:Sprite;
		
		/** Text field */
		private var textTF			:TextField;
		
		/** Background */
		protected var backgroundDO	: Shape;
		
		/**
		 * (Constructor)
		 * - Returns a new FadingTextEffect instance
		 * @param	text
		 */
		public function FadingTextEffect(text:String) {
			
			textTF = new TextField();
			addChild(textTF);
			textTF.embedFonts = true;
			textTF.selectable = false;
			textTF.text = text;
			var textFormat:TextFormat = new TextFormat("dmMedium", 16, 0xFFFFFF, true, true);
			textTF.setTextFormat(textFormat);
			textTF.width = textTF.textWidth + 5;
			textTF.cacheAsBitmap = true;
			
			textMaskDO = new Sprite();
			addChild(textMaskDO);
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(textTF.width + FADE_AREA_WIDTH * 2, textTF.textHeight + 5);
			textMaskDO.graphics.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0xFF0000, 0xFF0000, 0xFFFFFF], [0, 1, 1, 0], [0, 45, 210, 255], matrix);
			textMaskDO.graphics.drawRect(0, 0, textTF.width + FADE_AREA_WIDTH * 2, textTF.textHeight + 5);
			textMaskDO.graphics.endFill();
			textMaskDO.cacheAsBitmap = true;
			textMaskDO.x = -textMaskDO.width;
			textTF.mask = textMaskDO;
			
			this.backgroundDO = new Shape();
			this.backgroundDO.graphics.lineStyle( 1, 0xFFFFFF );
			this.backgroundDO.graphics.beginFill( 0xCCCCCC, 0.5 );
			this.backgroundDO.graphics.drawRoundRect( -5, -5, this.textTF.width + FADE_AREA_WIDTH * 2, this.textTF.textHeight + 15, 15, 15 );
			this.backgroundDO.alpha = 0;
			this.backgroundDO.x = -this.backgroundDO.width;
			this.addChildAt( this.backgroundDO, 0 );
			
		}
		
		public function display():void {
			TweenLite.to(textMaskDO, 1, {x: textTF.x - FADE_AREA_WIDTH});
			TweenLite.to(this.backgroundDO, 1, {x: textTF.x - FADE_AREA_WIDTH, alpha:1});
		}
		
		public function hide():void {
			TweenLite.to(textMaskDO, 1, {x: textTF.x + textTF.width + FADE_AREA_WIDTH, onComplete: destroy});
			TweenLite.to(this.backgroundDO, 0.5, {x: textTF.x + textTF.width + FADE_AREA_WIDTH, onComplete: destroy, alpha: 0 });
		}
		
		public function destroy():void {
			try {
				parent.removeChild(this);
			} catch (error:Error) {
			}
		}
		
		public function getWidth():Number {
			return textTF.width;
		}
	}

}