package ucc.operation.generic {
	import ucc.operation.AbstractOperation;
	import ucc.operation.OperationState;
	
/**
 * Passive operation does nothing. It doesn't end until manual call to method stop()
 *
 * @version $Id: PassiveOperation.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class PassiveOperation extends AbstractOperation {
	
	/**
	 * Class constructor
	 */
	public function PassiveOperation () {
		
	}
	
	/**
	 * @inheritDoc
	 */
	override public function start() : void  {
		this.setProgress( 0 );
		this.setState( OperationState.RUNNING );
	}
	
	/**
	 * Stop and finnish operation
	 */
	override public function stop() : void  {
		this.setState( OperationState.STOPPED );
	}
	
}
	
}