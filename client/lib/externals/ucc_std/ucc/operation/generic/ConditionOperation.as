package ucc.operation.generic  {
	import ucc.error.IllegalArgumentException;
	import ucc.operation.AbstractOperation;
	import ucc.operation.Operation;
	import ucc.operation.OperationEvent;
	import ucc.operation.OperationState;
	import flash.errors.IllegalOperationError;
	
/**
 * Condition operation. Starts child operation if condition is Boolean true or function callback returns true
 *
 * @version $Id: ConditionOperation.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class ConditionOperation extends AbstractOperation {
	
	/** Condition */
	protected var condition			: * ;
	
	/** Child operation */
	protected var childOperation	: Operation;
	
	/** Invert condition result? */
	protected var not 				: Boolean;
	
	/** Else operation (runed if condtion return false). Not required */
	protected var elseOperation 	: Operation;
	
	/** Current operation */
	protected var currentOperation	: Operation;
	
	/**
	 * Class constructor
	 * @param	condition	Boolean value or Function to be executed to test its results. Function returning void is treated like always returning false
	 * @param	operation	Operation to execute if condition evaluates to true
	 * @param	not			invert condition result (add logical not operator (!))
	 */
	public function ConditionOperation ( condition : * , operation : Operation, not : Boolean = false ) {
		
		this.not = not;
		this.condition = condition;
		this.childOperation = operation;
		
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function start () : void {
		
		var conditionResult : Boolean;
		
		this.setState( OperationState.RUNNING );
		
		if ( this.condition is Function ) {
			conditionResult = condition();
		} else {
			conditionResult = Boolean( condition );
		}
		
		if ( this.not ) {
			conditionResult = !conditionResult;
		}
		
		if ( conditionResult ) {
			this.currentOperation = this.childOperation;
			this.addEventListenersForOperation( this.currentOperation );
			this.currentOperation.start();
		} else if ( this.elseOperation && !conditionResult ) {
			this.currentOperation = this.elseOperation;
			this.addEventListenersForOperation( this.currentOperation );
			this.currentOperation.start();
		} else {
			this.setState( OperationState.COMPLETED );
		}
		
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function stop () : void {
		this.setState( OperationState.STOPPED );
		this.currentOperation.stop();
		this.removeEventListenersForOperation( this.currentOperation );
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function pause (  ) : void {
		this.setState( OperationState.PAUSED );
		this.currentOperation.pause();
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function resume (  ) : void {
		this.setState( OperationState.RUNNING );
		this.childOperation.resume();
	}
	
	/**
	 * Add event listeners for operation
	 * @param	operation
	 */
	protected function addEventListenersForOperation ( operation : Operation ) : void {
		operation.addEventListener( OperationEvent.COMPLETE, this.onChildOperationComplete );
		operation.addEventListener( OperationEvent.FAIL, this.onChildOperationFailed );
		operation.addEventListener( OperationEvent.PROGRESS, this.onChildOperationProgress );
	}
	
	/**
	 * remove event listeners for operation
	 * @param	operation
	 */
	protected function removeEventListenersForOperation ( operation : Operation ) : void {
		operation.removeEventListener( OperationEvent.COMPLETE, this.onChildOperationComplete );
		operation.removeEventListener( OperationEvent.FAIL, this.onChildOperationFailed );
		operation.removeEventListener( OperationEvent.PROGRESS, this.onChildOperationProgress );
	}
	
	/**
	 * Add else operation
	 */
	public function else_ ( operation : Operation ) : Operation {
		if ( !this.elseOperation ) {
			this.elseOperation = operation;
		} else {
			throw new IllegalOperationError( "Can\'t add more than one else operation!" )
		}
		
		return this;
		
	}
	
	/**
	 *	On child operation progress
	 */
	protected function onChildOperationProgress ( event : OperationEvent) : void {
		this.setProgress( Operation( event.target ).getProgress() );
	}
	
	/**
	 *	On child operation failed
	 */
	protected function onChildOperationFailed ( event : OperationEvent) : void {
		this.setState( OperationState.FAILED );
		this.removeEventListenersForOperation( event.target as Operation );
	}
	
	/**
	 *	On child operation complete
	 */
	protected function onChildOperationComplete ( event : OperationEvent ) : void {
		this.setState( OperationState.COMPLETED );
		this.removeEventListenersForOperation( event.target as Operation );
	}
	
}
	
}