<?php
/**
 * Base class for users operations
 * Users
 */
class Builder
{	
    function Builder() //Constructor
	{
    	include_once 'DBConnection.php';
	}
	
	function getComponentTypes() {
		$result = mysql_query("SELECT * FROM component_types;");
		$types = array();
		while ($type = mysql_fetch_object($result))
			array_push($types, $type);
		return $types;
	}
	
	function getCharacterTypes() {
		$result = mysql_query("SELECT * FROM character_types;");
		$types = array();
		while ($type = mysql_fetch_object($result))
			array_push($types, $type);
		return $types;
	}
}
?>