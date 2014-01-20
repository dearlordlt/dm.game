package ucc.operation.generic  {
	import ucc.operation.AbstractOperation;
	import ucc.operation.OperationState;
	
/**
 * Empty operation doesn't do anything. Just completes just after started
 *
 * @version $Id: EmptyOperation.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class EmptyOperation extends AbstractOperation {
	
	/**
	 * Class constructor
	 */
	public function EmptyOperation () {
		
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function start () : void {
		this.setState( OperationState.RUNNING );
		this.setProgress( 0 );
		this.setProgress( 1 );
		this.setState( OperationState.COMPLETED );
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function pause () : void {
		this.setState( OperationState.PAUSED );
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function resume () : void {
		this.start();
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function stop () : void {
		this.setState( OperationState.STOPPED );
	}
	
}
	
}