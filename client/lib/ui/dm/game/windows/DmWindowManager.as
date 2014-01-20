package dm.game.windows {
import dm.game.windows.chat.Chat;
import dm.game.windows.menu.Menu;
import flash.display.Bitmap;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import org.as3commons.lang.ClassUtils;
import ucc.ui.style.DynamicStyleManager;
import ucc.ui.window.WindowsManager;

/**
 * ...
 * @author zenia
 */
public class DmWindowManager {
	
	// [Embed( source="../../../../../bin-debug/assets/misc/loading_screen.jpg" )]
	// private var LoadingScreen : Class;	
	
	[Embed( source="../../../../../bin-debug/assets/misc/su-seseliu.jpg" )]
	private var VideoBgScreen : Class;
	
	public var windowLayer : DisplayObjectContainer;
	
	/** Menu */
	public var menu : Menu
	
	/** Chat */
	public var chat : Chat;
	
	private var _preloader : Sprite;
	
	/** Video screen */
	private var videoScreenDO 	: Bitmap;
	
	private static var _allowInstantiation : Boolean = false;
	
	private static var _instance : DmWindowManager;
	
	public function DmWindowManager() {
		if ( !_allowInstantiation )
			throw( new Error( "Use 'instance' property to get an instance" ) );
	}
	
	public static function get instance() : DmWindowManager {
		if ( !_instance ) {
			_allowInstantiation = true;
			_instance = new DmWindowManager();
			_allowInstantiation = false;
		}
		return _instance;
	}
	
	public function showPreloader() : void {
		try {
			windowLayer.removeChild( _preloader )
		} catch ( error : Error ) {
		}
		_preloader = new Sprite();
		windowLayer.addChild( _preloader );
		_preloader.graphics.beginFill( 0xCCCCCC );
		_preloader.graphics.drawRect( 0, 0, windowLayer.stage.stageWidth, windowLayer.stage.stageHeight );
		_preloader.graphics.endFill();
		var loadingScreen : Bitmap =  new Bitmap( ClassUtils.newInstance( DynamicStyleManager.getStyleForInstance( this, "loadingScreenBg" ) ) );
		loadingScreen.smoothing = true;
		_preloader.addChild( loadingScreen );
		
		/* sorry, cia ant smugio reikejo :D */
		var judejimas:Sprite = new Judejimas();		
		_preloader.addChild(judejimas);
		judejimas.x = judejimas.stage.stageWidth * 0.5 - judejimas.width * 0.5;
		judejimas.y = judejimas.stage.stageHeight - 100;
		
		var ratio : Number = loadingScreen.width / loadingScreen.height;
		loadingScreen.height = loadingScreen.stage.stageHeight;
		loadingScreen.width = loadingScreen.height * ratio;
		loadingScreen.x = loadingScreen.stage.stageWidth * 0.5 - loadingScreen.width * 0.5;
		loadingScreen.y = loadingScreen.stage.stageHeight * 0.5 - loadingScreen.height * 0.5;
	}
	
	public function showVideoBackground () : void {
		this.videoScreenDO = new this.VideoBgScreen() as Bitmap;
		
		var scale : Number = Math.max( this.windowLayer.stage.stageWidth / this.videoScreenDO.width, this.windowLayer.stage.stageHeight / this.videoScreenDO.height );
		
		this.videoScreenDO.scaleX = scale;
		this.videoScreenDO.scaleY = scale;
		
		this.videoScreenDO.x = this.windowLayer.stage.stageWidth * 0.5 - this.videoScreenDO.width * 0.5;
		this.videoScreenDO.y = this.windowLayer.stage.stageHeight * 0.5  - this.videoScreenDO.height * 0.5;
		
		this.windowLayer.addChildAt( this.videoScreenDO, 0 );
	}
	
	public function hideVideoScreen () : void {
		
		if ( this.videoScreenDO ) {
			this.windowLayer.removeChild( this.videoScreenDO );
			this.videoScreenDO = null;
		}
		
	}
	
	public function addWindow( window : DmWindow ) : Boolean {
		WindowsManager.getInstance().addWindowToManager( window );
		return true;
	}
	
	public function hidePreloader() : void {
		try {
			windowLayer.removeChild( _preloader )
		} catch ( error : Error ) {
		}
	}

}
}