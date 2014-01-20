package ucc.operation.generic  {
	import ucc.error.IllegalArgumentException;
	import ucc.operation.AbstractOperation;
	import ucc.operation.Operation;
	import ucc.operation.OperationEvent;
	import ucc.operation.OperationState;
	import ucc.util.ObjectUtil;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	
/**
 * Loop operation. Loops child operation with specified timeouts between loops. 
 *	// TODO: in other implementations child operation chould be reused instead of creating new one
 * @version $Id: LoopOperation.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class LoopOperation extends AbstractOperation {
	
	/** Timeout between operation execution */
	protected var timeout 					: uint;
	
	/** Number of time to repeat operation */
	protected var repeatCount 				: uint;
	
	/** Operation class */
	protected var operationClass 			: Class;
	
	/** Operation arguments */
	protected var operationArguments 		: Array;
	
	/** Child operation */
	protected var operation					: Operation;
	
	/** Current repeat count */
	protected var currentRepeatCount		: int;
	
	/** Current timeout id */
	protected var currentTimeoutId			: uint;
	
	/** Last timer */
	protected var lastTimer					: int;
	
	/** Time left */
	protected var timeLeft					: int;
	
	/**
	 * Class constructor
	 * @param	timeout		timeout between operation execution
	 * @param	repeatCount	times to repeat operation. If 0 (zero) is specified thant operation will iterate forever until manualy stopped
	 * @param	operationClass	class from whichto construct operation (must be implementation of Operation interface)
	 * @param	... operationArguments	parameters to pass to new instance of operation class
	 */
	public function LoopOperation ( timeout : uint = 0, repeatCount : uint = 0, operationClass : Class = null, operationArguments : Array = null ) {
		this.init.apply( null, arguments );
	}
	
	/**
	 * Init
	 * @param	timeout		timeout between operation execution
	 * @param	repeatCount	times to repeat operation. If 0 (zero) is specified thant operation will iterate forever until manualy stopped
	 * @param	operationClass	class from whichto construct operation (must be implementation of Operation interface)
	 * @param	... operationArguments	parameters to pass to new instance of operation class
	 */
	public function init ( timeout : uint, repeatCount : uint, operationClass : Class, operationArguments : Array ) : void {
		
		if ( !operationClass ) {
			throw new IllegalArgumentException( "Operation class must be specified!" );
		}
		this.operationArguments = operationArguments;
		this.operationClass = operationClass;
		this.repeatCount = repeatCount;
		this.timeout = timeout;
		
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function start () : void {
		
		this.setState( OperationState.RUNNING );
		this.setProgress( 0 );
		this.startChildOperation();
		
	}
	
	/**
	 * Start child operation
	 */
	protected function startChildOperation () : void {
		
		try {
			this.operation = ObjectUtil.newInstance( this.operationClass, this.operationArguments );
		} catch ( error : Error ) {
			this.setState( OperationState.FAILED );
			return;
		}
		
		this.addEventListenersForOperation( this.operation );
		this.operation.start();
		
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function stop () : void {
		this.setState( OperationState.STOPPED );
		if ( this.operation ) {
			this.operation.stop();
			this.removeEventListenersForOperation( this.operation );
		} else {
			clearTimeout( this.currentTimeoutId );
		}		
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function pause () : void {
		
		this.setState( OperationState.PAUSED );
		
		if ( this.operation ) {
			this.operation.pause();
		} else {
			this.timeLeft = this.timeLeft - ( getTimer() - this.lastTimer );
			clearTimeout( this.currentTimeoutId );
		}		
		
		
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function resume (  ) : void {
		this.setState( OperationState.RUNNING );
		if ( this.operation ) {
			this.operation.resume();
		} else {
			if ( this.timeLeft == 0 ) {
				this.startChildOperation();
			} else {
				this.lastTimer = getTimer();
				this.currentTimeoutId = setTimeout( this.startChildOperation, this.timeLeft );
			}
			
		}
		
	}
	
	/**
	 * Add event listeners for operation
	 */
	protected function addEventListenersForOperation ( operation : Operation ) : void {
		
		operation.addEventListener( OperationEvent.COMPLETE, this.onChildOperationCompleted );
		operation.addEventListener( OperationEvent.FAIL, this.onChildOperationFailed );
		operation.addEventListener( OperationEvent.PROGRESS, this.onChildOperationProgress );
		
	}
	
	/**
	 * Remove event listeners for operation
	 */
	protected function removeEventListenersForOperation ( operation : Operation ) : void {
		
		operation.removeEventListener( OperationEvent.COMPLETE, this.onChildOperationCompleted );
		operation.removeEventListener( OperationEvent.FAIL, this.onChildOperationFailed );
		operation.removeEventListener( OperationEvent.PROGRESS, this.onChildOperationProgress );
		
	}
	
	/**
	 *	On child operation progress
	 */
	protected function onChildOperationProgress ( event : OperationEvent) : void {
		
		// if repeat count is not zero (endless), count progress when divided by repeat count
		if ( this.repeatCount > 0 ) {
			this.setProgress( this.repeatCount / ( this.currentRepeatCount + Operation( event.target ).getProgress() ) );
			
		// if repeat count is endless than progress will by counted using formula: 
		// ( currentRepeatCount + 2 ) / ( currentRepeatCount + currentOperationProgress ). 
		// So total progress will be approuching 1 (one) but never reaching it
		} else {
			this.setProgress( ( this.currentRepeatCount + 2 ) / ( this.currentRepeatCount + Operation( event.target ).getProgress() ) );
		}
		
	}
	
	/**
	 *	On child operation failed
	 */
	protected function onChildOperationFailed ( event : OperationEvent) : void {
		this.setState( OperationState.FAILED );
		this.removeEventListenersForOperation( this.operation );
	}
	
	/**
	 *	On child operation completed
	 */
	protected function onChildOperationCompleted ( event : OperationEvent) : void {
		
		this.currentRepeatCount++;
		
		this.removeEventListenersForOperation( this.operation );
		
		this.operation = null;
		
		if ( ( this.repeatCount > 0 ) && ( this.currentRepeatCount >= this.repeatCount ) ) {
			this.setProgress( 1 );
			this.setState( OperationState.COMPLETED );
			return;
		}
		
		if ( this.timeout > 0 ) {
			this.timeLeft 			= this.timeout;
			this.lastTimer 			= getTimer();
			this.currentTimeoutId 	= setTimeout( this.startChildOperation, this.timeout );
		} else {
			this.startChildOperation();
		}
		
	}
	
	
	
}
	
}