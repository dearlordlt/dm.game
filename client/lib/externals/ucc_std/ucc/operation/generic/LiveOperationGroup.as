package ucc.operation.generic {
	import ucc.error.IllegalArgumentException;
	import ucc.error.UnsupportedOperationException;
	import ucc.operation.Operation;
	import ucc.operation.OperationEvent;
	import ucc.operation.OperationGroup;
	import ucc.operation.OperationState;
	import flash.utils.Dictionary;
	
/**
 * Live operation group. Suboperations can be added to it at any time. Progress is counten only from executing and unstarted operations
 * // TODO: implement everything
 * @version $Id: LiveOperationGroup.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class LiveOperationGroup extends AbstractOperationGroup {
	
	/** Current operation */
	protected var currentOperation							: Operation;
	
	/** Current progress weight */
	protected var currentOperationProgressWeight			: Number;
	
	/** Total progress sum (progress weights of operations stack added) */
	protected var totalProgressSum							: Number = 0;
	
	/** Current progress sum */
	protected var currentProgressSum						: Number = 0;	
	
	/** Fail on child operation fail? */
	protected var failOnChildOperationFail 					: Boolean;
	
	/**
	 * Class constructor
	 */
	public function LiveOperationGroup ( failOnChildOperationFail : Boolean = false ) {
		
		this.failOnChildOperationFail = failOnChildOperationFail;
		
		// Live operation group's progress is 100% when all job is done or there is nothing to do
		this.setProgress( 1 );
		
	}
	
	/**
	 * Add operation
	 * @param	operation			Instance of any Operation implementation
	 * @param	progressWeight		a multiplicator for operation progress.
	 * For example if in operation group there are two operations with progress weights of 2 and 1 then when first suboperaiton is completed total progress of operation group will be 66.6 percent.
	 * In LiveOperationGroup if you pass negative progress weight, operation will be treated as highest priority operation and added just after currently executing operation. When adding progressWeight to progress weights stack it will be converted to positive number
	 * @return	reference to same operation group
	 */
	public override function addOperation ( operation : Operation ,  progressWeight : Number  = 1 ) : OperationGroup {
		
		if ( !operation ) {
			throw new IllegalArgumentException( "Operation must be not null!" );
		}		
		
		if ( isNaN( progressWeight ) || !isFinite( progressWeight) ) {
			throw new IllegalArgumentException( "Progress weight must be not infinite!" );
		}		
		
		if ( progressWeight < 0 ) {
			
			this.operations.unshift( operation );
			this.progressWeights.unshift( -progressWeight )
			
		} else {
			this.operations.push( operation );
			this.progressWeights.push( progressWeight );
		}
		
		if ( this.getState() == OperationState.IDLE ) {
			
			this.startNextOperation();
		}
		
		return this;
		
	}
	
	/**
	 * Get current operation
	 * @return
	 */
	public function getCurrentOperation () : Operation {
		return this.currentOperation;
	}
	
	/**
	 *	Stops currently executing operation and removes all upcomming unstarted operations. In other words it clears operations stack and set to state IDLE
	 */
	public override function stop () : void {
		
		if ( this.getState() != OperationState.IDLE ) {
			
			this.operations.length = 0;
			this.progressWeights.length = 0;
			this.currentOperation.stop();
			
		}
		
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function start () : void {
		// do nothing. LiveOperationGroup runs automaticaly when new operation appears in stack
	}
	
	/**
	 *	Pauses group. If current child operation can't be stopped (#pause() method is not implemented), LiveOperationGroup 
	 */
	public override function pause () : void {
		
		if ( this.getState() == OperationState.RUNNING ) {
			
			try {
				this.currentOperation.pause();
			} catch ( error : UnsupportedOperationException ) {
				this.setState( OperationState.PAUSING );
			}
		}
		
	}
	
	
	/**
	 *	@inheritDoc
	 */
	public override function resume () : void {
		
		if ( this.getState() == OperationState.PAUSED ) {
			this.setState( OperationState.RUNNING );
			this.startNextOperation();
		}
		
	}
	
	/**
	 * Start next operation
	 */
	protected function startNextOperation () : void {
		
		if ( this.operations.length > 0 ) {
			
			this.currentOperation = this.operations.shift();
			
			this.progressWeights.forEach( this.buildTotalProgressSum );
			
			this.currentOperationProgressWeight = this.progressWeights.shift();
			
			this.addEventListenersForOperation( this.currentOperation );
			
			this.setState( OperationState.RUNNING );
			
			this.currentOperation.start();
			
		} else {
			this.setState( OperationState.IDLE );
		}
		
	}
	
	/**
	 * Build total progress sum (array iterator)
	 */
	protected function buildTotalProgressSum ( progressWeight : Number, index : int, array : Array ) : void {
		this.totalProgressSum += progressWeight;
	}
	
	/**
	 *	On child operation stopped
	 */
	protected function onChildOperationStopped ( event : OperationEvent) : void {
		
		this.removeEventListenersFromOperation( this.currentOperation );
		
		if ( this.operations.length > 0 ) {
			
			// if it is pausing
			if ( this.getState() == OperationState.PAUSING ) {
				this.setState( OperationState.PAUSED );
				return;
			}			
			
			this.startNextOperation();
			
		} else {
			this.setProgress( 1 );
			this.setState( OperationState.IDLE );
		}
		
	}
	
	/**
	 *	On child operation progress
	 */
	protected function onChildOperationProgress ( event : OperationEvent) : void {
		
		this.setProgress( ( this.currentOperation.getProgress() * this.currentOperationProgressWeight + this.totalProgressSum - this.currentOperationProgressWeight ) / this.totalProgressSum );
		
	}
	
	/**
	 *	On child operation fail
	 */
	protected function onChildOperationFail ( event : OperationEvent ) : void {
		
		this.removeEventListenersFromOperation( this.currentOperation );
		
		// LiveOperation group doesn't stop on child operation fail
		if ( !this.failOnChildOperationFail ) {
			this.startNextOperation();
		} else {
			this.setState( OperationState.FAILED );
		}
		
		
	}
	
	/**
	 *	On child operarion completed
	 */
	protected function onChildOperationCompleted ( event : OperationEvent) : void {
		this.removeEventListenersFromOperation( Operation( event.target ) );
		this.startNextOperation();
	}
	
	/**
	 *	On child operation started
	 */
	protected function onChildOperationStarted ( event : OperationEvent) : void {
		
	}
	
	/**
	 *	On child operation paused
	 */
	protected function onChildOperationPaused ( event : OperationEvent) : void {
		this.setState( OperationState.PAUSED );
	}
	
	/**
	 *	On child operation resumed
	 */
	protected function onChildOperationResumed ( event : OperationEvent ) : void {
		this.setState( OperationState.RUNNING );
	}
	
	/**
	 * Add event listeners for operation
	 */
	protected function addEventListenersForOperation ( operation : Operation ) : void {
		operation.addEventListener( OperationEvent.COMPLETE, this.onChildOperationCompleted );
		operation.addEventListener( OperationEvent.FAIL, this.onChildOperationFail );
		operation.addEventListener( OperationEvent.PROGRESS, this.onChildOperationProgress );
		operation.addEventListener( OperationEvent.STOP, this.onChildOperationStopped );
		operation.addEventListener( OperationEvent.START, this.onChildOperationStarted );
		operation.addEventListener( OperationEvent.PAUSE, this.onChildOperationPaused );
		operation.addEventListener( OperationEvent.RESUME, this.onChildOperationResumed );
	}
	
	/**
	 * Remove event listeners from operation
	 */
	protected function removeEventListenersFromOperation ( operation : Operation ) : void {
		operation.removeEventListener( OperationEvent.COMPLETE, this.onChildOperationCompleted );
		operation.removeEventListener( OperationEvent.FAIL, this.onChildOperationFail );
		operation.removeEventListener( OperationEvent.PROGRESS, this.onChildOperationProgress );
		operation.removeEventListener( OperationEvent.STOP, this.onChildOperationStopped );
		operation.removeEventListener( OperationEvent.START, this.onChildOperationStarted );
		operation.removeEventListener( OperationEvent.PAUSE, this.onChildOperationPaused );
		operation.removeEventListener( OperationEvent.RESUME, this.onChildOperationResumed );
	}	
	
	
}
	
}