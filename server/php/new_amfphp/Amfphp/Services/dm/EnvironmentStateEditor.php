<?php

/**
 * Base class for users operations
 * Users
 */
class EnvironmentStateEditor {
	
	/**
	 * PDO conneciton
	 * @var PDO
	 */
	private $con;
	
    function __construct() { //Constructor
		$this->con = PDOConnection::con(basename(__DIR__));
    }

    function getAllStates() {
        $state_rs = mysql_query("SELECT environment_states.*, users.username AS last_modified_by_username FROM environment_states LEFT JOIN users ON ( users.id = environment_states.last_modified_by );");

        while ($state = mysql_fetch_object($state_rs)) {
            $state->skybox = mysql_fetch_object(mysql_query("SELECT * FROM skyboxes WHERE id=$state->skybox_id;"));

            $visual_rs = mysql_query("SELECT * FROM environment_visual_effects WHERE state_id=$state->id;");
			$state->visualEffects = array();
            while ($visual = mysql_fetch_object($visual_rs)) {
                $state->visualEffects[] = $visual;
			}
			
            $audio_rs = mysql_query("SELECT * FROM environment_audio_effects WHERE state_id=$state->id;");
			
			$state->audioEffects = array();
            while ($audio = mysql_fetch_object($audio_rs)) {
                $state->audioEffects[] = $audio;
			}
			
            $states[] = $state;
        }

        return $states;
    }

    function getStateById($stateId) {
        
        $state = mysql_fetch_object(mysql_query("SELECT * FROM environment_states WHERE id=$stateId;"));
        $state->skybox = mysql_fetch_object(mysql_query("SELECT * FROM skyboxes WHERE id=$state->skybox_id;"));

        $visual_rs = mysql_query("SELECT * FROM environment_visual_effects WHERE state_id=$state->id;");
        while ($visual = mysql_fetch_object($visual_rs))
            $state->visualEffects[] = $visual;

        $audio_rs = mysql_query("SELECT * FROM environment_audio_effects WHERE state_id=$state->id;");
        while ($audio = mysql_fetch_object($audio_rs))
            $state->audioEffects[] = $audio;
        
        return $state;
    }

    function saveState($state, $userId) {
		
		$this->con->beginTransaction();
		
		try {
			
			if ( !isset($state->id) ) {
				$stm = $this->con->prepare("INSERT INTO environment_states (label, skybox_id, last_modified, last_modified_by) VALUES (?, ?, NOW(), ?)");
				$stm->execute( array( $state->label, $state->skybox_id, $userId ) );
				$state->id = $this->con->lastInsertId();
			} else {
				$stm = $this->con->prepare("UPDATE environment_states SET label=?, skybox_id=?, last_modified=NOW(), last_modified_by=? WHERE id=?");
				$stm->execute( array( $state->label, $state->skybox_id, $userId, $state->id ) );
				
				$stm = $this->con->prepare("DELETE FROM environment_audio_effects WHERE state_id=?");
				$stm->execute(array($state->id));
				
				$stm = $this->con->prepare("DELETE FROM environment_visual_effects WHERE state_id=?");
				$stm->execute(array($state->id));
				
			}
			
			$query = "INSERT INTO environment_audio_effects (state_id, audio_path, volume) VALUES ";

			foreach ($state->audioEffects as $audio) {
				$query.= "( $state->id, '$audio->audio_path', $audio->volume ), ";
			}

			$query = substr_replace( $query, " ", -2 );			
			
			$stm = $this->con->prepare($query);
			$stm->execute();
			
			$query = "INSERT INTO environment_visual_effects (state_id, texture_path, intensity, fall_speed) VALUES ";

			foreach ($state->visualEffects as $visual) {
				$query.= "( $state->id, '$visual->texture_path', $visual->intensity, $visual->fall_speed ), ";
			}

			$query = substr_replace( $query, " ", -2 );			
			
			$stm = $this->con->prepare($query);
			$stm->execute();
			
			
			$this->con->commit();
			
		} catch ( Exception $error ) {
			$this->con->rollBack();
			
			error_log($error->getMessage()." | ".$error->getTraceAsString());
			
			return array(
				"error" => $error->getMessage(),
				"stackTrace" => $error->getTraceAsString()
			);
			
		}
		
		/*
        if ($state->id == 0) {
            mysql_query("INSERT INTO environment_states (label, skybox_id, last_modified, last_modified_by) VALUES ('$state->label', $state->skybox_id, NOW(), $userId);");
            $state->id = mysql_insert_id();
        } else {
            mysql_query("UPDATE environment_states SET label='$state->label', skybox_id=$state->skybox_id, last_modified=NOW(), last_modified_by=$userId;");
            mysql_query("DELETE FROM environment_audio_effects WHERE state_id=$state->id;");
            mysql_query("DELETE FROM environment_visual_effects WHERE state_id=$state->id;");
        }

        foreach ($state->audioEffects as $audio)
            mysql_query("INSERT INTO environment_audio_effects (state_id, audio_path, volume) VALUES ($state->id, '$audio->audio_path', $audio->volume);");

        foreach ($state->visualEffects as $visual)
            mysql_query("INSERT INTO environment_visual_effects (state_id, texture_path, intensity, fall_speed) VALUES ($state->id, '$visual->texture_path', $visual->intensity, $visual->fall_speed);");
		 
		*/
    }

    function getAllParticleTextures() {
        $path = 'assets/textures/particle/';
        $files = scandir('/var/www/html/dm/'.$path);

        foreach ($files as $filename) {
            if ($filename == '.' || $filename == '..')
                continue;
            $texture = new stdClass();
            $texture->label = $filename;
            $texture->texture_path = $path.$filename;
            $textures[] = $texture;
        }
        return $textures;
    }

    function getAllAudios() {
        $path = 'assets/audio/';
        $files = scandir('/var/www/html/dm/'.$path);

        foreach ($files as $filename) {
            if ($filename == '.' || $filename == '..')
                continue;
            $audio = new stdClass();
            $audio->label = $filename;
            $audio->audio_path = $path.$filename;
            $audios[] = $audio;
        }
        return $audios;
    }

    function saveRoom($id, $label, $mapId) {
        if ($id == 0)
            mysql_query("INSERT INTO rooms (label, map_id) VALUES ('$label', $mapId);");
        else
            mysql_query("UPDATE rooms SET label='$label', map_id=$mapId WHERE id=$id;");
    }

    function getAllRooms() {
        $result = mysql_query("SELECT * FROM rooms ORDER BY id;");
        $rooms = array();
        while ($room = mysql_fetch_object($result)) {
            array_push($rooms, $room);
        }
        return $rooms;
    }

}

?>