package ucc.operation.generic  {
	import ucc.data.service.RemoteMethodCall;
	import ucc.operation.AbstractOperation;
	import ucc.operation.OperationState;
	
/**
 * Service call operation
 *
 * @version $Id: ServiceCallOperation.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class ServiceCallOperation extends AbstractOperation {
	
	/** Remote method call */
	protected var remoteMethodCall : RemoteMethodCall;
	
	/** Result */
	protected var result			: Object;
	
	/**
	 * Class constructor
	 */
	public function ServiceCallOperation ( remoteMethodName : String, ... params ) {
		this.remoteMethodCall = new RemoteMethodCall( remoteMethodName, params,  )
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function start (  ) : void {
		super.start();
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function stop (  ) : void {
		this.setState( OperationState.STOPPED );
	}
	
	/**
	 * On result
	 */
	protected function onResult ( result : Object ) : void {
		if ( this.getState() == OperationState.RUNNING ) {
			this.setState( OperationState.COMPLETED );
		}
	}
	
	/**
	 * On fault
	 */
	protected function onFault ( result : Object ) : void {
		if ( this.getState() == OperationState.RUNNING ) {
			this.setState( OperationState.FAILED );
		}
	}
	
	/**
	 * Get result
	 */
	public function getResult () : Object {
		return result;
	}
	
}
	
}