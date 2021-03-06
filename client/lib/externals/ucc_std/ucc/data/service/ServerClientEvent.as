package ucc.data.service {
	
import flash.events.Event;
	
/**
 * Server client event
 * 
 * @version $Id: ServerClientEvent.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class ServerClientEvent extends Event {
	
	/** CONNECTING event */
	public static const CONNECTING 				: String = "ucc.data.service.ServerClientEvent.CONNECTING";
	
	/** Successfuly connected event */
	public static const CONNECTED 				: String = "ucc.data.service.ServerClientEvent.CONNECTED";
	
	/** Connection successfuly closed event */
	public static const CLOSED 					: String = "ucc.data.service.ServerClientEvent.CLOSED";
	
	/** Connection failed event */
	public static const CONNECTION_FAILED 		: String = "ucc.data.service.ServerClientEvent.CONNECTION_FAILED";
	
	/** Message delivery failed event */
	public static const DELIVERY_FAILED 		: String = "ucc.data.service.ServerClientEvent.DELIVERY_FAILED";
	
	/** Associated data */
	public var associatedData		: * ;
	
	/** Associated evet */
	public var associatedEvent		: Event;
	
	/**
	 * Constructor
	 */
	public function ServerClientEvent( type : String, associatedData : * = null, associatedEvent : Event = null ) { 
		super( type );
		this.associatedEvent 	= associatedEvent;
		this.associatedData 	= associatedData;
		
	} 
	
}

}