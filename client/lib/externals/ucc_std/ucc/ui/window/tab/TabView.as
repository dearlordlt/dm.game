package ucc.ui.window.tab {
	
import dm.game.windows.DmWindow;
import fl.core.UIComponent;
import flash.display.MovieClip;
import ucc.ui.window.WindowEvent;
import ucc.util.DisplayObjectUtil;
	
/**
 * Tab view
 * 
 * @version $Id: TabView.as 27 2013-05-06 05:42:57Z rytis.alekna $
 */
public class TabView extends MovieClip {
	
	/**
	 * Redraw
	 */
	public function redraw () : void {
		
		var uiComponents : Array = DisplayObjectUtil.getDescendantsByType( this, UIComponent );
		for each( var item : UIComponent in uiComponents ) {
			try {
				item.validateNow();
			} catch ( error : Error ) {
				// trace( "[dm.game.windows.DmWindow.redraw] error : " + error );
			}
			
		}		
		
		/*
		this.dispatchEvent( new WindowEvent( WindowEvent.REDRAW, true ) );
		
		
		if ( this.parent ) {
			if ( this.parent is DmWindow ) {
				( this.parent as DmWindow ).redraw();
			} else if ( this.parent is TabView ) {
				( this.parent as TabView ).redraw();
			}
			
		}
		*/
		
	}
	
}

}