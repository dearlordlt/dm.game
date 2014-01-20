<?php
/**
 * Base class for users operations
 * Users
 */
class Controls
{	
    function __construct() { //Constructor
	}
	
	function getUserControls($userId) {
		$action_rs = mysql_query("SELECT label, key_press_type, default_key_code, key_code FROM control_actions LEFT JOIN user_controls ON control_actions.id = action_id AND user_id=".$userId.";");
		$actions = array();
		while ($action = mysql_fetch_object($action_rs))
			$actions[] = $action;
		return $actions;
	}

}
?>