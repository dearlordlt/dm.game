<?php
/**
 * Base class for users operations
 * Users
 */
class Avatar
{	
    function Avatar() //Constructor
	{
    	include_once 'DBConnection.php';
		include_once 'Skin3D.php';
	}
	
	function saveAvatar($userId, $name, $skin, $characterType, $roleId = 1) {
		$skin3d = new Skin3D();
		$skinId = $skin3d->saveSkin($skin)->id;
		//mysql_query("UPDATE avatars SET active=0 WHERE user_id=".$userId.";");
		mysql_query("INSERT INTO avatars (user_id, name, skin3d_id, character_type, role_id, active) VALUES (".$userId.", '".$name."', ".$skinId.", ".$characterType.", ".$roleId.", 1);");
		$avatarId = mysql_insert_id();
		mysql_query("INSERT INTO avatar_last_location (avatar_id, room_id, x, y, z) VALUES (".$avatarId.", 146, 0, 0, 0);");
		$avatar_rs = mysql_query("SELECT * FROM avatars WHERE id=".$avatarId.";");
		return mysql_fetch_object($avatar_rs);
	}
	
	function getAvatarLastLocation($avatarId) {
		$location_rs = mysql_query("SELECT * FROM avatar_last_location WHERE avatar_id=".$avatarId.";");
		return mysql_fetch_object($location_rs);
	}
	
	function updateLastLocation($avatarId, $roomId, $x, $y, $z) {
		mysql_query("UPDATE avatar_last_location SET room_id=".$roomId.", x=".$x.", y=".$y.", z=".$z." WHERE avatar_id=".$avatarId.";");
	}
	
	function deactivateAvatar($avatarId) {
		mysql_query("UPDATE avatars SET active=0 WHERE id=".$avatarId.";");
	}
	
	function hasAvatar($userId) {
		$avatar_rs = mysql_query("SELECT * FROM avatars WHERE user_id=".$userId.";");
		return (mysql_num_rows($avatar_rs) > 0);
	}
	
	function setVar($avatarId, $label, $value) {
		$var_rs = mysql_query("SELECT * FROM avatar_vars WHERE avatar_id=".$avatarId." AND label='".$label."';");
		//return "SELECT * FROM avatar_vars WHERE avatar_id=".$avatarId." AND label='".$label."';";
		if (mysql_num_rows($var_rs) > 0) {
		    mysql_query("UPDATE avatar_vars SET value='".$value."' WHERE avatar_id=".$avatarId." AND label='".$label."';");
		} else {
		    mysql_query("INSERT INTO avatar_vars (avatar_id, label, value) VALUES (".$avatarId.", '".$label."', '".$value."');");
		}
		
	}
	
	function modifyVar($avatarId, $label, $value) {
		$var_rs = mysql_query("SELECT * FROM avatar_vars WHERE avatar_id=".$avatarId." AND label='".$label."';");		
		if (mysql_num_rows($var_rs) > 0) {
			$var = mysql_fetch_object($var_rs);
			$value += (int)$var->value;
			mysql_query("UPDATE avatar_vars SET value='".$value."' WHERE avatar_id=".$avatarId." AND label='".$label."';");
		}
	}
	
	function removeVar($avatarId, $label) {
		mysql_query("DELETE FROM avatar_vars WHERE avatar_id=".$avatarId." AND label='".$label."';");
	}
	
	/**
	 * Get var
	 * @param type $avatarId
	 * @param type $label
	 */
	function getVar ($avatarId, $label) {
	    
	    $con = PDOConnection::con();
	    
	    $stm = $con->prepare("SELECT value FROM avatar_vars WHERE avatar_id=:avatarId AND label=:label");
	    
	    $stm->execute( 
		array (
		    "avatarId" => $avatarId,
		    "label" => $label
		) 
	    );
	    
	    return $stm->fetchObject();
	    
	}
	
	/**
	 * Get stats
	 * @param type $avatarId
	 * @return type
	 */
	function getStats ($avatarId) {
	    
	    $con = PDOConnection::con("dm");
	    
	    $selectStm = $con->prepare("SELECT label, value FROM avatar_vars WHERE avatar_id=:avatarId AND label IN ('a.muzika.progress', 'a.ekologija.progress', 'a.daile.progress', 'a.patycios.progress', 'a.tachnologijos.progress')");
	    
	    $selectStm->execute( 
			array (
				"avatarId" => $avatarId
			) 
	    );
	    
	    if ( $selectStm->rowCount() > 0 ) {
		return $selectStm->fetchAll(PDO::FETCH_ASSOC);
		
	    // else inser empty values
	    } else {
		$insertStm = $con->prepare("INSERT INTO avatar_vars (avatar_id, label, value) VALUES 
		    (:avatarId, 'a.muzika.progress', 0), 
		    (:avatarId, 'a.ekologija.progress', 0), 
		    (:avatarId, 'a.daile.progress', 0), 
		    (:avatarId, 'a.patycios.progress', 0), 
		    (:avatarId, 'a.tachnologijos.progress', 0)");
		
		$insertStm->execute( 
		    array (
			"avatarId" => $avatarId
		    ) 
		);
		
		$selectStm->execute( 
		    array (
			"avatarId" => $avatarId
		    ) 
		);
		
		return $selectStm->fetchAll(PDO::FETCH_ASSOC);
	    }
	    
	    
	    
	    
	}
	
}
?>