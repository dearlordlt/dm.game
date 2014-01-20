<?php

/**
 * Gallery
 *
 * @author $Id$
 */
class Gallery {

	/**
	 *
	 * @var PDO
	 */
	private $con;
	
	const UPLOAD_FOLDER = "http://vds000004.hosto.lt/dm_gallery_uploads/image/";


	function __construct() { //Constructor
		$this->con = PDOConnection::con(basename(__DIR__));
	}
	
	function getAvatarImages ( $avatarId ) {
		
		$stm = $this->con->prepare(
									"SELECT	id, avatar_id, label, CONCAT( '". self::UPLOAD_FOLDER. "', source ) as source, description, date_added
											FROM gallery_images
											WHERE gallery_images.avatar_id = ? ORDER BY date_added DESC"
		);
		
		$stm->execute( array($avatarId));
		return $stm->fetchAll(PDO::FETCH_OBJ);
		
	}
	
	function getImageRating ( $imageId, $ratersId ) {
		
		$stm = $this->con->prepare(
									"SELECT	( SELECT COUNT(*) FROM gallery_images_rating WHERE image_id = :imageId AND rating = 'Y' ) AS positive,
											( SELECT COUNT(*) FROM gallery_images_rating WHERE image_id = :imageId AND rating = 'N' ) AS negative"
		);
		
		$stm->execute( 
				array(
					"imageId"	=> $imageId
				)
		);
		
		$retVal = $stm->fetchObject();
		$retVal->own = $this->getAvatarVoteForImage($imageId, $ratersId);
		return $retVal;		
		
		
		return $stm->fetchAll(PDO::FETCH_OBJ);
		
	}
	
	function getAvatarVoteForImage ( $imageId, $ratersId ) {
		$stm = $this->con->prepare("SELECT rating FROM gallery_images_rating WHERE image_id = :imageId AND avatar_id = :ratersId");
		
		$stm->execute(
			array (
				"imageId" => $imageId,
				"ratersId" => $ratersId
			)				
		);
		
		if ( $stm->rowCount() > 0 ) {
			return $stm->fetchColumn();
		} else {
			return false;
		}
		
		
	}	
	
	/**
	 * Get dialog rating
	 * @param type $dialogId
	 * @return object with int attributes int 'positive', int 'negative' and string 'own'
	 */
	function getDialogRating ( $dialogId, $avatarId ) {
		$stm = $this->con->prepare("
			SELECT 
				( SELECT COUNT(*) FROM dialog_ratings WHERE dialog_id = :dialogId AND rating = 'Y') AS positive,
				( SELECT COUNT(*) FROM dialog_ratings WHERE dialog_id = :dialogId AND rating = 'N') AS negative
		");
		
		$stm->execute(
			array (
				"dialogId" => $dialogId
			)
		);
		
		$retVal = $stm->fetchObject();
		$retVal->own = $this->getAvatarVoteForDialog($dialogId, $avatarId);
		return $retVal;
		
	}	
	
	function rateImage ( $ratersId, $imageId, $rating ) {
		$rating = strtoupper($rating);
		if (!in_array($rating, array("Y", "N"))) {
			return false;
		}
		
		$stm = $this->con->prepare("INSERT INTO gallery_images_rating (image_id, avatar_id, rating) VALUES (:imageId, :ratersId, :rating) ON DUPLICATE KEY UPDATE rating = :rating");
		$stm->execute(
				array (
					"ratersId" => $ratersId, 
					"imageId" => $imageId, 
					"rating" => $rating
				)
		);
		
		return $this->getImageRating($imageId, $ratersId);
		
	}
	
	function removeRating ( $ratersId, $imageId ) {
		$stm = $this->con->prepare("DELETE FROM gallery_images_rating WHERE image_id = :imageId AND avatar_id = :ratersId");
		$stm->execute(
				array (
					"ratersId" => $ratersId, 
					"imageId" => $imageId
				)
		);
		
		return $this->getImageRating($imageId, $ratersId);
		
	}
	
}

?>
