package ucc.data.service  {
	import ucc.error.IllegalStateException;
	import ucc.logging.Logger;
	
/**
 * Serrvice
 *
 * @version $Id: Service.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class Service {
	
	/** Already called? */
	protected var called		: Boolean;
	
	/** Remote method call */
	protected var remoteMethodCall		: RemoteMethodCall;
	
	/**
	 * Class constructor
	 */
	public function Service ( remoteMethodCall : RemoteMethodCall = null ) {
		this.remoteMethodCall = remoteMethodCall;
	}
	
	/**
	 * Add responder
	 */
	public function addResponders ( resultCallback : Function = null, faultCallback : Function = null ) : Service {
		this.remoteMethodCall.onResultCallback 	= resultCallback;
		this.remoteMethodCall.onFaultCallback	= faultCallback;
		return this;
	}
	
	/**
	 * Call service
	 */
	public function call () : Service {
		if ( this.called ) {
			Logger.log( "ucc.data.service.Service.call() : service allready called same service!" );
			this.remoteMethodCall.resetUUID();
			// throw new IllegalStateException( "ucc.data.service.Service.call() : service allready called!" );
		}
		AmfPhpClient.getInstance().placeRemoteMethodCall( this.remoteMethodCall );
		this.called = true;
		return this;
	}
	
	/**
	 * Create service
	 */
	protected static function createService ( remoteMethod : String, params : Array = null, onResultCallback : Function = null, onFaultCallback : Function = null ) : Service {
		return new Service( new RemoteMethodCall( remoteMethod, params, onResultCallback, onFaultCallback ) );
	}
}
	
}