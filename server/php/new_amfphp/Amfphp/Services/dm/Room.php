<?php

/**
 * Base class for users operations
 * Users
 */
class Room {
	
	/**
	 *PDO connection
	 * @var PDO
	 */
	private $con;
	
    function __construct() { //Constructor
		$this->con = PDOConnection::con(basename(__DIR__));
        include_once 'EnvironmentStateEditor.php';
    }

    function getRoomByLabel($label) {     
		
        $room_rs = mysql_query("SELECT rooms.*, maps.label AS map_label FROM rooms LEFT JOIN maps ON rooms.map_id=maps.id WHERE rooms.label='$label';");
        
        
        
        if (mysql_num_rows($room_rs) == 0)
            return false;

        $room = mysql_fetch_object($room_rs);        
        
        $ese = new EnvironmentStateEditor();
        $state_rs = mysql_query("SELECT * FROM environment_states WHERE id IN (SELECT state_id FROM states_to_rooms WHERE room_id=$room->id);");

        while ($state = mysql_fetch_object($state_rs))
            $room->states[] = $ese->getStateById($state->id);
        
        return $room;
    }

    function saveRoom($room, $userId) {
		
		try {
			$this->con->beginTransaction();
			
			if ( !isset($room->id) ) {
				$stm = $this->con->prepare("INSERT INTO rooms (label, map_id, state_duration, last_modified, last_modified_by) VALUES (:label, :map_id, state_duration=:state_duration, last_modified=NOW(), last_modified_by=:userId)");

				$stm->execute(
						array(
							"label" => $room->label,
							"map_id" => $room->map_id,
							"state_duration" => $room->state_duration,
							"userId" => $userId
						)
				);
				
				$room->id = $this->con->lastInsertId();
				
			} else {
				
				$stm = $this->con->prepare("UPDATE rooms SET label=:label, map_id=:map_id, state_duration=:state_duration, last_modified=NOW(), last_modified_by=:userId WHERE id=:id");
				
				$stm->execute( array(
							"label" => $room->label,
							"map_id" => $room->map_id,
							"state_duration" => $room->state_duration,
							"id" => $room->id,
							"userId" => $userId )
				);				
				
				$stm = $this->con->prepare("DELETE FROM states_to_rooms WHERE room_id=?");
				$stm->execute(array( $room->id ));
				
				

				
			}
			
			if ( !empty( $room->states ) ) {
				
				$query = "INSERT INTO states_to_rooms (room_id, state_id) VALUES ";

				foreach ($room->states as $state) {
					$query.= "( $room->id, $state->id ), ";
				}

				$query = substr_replace( $query, " ", -2 );
				
				$stm = $this->con->prepare($query);

				$stm->execute();

			}			
			
			$this->con->commit();
			
		} catch ( Exception $error ) {
			$this->con->rollBack();
			
			error_log($error);
			
			return array(
				"error" => $error->getMessage()
			);
		}
		
    }

    function getAllRooms() {
        $room_rs = mysql_query("SELECT rooms.*, maps.label AS map FROM rooms LEFT JOIN maps ON rooms.map_id=maps.id;");
        $rooms = array();
        while ($room = mysql_fetch_object($room_rs)) {
            $room->states = array();
            $state_rs = mysql_query("SELECT * FROM environment_states WHERE id IN (SELECT state_id FROM states_to_rooms WHERE room_id=$room->id);");
            while ($state = mysql_fetch_object($state_rs))
                $room->states[] = $state;
            $rooms[] = $room;
        }
        return $rooms;
    }

}

?>