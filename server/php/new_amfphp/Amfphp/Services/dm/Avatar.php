<?php

/**
 * Base class for users operations
 * Users
 */
class Avatar {

    /**
     * PDO connection
     * @var PDO
     */
    private $con;

    function __construct() { //Constructor
        $this->con = PDOConnection::con(basename(__DIR__));
        include_once 'Skin3D.php';
		include_once 'Tags.php';
    }

    function saveAvatar($userId, $name, $skin, $characterType, $roleId = 1) {
        $avatar_rs = mysql_query("SELECT * FROM avatars WHERE name='".$name."';");
        if (mysql_num_rows($avatar_rs) > 0) {
            $response = new stdClass;
            $response->type = "error";
            $response->message = "Name ".$name." is already taken.";
            return $response;
        }

        $skin3d = new Skin3D();
        $skinId = $skin3d->saveSkin($skin)->id;

        /*
         * This is for avatars, created through DB. Their's skin3d_id = 0;
         */
        $avatar_rs = mysql_query("SELECT * FROM avatars WHERE user_id=".$userId." AND skin3d_id=0 LIMIT 1;");

        if (mysql_num_rows($avatar_rs) > 0) {
            $avatar = mysql_fetch_object($avatar_rs);
            if ($avatar->skin3d_id == 0) {
                mysql_query("UPDATE avatars SET name='".$name."', skin3d_id=".$skinId.", character_type=".$characterType.", role_id=".$roleId.", active=1 WHERE id=".$avatar->id.";");
                $avatarId = $avatar->id;
            }
        } else {
            //mysql_query("UPDATE avatars SET active=0 WHERE user_id=".$userId.";");
            mysql_query("INSERT INTO avatars (user_id, name, skin3d_id, character_type, role_id, active) VALUES (".$userId.", '".$name."', ".$skinId.", ".$characterType.", ".$roleId.", 1);");
            $avatarId = mysql_insert_id();
        }

        // mysql_query("INSERT INTO avatar_last_location (avatar_id, room_id, x, y, z) VALUES (".$avatarId.", 146, 0, 0, 0);");
		
		$spawnpointStm = $this->con->prepare("SELECT rooms.id, map_avatar_spawnpoints.x, map_avatar_spawnpoints.y, map_avatar_spawnpoints.z 
											FROM users 
											LEFT JOIN schools ON ( schools.id = users.school_id )
											LEFT JOIN rooms ON ( rooms.id = schools.room_id )
											LEFT JOIN map_avatar_spawnpoints ON ( rooms.map_id = map_avatar_spawnpoints.map_id )
											WHERE users.id = ?
											");
		
		$spawnpointStm->execute( array( $userId ) );
		
		$location = $spawnpointStm->fetchObject();
		
		$stm = $this->con->prepare("INSERT IGNORE INTO avatar_last_location (avatar_id, room_id, x, y, z) 
									VALUES (:avatarId, :roomId, :x, :y, :z )");
		
		$stm->execute(
			array (
				"avatarId" => $avatarId,
				"roomId" => $location->id,
				"x" => $location->x,
				"y" => $location->y,
				"z" => $location->z
			)
		);
		
		// $stm = $this->con->prepare($statement);
		
		// insert default vars to avatar
		$tagsService = new Tags();
		$tagsService->createDefaultTagsForAvatar($avatarId);
		
        // mysql_query("INSERT INTO avatar_vars (avatar_id, label, value) VALUES (".$avatarId.", 'money', '0');");

        $avatar_rs = mysql_query("SELECT * FROM avatars WHERE id=".$avatarId.";");
        return mysql_fetch_object($avatar_rs);
    }
	
	function getLastAvatarRoomLabel ( $avatarId ) {
		
		$stm = $this->con->prepare("SELECT rooms.label 
									FROM rooms 
									LEFT JOIN avatar_last_location ON ( rooms.id = avatar_last_location.room_id )
									WHERE avatar_last_location.avatar_id = ?");
		
		$stm->execute(array($avatarId));
		
		return $stm->fetchColumn(0);
		
	}
	
	function getAvatarHomeTown ( $avatarId ) {
		
		$stm = $this->con->prepare("SELECT rooms.label
									FROM avatars
									LEFT JOIN users ON ( avatars.user_id = users.id )
									LEFT JOIN schools ON ( users.school_id = schools.id )
									LEFT JOIN rooms ON ( rooms.id = schools.room_id )
									WHERE avatars.id = ?
									");
		
		$stm->execute( array( $avatarId ) );
		
		return $stm->fetchColumn(0);
		
	}

	function getAvatarLastLocation($avatarId) {
        $location_rs = mysql_query("SELECT * FROM avatar_last_location WHERE avatar_id=".$avatarId.";");
        return mysql_fetch_object($location_rs);
    }

    function updateAvatarSkin($avatarId, $partToReplaceName, $partToReplaceWithNum, $textureSetNum) {
        $charType = mysql_fetch_object(mysql_query("SELECT label FROM character_types WHERE id IN (SELECT subtype FROM skin3d WHERE id IN (SELECT skin3d_id FROM avatars WHERE id=$avatarId));"))->label;
        $partToReplaceWithId = mysql_fetch_object(mysql_query("SELECT id FROM skin3d_elements WHERE label='".$charType.'_'.$partToReplaceName.'_'.$partToReplaceWithNum."';"))->id;  
        mysql_query("UPDATE skin3d_elements_to_skins SET element_id=$partToReplaceWithId WHERE skin3d_id IN (SELECT skin3d_id FROM avatars WHERE id=$avatarId) AND element_id IN (SELECT id FROM skin3d_elements WHERE label LIKE '%$partToReplaceName%');");
        $elementToSkinId = mysql_fetch_object(mysql_query("SELECT id0 FROM skin3d_elements_to_skins WHERE skin3d_id IN (SELECT skin3d_id FROM avatars WHERE id=$avatarId) AND element_id IN (SELECT id FROM skin3d_elements WHERE label LIKE '%$partToReplaceName%');"))->id0;
        mysql_query("DELETE FROM skin3d_textures_to_elements WHERE elements_to_skins_id=$elementToSkinId;");
        $texture_rs = mysql_query("SELECT id FROM skin3d_textures WHERE label LIKE '".$charType.'_'.$partToReplaceName.'_'.$partToReplaceWithNum.'_'.$textureSetNum."%';");
        while($texture = mysql_fetch_object($texture_rs))
            mysql_query("INSERT INTO skin3d_textures_to_elements (elements_to_skins_id, texture_id, part_name) VALUES ($elementToSkinId, $texture->id, '".$charType.'_'.$partToReplaceName.'_'.$partToReplaceWithNum."');");
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
            $value += (int) $var->value;
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
    function getVar($avatarId, $label) {

        $con = $this->con;

        $stm = $con->prepare("SELECT value FROM avatar_vars WHERE avatar_id=:avatarId AND label=:label");

        $stm->execute(
                array(
                    "avatarId" => $avatarId,
                    "label" => $label
                )
        );

        return $stm->fetchObject();
    }
	
	function addToVar ( $avatarId, $label, $ammount ) {
		$value = $this->getVar($avatarId, $label);
		
		if ( !empty($value) && is_numeric($value) && is_numeric($ammount) ) {
			$ammount = floatval($value) + floatval($ammount);
			
			$stm = $this->con->prepare("UPDATE avatar_vars SET value=:value WHERE avatar_id=:avatarId AND label=:label");
			
			return $stm->execute(
					array(
						"value" => $ammount,
						"avatarId" => $avatarId,
						"label" => $label
					)
			);
			
			
		} else {
			return false;
		}
		
	}
	
    /**
     * Get stats
     * @param type $avatarId
     * @return type
     */
    function getStats($avatarId) {

        $con = $this->con;

        $selectStm = $con->prepare("SELECT label, value FROM avatar_vars WHERE avatar_id=:avatarId AND label IN ('a.muzika.progress', 'a.ekologija.progress', 'a.daile.progress', 'a.patycios.progress', 'a.tachnologijos.progress')");

        $selectStm->execute(
                array(
                    "avatarId" => $avatarId
                )
        );

        if ($selectStm->rowCount() > 0) {
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
                    array(
                        "avatarId" => $avatarId
                    )
            );

            $selectStm->execute(
                    array(
                        "avatarId" => $avatarId
                    )
            );

            return $selectStm->fetchAll(PDO::FETCH_ASSOC);
        }
    }

    function getAvatarProfessionStats($avatarId) {

        $retVal = array();

        $stm = $this->con->prepare("
			SELECT 
				SUBSTRING( ( SELECT value 
					FROM avatar_vars 
					WHERE avatar_vars.label = CONCAT('profesija_', :num ) 
						AND avatar_vars.avatar_id = :avatarId
				), 3 ) AS profession,
					
				( SELECT value 
					FROM avatar_vars 
					WHERE avatar_vars.label = CONCAT('p_', profession )
						AND avatar_vars.avatar_id = :avatarId
				) AS profession_level,
				
				( SELECT value 
					FROM avatar_vars
					WHERE avatar_vars.label = CONCAT( 'prof.', profession, '.progress' )
						AND avatar_vars.avatar_id = :avatarId
				) AS profession_points,
				
				( SELECT value 
					FROM avatar_vars
					WHERE avatar_vars.label = CONCAT('profesija_', :num, '_sub' )
						AND avatar_vars.avatar_id = :avatarId
				) AS sub_profession
				
		");

        $stm->execute(
                array(
                    "avatarId" => $avatarId,
                    "num" => 1
                )
        );

        if ($stm->rowCount() === 1) {
            $retVal[] = $stm->fetchObject();
        }

        $stm->execute(
                array(
                    "avatarId" => $avatarId,
                    "num" => 2
                )
        );

        if ($stm->rowCount() === 1) {
            $retVal[] = $stm->fetchObject();
        }


        return $retVal;
    }

    /**
     * Get avatar description
     * @param type $avatarId
     */
    function getAvatarDescription($avatarId) {
        $stm = $this->con->prepare("SELECT description FROM avatars WHERE id = ?");
        $stm->execute(array($avatarId));
        return $stm->fetchColumn(0);
    }

    /**
     * Set avatar description
     * @param type $avatarId
     */
    function setAvatarDescription($avatarId, $description) {
        $stm = $this->con->prepare("UPDATE avatars SET description = ? WHERE id = ?");
        return $stm->execute(array($description, $avatarId));
    }

    /**
     * Get avatar picture
     */
    function getAvatarPicture($avatarId) {

        $stm = $this->con->prepare("SELECT picture FROM avatars WHERE id = ?");
        $stm->execute(array($avatarId));
        return $stm->fetchColumn(0);
    }

    /**
     * Get avatar by id
     * @param type $avatarId
     */
    public function getAvatarById($avatarId) {

        $stm = $this->con->prepare("SELECT * FROM avatars WHERE id = ?");
        $stm->execute(array($avatarId));
        return $stm->fetch(PDO::FETCH_OBJ);
    }

    /**
     * Get avatar by id
     * @param type $avatarId
     */
    public function getAvatarByName($avatarName) {

        $stm = $this->con->prepare("SELECT * FROM avatars WHERE name = ?");
        $stm->execute(array($avatarName));
        if ($stm->rowCount() > 0) {
            return $stm->fetch(PDO::FETCH_OBJ);
        } else {
            return false;
        }
    }
	
}

?>