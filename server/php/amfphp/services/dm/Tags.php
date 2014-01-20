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
	function createTag ( $tagName, $comment ) {
		$stm = $this->con->prepare( "INSERT INTO avatar_vars_labels (label, comment) VALUES (:tagName, :comment)" );
		$stm->bindValue("tagName", $tagName);
		$stm->bindValue("comment", $comment);
		return $stm->execute();
	}
	
	/**
	 * Get all tags
	 */
	function getAllTags () {
		$stm = $this->con->prepare( "SELECT * FROM avatar_vars_labels" );
		$stm->execute();
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
	
}

?>
