<?php

/**
 * DataLister
 *
 * @author $Id$
 */
class DataLister {
	
    function __construct() { //Constructor
	}
	
	/**
	 * Get all data from specified table
	 * @param string $table
	 * @param array $fields
	 * @return type
	 */
	function getData ( $table, $fields ) {
		
		
		
		if ( isset($fields) ) {
			if ( is_array($fields) ) {
				$fields = implode( ", ", $fields );
			}
		} else {
			$fields = "*";
		}
		
		// return $fields;
		
		// return $fields.":".$table;
		
		$fields = mysql_real_escape_string($fields);
		$table = mysql_real_escape_string($table);
		
		
		
		$query = "SELECT ".$fields." FROM `".$table."`;";
		
		// return $query;
		
		$result = mysql_query($query);
		
		// return $result;
		
		if ( $result ) {
			
			$retVal = array();
			
			while ( $row = mysql_fetch_object($result) ) {
				$retVal[] = $row;
			}
			
			return $retVal;
			
		} else {
			return array (
				"error" => mysql_error()
			);
		}
		
		
	}
	
}

?>
