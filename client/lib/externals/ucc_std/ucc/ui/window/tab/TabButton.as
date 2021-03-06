package ucc.ui.window.tab {
	import fl.controls.Button;
	import fl.core.UIComponent;
	import fl.managers.StyleManager;
	import flash.text.Font;
	import flash.text.TextFormat;
	

/**
 * Tab button
 * @version $Id: TabButton.as 27 2013-05-06 05:42:57Z rytis.alekna $
 */
public class TabButton extends Button {
	
	private static var defaultStyles:Object = {
		"upSkin" : "ucc.ui.window.tab.TabButtonUpSkin",
		"downSkin": "ucc.ui.window.tab.TabButtonUpSkin",
		"overSkin": "ucc.ui.window.tab.TabButtonUpSkin",
		"disabledSkin": "ucc.ui.window.tab.TabButtonUpSkin",
		"selectedDisabledSkin": "ucc.ui.window.tab.TabButtonDisabledSkin",
		"selectedUpSkin": "ucc.ui.window.tab.TabButtonDisabledSkin",
		"selectedDownSkin": "ucc.ui.window.tab.TabButtonDisabledSkin",
		"selectedOverSkin": "ucc.ui.window.tab.TabButtonDisabledSkin",
		
		"embedFonts": true,
		"textFormat": new TextFormat("HelvNeueCondDDB", 16, 0xFFFFFF, false, true ),
		"disabledTextFormat": new TextFormat("HelvNeueCondDDB", 16, 0xCCCCCC, false, true )
	};	
	
	public static function getStyleDefinition():Object { 
		return UIComponent.mergeStyles(defaultStyles, Button.getStyleDefinition());
	}	
	
	// static initializator
	/**
	 * Static constructor
	 */
	private static function staticConstructor () : void {
		/*
		StyleManager.setComponentStyle(TabButton, "upSkin", ucc.ui.window.tab.TabButtonUpSkin );
		StyleManager.setComponentStyle(TabButton, "downSkin", ucc.ui.window.tab.TabButtonUpSkin );
		StyleManager.setComponentStyle(TabButton, "overSkin", ucc.ui.window.tab.TabButtonUpSkin );
		StyleManager.setComponentStyle(TabButton, "disabledSkin", ucc.ui.window.tab.TabButtonUpSkin );
		StyleManager.setComponentStyle(TabButton, "selectedDisabledSkin", ucc.ui.window.tab.TabButtonDisabledSkin );
		StyleManager.setComponentStyle(TabButton, "selectedUpSkin", ucc.ui.window.tab.TabButtonDisabledSkin );
		StyleManager.setComponentStyle(TabButton, "selectedDownSkin", ucc.ui.window.tab.TabButtonDisabledSkin );
		StyleManager.setComponentStyle(TabButton, "selectedOverSkin", ucc.ui.window.tab.TabButtonDisabledSkin );
		var dmItalicFont : Font = new dmItalic();
		StyleManager.setComponentStyle(TabButton, "textFormat", new TextFormat(dmItalicFont.fontName, 16, 0xFFFFFF, false, true ));
		StyleManager.setComponentStyle(TabButton, "disabledTextFormat", new TextFormat(dmItalicFont.fontName, 16, 0xCCCCCC, false, true ));
		*/
	}
	
	/**
	 * Class constructor
	 */
	public function TabButton () {
		
		/*
		StyleManager.setComponentStyle(this, "upSkin", "ucc.ui.window.tab.TabButtonUpSkin" );
		StyleManager.setComponentStyle(this, "downSkin", "ucc.ui.window.tab.TabButtonUpSkin" );
		StyleManager.setComponentStyle(this, "overSkin", "ucc.ui.window.tab.TabButtonUpSkin" );
		StyleManager.setComponentStyle(this, "disabledSkin", "ucc.ui.window.tab.TabButtonUpSkin" );
		StyleManager.setComponentStyle(this, "selectedDisabledSkin", "ucc.ui.window.tab.TabButtonDisabledSkin" );
		StyleManager.setComponentStyle(this, "selectedUpSkin", "ucc.ui.window.tab.TabButtonDisabledSkin" );
		StyleManager.setComponentStyle(this, "selectedDownSkin", "ucc.ui.window.tab.TabButtonDisabledSkin" );
		StyleManager.setComponentStyle(this, "selectedOverSkin", "ucc.ui.window.tab.TabButtonDisabledSkin" );
		var dmItalicFont : Font = new dmItalic();
		StyleManager.setComponentStyle(this, "embedFonts", true);
		StyleManager.setComponentStyle(this, "textFormat", new TextFormat(dmItalicFont.fontName, 16, 0xFFFFFF, false, true ));
		StyleManager.setComponentStyle(this, "disabledTextFormat", new TextFormat(dmItalicFont.fontName, 16, 0xCCCCCC, false, true ));		
		*/
		
		this.height = 30;
	}
	
}

}