<?php

/**
 * ObjectUtil
 *
 * @author $Id$
 */
class ObjectUtil {

	private function __construct() {
	}
	
	/**
	 * Convert stdClass object to associative array
	 * @param type $d
	 * @return type
	 */
	public static function objectToArray($d) {
		
		// return get_object_vars($d);
		
		
		if (is_object($d)) {
			// Gets the properties of the given object
			// with get_object_vars function
			$d = get_object_vars($d);
		}
 
		if (is_array($d)) {
			/*
			* Return array converted to object
			* Using __FUNCTION__ (Magic constant)
			* for recursive call
			*/
		   // call_user_method(__FUNCTION__, $obj)
			return array_map(array( __CLASS__, __FUNCTION__ ), $d);
		}
		else {
			// Return array
			return $d;
		}
		
	}
	
	/**
	 * Conveert arrray to object
	 * @param type $d
	 * @return type
	 */
	public static function arrayToObject($d) {
		if (is_array($d)) {
			/*
			* Return array converted to object
			* Using __FUNCTION__ (Magic constant)
			* for recursive call
			*/
			return (object) array_map(array( __CLASS__, __FUNCTION__ ), $d);
		}
		else {
			// Return object
			return $d;
		}
	}	
	
}

?>
