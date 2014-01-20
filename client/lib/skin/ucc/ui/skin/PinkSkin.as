package ucc.ui.skin {
	import flash.display.DisplayObjectContainer;
	import flash.text.Font;
	import flash.text.TextFormat;
	import org.as3commons.lang.ClassUtils;
	import ucc.ui.graphic.DashedLine;
	import ucc.ui.style.DynamicStyleManager;
	
/**
 * Orange skin
 * 
 * @version $Id: PinkSkin.as 125 2013-05-14 08:31:39Z rytis.alekna $
 */
public class PinkSkin extends AbstractSkin {
	
	/**
	 *	@inheritDoc
	 */
	public override function setStyles () : void {
		
		// label styles
		var dmLightFont:Font = ClassUtils.newInstance( ClassUtils.forName("Arial"));
		var labelTextFormat:TextFormat = new TextFormat(dmLightFont.fontName, 11, 0x575756, false);
		DynamicStyleManager.setComponentStyle("fl.controls.Label", "textFormat", labelTextFormat);
		// DynamicStyleManager.setComponentStyle("fl.controls.Label", "embedFonts", true);
		
		DynamicStyleManager.setComponentStyle("fl.controls.CheckBox", "textFormat", labelTextFormat);
		// DynamicStyleManager.setComponentStyle("fl.controls.CheckBox", "embedFonts", true);
		
		// DynamicStyleManager.setComponentStyle( Button, "textFormat", new TextFormat( dmLightFont.fontName, 12, 0x6D6E70, true ) );
		DynamicStyleManager.setComponentStyle("fl.controls.Button", "textFormat", new TextFormat(dmLightFont.fontName, 11, 0xFFFFFF, false));
		DynamicStyleManager.setComponentStyle("fl.controls.Button", "disabledTextFormat", new TextFormat(dmLightFont.fontName, 11, 0xCCCCCC, false));
		
		// DynamicStyleManager.setComponentStyle("fl.controls.Button", "embedFonts", true);
		DynamicStyleManager.setComponentStyle("fl.controls.List", "contentPadding", 2);		
		
		DynamicStyleManager.setComponentStyle( "dm.game.windows.Tooltip", "outlineFunction", this.drawToolTipOutline );
		
		DynamicStyleManager.setComponentStyle( "ucc.ui.window.tab.TabButton", "textFormat", new TextFormat(dmLightFont.fontName, 14, 0x575756, false, false ) );
		DynamicStyleManager.setComponentStyle( "ucc.ui.window.tab.TabButton", "disabledTextFormat", new TextFormat(dmLightFont.fontName, 14, 0xFFFFFF, false, false ) );
		DynamicStyleManager.setComponentStyle( "ucc.ui.window.tab.TabButton", "embedFonts", false );
		
		DynamicStyleManager.setComponentStyle( "dm.game.windows.DmWindowManager", "loadingScreenBg", VdkLoadingScreen );
		
		
		DynamicStyleManager.setComponentStyle( "dm.game.windows.dialogviewer.DialogOption", "textFormat", new TextFormat(dmLightFont.fontName, 14, 0x777777, true, false) );
		DynamicStyleManager.setComponentStyle( "dm.game.windows.dialogviewer.DialogOption", "buttonColor",  0xED0A6D ); // 0xE45C2D
		
		
		
		// new TextFormat(font.fontName, 12, 0x777777, true, true)
		
	}
	
	private function drawToolTipOutline ( w : Number, h : Number, target : DisplayObjectContainer ) : void {
		
		var dashedLine : DashedLine;
		
		if ( target.getChildByName("outlineDO") ) {
			dashedLine = target.getChildByName("outlineDO") as DashedLine;
		} else {
			dashedLine = new DashedLine( 1, 0x575756, 0.6, [5, 3] );
			target.addChildAt( dashedLine, 0 );
		}
		
		dashedLine.clear();
		dashedLine.beginFill( 0xFFFFFF, 0.6 );
		
		dashedLine.moveTo( 0, 0 );
		dashedLine.lineTo( w * 0.5 - 7, 0 );
		
		// draw pointer
		dashedLine.lineTo( w * 0.5, -10 );
		dashedLine.lineTo( w * 0.5 + 7, 0 );
		
		dashedLine.lineTo( w, 0 );
		dashedLine.lineTo( w, h );
		dashedLine.lineTo( 0, h );
		dashedLine.lineTo( 0, 0 );
		dashedLine.endFill();
		
	}
	
}

}