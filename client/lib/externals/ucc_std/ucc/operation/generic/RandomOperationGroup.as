package ucc.operation.generic  {
	import ucc.operation.Operation;
	import ucc.operation.OperationEvent;
	import ucc.operation.OperationGroup;
	import ucc.operation.OperationState;
	
/**
 * Random operation group. Randomly selects one of child operations and excutes it and then completes. 
 * Use progress weight raise or lower probability of single operation
 * @version $Id: RandomOperationGroup.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class RandomOperationGroup extends AbstractOperationGroup {
	
	/** Curtom random function */
	protected var randomFunction		: Function;
	
	/** Random function params */
	protected var randomFunctionParams 	: Array;
	
	/** Max value */
	protected var maxValue				: Number = 0;
	
	/** Max value index */
	protected var maxValueIndex			: int;
	
	/** Selected operation */
	protected var selectedOperation		: Operation;
	
	/**
	 * Calss constructor
	 * @param	randomFunction	custom random number generator function. if noone is passed Math.random() is used
	 */
	public function RandomOperationGroup ( randomFunction : Function = null, randomFunctionParams : Array = null ) {
		
		if ( this.randomFunction != null ) {
			this.randomFunction = randomFunction;
		} else {
			this.randomFunction = Math.random;
		}
		this.randomFunctionParams = randomFunctionParams;
		
	}
	
	/**
	 *	Add operation to operations sctack
	 * 	@param	operation	Any Operation implementation
	 * 	@param	progressWeight	probability multiplicator
	 */
	public override function addOperation ( operation : Operation ,  progressWeight : Number = 1 ) : OperationGroup {
		return super.addOperation(operation, progressWeight);
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function start (  ) : void {
		
		this.setState( OperationState.RUNNING );
		
		// if there are no child operations - complete
		if ( this.operations.length == 0 ) {
			this.setState( OperationState.COMPLETED );
		} else {
			this.progressWeights.forEach( this.calculateMaxValue );
			this.selectedOperation = this.operations[ this.maxValueIndex ];
			this.addEventListenersForOperation( this.selectedOperation );
			this.selectedOperation.start();
		}
	}
	
	/**
	 * Calculate max random value
	 * @param	item
	 * @param	index
	 * @param	array
	 */
	protected function calculateMaxValue ( item : Number, index : int, array : Array ) : void {
		
		var randVal : Number = item * this.randomFunction.apply( null, this.randomFunctionParams );
		
		this.maxValue = Math.max( this.maxValue, randVal );
		
		if ( this.maxValue == randVal ) {
			this.maxValueIndex = index;
		}
		
	}
	
	/**
	 * Add event listeneers for operation
	 */
	protected function addEventListenersForOperation ( operation : Operation ) : void {
		operation.addEventListener( OperationEvent.COMPLETE, this.onChildOperationComplete );
		operation.addEventListener( OperationEvent.FAIL, this.onChildOperationFailed );
	}
	
	/**
	 *	On child operation failed
	 */
	protected function onChildOperationFailed ( event : OperationEvent) : void {
		this.setState( OperationState.FAILED );
		this.removeEventListenersForOperation( this.selectedOperation );
	}
	
	/**
	 * Remove event listeneers for operation
	 */
	protected function removeEventListenersForOperation ( operation : Operation ) : void {
		operation.removeEventListener( OperationEvent.COMPLETE, this.onChildOperationComplete );
		operation.removeEventListener( OperationEvent.FAIL, this.onChildOperationFailed );
	}
	
	/**
	 *	On operation complete
	 */
	protected function onChildOperationComplete ( event : OperationEvent) : void {
		this.setState( OperationState.COMPLETED );
		this.removeEventListenersForOperation( this.selectedOperation );
		this.selectedOperation = null;
		this.operations.length = 0;
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function stop () : void {
		this.setState( OperationState.STOPPED );
		this.removeEventListenersForOperation( this.selectedOperation );
		this.selectedOperation.stop();
		this.selectedOperation = null;
		this.operations.length = 0;
	}
	
}
	
}