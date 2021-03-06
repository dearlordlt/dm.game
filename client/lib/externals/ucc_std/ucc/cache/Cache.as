package ucc.cache {
	
/**
 * Objects cache
 * @author Rytis Alekna
 * @version $Id: Cache.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public interface Cache {
	
	/**
	 * Retrieve object 
	 * @param	key	any chosen key
	 * @return
	 */
	function retrieveObjectByKey ( key : * ) : * ;
	
	/**
	 * Store object to cache
	 * @param	object	object to store
	 * @param	key	a key to identify object. Key must not be <code>undefined</code>, <code>null</code> or <code>false</code>. Thre is no warning if you override already existing object with the same key
	 */
	function storeObject ( object : * , key : * ) : void;
	
	/**
	 * Clear cache
	 */
	function clear () : void;
	
}
	
}