package ucc.operation.load  {
	import ucc.error.IllegalArgumentException;
	import ucc.operation.AbstractOperation;
	import ucc.operation.OperationState;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
/**
 * Display object load operation
 *
 * @version $Id: DisplayObjectLoadOperation.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class DisplayObjectLoadOperation extends AbstractOperation {
	
	/** Url request */
	protected var request			: URLRequest;
	
	/** Loader */
	protected var loaderDO			: Loader;
	
	/** Loader context */
	protected var loaderContext		: LoaderContext;
	
	/** Loaded display object */
	protected var loadedDO			: DisplayObject;
	
	/**
	 * Class constructor
	 */
	public function DisplayObjectLoadOperation ( source : *, loaderContext : LoaderContext = null ) {
		
		if ( source is String ) {
			this.request = new URLRequest( source );
		} else if ( source is URLRequest ) {
			this.request = source;
		} else {
			throw new IllegalArgumentException( "Invalid source parameter!" );
		}
		
		this.loaderContext = loaderContext ? loaderContext : new LoaderContext( false, ApplicationDomain.currentDomain );
		
	}
	
	/** 
	 * Get request
	 * 
	 * @return 	request
	 */
	public function getRequest() : URLRequest {
		return this.request;
	}
	
	/**
	 * Get loaded display object
	 * @return
	 */
	public function getLoadedDO () : DisplayObject {
		return this.loadedDO;
	}
	
	/** 
	 * Create loader
	 */
	protected function createLoader() : void {
	
		this.loaderDO = new Loader();
		
		this.loaderDO.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, this.onLoaderProgress );
		this.loaderDO.contentLoaderInfo.addEventListener( Event.COMPLETE, this.onLoaderComplete );
		this.loaderDO.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, this.onLoaderFail );
	}
	
	/**
	 * Destroy loader
	 */
	protected function destroyLoader() : void {
		
		this.loaderDO.contentLoaderInfo.removeEventListener( ProgressEvent.PROGRESS, this.onLoaderProgress );
		this.loaderDO.contentLoaderInfo.removeEventListener( Event.COMPLETE, this.onLoaderComplete );
		this.loaderDO.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, this.onLoaderFail );
		
		this.loaderDO = null;
	}
	
	/**
	 * Start task
	 */
	override public function start() : void {
		
		this.setState( OperationState.RUNNING );
		
		this.setProgress( 0 );
		
		this.createLoader();
		
		// Try to load
		try {
			this.loaderDO.load( this.request, this.loaderContext );
		
		// Error - fail	
		} catch( e : Error ) {
			
			this.destroyLoader();
			this.setState( OperationState.FAILED );
		}
	}
	
	/** 
	 * Stop task
	 */
	override public function stop() : void {
		
		this.destroyLoader();
		
		this.setState( OperationState.STOPPED );
	}
	
	/**
	 * On loader complete
	 * 
	 * @param	event
	 */
	protected function onLoaderComplete( event : Event ) : void {
		
		this.loadedDO = this.loaderDO.content;
		
		this.destroyLoader();
		
		this.setProgress( 1 );
		
		this.setState( OperationState.COMPLETED );
	}
	
	/**
	 * On loader progress
	 * 
	 * @param	event
	 */
	protected function onLoaderProgress( event : ProgressEvent ) : void {
		
		if( event.bytesTotal > 0 ) {
			this.setProgress( event.bytesLoaded / event.bytesTotal );
		} else {
			this.setProgress( 0 );
		}
	}
	
	/**
	 * On loader fail
	 * 
	 * @param	event
	 */
	protected function onLoaderFail( event : Event ) : void {
		
		this.destroyLoader();
		
		this.setState( OperationState.FAILED);
	}	
	
}
	
}