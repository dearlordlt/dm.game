package dm.game.windows.media {
	import dm.game.windows.DmWindow;
	import fl.containers.UILoader;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	

/**
 * Image viewer
 * @version $Id: ImageViewer.as 216 2013-10-02 05:00:40Z rytis.alekna $
 */
public class ImageViewer extends DmWindow implements MediaPlayer {
	
	/** Ui loader */
	public var uiLoaderDO		: UILoader;	
	
	/** Mask */
	public var maskDO			: MovieClip;
		
	/** MARGIN */
	public static const MARGIN 	: Number = 200;
	
	/** File path */
	protected var filePath 		: String;
	
	/** loader */
	protected var loader 		: Loader;
	
	/**
	 * (Constructor)
	 * - Returns a new ImageViewer instance
	 */
	public function ImageViewer() {
		super( null, _("Image viever") );
	}
	
	/**
	 * Sets the FilePath property of this instance.
	 */
	public function setFilePath ( value : String ) : void {
		this.filePath = value;
		// this.uiLoaderDO.source = this.filePath;
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function initialize () : void {
		
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function postInitialize () : void {
		
		
		if ( this.filePath ) {
			
			loader = new Loader();
			
			loader.x = 15;
			loader.y = 35;
			loader.load( new URLRequest( this.filePath ) );
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, this.onContentLoadComplete );
			
			this.addChild( loader );
			
			/*
			this.uiLoaderDO.load( new URLRequest( this.filePath ) )
			this.uiLoaderDO.addEventListener( Event.COMPLETE, this.onContentLoadComplete );
			*/
			this.filePath = null;
		}
		
	}
	
	/**
	 *	On content load complete
	 */
	protected function onContentLoadComplete ( event : Event) : void {
		
		this.loader.scaleX = this.loader.scaleY = this.getImageScaleRatio( this.loader );
		
		this.maskDO.width 	= this.loader.width;
		this.maskDO.height 	= this.loader.height;
		this.loader.mask = this.maskDO;
		
		super.redraw();
		
		// repositioning to center
		this.x = ( this.stage.stageWidth - this.width ) / 2;
		this.y = ( this.stage.stageHeight - this.height ) / 2;
		
	}
	
	protected function getImageScaleRatio ( loader : Loader ) : Number {
		
		var widthRatio 	: Number = Math.min( 1, ( this.stage.stageWidth - MARGIN ) / loader.contentLoaderInfo.width );
		var heightRatio : Number = Math.min( 1, ( this.stage.stageHeight - MARGIN ) / loader.contentLoaderInfo.height );
		
		return Math.min( widthRatio, heightRatio );
		
	}
	
}

}