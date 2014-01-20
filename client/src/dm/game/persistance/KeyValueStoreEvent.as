package dm.game.persistance {
	
import flash.events.Event;
	
/**
 * Key value store event
 * 
 * @version $Id: KeyValueStoreEvent.as 2 2013-01-03 09:37:22Z rytis.alekna $
 */
public class KeyValueStoreEvent extends Event {
	
	/** Persistance fail */
	public static const PERSISTANCE_FAIL	 		: String = "dm.game.persistance.KeyValueStoreEvent.PERSISTANCE_FAIL";
	
	/** PERSISTANCE_SUCCESS event */
	public static const PERSISTANCE_SUCCESS 		: String = "dm.game.persistance.KeyValueStoreEvent.PERSISTANCE_SUCCESS";
	
	/** ON_DATA event fired when data asyncroniasly retrieved from persistence */
	public static const ON_DATA 					: String = "dm.game.persistance.KeyValueStoreEvent.ON_DATA";
	
	/** Key */
	public var key				: String;
	
	/** Value */
	public var value			: * ;
	
	/**
	 * Constructor
	 */
	public function KeyValueStoreEvent( type : String, key : String = null, value : * = null ) { 
		super( type );
		this.key 	= key;
		this.value 	= value;
	} 
	
}

}