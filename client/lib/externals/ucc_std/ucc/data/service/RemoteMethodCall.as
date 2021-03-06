package ucc.data.service  {
	
import ucc.util.StringUtil;

/**
 * Net connection call
 * @version $Id: RemoteMethodCall.as 3 2013-01-31 07:31:58Z rytis.alekna $
 */
public class RemoteMethodCall {
	
	/** Remote method */
	public var remoteMethod 		: String;
	
	/** Params */
	public var params 				: Array;
	
	/** On result callback */
	public var onResultCallback 	: Function;
	
	/** On fault callback */
	public var onFaultCallback 		: Function;
	
	/** UUID */
	protected var uuid				: String;
	
	/** Last result */
	internal var lastResult 		: * ;
	
	/** Call stack trace */
	internal var callStackTrace	: String;
	
	/**
	 * Class constructor
	 */
	public function RemoteMethodCall ( remoteMethod : String, params : Array = null, onResultCallback : Function = null, onFaultCallback : Function = null ) {
		this.remoteMethod = remoteMethod;
		this.params = params;
		this.onResultCallback = onResultCallback;
		this.onFaultCallback = onFaultCallback;
		this.resetUUID();
	}
	
	/**
	 * Get unique identifier of this call
	 * @return
	 */
	public function getUUID () : String {
		return this.uuid;
	}
	
	/**
	 * Reset UUID for new call
	 * @return
	 */
	public function resetUUID () : void {
		this.uuid = StringUtil.random( 15, true );
	}
	
	/**
	 * Get last result. Be aware that value is is not cloned.
	 */
	public function getLastResult () : * {
		return this.lastResult;
	}
	
	/**
	 * Get call stack trace
	 * @return	call stack trace of remote method call
	 */
	public function getCallStackTrace () : String {
		return this.callStackTrace;
	}
	
	/**
	 * Remote method call
	 * @return
	 */
	public function clone () : RemoteMethodCall {
		var retVal : RemoteMethodCall = new RemoteMethodCall( this.remoteMethod, this.params.concat(), this.onResultCallback, this.onFaultCallback );
		retVal.lastResult = this.lastResult;
		retVal.uuid = this.getUUID();
		return retVal;
	}
	
	/**
	 * To string
	 */
	public function toString () : String {
		return "RemoteMethodCall[ method: " + this.remoteMethod + ", uuid: " + this.uuid + " ]";
	}
	
}
	
}