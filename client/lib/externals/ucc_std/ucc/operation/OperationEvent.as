package ucc.operation {
	
import flash.events.Event;
	
/**
 * Operation event
 * 
 * @version $Id: OperationEvent.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class OperationEvent extends Event {
	
	/** Start event */
	public static const START	 		: String = "ucc.operation.OperationEvent.START";
	
	/** Completed event */
	public static const COMPLETE 		: String = "ucc.operation.OperationEvent.COMPLETE";
	
	/** Failed event */
	public static const FAIL 			: String = "ucc.operation.OperationEvent.FAIL";
	
	/** Paused event */
	public static const PAUSE 			: String = "ucc.operation.OperationEvent.PAUSE";
	
	/** Pausing event */
	public static const PAUSING 		: String = "ucc.operation.OperationEvent.PAUSING";
	
	/** Resumed event */
	public static const RESUME 			: String = "ucc.operation.OperationEvent.RESUME";
	
	/** Stopped event */
	public static const STOP	 		: String = "ucc.operation.OperationEvent.STOP";
	
	/** Progress event */
	public static const PROGRESS 		: String = "ucc.operation.OperationEvent.PROGRESS";
	
	/** Idle event */
	public static const IDLE 			: String = "ucc.operation.OperationEvent.IDLE";
	
	/**
	 * Constructor
	 */
	public function OperationEvent( type : String ) { 
		super( type );
	} 
	
	/**
	 *	@inheritDoc
	 */
	public final override function clone (  ) : Event {
		return new OperationEvent( this.type );
	}
	
}

}