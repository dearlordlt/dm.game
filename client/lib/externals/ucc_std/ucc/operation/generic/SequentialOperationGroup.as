package ucc.operation.generic  {
	import ucc.error.IllegalStateException;
	import ucc.operation.AbstractOperation;
	import ucc.operation.Operation;
	import ucc.operation.OperationEvent;
	import ucc.operation.OperationGroup;
	import ucc.operation.OperationState;
	import flash.utils.getTimer;
	
/**
 * Sequential operation group
 *
 * @version $Id: SequentialOperationGroup.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class SequentialOperationGroup extends AbstractOperationGroup {
	
	/** Currently beeing executed operation */
	protected var currentOperation 		: Operation;
	
	/** Current operation index */
	protected var currentOperationIndex	: int = 0;
	
	/** Total progress sum */
	protected var totalProgressSum		: Number = 0;
	
	/** Current progress sum */
	protected var currentProgressSum	: Number = 0;
	
	// TODO:remove
	protected var startTime				: Number;
	
	/**
	 * Class constructor
	 */
	public function SequentialOperationGroup () {
	}
	
	/**
	 * @inheritDoc
	 */
	override public function addOperation(operation : Operation, progressWeight : Number = 1) : OperationGroup  {
		this.totalProgressSum += progressWeight;
		return super.addOperation(operation, progressWeight);
	}
	
	/**
	 * @inheritDoc
	 */
	override public function start() : void  {
		this.setState( OperationState.RUNNING );
		this.setProgress(0);
		this.currentProgressSum = 0;
		this.currentOperationIndex = 0;
		this.startTime = getTimer();
		this.startNextOperation();
	}	
	
	/**
	 * Takes next operation from operations queue
	 * @return	
	 */
	protected function startNextOperation () : void {
		if ( this.operations.length > this.currentOperationIndex ) {
			this.currentOperation = this.operations[ this.currentOperationIndex ];
			this.addEventListenersForOperation( this.currentOperation );
			this.currentOperation.start();
		} else {
			this.setProgress( 1 );
			this.setState( OperationState.COMPLETED );
		}
	}
	
	/**
	 * @inheritDoc
	 */
	override public function stop() : void  {
		if ( this.currentOperation && this.currentOperation.getState() == OperationState.RUNNING ) {
			this.currentOperation.stop();
		}
		this.setState( OperationState.STOPPED );
		
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
		this.setState( OperationState.RUNNING )
		this.currentOperation.resume();
	}
	
	/**
	 * On child operation completed
	 * @param	event
	 */
	protected function onChildOperationCompleted ( event : OperationEvent ) : void {
		
		// trace( "[ucc.operation.generic.SequentialOperationGroup.onChildOperationCompleted] : " + getTimer() );
		
		this.removeEventListenersFromOperation( event.target as Operation );
		
		// update progress cache
		this.currentProgressSum += this.progressWeights[ this.currentOperationIndex ];
		
		// increment current operation index
		this.currentOperationIndex++;
		this.startNextOperation();
	}
	
	/**
	 * On child operation stopped
	 * @param	event
	 */
	protected function onChildOperationStopped ( event : OperationEvent ) : void {
		this.setState( OperationState.STOPPED );
	}
	
	/**
	 * Handle child operation's fail
	 * @param	event
	 */
	protected function onChildOperationFail ( event : OperationEvent ) : void {
		this.removeEventListenersFromOperation( this.currentOperation as Operation );
		this.setState( OperationState.FAILED );
	}
	
	/**
	 * On child operation progress
	 * @param	event
	 */
	protected function onChildOperationProgress ( event : OperationEvent ) : void {
		this.setProgress( ( this.currentProgressSum + this.currentOperation.getProgress() * this.progressWeights[ this.currentOperationIndex ] ) / this.totalProgressSum );
	}
	
	/**
	 * Add event listeners for operation
	 */
	protected function addEventListenersForOperation ( operation : Operation ) : void {
		operation.addEventListener( OperationEvent.COMPLETE, this.onChildOperationCompleted );
		operation.addEventListener( OperationEvent.FAIL, this.onChildOperationFail );
		operation.addEventListener( OperationEvent.PROGRESS, this.onChildOperationProgress );
		operation.addEventListener( OperationEvent.STOP, this.onChildOperationStopped );
	}
	
	/**
	 * Remove event listeners from operation
	 */
	protected function removeEventListenersFromOperation ( operation : Operation ) : void {
		operation.removeEventListener( OperationEvent.COMPLETE, this.onChildOperationCompleted );
		operation.removeEventListener( OperationEvent.FAIL, this.onChildOperationFail );
		operation.removeEventListener( OperationEvent.PROGRESS, this.onChildOperationProgress );
		operation.removeEventListener( OperationEvent.STOP, this.onChildOperationStopped );
	}
	
}
	
}