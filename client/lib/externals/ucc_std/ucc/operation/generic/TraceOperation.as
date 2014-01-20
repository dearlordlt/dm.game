package ucc.operation.generic  {
	import ucc.operation.AbstractOperation;
	import ucc.operation.OperationState;
	
/**
 * Trace operation
 *
 * @version $Id: TraceOperation.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class TraceOperation extends AbstractOperation {
	
	/** Arguments */
	protected var args	: Array
	
	/**
	 * Class constructor
	 */
	public function TraceOperation ( ... args ) {
		this.args = args;
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function start () : void {
		this.setState( OperationState.RUNNING );
		this.setProgress(0);
		trace.apply( null, this.args );
		this.setProgress(1);
		this.setState( OperationState.COMPLETED );
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function stop () : void {
		this.setState( OperationState.STOPPED );
	}
	
}
	
}