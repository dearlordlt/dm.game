<?php

/**
 * Media
 *
 * @author $Id$
 */
class Media {
	
	/**
	 *	PDO connection
	 * @var PDO 
	 */
	private $con;
	
	
	function __construct() {
		$this->con = PDOConnection::con(basename(__DIR__) );
	}

	
	function getAllMedia () {
		$stm = $this->con->prepare(
				"SELECT media.*, users.username AS username, media_categories.label AS category_label FROM media 
				LEFT JOIN users ON ( users.id = media.last_modified_by )
				LEFT JOIN media_categories ON ( media.category_id = media_categories.id )
				GROUP BY last_modified"
		);
		$stm->execute();
		return $stm->fetchAll(PDO::FETCH_OBJ);
	}
	
	function getMediaById ( $id ) {
		$stm = $this->con->prepare(
				"SELECT media.*, users.username AS username 
				FROM media
				LEFT JOIN users ON ( users.id = media.last_modified_by )
				WHERE media.id = ?"
		);
		$stm->execute( array($id) );
		return $stm->fetch(PDO::FETCH_OBJ);
	}
	
	function getAllMediaCategories () {
		
		$stm = $this->con->prepare("SELECT * FROM media_categories");
		$stm->execute();
		return $stm->fetchAll(PDO::FETCH_OBJ);
		
	}
	
	function createNewCategory ( $label ) {
		$stm = $this->con->prepare("INSERT INTO media_categories (label) VALUES (?)");
		return $stm->execute( array( $label ) );
	}
	
}

?>
