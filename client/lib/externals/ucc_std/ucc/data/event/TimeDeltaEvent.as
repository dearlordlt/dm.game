package ucc.data.event {
	
import flash.events.Event;
	
/**
 * Time delta event. This event is dispatched together with enter frame event, but provides time delta between last enter frame event
 * 
 * @version $Id: TimeDeltaEvent.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class TimeDeltaEvent extends Event {
	
	/** Name event */
	public static const TIMER 	: String = "com.pepiplay.data.event.TimeDeltaEvent.TIMER";
	
	/** Time delta between previouse time */
	public var timeDelta : int;
	
	/**
	 * Constructor
	 */
	public function TimeDeltaEvent( type : String, timeDelta : int ) { 
		super( type );
		this.timeDelta = timeDelta;
	}
	
}

}