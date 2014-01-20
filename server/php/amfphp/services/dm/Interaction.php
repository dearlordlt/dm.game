<?php
/**
 * Base class for users operations
 * Users
 */
class Interaction
{	
    function Interaction() //Constructor
	{
    	include_once 'DBConnection.php';
		include_once 'Functions.php';
		include_once 'Conditions.php';
	}
	
	function getAllInteractions() {
		$interaction_rs = mysql_query("SELECT * FROM interactions;");
		$interactions = array();
		while($interaction = mysql_fetch_object($interaction_rs))
			array_push($interactions, $interaction);
		return $interactions;
	}
	
	function getUserInteractions($userId) {
		$admin_rs = mysql_query("SELECT * FROM users WHERE id=".$userId." AND isadmin='Y';");
		if (mysql_num_rows($admin_rs) > 0)
			return $this->getAllInteractions();
	
		$interaction_rs = mysql_query("SELECT * FROM interactions WHERE id IN (SELECT object_id FROM object_permissions WHERE object_type='interaction' AND moderator_id=".$userId.");");
		$interactions = array();
		while($interaction = mysql_fetch_object($interaction_rs))
			array_push($interactions, $interaction);
		return $interactions;
	}
	
	function saveInteraction($interaction, $userId) {
		if ($interaction['id'] == 0) {
			mysql_query("INSERT INTO interactions (label, last_modified, last_modified_by) VALUES ('".$interaction['label']."', NOW(), ".$userId.");");
			$interactionId = mysql_insert_id();
			mysql_query("INSERT INTO object_permissions (object_type, object_id, moderator_id) VALUES ('interaction', ".$interactionId.", ".$userId.");");
		} else {
			$interactionId = $interaction['id'];
			mysql_query("UPDATE interactions SET label='".$interaction['label']."', last_modified=NOW(), last_modified_by=".$userId." WHERE id=".$interactionId.";");
			mysql_query("DELETE FROM functions_to_interactions WHERE interaction_id=".$interactionId.";");
			mysql_query("DELETE FROM conditions_to_interactions WHERE interaction_id=".$interactionId.";");
		}
		
		foreach($interaction['functionIds'] as $functionId)
			mysql_query("INSERT INTO functions_to_interactions (interaction_id, function_id) VALUES (".$interactionId.", ".$functionId.");");
			
		foreach($interaction['conditionIds'] as $conditionId)
			mysql_query("INSERT INTO conditions_to_interactions (interaction_id, condition_id) VALUES (".$interactionId.", ".$conditionId.");");
		
		return $this->getInteractionById($interactionId);
	}
	
	function getInteractionById($interactionId) {
		$interaction_rs = mysql_query("SELECT * FROM interactions WHERE id=".$interactionId.";");
		if (mysql_num_rows($interaction_rs) > 0) {
			$interaction = mysql_fetch_object($interaction_rs);
			
		$function_rs = mysql_query("SELECT * FROM functions_to_interactions WHERE interaction_id=".$interactionId.";");
		$functionsClass = new Functions();
		$interaction->functions = array();
		while($function = mysql_fetch_object($function_rs))
			array_push($interaction->functions, $functionsClass->getFunctionById($function->function_id));
			
		$condition_rs = mysql_query("SELECT * FROM conditions_to_interactions WHERE interaction_id=".$interactionId.";");
		$conditionsClass = new Conditions();
		$interaction->conditions = array();
		while($condition = mysql_fetch_object($condition_rs))
			array_push($interaction->conditions, $conditionsClass->getConditionById($condition->condition_id));
			
			return $interaction;
		} else
			return false;
	}
	
	function register($username, $password) {
		$user_rs = mysql_query("SELECT * FROM users WHERE username='".$username."';");
		if (mysql_num_rows($user_rs) > 0)
			return false;
		return mysql_query("INSERT INTO users (username, password) VALUES ('".$username."', '".$password."');");
	}
}
?>