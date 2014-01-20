<?php

/**
 * Scores
 *
 * @author $Id$
 */
class Scores {
	
	/**
	 *	PDO connection
	 * @var PDO
	 */
	private $con;
	
	function __construct() {
		$this->con = PDOConnection::con(basename(__DIR__));
	}
  
	public function getTopSchools () {
		
		$stm = $this->con->prepare("
			SELECT schools.id, schools.title, ROUND( AVG( avatar_vars.value *1 ) , 2 ) AS balanced_score, SUM( avatar_vars.value *1 ) AS total_score
			FROM schools
			LEFT JOIN users ON ( users.school_id = schools.id ) 
			LEFT JOIN avatars ON ( users.id = avatars.user_id ) 
			LEFT JOIN avatar_vars ON ( avatar_vars.avatar_id = avatars.id ) 
			LEFT JOIN avatar_vars_labels ON ( avatar_vars_labels.label = avatar_vars.label ) 
			LEFT JOIN avatar_vars_labels_to_groups ON ( avatar_vars_labels_to_groups.label_id = avatar_vars_labels.id ) 
			LEFT JOIN avatar_vars_groups ON ( avatar_vars_groups.id = avatar_vars_labels_to_groups.group_id ) 
			WHERE avatar_vars_groups.label = 'progress' AND schools.id != 0
			GROUP BY schools.id
			ORDER BY balanced_score DESC 
		");
		
		$stm->execute();
		
		return $stm->fetchAll(PDO::FETCH_OBJ);
		
	}
	
	public function getSchoolTopPlayers ( $schoolId ) {
		
		$stm = $this->con->prepare("
			SELECT avatars.id, avatars.name, ROUND( AVG( avatar_vars.value *1 ) , 2 ) AS balanced_score, SUM( avatar_vars.value *1 ) AS total_score
			FROM schools
			LEFT JOIN users ON ( users.school_id = schools.id ) 
			LEFT JOIN avatars ON ( users.id = avatars.user_id ) 
			LEFT JOIN avatar_vars ON ( avatar_vars.avatar_id = avatars.id ) 
			LEFT JOIN avatar_vars_labels ON ( avatar_vars_labels.label = avatar_vars.label ) 
			LEFT JOIN avatar_vars_labels_to_groups ON ( avatar_vars_labels_to_groups.label_id = avatar_vars_labels.id ) 
			LEFT JOIN avatar_vars_groups ON ( avatar_vars_groups.id = avatar_vars_labels_to_groups.group_id ) 
			WHERE avatar_vars_groups.label = 'progress' AND schools.id = ?
			GROUP BY avatars.id
			ORDER BY balanced_score DESC 
			LIMIT 0,10
		");
		
		$stm->execute( array($schoolId) );
		
		return $stm->fetchAll(PDO::FETCH_OBJ);		
		
	}
	
	public function getTopPlayers () {
		
		$stm = $this->con->prepare("
			SELECT avatars.id, avatars.name, schools.title AS school_title, ROUND( AVG( avatar_vars.value *1 ) , 2 ) AS balanced_score, SUM( avatar_vars.value *1 ) AS total_score
			FROM schools
			LEFT JOIN users ON ( users.school_id = schools.id ) 
			LEFT JOIN avatars ON ( users.id = avatars.user_id ) 
			LEFT JOIN avatar_vars ON ( avatar_vars.avatar_id = avatars.id ) 
			LEFT JOIN avatar_vars_labels ON ( avatar_vars_labels.label = avatar_vars.label ) 
			LEFT JOIN avatar_vars_labels_to_groups ON ( avatar_vars_labels_to_groups.label_id = avatar_vars_labels.id ) 
			LEFT JOIN avatar_vars_groups ON ( avatar_vars_groups.id = avatar_vars_labels_to_groups.group_id ) 
			WHERE avatar_vars_groups.label = 'progress' AND schools.id != 0
			GROUP BY avatars.id
			ORDER BY balanced_score DESC 
			LIMIT 0,10
		");
		
		$stm->execute( array($schoolId) );
		
		return $stm->fetchAll(PDO::FETCH_OBJ);		
		
	}
	
}

?>
