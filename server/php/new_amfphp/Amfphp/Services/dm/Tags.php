<?php

/**
 * Tags
 *
 * @author $Id$
 */
class Tags {
	
	/**
	 *	PDO connection
	 * @var PDO
	 */
	private $con;
	
	/**
	 * Constructor
	 */
	function Tags() {
		$this->con = PDOConnection::con(basename(__DIR__));
	}
	
	/**
	 * Create tag
	 * @param string $tagName
	 * @return true on successful insert
	 */
	function createTag ( $varName, $comment, $makeDefault, $defaultValue ) {
		
		try {
			
			$this->con->beginTransaction();
			
			$stm = $this->con->prepare("INSERT INTO avatar_vars_labels (label, comment) VALUES ( ?, ? )");
			$stm->execute( array( $varName, $comment ) );
			
			$varId = $this->con->lastInsertId();
			
			if ( $makeDefault == true ) {
				$stm = $this->con->prepare("INSERT INTO default_vars ( var_id, default_value ) VALUES ( ?, ? )");
				$stm->execute( array( $varId, $defaultValue ) );

				$stm = $this->con->prepare("INSERT IGNORE INTO dm.avatar_vars ( avatar_id, label, value) SELECT avatars.id, ?, ? FROM avatars");

				$stm->execute( array( $varName, $defaultValue ) );
			}
			
			$this->con->commit();
			
			return true;
			
		} catch ( Exception $error ) {
			
			$this->con->rollBack();
			
			error_log($error->getMessage());
			
			return array (
				"error" => $error->getMessage()
			);
			
		}		
		

	}
	
	function updateVar ( $varId, $varName, $comment, $makeDefault, $defaultValue ) {
		
		try {
			
			$this->con->beginTransaction();
			
			if ( $makeDefault == true ) {
				$stm = $this->con->prepare("INSERT IGNORE INTO default_vars ( var_id, default_value ) VALUES ( ?, ? )");
				$stm->execute( array( $varId, $defaultValue ) );
				
				$stm = $this->con->prepare("INSERT IGNORE INTO dm.avatar_vars ( avatar_id, label, value) SELECT avatars.id, ?, ? FROM avatars");
				$stm->execute( array( $varName, $defaultValue ) );
			} else {
				$stm = $this->con->prepare("DELETE FROM default_vars WHERE var_id = ?");
				$stm->execute( array( $varId ) );
			}
			
			$stm = $this->con->prepare("UPDATE avatar_vars_labels SET comment = ?");
			$stm->execute( array ( $comment ) );
			
			$this->con->commit();
			
			return true;
			
		} catch ( Exception $error ) {
			
			$this->con->rollBack();
			
			error_log($error->getMessage());
			
			return array (
				"error" => $error->getMessage()
			);
			
		}		
		
	}	
	
	function createDefaultTagsForAvatar ( $avatarId ) {
		
		try {
			
			$this->con->beginTransaction();
			
			$stm = $this->con->prepare("INSERT IGNORE INTO dm.avatar_vars ( avatar_id, label, value) 
											SELECT ?, avatar_vars_labels.label, default_vars.default_value FROM default_vars 
											LEFT JOIN avatar_vars_labels ON ( default_vars.var_id = avatar_vars_labels.id)");
			$stm->execute( array( $avatarId ) );
			
			$this->con->commit();
			
			return true;
			
		} catch ( Exception $error ) {
			
			$this->con->rollBack();
			
			error_log($error->getMessage());
			
			return array (
				"error" => $error->getMessage()
			);
			
		}		
		
	}
	
	function deleteVar ( $varName ) {
		
		try {
			
			$this->con->beginTransaction();
			
			$stm = $this->con->prepare("DELETE FROM avatar_vars_labels WHERE label = ?");
			$stm->execute( array( $varName ) );
			$this->con->commit();
			return true;
			
		} catch ( Exception $error ) {
			
			$this->con->rollBack();
			
			error_log($error->getMessage());
			
			return array (
				"error" => $error->getMessage()
			);
			
		}
		
	}
	
	function createTagGroup ( $groupName, $comment ) {
		$stm = $this->con->prepare( "INSERT INTO avatar_vars_groups (label, comment) VALUES (:groupName, :comment)" );
		$stm->bindValue("groupName", $groupName);
		$stm->bindValue("comment", $comment);
		return $stm->execute();
	}
	
	/**
	 * Get all tags
	 */
	function getAllTags () {
		$stm = $this->con->prepare( "SELECT avatar_vars_labels.*, ( default_vars.var_id IS NOT NULL ) AS is_default, default_vars.default_value FROM avatar_vars_labels LEFT JOIN default_vars ON ( avatar_vars_labels.id = default_vars.var_id ) ORDER BY is_default DESC, avatar_vars_labels.id" );
		$stm->execute();
		return $stm->fetchAll(PDO::FETCH_OBJ);
	}
	
	function getDafaultTags () {
		$stm = $this->con->prepare( "SELECT avatar_vars_labels.*, default_vars.default_value FROM default_vars LEFT JOIN avatar_vars_labels ON ( default_vars.var_id = avatar_vars_labels.id ) ORDER BY avatar_vars_labels.label" );
		$stm->execute();
		return $stm->fetchAll(PDO::FETCH_OBJ);
	}
	
	function getTagUsageStatistics ( $varName ) {
		$stm = $this->con->prepare("
			SELECT
				( SELECT COUNT(*) FROM `condition_params` WHERE label='label' AND value=:varName ) AS conditions,
				( SELECT COUNT(*) FROM `function_params` WHERE label='label' AND value=:varName ) AS functions,
				( SELECT COUNT(*) FROM `avatar_vars` WHERE label=:varName ) AS avatar_vars
		");
		
		$stm->execute( array ( "varName" => $varName ) );
		
		return $stm->fetchObject();
		
	}
	
	/**
	 * Get all groups
	 */
	function getAllGroups () {
		$stm = $this->con->prepare( "SELECT * FROM avatar_vars_groups" );
		$stm->execute();
		return $stm->fetchAll(PDO::FETCH_OBJ);
	}
	
	/**
	 * Add var to group
	 * @param type $varId
	 * @param type $groupId
	 */
	function addVarToGroup ( $varId, $groupId ) {
		$stm = $this->con->prepare( "INSERT IGNORE INTO avatar_vars_labels_to_groups (label_id, group_id) VALUES(:varId, :groupId)" );
		return $stm->execute(
			array (
				"varId" => $varId,
				"groupId" => $groupId
			)
		);
	}
	
	/**
	 * Remove var from group
	 * @param type $varId
	 * @param type $groupId
	 * @return type
	 */
	function removeVarFromGroup ( $varId, $groupId ) {
		$stm = $this->con->prepare( "DELETE FROM avatar_vars_labels_to_groups WHERE label_id = :varId AND group_id = :groupId" );
		return $stm->execute(
			array (
				"varId" => $varId,
				"groupId" => $groupId
			)
		);
	}
	
	/**
	 * Get all tags by group id
	 * @param type $groupId
	 * @return type
	 */
	function getAllTagsByGroupId ( $groupId ) {
		$stm = $this->con->prepare( "
									SELECT avatar_vars_labels.*, ( default_vars.var_id IS NOT NULL ) AS is_default, default_vars.default_value
										FROM avatar_vars_labels 
									LEFT JOIN avatar_vars_labels_to_groups 
										ON ( avatar_vars_labels.id = avatar_vars_labels_to_groups.label_id )
									LEFT JOIN default_vars 
										ON ( avatar_vars_labels.id = default_vars.var_id )
									WHERE avatar_vars_labels_to_groups.group_id = :groupId
									" );
		$stm->execute( array ( "groupId" => $groupId ));
		return $stm->fetchAll(PDO::FETCH_OBJ);		
	}
	
	/**
	 * Get avatar tags by group id
	 * @param type $groupId
	 * @return type
	 */
	function getAvatarTagsByGroupLabel ( $avatarId, $groupLabel ) {
		$stm = $this->con->prepare( "
									SELECT avatar_vars.* 
									FROM avatar_vars 
									LEFT JOIN avatar_vars_labels
										ON ( avatar_vars.label = avatar_vars_labels.label )
									LEFT JOIN avatar_vars_labels_to_groups 
										ON ( avatar_vars_labels.id = avatar_vars_labels_to_groups.label_id )
									LEFT JOIN avatar_vars_groups 
										ON ( avatar_vars_labels_to_groups.group_id = avatar_vars_groups.id )
									WHERE 
										avatar_vars_groups.label = :groupLabel 
										AND avatar_vars.avatar_id = :avatarId
									" );
		$stm->execute( 
				array ( 
					"avatarId" => $avatarId,
					"groupLabel" => $groupLabel
				)
		);
		return $stm->fetchAll(PDO::FETCH_OBJ);		
	}
	
	/**
	 * Get avatar tags by group id
	 * @param type $groupId
	 * @return type
	 */
	function getAvatarTagsByGroupId ( $avatarId, $groupId ) {
		$stm = $this->con->prepare( "
									SELECT avatar_vars.* 
									FROM avatar_vars 
									LEFT JOIN avatar_vars_labels
										ON ( avatar_vars.label = avatar_vars_labels.label )
									LEFT JOIN avatar_vars_labels_to_groups 
										ON ( avatar_vars_labels.id = avatar_vars_labels_to_groups.label_id )
									LEFT JOIN avatar_vars_groups 
										ON ( avatar_vars_labels_to_groups.group_id = avatar_vars_groups.id )
									WHERE 
										avatar_vars_groups.id = :groupId 
										AND avatar_vars.avatar_id = :avatarId
									" );
		$stm->execute( 
				array ( 
					"avatarId" => $avatarId,
					"groupId" => $groupId
				)
		);
		return $stm->fetchAll(PDO::FETCH_OBJ);		
	}
	
	/**
	 * Get all tags by group label
	 * @param type $groupId
	 * @return type
	 */
	function getAllTagsByGroupLabel ( $groupLabel ) {
		$stm = $this->con->prepare( "
									SELECT avatar_vars_labels.*, ( default_vars.var_id IS NOT NULL ) AS is_default, default_vars.default_value 
										FROM avatar_vars_labels 
									LEFT JOIN avatar_vars_labels_to_groups 
										ON ( avatar_vars_labels.id = avatar_vars_labels_to_groups.label_id )
									LEFT JOIN avatar_vars_groups 
										ON ( avatar_vars_groups.id = avatar_vars_labels_to_groups.group_id )
									LEFT JOIN default_vars 
										ON ( avatar_vars_labels.id = default_vars.var_id )									
									WHERE avatar_vars_groups.label = :groupLabel
									" );
		$stm->execute( array ( "groupLabel" => $groupLabel ));
		return $stm->fetchAll(PDO::FETCH_OBJ);		
	}
	
	function getAvatarsByVarValue ( $var, $operator, $value ) {
		
		$OPS = array(
			0 => "=", // value
			1 => "<",
			2 => ">",
			3 => ">=",
			4 => "<=",
			5 => "!=",
			6 => "=", // label
			7 => "!=", // label
		);
		
		if ( isset($var) ) {
			
			if ( $operator < 6 ) {
				if ( !isset($OPS[$operator]) ) {
					throw new Exception("Illegal comparison operator provided!");
				}
				$stm = $this->con->prepare("SELECT 
												avatars.id AS id, 
												avatars.name AS avatar_name, 
												users.username AS user_name,
												schools.title AS school
												FROM avatars
												LEFT JOIN avatar_vars ON ( avatar_vars.avatar_id = avatars.id )
												LEFT JOIN users ON ( users.id = avatars.user_id )
												LEFT JOIN schools ON ( schools.id = users.school_id )
												WHERE avatar_vars.label = :label AND avatar_vars.value ".$OPS[$operator]." :value
												GROUP BY avatar_name
											");
				$stm->bindParam("label", $var);
				$stm->bindParam("value", $value);

			} else {

				if ( $operator > 7 ) {
					throw new Exception("Illegal operator provided!");
				}
				
				if ( $operator == 6 ) {
					$stm = $this->con->prepare("SELECT 
													avatars.id AS id, 
													avatars.name AS avatar_name, 
													users.username AS user_name,
													schools.title AS school
													FROM avatars
													LEFT JOIN avatar_vars ON ( avatar_vars.avatar_id = avatars.id )
													LEFT JOIN users ON ( users.id = avatars.user_id )
													LEFT JOIN schools ON ( schools.id = users.school_id )
													WHERE avatar_vars.label ".$OPS[$operator]." :label 
													GROUP BY avatar_name
												");	
				} else {
					$stm = $this->con->prepare("SELECT 
													avatars.id AS id, 
													avatars.name AS avatar_name, 
													users.username AS user_name,
													schools.title AS school
													FROM avatars
													LEFT JOIN avatar_vars ON ( avatar_vars.avatar_id = avatars.id )
													LEFT JOIN users ON ( users.id = avatars.user_id )
													LEFT JOIN schools ON ( schools.id = users.school_id )
													WHERE :label NOT IN ( 
														SELECT avatar_vars.label FROM avatar_vars WHERE avatar_vars.avatar_id = avatars.id
													)
													GROUP BY avatar_name
												");	
				}
				$stm->bindParam("label", $var);
			}
		} else {
			$stm = $this->con->prepare("SELECT 
											avatars.id AS id, 
											avatars.name AS avatar_name, 
											users.username AS user_name,
											schools.title AS school
											FROM avatars
											LEFT JOIN users ON ( users.id = avatars.user_id )
											LEFT JOIN schools ON ( schools.id = users.school_id )
										");	
		}

		$stm->execute();
		
		return $stm->fetchAll(PDO::FETCH_OBJ);
		
	}
	
	function getReferencedVarValue ( $avatarId, $pointer ) {
		
		$stm = $this->con->prepare("
			SELECT value 
			FROM avatar_vars 
			WHERE 
				avatar_id = :avatarId
				AND label = ( 
								SELECT value 
								FROM avatar_vars 
								WHERE 
									avatar_id = :avatarId
									AND label = :pointer
							)
		");
		
		$stm->execute(
			array (
				"avatarId" => $avatarId,
				"pointer" => $pointer
			)
		);
		
		if ( $stm->rowCount() > 0 ) {
			return $stm->fetchObject();
		} else {
			return null;
		}
		
	}
	
	function getAvatarVars ( $avatarId ) {
		$stm = $this->con->prepare("SELECT * FROM avatar_vars WHERE avatar_id = :id");
		$stm->bindParam("id", $avatarId);
		$stm->execute();
		return $stm->fetchAll(PDO::FETCH_OBJ);
	}
	
	/**
	 * Set tag to avatars
	 * @param array $avatars
	 * @param type $tag
	 * @param type $value
	 */
	function setTagsToAvatars ( $avatars, $tag, $value ) {
		
		$tag = self::escape_mysql_string($tag);
		$value = self::escape_mysql_string($value);
		
		if ( isset($avatars) && count($avatars) > 0 ) {
			$qMarks = str_repeat("(?, '$tag', '$value'), ", count($avatars) - 1) . "(?, '$tag', '$value')";
			$stm = $this->con->prepare("INSERT INTO avatar_vars (avatar_id, label, value) VALUES $qMarks ON DUPLICATE KEY UPDATE value=VALUES(value)");
			$stm->execute($avatars);
		}
		
		
	}
	
	function deleteAvatarsVar ( $avatars, $tag ) {
		
		if ( isset($avatars) && count($avatars) > 0 ) {
			$qMarks = str_repeat("?, ", count($avatars) -1 ) . "?";
			$stm = $this->con->prepare("DELETE FROM avatar_vars WHERE avatar_id IN( $qMarks ) AND label=?");
			array_push($avatars, $tag);
			$stm->execute($avatars);
		}		
		
	}
	
	/**
	 * Escape mysql string without mysql_escape_real_string
	 * @param type $aQuery
	 * @return type
	 */
	private static function escape_mysql_string($aQuery) { 
		return strtr($aQuery, array( "\x00" => '\x00', "\n" => '\n', "\r" => '\r', '\\' => '\\\\', "'" => "\'", '"' => '\"', "\x1a" => '\x1a' )); 
	} 
	
	/**
	 * Avatar var is equal or greater than other given vars condition
	 * @param int $avatarId
	 * @param string $varName
	 * @param string $otherVars		comma separated var names
	 * @return boolean
	 */
	public function avatarVarIsEqualOrGreaterThenOthersVars ( $avatarId, $varName, $otherVars ) {
		
		$stm = $this->con->prepare("SELECT 
										( 
											( SELECT value*1 FROM avatar_vars WHERE label = :varName AND avatar_id = :avatarId ) 
											>= 
											( SELECT MAX(value*1) FROM avatar_vars WHERE FIND_IN_SET ( label, :otherVars ) AND avatar_id = :avatarId )
										)");
		
		$stm->execute(
			array (
				"varName"	=> $varName,
				"avatarId"	=> $avatarId,
				"otherVars"	=> $otherVars
			)
		);
		
		return intval($stm->fetchColumn(0));
	}
	
}

?>
