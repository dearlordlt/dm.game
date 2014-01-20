package ucc.util {

import ucc.error.Exception
import flash.display.LoaderInfo;
import flash.display.Sprite;
import flash.display.Stage;

/**
 * Flashvars retrieving utility
 *
 * $Id: FlashVarsUtil.as 3 2013-01-31 07:31:58Z rytis.alekna $
 */
public class FlashVarsUtil {
	
	/** reference to stage that is added to stage */
	public static var stage : Stage;
	
	/**
	 * Private class constuctor - use static methods
	 */
	public function FlashVarsUtil( atractor : SingletonAtractor ) {
	}
	
	/**
	 * @deprecated	Flash vars util uses com.flintgames.project.StageReference, so there is no more need to explcitly set stage reference
	 * Init FlashVarsUtil
	 * @param	displayObjectReference
	 */
	public static function initialize( stageReference : Stage ) : void {
		
		if ( !stageReference )
			throw new Exception( 'FlashVarsUtil : specified stage reference is undefined!' )
		stage = stageReference;
	
	}
	
	/**
	 * Get flash var
	 * @param	name	flash var name
	 * @param	default value	value to be returned if flash var doesn't exist
	 * @return	String
	 */
	public static function getParameter( name : String, defaultValue : * = "" ) : * {
		
		var retVal : *;
		
		try {
			retVal = LoaderInfo( stage.loaderInfo ).parameters[ name ]
		} catch ( error : Error ) {
			retVal = null;
		}
		
		return retVal ? retVal : defaultValue;
	
	}
	
	/**
	 * Checks if specified parameters exists. Retruns false if any of specified parameters don't exist
	 * @param	... parameters	Array of parameters names
	 * @return
	 */
	public static function parameterExist( ... parameters ) : Boolean {
		for ( var i : int = 0; i < parameters.length; i++ ) {
			if ( !( getParameter( parameters[ i ] ) ) ) {
				return false;
			}
		}
		return true;
	}
	
	/**
	 * Is parameters available
	 * @return
	 */
	public static function isParametersAvailable() : Boolean {
		
		var parametersCount : uint;
		
		if ( stage ) {
			
			for ( var i : String in stage.loaderInfo.parameters ) {
				parametersCount++;
			}
			
			return parametersCount > 0 ? true : false;
			
		} else {
			return false;
		}
	
	}

}

}

/**
 * Internal class required for Singleton construction
 */
class SingletonAtractor {
}