package ucc.operation.generic  {
	import ucc.error.IllegalArgumentException;
	import ucc.operation.AbstractOperation;
	import ucc.operation.OperationState;
	import ucc.util.ObjectUtil;
	import ucc.util.PropertyChain;
	import org.as3commons.lang.ObjectUtils;
	
/**
 * Function call operation
 *
 * @version $Id: FunctionCallOperation.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class FunctionCallOperation extends AbstractOperation {
	
	/** Callback */
	protected var callback			: *;
	
	/** Call parameters */
	protected var parameters		: Array;
	
	/** Handle exceptions */
	protected var failOnException	: Boolean;
	
	/**
	 * Class constructor
	 */
	public function FunctionCallOperation ( callback : * , parameters : Array = null, failOnException : Boolean = false ) {
		
		if ( ( callback == null ) || !( ( callback is Function ) || ( callback is PropertyChain ) ) ) {
			throw new IllegalArgumentException( "Callback must be not null Function callback or PropertyChain!" );
		}	
		
		this.callback = callback;
		this.parameters = parameters;
		this.failOnException = failOnException;
	}
	
	/**
	 * @inheritDoc
	 */
	override public function start() : void  {
		
		this.setState( OperationState.RUNNING );
		this.setProgress( 0 );
		if ( this.failOnException ) {
			try {
				
				if ( this.callback is Function ) {
					this.callback.apply( null, this.parameters );
				} else if ( this.callback is PropertyChain ) {
					( ObjectUtil.resolvePropertyChain( this.callback.chain, this.callback.targetInstance ) as Function ).apply( this.parameters );
				}
				
				if ( this.getState() == OperationState.RUNNING ) {
					this.setProgress( 1 );
					this.setState( OperationState.COMPLETED );
				}
				
			} catch ( error : Error ) {
				this.setState( OperationState.FAILED );
			} 
		} else {
			
			if ( this.callback is Function ) {
				this.callback.apply( null, this.parameters );
			} else if ( this.callback is PropertyChain ) {
				( ObjectUtil.resolvePropertyChain( this.callback.chain, this.callback.targetInstance ) as Function ).apply( this.parameters );
			}
			
			if ( this.getState() == OperationState.RUNNING ) {
				this.setProgress( 1 );
				this.setState( OperationState.COMPLETED );
			}
		}
		
	}
	
	/**
	 * @inheritDoc
	 */
	override public function stop() : void  {
		this.setState( OperationState.STOPPED );
	}
	
}
	
}