package dm.builder.interfaces {

import flash.display.DisplayObjectContainer;
import ucc.ui.window.WindowsManager;

/**
 * Old window manager left buried pars compatibility. It is just a wrapper for ucc.ui.window.WindowsManager
 * @version $Id: WindowManager.as 28 2013-02-21 15:32:33Z rytis.alekna $
 */
public class WindowManager {
	
	/** Singleton instance */
	private static var _instance : WindowManager;
	
	/** Top layer */
	protected var _topLayer : DisplayObjectContainer;
	
	/**
	 * Class constructor
	 */
	public function WindowManager () {
		
	}
	
	public static function get instance() : WindowManager {
		if ( !_instance ) {
			_instance = new WindowManager();
		}
		return _instance;
	}
	
	public function get topLayer () : DisplayObjectContainer {
		return WindowsManager.getInstance().getDefaultParentContainer();
	}
	
	public function set topLayer ( value : DisplayObjectContainer ) : void {
		WindowsManager.getInstance().setDefaultParentContainer( value );
	}
	
	public function addWindow( window : BuilderWindow, parent : DisplayObjectContainer = null ) : void {
		// _windows.push(window);
		WindowsManager.getInstance().addWindowToManager( window, parent );
	}
	
	public function removeWindow( window : BuilderWindow ) : void {
		window.destroy();
	}
	
	public function getWindowById( id : String ) : BuilderWindow {
		return WindowsManager.getInstance().getWindowById( id ) as BuilderWindow;
	}
	
	public function dispatchMessage( message : String ) : void {
		new BuilderMessage( topLayer, "Message", message );
	}

}

}