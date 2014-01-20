<?php
/**
 * Base class for loot operations
 * Loot
 */
class SocialCapital {	

	/**
	 *
	 * @var PDO
	 */
	private $con;
	
	function __construct() { //Constructor
		$this->con = PDOConnection::con(basename(__DIR__));
	}
	
	function logInteraction ( $avatarId, $toAvatarId, $interactionType ) {
		
		if ( !in_array($interactionType, array('message','trade','cheat')) ) {
			return array ( "error" => "Invalid interaction type provided!" );
		}
		
		$stm = $this->con->prepare("
			INSERT INTO social_capital (avatar_id, to_avatar_id, interaction_type, amount) VALUES (:avatarId, :toAvatarId, :interactionType, 1) 
				ON DUPLICATE KEY UPDATE amount=amount+1");
		
		return $stm->execute(
			array(
				"avatarId" => $avatarId,
				"toAvatarId" => $toAvatarId,
				"interactionType" => $interactionType
			)
		);
		
		
	}
	
	function getAvatarSocialCapital ( $avatarId ) {
		
		$stm = $this->con->prepare("");
		
	}
	
}
?>