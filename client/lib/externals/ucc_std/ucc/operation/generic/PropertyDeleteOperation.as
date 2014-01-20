package ucc.operation.generic  {
	import ucc.error.IllegalArgumentException;
	import ucc.operation.AbstractOperation;
	import ucc.operation.OperationState;
	
/**
 * Value deletion operation.
 * Deltes value from dictionary
 *
 * @version $Id: PropertyDeleteOperation.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class PropertyDeleteOperation extends AbstractOperation {
	
	/** Context */
	protected var context 	: * ;
	
	/** Member */
	protected var member 	: * ;
	
	/**
	 * Class constructor
	 */
	public function PropertyDeleteOperation ( context : * , member : * ) {
		
		this.member = member;
		
		if ( !context ) {
			throw new IllegalArgumentException( "Context must be not null!" );
		}
		
		this.context = context;
		
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function start (  ) : void {
		
		this.setState( OperationState.RUNNING );
		this.setProgress( 0 );
		
		try {
			delete this.context[this.member];
			this.setProgress( 1 );
			this.setState( OperationState.COMPLETED );
			this.context = null;
		} catch ( error : Error ) {
			this.setState( OperationState.FAILED );			
		}
		
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function stop (  ) : void {
		this.setState( OperationState.STOPPED );
	}
	
}
	
}