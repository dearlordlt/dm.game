package ucc.util  {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
/**
 * Misc math utilities
 *
 * @version $Id: MathUtil.as 16 2013-03-04 07:47:57Z rytis.alekna $
 */
public class MathUtil {
	
	/** Radians to degrees */
	public static const RAD_TO_DEG		: Number = 180 / Math.PI;
	
	/** Degress to radians */
	public static const DEG_TO_RAD		: Number = Math.PI / 180;
	
	/**
	 * Normalize number to given range
	 * @param	value	value to normalize
	 * @param	min		lover normalization bound
	 * @param	max		uper normalization bound
	 * @return
	 */
	public static function normalize ( value : Number, min : Number, max : Number ) : Number {
		return Math.min( Math.max( value, min ), max );
	}
	
	/**
	 * Get sign of number
	 */
	public static function getSign ( value : Number ) : int {
		return ( value == 0 ) ? 0 : ( ( value > 0 ) ? 1 : -1 );
	}
	
	/**
	 * Get random boolean value
	 * @return	true or false
	 */
	public static function getRandomBoolean () : Boolean {
		return Math.random() < 0.5;
	}
	
	/**
	 * Protect number from being NaN. That is - if <code>value</code> if NaN, it's converted to <code>nanSubstitute</code>
	 * @param	value
	 * @param	naNSubstitute
	 * @return	original value or NaN substitute
	 */
	public static function protectNumberFromNan ( value : Number, nanSubstitute : Number = 0 ) : Number {
		return isNaN( value ) ? nanSubstitute : value;
	}
	
	/**
	 * Get random integer in specified range
	 * @param	min	value (inclusive)
	 * @param	max value (inclusive)
	 * @return	integer in specified range
	 */
	public static function getRandomIntInRange ( minValue : int, maxValue : int ) : int {
		
		// make equal opportunity for edge numbers to be selected
		var min : Number = minValue - 0.4999;
		var max : Number = maxValue + 0.4999;
		return Math.round( min + ( ( max - min ) * Math.random() ) );
	}
	
	/**
	 * Get random number
	 * @param	min
	 * @param	max
	 * @return	random number in range
	 */
	public static function getRandomNumberInRange ( min : Number, max : Number ) : Number {
		return min + ( ( max - min ) * Math.random() );
	}
	
	/**
	 * get random argument form provided arguments to method
	 * @param	... args
	 * @return
	 */
	public static function getRandomArgument ( ... args ) : * {
		return args[ Math.round( Math.random() * ( args.length - 0.5001 ) - 0.4999 ) ];
	}
	
	/**
	 * Get fraction of given number
	 * @param	value
	 * @return
	 */
	public static function getFraction ( value : Number ) : Number {
		return value - Math.floor( value );
	}
	
	/**
	 * Get grid cell width and height when number of columns or rows are specified
	 * @param	gridWidth
	 * @param	gridHeight
	 * @param	columns
	 * @param	rows
	 * @return	an object with such properties: { rows : rows, columns : columns, cellWidth : cellWidth, cellHeight : cellHeight };
	 */
	public static function getGridCellDimensions ( gridWidth : Number, gridHeight : Number, columns : uint = 0, rows : uint = 0 ) : Object {
		
		var cellHeight 	: Number;
		var cellWidth	: Number;
		
		assert( gridWidth && gridHeight && ( columns || rows ) );
		
		if ( rows && columns ) {
			
			cellWidth = gridWidth / columns;
			
			cellHeight = gridHeight / rows;
			
		} else if ( rows && !columns ) {
			
			cellHeight = gridHeight / rows;
			
			columns = Math.round( gridWidth / cellHeight ); 
			
			cellWidth = gridWidth / columns;
			
		} else if ( !rows && columns ) {
			
			cellWidth = gridWidth / columns;
			
			rows = Math.round( gridHeight / cellWidth );
			
			cellHeight = gridHeight / rows;
			
		}
		
		return { rows : rows, columns : columns, cellWidth : cellWidth, cellHeight : cellHeight };
		
	}
	
	/**
	 * Get angle between points in radians
	 * @param	point1
	 * @param	point2
	 * @return	angle in radians
	 */
	public static function getAngleBetweenPoints ( point1 : Point, point2 : Point ) : Number {
		var diff : Point = point2.subtract( point1 );
		return Math.atan2( diff.y, diff.x );
	}
	
}
	
}