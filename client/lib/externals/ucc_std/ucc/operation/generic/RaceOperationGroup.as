package ucc.operation.generic  {
	import ucc.data.event.FrameImpulse;
	import ucc.operation.Operation;
	import ucc.operation.OperationEvent;
	import ucc.operation.OperationState;
	import flash.events.Event;
	
/**
 * Race operation group. Works like concurent operation group, but operation is completed when any the first operation is completed.
 *
 * @version $Id: RaceOperationGroup.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class RaceOperationGroup extends ConcurentOperationGroup {
	
	/**
	 * Class constructor
	 */
	public function RaceOperationGroup () {
		super();
	}
	
	/**
	 * On child operation complete
	 */
	override protected function onChildOperationComplete ( event : OperationEvent ) : void {
		
		super.onChildOperationComplete( event );
		
		if ( this.incompleteOperationsNum < this.getOperations().length ) {
			
			for each ( var operation : Operation in this.operations ) {
				if ( operation.getState() != OperationState.COMPLETED ) {
					operation.removeEventListener( OperationEvent.COMPLETE, this.onChildOperationComplete );
					operation.removeEventListener( OperationEvent.FAIL, this.onChildOperationFail );					
					operation.stop();
				}
			}
			
			FrameImpulse.getInstance().removeEventListener( Event.ENTER_FRAME, this.onEnterFrame );			
			
			this.setState( OperationState.COMPLETED );
			
		}
		
	}	
	
}
	
}