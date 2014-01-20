<?php
/**
 * Base class for users operations
 * Users
 */
class Builder
{	
    function __construct() { //Constructor
	}
	
	function getComponentTypes() {
		$result = mysql_query("SELECT * FROM component_types;");
		$types = array();
		while ($type = mysql_fetch_object($result))
			array_push($types, $type);
		return $types;
	}
	
	function getCharacterTypes($userId) {
                $isAdmin = mysql_num_rows(mysql_query("SELECT * FROM users WHERE id=$userId AND isadmin='Y';")) > 0;
                if ($isAdmin) {
                    $result = mysql_query("SELECT * FROM character_types;");
                } else {
                    $result = mysql_query("SELECT * FROM character_types WHERE available=1;");
                }
		$types = array();
		while ($type = mysql_fetch_object($result))
			array_push($types, $type);
		return $types;
	}
}
?>