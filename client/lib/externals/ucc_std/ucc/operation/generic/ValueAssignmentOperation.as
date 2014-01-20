package ucc.operation.generic  {
	import ucc.error.IllegalArgumentException;
	import ucc.operation.AbstractOperation;
	import ucc.operation.OperationState;
	
/**
 * Set value for variable in specified context
 *
 * @version $Id: ValueAssignmentOperation.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class ValueAssignmentOperation extends AbstractOperation {
	
	/** Context */
	protected var context 			: * ;
	
	/** Member (string or QName) */
	protected var member			: * ;
	
	/** Value */
	protected var value				: * ;
	
	/** Fail on exception */
	protected var failOnException	: Boolean;
	
	/**
	 * 
	 * @param	context
	 * @param	member	String or QName (namespace+name). Member can be only public.
	 * @param	value
	 * @param	failOnException
	 */	
	public function ValueAssignmentOperation ( context : *, member : *, value : *, failOnException : Boolean = true ) {
		this.context = context;
		
		if ( ( member is String ) || ( member is QName ) ) {
			this.member = member;
		} else {
			throw new IllegalArgumentException( "member can be String or QName" );;
		}
		
		this.value = value;
		this.failOnException = failOnException;
	}
	
	/**
	 * @inheritDoc
	 */
	override public function start() : void  {
		
		this.setState( OperationState.RUNNING );
		this.setProgress( 0 );
		if ( this.failOnException ) {
			
			try {
				this.context[ this.member ] = this.value;
				this.setProgress( 1 );
				this.setState( OperationState.COMPLETED );
			} catch ( error : Error ) {
				this.setState( OperationState.FAILED );
				throw error;
			}
			
		} else {
			this.context[ this.member ] = this.value;
			this.setProgress( 1 );
			this.setState( OperationState.COMPLETED );
		}
		
	}
	
}
	
}