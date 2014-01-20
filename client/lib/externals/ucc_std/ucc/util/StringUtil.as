package ucc.util {
	import flash.net.URLRequest;
	
/**
 * Variuos string utils
 * 
 * @version $Id: StringUtil.as 35 2013-06-14 12:16:22Z rytis.alekna $
 */
public class StringUtil {
	
	/** Camel case spliter */
	private static const cameCaseSplitter				: RegExp = /((^[a-z]+)|([A-Z]{1}[a-z]+)|([A-Z]+(?=([A-Z][a-z])|($))))/g;
	
	/** Email pattern */
	private static const emailPattern					: RegExp = /^[0-9a-zA-Z][-._a-zA-Z0-9]*@([0-9a-zA-Z][-._0-9a-zA-Z]*\.)+[a-zA-Z]{2,4}$/;
	
	/**
	 * Class constuctor
	 */
	public function StringUtil() {
		
	}
	
	/** available char array */
	private static const DEFAULT_CHARS 					: String = 'abcdefghijklmnopqrstuvwxyz';
	
	/** available numbers array */
	private static const DEFAULT_NUMBERS				: String = '0123456789';
	
	/** Trim left regexp */
	private static const TRIM_LEFT_PATTERN				: RegExp = /^(\s*)/;
	
	/** Trim right regexp */
	private static const TRIM_RIGHT_PATTERN				: RegExp = /(\s*)$/;
	
	/**
	 * Generates a random string of characters specified in DEFAULT_CHARS constant
	 * @param	length of returning string.
	 * @param	use numbers?
	 * @param	allow upper case letters?
	 * @param	custom chars instead of default
	 * @param	custom numbers instead of default
	 * @return	random string
	 */
	public static function random ( length : uint = 10, useNumbers : Boolean = false, mixWithUpperCase : Boolean = true, chars : String = '', numbers : String = '' ) : String {
		
		if ( chars.length == 0 ) {
			chars = DEFAULT_CHARS;
		}
		
		if ( useNumbers ) {
			chars += ( numbers.length == 0 ) ? DEFAULT_NUMBERS : numbers;
		}
		
		var charsLength : Number = chars.length;
		
		var retVal 		: String = '';
		
		var char 		: String;
		
		for ( var i : uint = 0; i < length; i++ ) {
			char = chars.charAt( Math.floor( Math.random() * charsLength ) );
			retVal += mixWithUpperCase ? char : char.toLocaleLowerCase();
		}
		
		return retVal;
		
	}
	
	/**
	 * Create url request from string
	 * @param	url	String or URLRequest
	 * @return	Url request. If url argument was URL request, original requests is returned
	 */
	public static function createUrlRequest ( url : * ) : URLRequest {
		
		assert( url is String || url is URLRequest, "Url must be String or URLRequest" );
		
		if ( url is URLRequest ) {
			return url;
		}
		
		return new URLRequest( url );
		
	}
	
	/**
	 * Cammel case to sentence
	 * @param	value
	 * @return
	 */
	public static function cammelCaseToSentence ( value : String ) : String {
		
		var tokens : Array = value.match( cameCaseSplitter );
		
		if ( tokens.length > 0 ) {
			
			var retVal : String = tokens.join(" ");
			
			retVal = retVal.toLowerCase();
			
			return retVal.charAt(0).toUpperCase() + retVal.substring(1);
			
		} else {
			return "";
		}
		
	}
	
	/**
	 * trim left white space
	 * @param	value
	 * @return
	 */
	public static function trimLeft ( value : String ) : String {
		return value.replace( TRIM_LEFT_PATTERN, "" );
	}
	
	/**
	 * Trim right white space
	 * @param	value
	 * @return
	 */
	public static function trimRight ( value : String ) : String {
		return value.replace( TRIM_RIGHT_PATTERN, "" );
	}
	
	/**
	 * Trim white space
	 * @param	value
	 * @return
	 */
	public static function trim ( value : String ) : String {
		return value.replace( TRIM_RIGHT_PATTERN, "" ).replace( TRIM_LEFT_PATTERN, "" );
	}
	
	/**
	 * Determines whether the specified email is valid
	 * @param	email
	 * @return
	 */
	public static function isEmail ( email : String ) : Boolean {
		return emailPattern.test( email );
	}
	
}
	
}