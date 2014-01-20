<?php

/**
 * Quest
 *
 * @author $Id$
 */
class Quest {
	
	/**
	 * PDO connection
	 * @var PDO
	 */
	private $con;
	
	/**
	 * 
	 */
	function __construct() {
		$this->con = PDOConnection::con(basename(__DIR__));
	}
	
	function getAllQuestsForAvatar ( $avatarId ) {
		
		$stm = $this->con->prepare("SELECT quests.*, rooms.label AS room_label, quests_to_avatars.completed AS completed, quests_to_avatars.id AS assigned_quest_id, COUNT( * ) AS quest_count
										FROM quests 
										LEFT JOIN quests_to_avatars ON ( quests.id = quests_to_avatars.quest_id )
										LEFT JOIN rooms ON ( rooms.id = quests.room_id )
										WHERE quests_to_avatars.avatar_id = ? 
										GROUP BY quests_to_avatars.quest_id, quests_to_avatars.completed
										ORDER BY quests_to_avatars.completed DESC, quests_to_avatars.time_added ASC");
		
		$stm->execute( array ( $avatarId ) );
		return $stm->fetchAll(PDO::FETCH_OBJ);
	
	}
	
	function getAllQuests () {
		$stm = $this->con->prepare("SELECT quests.*, users.username, rooms.label AS room_label FROM quests 
										LEFT JOIN users ON (quests.last_modified_by = users.id)
										LEFT JOIN rooms ON ( quests.room_id = rooms.id )");
		$stm->execute();
		return $stm->fetchAll(PDO::FETCH_OBJ);
	}
	
	function addQuestToAvatar ( $questId, $avatarId ) {
		
		if ( $this->hasQuest($questId, $avatarId) ) {
			return true;
		}
		
		$stm = $this->con->prepare("INSERT INTO quests_to_avatars ( quest_id, avatar_id ) VALUES ( :questId, :avatarId )");
		return $stm->execute( 
				array ( 
					"avatarId" => $avatarId,
					"questId" => $questId
				) 
		);
		
	}
	
	function completeAvatarQuest($avatarId, $questId) {
		$stm = $this->con->prepare("UPDATE quests_to_avatars SET completed=1 WHERE avatar_id=? AND quest_id=?");
		return $stm->execute( array( $avatarId, $questId ) );
    }
	
	function createQuest ( $label, $description, $mapLabel, $markerX, $markerY, $roomId, $lastModifiedBy ) {
		$stm = $this->con->prepare("INSERT INTO quests ( label, description, map_label, marker_x, marker_y, room_id, last_modified_by ) VALUES ( ?, ?, ?, ?, ?, ?, ? )");
		return $stm->execute( array( $label, $description, $mapLabel, $markerX, $markerY, $roomId, $lastModifiedBy ) );
	}
	
	function updateQuest ( $id, $label, $description, $mapLabel, $markerX, $markerY, $roomId, $lastModifiedBy ) {
		$stm = $this->con->prepare("UPDATE quests SET label = ?, description = ?, map_label = ?, marker_x = ?, marker_y = ?, room_id = ?, last_modified_by = ? WHERE id = ?");
		return $stm->execute( array( $label, $description, $mapLabel, $markerX, $markerY, $roomId, $lastModifiedBy, $id ) );
	}
	
	/// CONDITIONS
	function hasQuest ( $questId, $avatarId ) {
		
		$stm = $this->con->prepare( "SELECT COUNT(*) AS incompleted FROM quests_to_avatars WHERE avatar_id = :avatarId AND quest_id = :questId AND completed = false" );
		
		$stm->execute( 
				array( 
					"questId" => $questId,
					"avatarId" => $avatarId
				) 
		);
		
		$result = $stm->fetchObject();
		
		if ( $result->incompleted > 0 ) {
			return true;
		} else {
			return false;
		}
		
	}
	
	function hasNotQuest ( $questId, $avatarId ) {
		return !$this->hasQuest($questId, $avatarId);
	}
	
	function questCompleted ( $questId, $avatarId ) {
		
		$stm = $this->con->prepare(
									"SELECT  
										( SELECT COUNT(*) FROM quests_to_avatars WHERE avatar_id = :avatarId AND quest_id = :questId AND completed = true ) AS completed,
										( SELECT COUNT(*) FROM quests_to_avatars WHERE avatar_id = :avatarId AND quest_id = :questId AND completed = false ) AS incompleted
									"
									);
		
		$stm->execute( 
				array( 
					"questId" => $questId,
					"avatarId" => $avatarId
				) 
		);
		
		$result = $stm->fetchObject();
		
		if ( ( $result->completed > 0 ) && ( ( $result->incompleted == 0 ) ) ) {
			return true;
		} else {
			return false;
		}
		
	}
	
	function questNotCompleted ( $questId, $avatarId ) {
		return !$this->questCompleted($questId, $avatarId);
	}		
	
}

?>
