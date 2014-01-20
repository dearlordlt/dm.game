package ucc.util  {
	import ucc.error.IllegalArgumentException;
	import ucc.error.IllegalStateException;
	import flash.utils.Dictionary;
/**
 * Dictionary that stores values using two keys
 * It's like two dimensional array, but value storage is made easier (you can store one value using many primary and secondary keys only with one insert method )
 *
 * @version $Id: DoubleKeyDictionary.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public dynamic class DoubleKeyDictionary {
	
	/** Is table locked? */
	protected var locked	: Boolean;
	
	/** Use weak reference */
	protected var useWeakReference	: Boolean;
	
	/** Treat arrays as keys collections */
	protected var arraysAreKeysCollections : Boolean;
	
	/** First keys dictionary */
	protected var firstKeysDictionary	: Dictionary = new Dictionary()
	
	/**
	 * DoubleKeyDictionary constructor
	 * @param	arrayDictionary
	 * <code>
	 * [
	 * 		[ "firstKey", "secondKey", "value1" ],
	 * 		[ [ "firstMultiKey0", "firstMultiKey1", "firstMultiKey2" ], "secondKey", "value2" ],
	 * 		[ [ "firstMultiKey0", "firstMultiKey1", "firstMultiKey2" ], [ "secondMultiKey0", "secondMultiKey1", "secondMultiKey2" ], "value3" ],
	 * 		[ "firstKey", [ "secondMultiKey0", "secondMultiKey1", "secondMultiKey2" ], "value4" ],
	 * ]
	 * </code>
	 * @param	lock dictionary (make it imutable)
	 * @param	arraysAreKeysCollections	key that are array will be treated as keys collections
	 */
	public function DoubleKeyDictionary ( arrayDictionary : Array = null, lock : Boolean = false, useWeakReference : Boolean = false, arraysAreKeysCollections : Boolean = true ) {
		
		this.arraysAreKeysCollections = arraysAreKeysCollections;
		this.useWeakReference = useWeakReference;
		if ( arrayDictionary ) {
			this.setArrayDictionary( arrayDictionary );
		}
		this.lockTable( lock );
		
	}
	
	/**
	 * (Un)lock table
	 * @param	true to lock
	 */
	public function lockTable ( value : Boolean ) : void {
		this.locked = value;
	}
	
	/**
	 * Set transition values table. By setting values using this method, old table is overriden.
	 * @param	arrayDictionary
	 * <code>
	 * [
	 * 		[ "firstKey", "secondKey", "value1" ],
	 * 		[ [ "firstMultiKey0", "firstMultiKey1", "firstMultiKey2" ], "secondKey", "value2" ],
	 * 		[ [ "firstMultiKey0", "firstMultiKey1", "firstMultiKey2" ], [ "secondMultiKey0", "secondMultiKey1", "secondMultiKey2" ], "value3" ],
	 * 		[ "firstKey", [ "secondMultiKey0", "secondMultiKey1", "secondMultiKey2" ], "value4" ],
	 * ]
	 * </code>
	 */
	public function setArrayDictionary ( arrayDictionary : Array ) : void {
		
		if ( !this.locked ) {
			
			for ( var i : int = 0; i < arrayDictionary.length; i++ ) {
				
				if ( arrayDictionary[i] is Array ) {
					this.setValue.apply( null, arrayDictionary[i] );
				} else {
					throw new IllegalArgumentException( "Suplied array dictionary is in incorect format!" );
				}
				
			}
			
		} else {
			throw new IllegalStateException( "Table is locked!" );
		}
		
	}
	
	/**
	 * Sets value using two (multi)keys
	 * Key can be any object. Except if by default arrays are treated as keys collections, array is extracted as key collection
	 * @param	firstKey	
	 * @param	secondKey	any object
	 * @param	value	value to stored
	 */
	public function setValue ( firstKey : * , secondKey : * , value : * ) : void {
		
		if ( this.locked ) {
			throw new IllegalStateException( "Dictionary is locked!" );
		}
		
		if ( ( firstKey is Array ) && this.arraysAreKeysCollections ) {
			
			for ( var i : int = 0; i < firstKey.length; i++ ) {
				this.insertValuesForFirstKey( firstKey[i], secondKey, value );
			}
			
		} else {
			this.insertValuesForFirstKey( firstKey, secondKey, value );
		}
		
	}
	
	/**
	 * Get value
	 * @param	firstKey
	 * @param	secondKey
	 * @return
	 */
	public function getValue ( firstKey : * , secondKey : * ) : * {
		var secondKeyDictionary : Dictionary =  this.firstKeysDictionary[ firstKey ];
		if ( secondKeyDictionary ) {
			return secondKeyDictionary[ secondKey ];
		} else {
			return null;
		}
	}
	
	/**
	 * Insert values for first key
	 * @param	key
	 * @param	secondKey
	 * @param	value
	 */
	protected function insertValuesForFirstKey ( key : * , secondKey : * , value : * ) : void {
		
		// gets existing first key dictionary or creates a new one
		var secondKeysDictionary	: Dictionary = this.firstKeysDictionary[ key ] ? this.firstKeysDictionary[ key ] : ( this.firstKeysDictionary[ key ] = new Dictionary( this.useWeakReference ) );
		
		// If second key ir collection if keys - iterate through it
		if ( ( secondKey is Array ) && this.arraysAreKeysCollections ) {
			for ( var i : int = 0; i < secondKey.length; i++ ) {
				secondKeysDictionary[ secondKey[i] ] = value;
			}
		// Else assign a value directly
		} else {
			secondKeysDictionary[ secondKey ] = value;
		}
		
	}
	
}
	
}