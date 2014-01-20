<?php
/**
 * Base class for users operations
 * Users
 */
class NPC
{	
    function NPC() //Constructor
	{
    	include_once 'DBConnection.php';
	}
	
	function getAllNpcs() {
		$npc_rs = mysql_query("SELECT * FROM npc;");
		$npcs = array();
		while($npc = mysql_fetch_object($npc_rs))
			array_push($npcs, $npc);
		return $npcs;
	}
	
	function getUserNpcs($userId) {
		$admin_rs = mysql_query("SELECT * FROM users WHERE id=".$userId." AND isadmin='Y';");
		if (mysql_num_rows($admin_rs) > 0)
			return $this->getAllNpcs();
	
		$npc_rs = mysql_query("SELECT * FROM npc WHERE id IN (SELECT object_id FROM object_permissions WHERE object_type='NPC' AND moderator_id=".$userId.");");
		$npcs = array();
		while($npc = mysql_fetch_object($npc_rs))
			array_push($npcs, $npc);
		return $npcs;
	}
	
	function getNpcById($npcId) {
		$npc_rs = mysql_query("SELECT * FROM npc WHERE id=".$npcId.";");
		$npc = mysql_fetch_object($npc_rs);
		$command_rs = mysql_query("SELECT * FROM npc_commands WHERE npc_id=".$npcId." ORDER BY queue;");
		$npc->commands = array();
		while($command = mysql_fetch_object($command_rs)) {
			$param_rs = mysql_query("SELECT * FROM npc_command_params WHERE command_id=".$command->id.";");
			$command->params = array();
			while ($param = mysql_fetch_object($param_rs))
				array_push($command->params, $param);
			array_push($npc->commands, $command);
		}
		return $npc;
	}
	
	function saveNpc($npc, $userId) {
		if ($npc['id'] != 0) {
			$npcId = $npc['id'];
			mysql_query("UPDATE npc SET label='".$npc['label']."', last_modified=NOW(), last_modified_by=".$userId." WHERE id=".$npcId.";");
			mysql_query("DELETE FROM npc_commands WHERE npc_id=".$npcId.";");			
		} else {
			mysql_query("INSERT INTO npc (label, last_modified, last_modified_by) VALUES ('".$npc['label']."', NOW(), ".$userId.");");
			$npcId = mysql_insert_id();
			mysql_query("INSERT INTO object_permissions (object_type, object_id, moderator_id) VALUES ('NPC', ".$npcId.", ".$userId.");");
		}

		$i = 0;
		foreach($npc['commands'] as $command) {
			$i++;
			$this->saveCommand($npcId, $command, $i);
		}
		return $this->getNpcById($npcId);
	}
	
	function getAllCommandLabels() {
		$command_rs = mysql_query("SELECT * FROM npc_command_labels;");
		$commands = array();
		while ($command = mysql_fetch_object($command_rs)) {
			$param_rs = mysql_query("SELECT * FROM npc_command_param_labels WHERE command_id=".$command->id.";");
			$command->params = array();
			while($param = mysql_fetch_object($param_rs))
				array_push($command->params, $param);
			array_push($commands, $command);
		}
		return $commands;
	}
	
	function saveCommand($npcId, $command, $queue) {
		mysql_query("INSERT INTO npc_commands (npc_id, label, queue) VALUES (".$npcId.", '".$command['label']."', ".$queue.");");
		$commandId = mysql_insert_id();
		foreach ($command['params'] as $param)
			mysql_query("INSERT INTO npc_command_params (command_id, label, value) VALUES (".$commandId.", '".$param['label']."', '".$param['value']."');");
		return $this->getCommandById($commandId);
	}
	
	function getCommandById($commandId) {
		$command_rs = mysql_query("SELECT * FROM npc_commands WHERE id=".$commandId.";");
		$command = mysql_fetch_object($command_rs);
		$param_rs = mysql_query("SELECT * FROM npc_command_params WHERE command_id=".$commandId.";");
		$command->params = array();
		while($param = mysql_fetch_object($param_rs))
			array_push($command->params, $param);
		return $command;
	}

}
?>