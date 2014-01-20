<?php

/**
 * Achievements
 *
 * @author $Id$
 */
class Achievements {
	
	/**
	 *	PDO connection
	 * @var PDO
	 */
	private $con;
	
	/**
	 * Constructor
	 */
	function __construct() {
		$this->con = PDOConnection::con(basename(__DIR__));
	}
	
	function getAvatarAchievements ( $avatarId ) {
		
		$stm = $this->con->prepare("SELECT achievements.*, avatar_vars.value AS value, 
										( CASE achievements.var_value 
											WHEN '0' 
												THEN 
													( CASE avatar_vars.value 
														WHEN NULL 
															THEN '0%' 
														ELSE 
															'100%' 
														END) 
												ELSE CONCAT( ROUND( LEAST( avatar_vars.value, achievements.var_value ) / achievements.var_value * 100 ), '%' )
												END
										) AS progress 
										FROM achievements LEFT JOIN avatar_vars ON ( avatar_vars.label = achievements.var_label AND avatar_vars.avatar_id = ? )");
		$stm->execute( array( $avatarId ) );
		return $stm->fetchAll(PDO::FETCH_OBJ);
		
	}
	
	function getAvatarAchievementsByLabel ( $avatarId, $varLabel ) {
		
		$stm = $this->con->prepare("SELECT achievements.*, avatar_vars.value AS value, 
										( CASE achievements.var_value 
											WHEN '0' 
												THEN 
													( CASE avatar_vars.value 
														WHEN NULL 
															THEN '0%' 
														ELSE 
															'100%' 
														END) 
												ELSE CONCAT( ROUND( LEAST( avatar_vars.value, achievements.var_value ) / achievements.var_value * 100 ), '%' )
												END
										) AS progress 
										FROM achievements LEFT JOIN avatar_vars ON ( avatar_vars.label = achievements.var_label ) WHERE avatar_vars.avatar_id = ?");
		$stm->execute( array( $avatarId ) );
		return $stm->fetchAll(PDO::FETCH_OBJ);		
		
	}
	
}

?>
