package ucc.operation.generic  {
	import ucc.error.IllegalArgumentException;
	import ucc.error.IllegalStateException;
	import ucc.operation.AbstractOperation;
	import ucc.operation.Operation;
	import ucc.operation.OperationEvent;
	import ucc.operation.OperationGroup;
	import ucc.operation.OperationState;
	import flash.events.IEventDispatcher;
	
/**
 * Abstract operation group
 *
 * @version $Id: AbstractOperationGroup.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class AbstractOperationGroup extends AbstractOperation implements OperationGroup {
	
	/** Operations */
	protected var operations		: Array = [];
	
	/** Progress weights */
	protected var progressWeights	: Array = [];
	
	/**
	 * Class constructor
	 */
	public function AbstractOperationGroup () {
		
	}	
	
	/** 
	 *	@inheritDoc 
	 */
	public function addOperation ( operation : Operation, progressWeight : Number = 1 ) : OperationGroup {
		
		if ( this.getState() != OperationState.IDLE ) {
			throw new IllegalStateException( "Can't add operation when group is not in idle state!" );
		}
		
		if ( !operation ) {
			throw new IllegalArgumentException( "Operation must be not null!" );
		}
		
		if ( isNaN( progressWeight ) || !( progressWeight > 0 ) || !isFinite( progressWeight) ) {
			throw new IllegalArgumentException( "Progress weight must be positive but not infinite!" )
		}
		
		this.operations.push( operation );
		this.progressWeights.push( progressWeight );
		return this;
		
	}
	
	
	/** 
	 *	@inheritDoc 
	 */
	public function getOperations() : Array {
		return this.operations.concat();
	}
	
}
	
}