package dm.game.persistance {
	import flash.events.IEventDispatcher;
	
/**
 * 
 * @author Rytis Alekna (r.alekna@gmail.com)
 * @version $Id: KeyValueStore.as 138 2013-05-24 14:49:58Z rytis.alekna $
 */
public interface KeyValueStore extends IEventDispatcher {
	
	/**
	 * Persist key value. Fires event if data can't be persisted
	 * @param	key
	 * @param	value
	 */
	function setKeyValue ( key : String, value : * ) : void;
	
	/**
	 * Get key value from store
	 * @param	key
	 * @param	defaultValue	if value not present
	 * @return
	 */
	function getKeyValue ( key : String, defaultValue : * = null, persistDefaultIfValueNotPresent : Boolean = false ) : * ;
	
}
	
}