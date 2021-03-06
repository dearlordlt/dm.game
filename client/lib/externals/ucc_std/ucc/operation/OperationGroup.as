package ucc.operation {
	
/**
 * Operation group
 * @version $Id: OperationGroup.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public interface OperationGroup extends Operation {
	
	/**
	 * Add operation to operation group
	 * @param	operation			Instance of any Operation implementation
	 * @param	progressWeight		a multiplicator for operation progress.  
	 * For example if in operation group there are two operations with progress weights of 2 and 1 then when first suboperaiton is completed total progress of operation group will be 66.6 percent.
	 * @return	reference to same operation group
	 */
	function addOperation ( operation : Operation, progressWeight : Number = 1 ) : OperationGroup;
	
	/**
	 * Get operation added to group
	 * @return
	 */
	function getOperations () : Array;
	
}
	
}