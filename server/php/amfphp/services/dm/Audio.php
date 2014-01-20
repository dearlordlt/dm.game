<?php
/**
 * Base class for users operations
 * Users
 */
class Audio
{	
    function Audio() //Constructor
	{
    	include_once 'DBConnection.php';
	}
	
	function updateAudio($audioId, $newLabel, $newDistance, $userId) {
		mysql_query("UPDATE audio SET label='".$newLabel."', distance=".$newDistance.", last_modified=NOW(), last_modified_by=".$userId." WHERE id=".$audioId.";");
	}
	
	function getAllAudios() {
		$audio_rs = mysql_query("SELECT * FROM audio;");
		$audios = array();
		while($audio = mysql_fetch_object($audio_rs))
			array_push($audios, $audio);
		return $audios;
	}
	
	function getUserItems($userId) {
		$admin_rs = mysql_query("SELECT * FROM users WHERE id=".$userId." AND isadmin='Y';");
		if (mysql_num_rows($admin_rs) > 0)
			return $this->getAllAudios();
	
		$audio_rs = mysql_query("SELECT * FROM audio WHERE id IN (SELECT object_id FROM object_permissions WHERE object_type='audio' AND moderator_id=".$userId.");");
		$audios = array();
		while($audio = mysql_fetch_object($audio_rs))
			array_push($audios, $audio);
		return $audios;
	}


}
?>