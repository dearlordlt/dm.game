<?php
/**
 * Base class for loot operations
 * Loot
 */
class Loot
{	
    function Loot() //Constructor
	{
    	include_once 'DBConnection.php';
	}
	
	function getAllLoot() {
		$loot_rs = mysql_query("SELECT * FROM loot;");
		$allLoot = array();
		while($loot = mysql_fetch_object($loot_rs)) {
			$dialog_rs = mysql_query("SELECT id, name AS label FROM dialog_dialogs WHERE id IN (SELECT dialog_id FROM dialogs_to_loot WHERE loot_id=".$loot->id.");");
			$loot->dialogs = array();
			while($dialog = mysql_fetch_object($dialog_rs))
				array_push($loot->dialogs, $dialog);
			array_push($allLoot, $loot);
		}
		return $allLoot;
	}
	
	function getUserLoot($userId) {
		$admin_rs = mysql_query("SELECT * FROM users WHERE id=".$userId." AND isadmin='Y';");
		if (mysql_num_rows($admin_rs) > 0)
			return $this->getAllLoot();
	
		$loot_rs = mysql_query("SELECT * FROM loot WHERE id IN (SELECT object_id FROM object_permissions WHERE object_type='loot' AND moderator_id=".$userId.");");
		$allLoot = array();
		while($loot = mysql_fetch_object($loot_rs)) {
			$dialog_rs = mysql_query("SELECT id, name AS label FROM dialog_dialogs WHERE id IN (SELECT dialog_id FROM dialogs_to_loot WHERE loot_id=".$loot->id.");");
			$loot->dialogs = array();
			while($dialog = mysql_fetch_object($dialog_rs))
				array_push($loot->dialogs, $dialog);
			array_push($allLoot, $loot);
		}
		return $allLoot;
	}
	
	function saveLoot($loot, $userId) {
		if ($loot['id'] == 0) {
			mysql_query("INSERT INTO loot (label, spawn_period, last_looted, last_modified, last_modified_by) VALUES ('".$loot['label']."', ".$loot['spawn_period'].", NOW(), NOW(), ".$userId.");");
			$lootId = mysql_insert_id();
			mysql_query("INSERT INTO object_permissions (object_type, object_id, moderator_id) VALUES ('loot', ".$lootId.", ".$userId.");");
		} else {
			$lootId = $loot['id'];
			mysql_query("UPDATE loot SET label='".$loot['label']."', spawn_period=".$loot['spawn_period'].", last_modified=NOW(), last_modified_by=".$userId." WHERE id=".$lootId.";");
			mysql_query("DELETE FROM dialogs_to_loot WHERE loot_id=".$lootId.";");
		}
		
		foreach($loot['dialogIds'] as $dialogId)
			mysql_query("INSERT INTO dialogs_to_loot (loot_id, dialog_id) VALUES (".$lootId.", ".$dialogId.");");
	}
	
	function getLoot($lootId) {
		$loot_rs = mysql_query("SELECT TIME_TO_SEC(TIMEDIFF(NOW(), last_looted))/60 AS diff, spawn_period FROM loot WHERE id=".$lootId.";");
		$loot = mysql_fetch_object($loot_rs);
		if ($loot->diff < $loot->spawn_period)
			return $loot->diff - $loot->spawn_period;
		$dialog_rs = mysql_query("SELECT dialog_id FROM dialogs_to_loot WHERE loot_id=".$lootId.";");
		$dialogIds = array();
		while($dialog = mysql_fetch_object($dialog_rs))
			$dialogIds[] = $dialog->dialog_id;
		mysql_query("UPDATE loot SET last_looted = NOW() WHERE id=".$lootId.";");
		return $dialogIds[array_rand($dialogIds)];
	}
}
?>