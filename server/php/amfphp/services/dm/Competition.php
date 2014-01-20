<?php

/**
 * Competition
 *
 * @author $Id$
 */
class Competition {

    function Competition() {
	
    }
    
    function getBullyingCompetitionTopChart () {
	
	$con = PDOConnection::con("dm");
	
	$stm = $con->prepare("SELECT avatar_vars.value * 1 AS progress, avatar_vars.avatar_id, avatars.name AS name FROM avatar_vars 
				LEFT JOIN (avatars) ON (avatars.id=avatar_vars.avatar_id) 
				LEFT JOIN (users) ON (avatars.user_id=users.id)
				WHERE avatar_vars.label='a.patycios.progress' AND users.isadmin='N' ORDER BY progress DESC LIMIT 0,20");
	
	$stm->execute();
	
	return $stm->fetchAll(PDO::FETCH_OBJ);
	
	
    }
    
}

?>
