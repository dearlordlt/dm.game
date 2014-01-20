package ucc.util  {
	import ucc.error.IllegalArgumentException;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Point;
	
/**
 * Various display object utilities
 *
 * @version $Id: DisplayObjectUtil.as 14 2013-02-27 02:28:08Z rytis.alekna $
 */
public class DisplayObjectUtil {
	
	/** Frame number pattern regexp */
	private static var frameNumberPatternRegExp : RegExp = /^(?P<meta>\:)?(?P<name>[a-z0-9_]+)(\s*(?P<offsetSign>[-+])\s*(?P<offsetLength>[0-9]+))?$/i;
	
	/**
	 * Private class constructor
	 * @private
	 */
	public function DisplayObjectUtil () {
	}
	
	/**
	 * Remove children of display object container
	 * @param	containerDO
	 */
	public static function removeChildren ( containerDO	: DisplayObjectContainer ) : void {
		
		while ( containerDO.numChildren > 0 ) {
			containerDO.removeChildAt(0);
		}
		
	}
	
	/**
	 * Remove specified children from their parents
	 * @param	children
	 */
	public static function removeSpecifiedChildren ( children : Array ) : void {
		for each( var item : DisplayObject in children ) {
			if ( item && item.parent ) {
				item.parent.removeChild( item );
			}
		}
	}
	
	/**
	 * Add children to specified container
	 * @param	containerDO
	 * @param	children
	 */
	public static function addSpecifiedChildren ( containerDO : DisplayObjectContainer, children : Array ) : void {
		
		if ( !containerDO ) {
			throw new IllegalArgumentException( "ucc.util.DisplayObjectUtil.addSpecifiedChildren() : containerDO not specified!" );
		}
		
		for each( var item : DisplayObject in children ) {
			if ( item ) {
				containerDO.addChild( item );
			}
			
		}
	}
	
	/**
	 * Get childs by regexp
	 *
	 * @param 	containerDO container get child childs of
	 * @param 	pattern regexp pattern
	 * @param 	sortByName if true, return array is sorted by name
	 * @return 	array of childs
	 */
	public static function getChildsByRegExp( containerDO : DisplayObjectContainer, pattern : RegExp, sortByName : Boolean = false ) : Array {
		
		var retVal 			: Array = [];
		
		// Match childs
		for( var i : int = 0; i < containerDO.numChildren; i++ ) {
			
			var childDO : DisplayObject = containerDO.getChildAt( i );
			
			if( childDO.name.match( pattern ) ) {
				retVal.push( childDO );
			}
		}
		
		if( sortByName ) {
			retVal.sortOn( ["name"] );
		}
		
		return retVal;
	}
	
	/**
	 * Get instances by mask
	 * 
	 * @param 	containerDO container get child childs of
	 * @param	mask instance mask, wildcards: * - any symbol, % - numerics (result is sorted by name)
	 * @param 	sortByName if true, return array is sorted by name
	 * @return 	array of childs
	 */
	public static function getChildsByMask( containerDO : DisplayObjectContainer, mask : String ) : Array {
		
		if( ! containerDO ) {
			throw new IllegalArgumentException( "Illegal containerDO value" );
		}
		
		if( ! mask ) {
			throw new IllegalArgumentException( "Illegal mask value" );
		}
		
		return DisplayObjectUtil.getChildsByRegExp( 
			containerDO,
			new RegExp( "^" + mask.replace( "*", ".*" ).replace( "%", "[0-9]+" ) + "$" ),
			mask.indexOf( "%" ) >= 0 
		);
	}
	
	/**
	 * Get children by class
	 * @param	containerDO
	 * @param	clazz	Class of children
	 * @param	sortOptions (same as for Array.sortOn method)
	 * @return	array Array of children of specified type
	 */
	public static function getChildrenByType ( containerDO : DisplayObjectContainer, clazz : Class, ... sortOptions ) : Array {
		
		if( ! containerDO ) {
			throw new IllegalArgumentException( "Illegal containerDO value" );
		}		
		
		var retVal : Array = [];
		
		for ( var i : int = 0; i < containerDO.numChildren; i++ ) {
			if ( containerDO.getChildAt( i ) is clazz ) {
				retVal.push( containerDO.getChildAt( i ) );
			}
		}
		
		if ( sortOptions.length > 0 ) {
			retVal.sortOn.apply( null, sortOptions );
		}
		
		return retVal;
	}
	
	/**
	 * Get descendants by class
	 * @param	containerDO
	 * @param	clazz	Class of children
	 * @param	sortOptions (same as for Array.sortOn method)
	 * @return	array Array of children of specified type
	 */
	public static function getDescendantsByType ( containerDO : DisplayObjectContainer, clazz : Class, ... sortOptions ) : Array {
		
		if( ! containerDO ) {
			throw new IllegalArgumentException( "Illegal containerDO value" );
		}		
		
		var retVal : Array = [];
		
		var child	: DisplayObject;
		
		for ( var i : int = 0; i < containerDO.numChildren; i++ ) {
			
			child = containerDO.getChildAt( i );
			
			if (  child is clazz ) {
				retVal.push( child );
			}
			
			if ( child is DisplayObjectContainer ) {
				retVal = retVal.concat( getDescendantsByType( DisplayObjectContainer( child ), clazz ) )
			}
			
		}
		
		if ( sortOptions.length > 0 ) {
			retVal.sortOn.apply( null, sortOptions );
		}
		
		return retVal;		
		
	}
	
	/**
	 * Get frame number by pattern.
	 * 
	 * Pattern examples:
	 * 		(int) 		10				frame number
	 * 		(String) 	name			frame name
	 * 		(String)	name+10			frame name plus offset
	 * 		(String)	:current+5		metavar (current frame) plus offset
	 * 		(String)	:total-2		metavar (total frames) minus offset
	 * 		(String)	:10				metavar (number)
	 * 
	 * @param	targetDO target display object
	 * @param	pattern frame pattern
	 * @return	frame number
	 */
	public static function getFrameNumber( targetDO : MovieClip, pattern : * ) : int {
		
		var retVal 	: int = -1;
		
		if( ! targetDO ) {
			throw new IllegalArgumentException( "Illegal targetDO value" );
		}
		
		// Integer value
		if( pattern is int ) {
			retVal = pattern;
		
		// String value	
		} else if( pattern is String ) {
			
			DisplayObjectUtil.frameNumberPatternRegExp.lastIndex = 0;
			
			var match : Object = DisplayObjectUtil.frameNumberPatternRegExp.exec( pattern );
			
			if( ! match ) {
				throw new IllegalArgumentException( "Illegal pattern syntax" );
			}
			
			// Meta
			if( match.meta ) {
				
				// Total frames
				if( match.name == "total" ) {
					retVal = targetDO.totalFrames;
					
				// Current frame
				} else if( match.name == "current" ) {
					retVal = targetDO.currentFrame;
				
				// Numeric frame	
				} else if( ! isNaN( parseInt( match.name ) ) ) {
					retVal = parseInt( match.name );
				
				// Uknown	
				} else {
					throw new IllegalArgumentException( "Illegal meta name in pattern" );
				}
				
			// Frame name
			} else {
				
				var label : Object = ArrayUtil.getElementByPropertyValue( targetDO.currentLabels, "name", match.name );
				
				if( label ) {
					retVal = label.frame;
				} else {
					throw new IllegalArgumentException( "Frame label doesn't exist" );
				}
			}
			
			// Offset
			if( match.offsetSign ) {
				retVal += parseInt( match.offsetLength ) * ( ( match.offsetSign == "+" ) ? 1 : -1 );
			}
		}
		
		// Final check
		if( ( retVal < 1 ) || ( retVal > targetDO.totalFrames ) ) {
			throw new IllegalArgumentException( "Illegal pattern - frame number is out of bounds" );
		}
		
		return retVal;
	}	
	
	/**
	 * Get position of the display object in the scope of other display object
	 * @param	scope
	 * @param	object
	 * @return	point with relative position to scope object
	 */
	public static function getObjectCoordinatesForScope ( scope : DisplayObject, object : DisplayObject ) : Point {
		return scope.globalToLocal( object.localToGlobal( new Point() ) );
	}	
	
}
	
}