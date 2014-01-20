package dm.game.persistance  {
	import ucc.error.IllegalArgumentException;
	import flash.events.EventDispatcher;
	import flash.net.SharedObject;
	
/**
 * Simple implementation of KeyValueStore - it encapsutes SharedObject functionality
 *
 * @version $Id: LocalKeyValueStore.as 10 2013-01-31 07:30:45Z rytis.alekna $
 */
[Event(name="dm.game.persistance.KeyValueStoreEvent.PERSISTANCE_SUCCESS", type="dm.game.persistance.KeyValueStoreEvent")]
[Event(name="dm.game.persistance.KeyValueStoreEvent.PERSISTANCE_FAIL", type="dm.game.persistance.KeyValueStoreEvent")]
public class LocalKeyValueStore extends EventDispatcher implements KeyValueStore {
	
	/** Shared object */
	protected var sharedObject 			: SharedObject;
	
	/**
	 * Class constructor
	 */
	public function LocalKeyValueStore ( localStoreName : String ) {
		this.sharedObject = SharedObject.getLocal( localStoreName );
	}
	
	/**
	 *	@inheritDoc
	 */
	public function setKeyValue ( key : String,  value : * ) : void {
		
		if ( !key ) {
			throw new IllegalArgumentException( "dm.game.persistance.LocalKeyValueStore.setKeyValue() : key must be not null!" );
		}
		
		try {
			this.sharedObject.data[ key ] = value;
			this.dispatchEvent( new KeyValueStoreEvent( KeyValueStoreEvent.PERSISTANCE_SUCCESS, key, value ) )
		} catch ( error : Error ) {
			this.dispatchEvent( new KeyValueStoreEvent( KeyValueStoreEvent.PERSISTANCE_FAIL, key, value ) );
		}
		
		
	}
	
	/**
	 *	@inheritDoc
	 */
	public function getKeyValue ( key : String,  defaultValue : *  = null, persistDefaultIfValueNotPresent : Boolean = false ) : * {
		
		if ( ( ( this.sharedObject.data[ key ] == null ) || ( isNaN( this.sharedObject.data[ key ] ) ) ) && persistDefaultIfValueNotPresent ) {
			this.setKeyValue( key, defaultValue );
			this.sharedObject.flush();
		}
		
		return this.sharedObject.data[ key ] ? this.sharedObject.data[ key ] : defaultValue;
	}
	
}
	
}