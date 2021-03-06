package ucc.util  {
	
import ucc.error.IllegalArgumentException;
	
/**
 * Various array utitlities
 *
 * @version $Id: ArrayUtil.as 3 2013-01-31 07:31:58Z rytis.alekna $
 */
public final class ArrayUtil {
	
	/**
	 * Get random elements from array
	 * 
	 * @param	source array
	 * @param	length of required random array, or -1 if all source array
	 * @param	splice do source array splicing?
	 * @return	random elements from source array
	 */
	public static function getRandomElements( source : Array, length : int = -1, splice : Boolean = false ) : Array {
		
		if( source == null ) {
			throw new IllegalArgumentException( "Illegal source argument - must be not null" );
		}
		
		// Normalize length
		length = ( length == -1 ) ? source.length : MathUtil.normalize( length, 0, source.length );
		
		// Create return value
		var values 	: Array = splice ? source : source.concat();
		var retVal 	: Array = [];
		
		for( var i : int = 0; i < length; i++ ) {
			retVal.push( values.splice( MathUtil.getRandomIntInRange( 0, values.length - 1 ), 1 )[0] );
		}
		
		return retVal;
	}
	
	/**
	 * Get random element
	 * 
	 * @param	source source array
	 * @param	splice do splicing?
	 * @return	random element
	 */
	public static function getRandomElement( source : Array, splice : Boolean = false ) : * {
		
		if ( source.length > 0 ) {
			if ( splice ) {
				return source.splice( MathUtil.getRandomIntInRange(0, source.length - 1 ), 1 )[0];
			} else {
				return source[ MathUtil.getRandomIntInRange(0, source.length - 1 ) ];
			}
			return 
		} else {
			return null;
		}
		
	}
	
	/**
	 * Shuffle array
	 * 
	 * @param	array to shuffle
	 * @param	copy array or shuffle same object?
	 * @return	shuffled array
	 */
	public static function shuffle( array : Array, copy : Boolean = false ) : Array {
		// TODO: finish fixing
		var retVal : Array = copy ? array.concat() : array;
		return ArrayUtil.getRandomElements( array, -1, false );
	}
	
	
	/** 
	 * Get keys of any value
	 * 
	 * @param	value any value
	 * @return	array of keys
	 */
	public static function getKeys( value : * ) : Array {
		
		var retVal : Array = [];
		
		if( value ) {
			
			for( var i : String in value ) {
				retVal.push( i );
			}
		}
		
		return retVal;
	}
	
	/**
	 * Remove element from array by reference
	 * @param	source	source array to remove element from
	 * @param	element	element to remove
	 * @return	removed element
	 */
	public static function removeElementByReference( source : Array, element : * ) : * {
		if ( source.indexOf( element ) != -1 ) {
			return source.splice( source.indexOf( element ), 1 )[0];
		} else {
			return undefined;
		}
	}
	
	/**
	 * Remove element by equality (element is compared by deep comparising, not by reference)
	 * @param	source array
	 * @param	element to compare
	 * @return	removed element
	 */
	public static function removeElementByEquality ( source : Array, element : * ) : * {
		
		var retVal : * ;
		for ( var i : int = 0; i < source.length; i++ ) {
			if ( ObjectUtil.areObjectsEqual( source[i], element ) ) {
				retVal = source[i];
				break;
			}
		}
		source.splice( i, 1 );
		return retVal;
	}
	
	/**
	 * Remove elements from array
	 * 
	 * @param	source array to remove element from
	 * @param	elements to remove
	 * @param	limit of removals, -1 unlimited
	 * @return	removed elements count
	 */
	public static function removeElements( source : Array, elements : Array, limit : int = -1 ) : int {
		
		var retVal : int = 0;
		
		if( source == null ) {
			throw new IllegalArgumentException( "Illegal source argument - must be not null" );
		}
		
		var i : int = 0;
		
		while( ( i < source.length ) && ( ( limit == -1 ) || ( retVal < limit  ) ) ) {
			
			if( elements.indexOf( source[i] ) >= 0 ) {
				source.splice( i, 1 );
				retVal++;
			} else {
				i++;
			}
		}
		
		return retVal;
	}
	
	/**
	 * Get element by property value
	 * 
	 * @param	source array
	 * @param	property of element
	 * @param	value of element propery
	 * @return	element
	 */
	public static function getElementByPropertyValue( source : Array, property : String, value : * ) : * {
		
		if( source == null ) {
			throw new IllegalArgumentException( "Illegal source argument - must be not null" );
		}
		
		var retVal : * = null;
		
		for( var i : int = 0; i < source.length; i++ ) {
			
			if( source[i][property] == value ) {
				retVal = source[i];
				break;
			}
		}
		
		return retVal;
	}
	
	/**
	 * Get elements by property value
	 * 
	 * @param	source array
	 * @param	property of element
	 * @param	value of element propery
	 * @return	array of elements that matches specified propery value
	 */
	public static function getElementsByPropertyValue( source : Array, property : String, value : * ) : Array {
		
		if( source == null ) {
			throw new IllegalArgumentException( "Illegal source argument - must be not null" );
		}
		
		return source.filter( 
			function ( item : * , index : int, array : Array ) : * {
				return item[property] == value;
			}
		)
	}
	
	/**
	 * Remove element by property value
	 * @param	source	array
	 * @param	property
	 * @param	value
	 * @return	removed element
	 */
	public static function removeElementByPropertyValue ( source : Array, property : String, value : * ) : * {
		return ArrayUtil.removeElementByReference( source, ArrayUtil.getElementByPropertyValue( source, property, value ) );
	}
	
	/**
	 * Swap elements indices in array
	 * 
	 * @param	source array
	 * @param	index1
	 * @param	index2
	 * @return	changed array
	 */
	public static function swapElements( source : Array, index1 : uint, index2 : uint ) : Array {
		if ( index1 == index2 ) {
			throw new IllegalArgumentException( "Provided indices must not be equal!" );
		}
		if ( index1 > source.length - 1 || index2 > source.length - 1 ) {
			throw new IllegalArgumentException( "Index must not be out of source array length range!" );
		}
		
		var swapElemenet1 : * = source[index1];
		var swapElemenet2 : * = source[index2];
		
		source.splice( index1, 1, swapElemenet2 );
		source.splice( index2, 1, swapElemenet1 );
		return source;
	}
	
	/**
	 * Change element index
	 * 
	 * @param	source array
	 * @param	currentIndex current index
	 * @param	destinationIndex destination index
	 * @return	source modified array
	 */
	public static function changeElementIndex( source : Array, currentIndex : uint, destinationIndex : uint ) : Array {
		
		if ( !source[currentIndex] ) {
			throw new IllegalArgumentException( "passed current index refers to undefined element!" );
		}
		
		if ( currentIndex == destinationIndex ) {
			throw new IllegalArgumentException( "Provided indices must not be equal!" );
		}
		
		var swapElement : * = source[currentIndex];
		
		if ( currentIndex > destinationIndex ) {
			source.splice( currentIndex, 1 );
			source.splice( destinationIndex, 0, swapElement );
		} else {
			source.splice( destinationIndex+1, 0, swapElement );
			source.splice( currentIndex, 1 );
		}
		
		return source;
	}
	
	/**
	 * Get array elements (or their values if index specified)
	 * 
	 * @param	source source array
	 * @param	valueIndex value index
	 * @return	array elements, o element values (if index specified)
	 */
	public static function getElements( source : Array, valueIndex : Array = null ) : Array {
		
		var retVal : Array = [];
		
		// No index - just return elements
		if( ( valueIndex == null ) || ( valueIndex.length == 0 ) ) {
			retVal = source.concat();
			
		// Got index...
		} else {
			
			for( var i : int = 0; i < source.length; i++ ) {
				
				var value : * = source[i];
				
				for( var j : int = 0; j < valueIndex.length; j++ ) {
					
					if( value && value[valueIndex[j]] ) {
						value = value[valueIndex[j]];
					} else {
						value = null; 
						break;
					}
				}
				
				retVal.push( value );
			}
		}
		
		return retVal;
	}
	
	/**
	 * Beginning of given array matches? If one of given arrays is empty function with return true.
	 * @param	array1
	 * @param	array2
	 * @return	true if yes.
	 */
	public static function beginningMatches ( array1 : Array, array2 : Array ) : Boolean {
		
		if ( ( !array1 || !array2 ) ) {
			throw new IllegalArgumentException( "Given arrays must be not null!" );
		}
		
		var minLength : int = Math.min( array1.length, array2.length );
		
		for ( var i : int = 0; i < minLength; i++ ) {
			if ( ( array1[i] !== array2[i] ) && ( ( array1[i] != ignore ) || ( array2[i] != ignore ) ) ) {
				return false;
			}
		}
		
		return true;
		
	}
	
	/**
	 * Are given arrays equal?
	 * @param	array1
	 * @param	array2
	 * @return	true if yes
	 */
	public static function equals ( array1 : Array, array2 : Array ) : Boolean {
		
		if ( ( !array1 || !array2 ) || ( array1.length != array2.length ) ) {
			return false;
		}
		
		for ( var i : int = 0; i < array1.length; i++ ) {
			if ( array1[i] != array2[i] && ( ( array1[i] != ignore ) || ( array2[i] != ignore ) ) ) {
				return false;
			}
		}
		
		return true;
		
	}
	
}
	
}