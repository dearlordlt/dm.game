package ucc.cache  {
	import flash.utils.Dictionary;
	
/**
 * 
 *
 * @version $Id: SimpleCache.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class SimpleCache implements Cache {
	
	/** Cache storage */
	protected var storage	: Dictionary = new Dictionary( true );
	
	/**
	 * Class constructor
	 */
	public function SimpleCache () {
		
	}
	
	
	/** 
	 *	@inheritDoc 
	 */
	public function retrieveObjectByKey(key:*):* {
		return this.storage[key];
	}
	
	/** 
	 *	@inheritDoc 
	 */
	public function storeObject(object:*, key:*):void {
		assert(key);
		this.storage[key] = object;
	}
	
	/** 
	 *	@inheritDoc 
	 */
	public function clear():void {
		for (var key : * in this.storage ) {
			delete this.storage[key];
		}
	}
	
}
	
}