<?php

/**
 * ChatRooms
 *
 * @author $Id$
 */
class ChatRooms {
	
	/**
	 *
	 * @var PDO
	 */
	private $con;
	
	function __construct() {
		$this->con = PDOConnection::con(basename(__DIR__) );
	}
	
	public function addRoom ( $label, $description, $createdBy ) {
		
		$stm = $this->con->prepare("INSERT IGNORE INTO chat_rooms ( label, description, created_by, last_modifed_by, last_modified_date ) VALUES ( ?, ?, ?, ?, NOW() )");
		return $stm->execute(array( $label, $description, $createdBy, $createdBy ));
		
	}
		
	public function removeRoom ( $id ) {
		
		$stm = $this->con->prepare("DELETE FROM chat_rooms WHERE id = ?");
		return $stm->execute(array( $id ));
		
	}
	
	public function updateRoom ( $id, $label, $description, $modifiedBy ) {
		$stm = $this->con->prepare("UPDATE chat_rooms SET label = ?, description = ?, last_modifed_by = ?, last_modified_date = NOW() WHERE id = ?");
		return $stm->execute(array( $label, $description, $modifiedBy, $id ));
	}
	
	public function getAllRooms () {
		$stm = $this->con->prepare("SELECT * FROM chat_rooms");
		$stm->execute();
		return $stm->fetchAll(PDO::FETCH_OBJ);
	}
	
}

?>
