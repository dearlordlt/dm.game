<?php
/**
 * Base class for users operations
 * Users
 */
class Audio
{	
    /**
	 * @var PDO
	 */
	private $con;
	
	function __construct() //Constructor
	{
    	$this->con = PDOConnection::con( basename(__DIR__) ); 
	}
	
	function updateAudio($audioId, $newLabel, $newDistance, $userId) {
		$stm = $this->con->prepare("UPDATE audio SET label=:newLabel, distance=:newDistance, last_modified=NOW(), last_modified_by=:userId WHERE id=:audioId");
		return $stm->execute(
			array(
				"audioId" => $audioId, 
				"newLabel" => $newLabel, 
				"newDistance" => $newDistance, 
				"userId" => $userId
			)
		);
		
	}
        
        function getAudioById($audioId) {
            $audio_rs = mysql_query("SELECT * FROM audio WHERE id=".$audioId.";");
            return mysql_fetch_object($audio_rs);
        }
	
	function getAllAudios() {
		$audio_rs = mysql_query("SELECT * FROM audio;");
		$audios = array();
		while($audio = mysql_fetch_object($audio_rs))
			array_push($audios, $audio);
		return $audios;
	}
	
	function getUserAudios($userId) {
		$admin_rs = mysql_query("SELECT * FROM users WHERE id=".mysql_real_escape_string($userId)." AND isadmin='Y';");
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