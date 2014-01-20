package ucc.ui.skin {

	import flash.text.Font;
	import flash.text.TextFormat;
	import org.as3commons.lang.ClassUtils;
	import ucc.ui.style.DynamicStyleManager;	
	
/**
 * Green skin
 * @version $Id: BlueSkin.as 173 2013-07-02 07:02:27Z rytis.alekna $
 */
public class BlueSkin extends AbstractSkin {
	
	/**
	 * (Constructor)
	 * - Returns a new BlueSkin instance
	 */
	public function BlueSkin() {
		
		// label styles
		var dmLightFont:Font = ClassUtils.newInstance( ClassUtils.forName("dmLight"));
		var labelTextFormat:TextFormat = new TextFormat(dmLightFont.fontName, 13, 0xFFFFFF);
		DynamicStyleManager.setComponentStyle("fl.controls.Label", "textFormat", labelTextFormat);
		DynamicStyleManager.setComponentStyle("fl.controls.Label", "embedFonts", true);
		
		DynamicStyleManager.setComponentStyle("fl.controls.CheckBox", "textFormat", labelTextFormat);
		DynamicStyleManager.setComponentStyle("fl.controls.CheckBox", "embedFonts", true);
		
		// DynamicStyleManager.setComponentStyle( Button, "textFormat", new TextFormat( dmLightFont.fontName, 12, 0x6D6E70, true ) );
		DynamicStyleManager.setComponentStyle("fl.controls.Button", "textFormat", new TextFormat(dmLightFont.fontName, 12, 0xFFFFFF, true));
		DynamicStyleManager.setComponentStyle("fl.controls.Button", "disabledTextFormat", new TextFormat(dmLightFont.fontName, 12, 0xCCCCCC, true));
		
		DynamicStyleManager.setComponentStyle("fl.controls.Button", "embedFonts", true);
		DynamicStyleManager.setComponentStyle("fl.controls.List", "contentPadding", 2);
		
		DynamicStyleManager.setComponentStyle( "ucc.ui.window.tab.TabButton", "textFormat", new TextFormat(dmLightFont.fontName, 12, 0xFFFFFF, false, true ) );
		DynamicStyleManager.setComponentStyle( "ucc.ui.window.tab.TabButton", "disabledTextFormat", new TextFormat(dmLightFont.fontName, 12, 0xCCCCCC, false, true ) );
		DynamicStyleManager.setComponentStyle( "ucc.ui.window.tab.TabButton", "embedFonts", true );
		
		DynamicStyleManager.setComponentStyle( "dm.game.windows.DmWindowManager", "loadingScreenBg", DmLoadingScreen );
		
		DynamicStyleManager.setComponentStyle( "dm.game.windows.dialogviewer.DialogOption", "textFormat", new TextFormat(dmLightFont.fontName, 12, 0x777777, true, false) );
		
		DynamicStyleManager.setComponentStyle( "dm.game.windows.dialogviewer.DialogOption", "buttonColor",  0xE45C2D );		
		
	}
	
}

}