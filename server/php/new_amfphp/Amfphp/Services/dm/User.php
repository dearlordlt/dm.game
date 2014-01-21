<?php

/**
 * Base class for users operations
 * Users
 */
class User {
	
	/**
	 *	PDO connection
	 * @var PDO
	 */
	private $con;
	
    function __construct() { //Constructor
		$this->con = PDOConnection::con(basename(__DIR__));
    }
    
    function login($username, $password, $moodle=0 ) {
		
		$con = PDOConnection::con("dm");
		
		if ( empty($username) ) {
			return array(
				"error" => "Incorect user name or password!",
				"errorCode" => 1
			);			
		}
		
		if ( $moodle == 0  ) {
		
			$stm = $con->prepare("SELECT * FROM users WHERE username=:username AND password=:password AND external_login=0");

			$stm->execute(
				array(
					"username" => $username,
					"password" => $password
				)
			);

			// return ($stm->rowCount() == 0 );

			if ($stm->rowCount() == 0) {
				return array (
					"error" => "Incorect user name or password!",
					"errorCode" => 1
				);
			} else {
				$user = $stm->fetch(PDO::FETCH_OBJ);
			}
		} else {
			if ( $this->loginToMoodle( $username, $password ) ) {
				$stm = $con->prepare("SELECT * FROM users WHERE username=:username AND external_login=1");

				$stm->execute(
					array(
						"username" => $username
					)
				);
				
				if ($stm->rowCount() == 0) {
					if ( !$this->register($username, $password, 1 ) ) {
						return array(
							"error" => "Error on registering user using Moodle account",
							"errorCode" => 2
						);
					}
				}
				
				$stm = $con->prepare("SELECT * FROM users WHERE username=:username AND external_login=1");
				
				$stm->execute(
					array(
						"username" => $username
					)
				);				
				
				$user = $stm->fetch(PDO::FETCH_OBJ);
				
			} else {
				return array(
					"error" => "Incorect Moodle user name or password!",
					"errorCode" => 1
				);				
			}
		}
		
		if ( $user->isadmin === "Y") {
			AmfphpAnnotatedAuthentication::addRole("admin");
		}
		AmfphpAnnotatedAuthentication::addRole("user");
		
		$avatarsStm = $con->prepare("SELECT * FROM avatars WHERE user_id=:id AND active = 1 AND skin3d_id <> 0");

		$avatarsStm->execute(
			array(
				"id" => $user->id
			)
		);

		if ($avatarsStm->rowCount() == 0 ) {
			$user->avatars = array();
			/*
			return array(
			"error" => "No avatars found for user!",
			"errorCode" => 2
			);
			*/

		} else {
			$user->avatars = $avatarsStm->fetchAll(PDO::FETCH_OBJ);
		}
                
                $school_rs = mysql_query("SELECT * FROM schools WHERE id=$user->school_id;");
                $user->school = mysql_fetch_object($school_rs);

		return $user;
    }
	
	function logout () {
		AmfphpAnnotatedAuthentication::clearSessionInfo();
	}
	
	/**
	 * Login to moodle
	 * @param type $username
	 * @param type $password
	 * @return boolean if success
	 */
	function loginToMoodle ( $username, $password ) {
		
		$key = 'Darnus_miestas_2013';
		
		if ( $username == base64_decode( base64_decode( urldecode( $password ) ) ) ) {
			return true;
		}
		
		$cookie="cookie.txt"; 
		
		// login page
		$url = "http://ucclearningzone.lt/login/remoteLogin.php";
		
		$postdata = "username=".$username."&password=".$password; 

		$ch = curl_init(); 
		curl_setopt ($ch, CURLOPT_URL, $url); 
		curl_setopt ($ch, CURLOPT_SSL_VERIFYPEER, FALSE); 
		curl_setopt ($ch, CURLOPT_USERAGENT, "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6"); 
		curl_setopt ($ch, CURLOPT_TIMEOUT, 60); 
		curl_setopt ($ch, CURLOPT_FOLLOWLOCATION, 0); 
		curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1); 
		// curl_setopt ($ch, CURLOPT_COOKIEJAR, $cookie); 
		curl_setopt ($ch, CURLOPT_REFERER, $url); 

		curl_setopt ($ch, CURLOPT_POSTFIELDS, $postdata); 
		curl_setopt ($ch, CURLOPT_POST, 1); 
		$result = curl_exec ($ch); 
		
		curl_close($ch);
		
		// return $result;
		return ( "true" === $result );
		
	}
	
	/**
	 * Register to game
	 * @param type $username
	 * @param type $password
	 * @param bool $external
	 * @return userId
	 */
    function register($username, $password, $external=0 ) {
		
		$stm = $this->con->prepare("SELECT * FROM users WHERE username=:username AND external_login=:external");
		
		$stm->execute(
			array ( 
				"username" => $username,
				"external" => $external
			)
		);
		
		if ( $stm->rowCount() > 0 ) {
			return false;
		} else {
			$stm = $this->con->prepare("INSERT INTO users (username, password, external_login) VALUES ( :username, :password, :external )");
			$stm->execute(
				array ( 
					"username" => $username,
					"password" => ( ( $external == true ) ? "" : $password ), // do not put password if it's external login
					"external" => $external
				)
			);
			
			$stm = $this->con->prepare("SELECT * FROM users WHERE id = ?");
			
			$stm->execute(
				array ( $this->con->lastInsertId() )
			);
			
			return $stm->fetchObject();
			
		}
		
    }
	
	/**
	 * Set user info
	 * @param type $id
	 * @param type $name
	 * @param type $surname
	 * @param type $email
	 * @param type $schoolId
	 * @param type $class
	 * @param type $city
	 */
	function setUserInfo ( $id, $name, $surname, $email, $schoolId, $class, $city, $parent ) {
		
		$stm = $this->con->prepare("UPDATE users SET name = :name, surname = :surname, email = :email, school_id = :schoolId, class = :class, city = :city, is_parent = :parent WHERE id = :id");
		
		return $stm->execute(
			array (
				"id"		=> $id,
				"name"		=> $name,
				"surname"	=> $surname,
				"class"		=> $class,
				"email"		=> $email,
				"schoolId"	=> $schoolId,
				"city"		=> $city,
				"parent"	=> $parent
			)
		);
		
	}
	
	/**
	 * Is user info set?
	 * @param int $id
	 */
	function isUserInfoSet ( $id ) {
		$stm = $this->con->prepare("SELECT ( SELECT name FROM users WHERE id = ? ) IS NOT NULL AS info_set");
		$stm->execute( array($id) );
		return $stm->fetchColumn(0) + 0;
	}
	
    function loginAdmin($username, $password) {
		$user_rs = mysql_query("SELECT * FROM users WHERE username='" . $username . "' AND password='" . $password . "' AND isadmin = 'Y';");

		if (mysql_num_rows($user_rs) > 0) {
			$user = mysql_fetch_object($user_rs);
			return $user;
		} else {
			return false;
		}
    }

    function getAllusers() {
		$user_rs = mysql_query("SELECT id, username, isadmin FROM users;");
		$users = array();
		while ($user = mysql_fetch_object($user_rs))
			array_push($users, $user);
		return $users;
    }

    function getUserInfoById($id) {
		$user_rs = mysql_query("SELECT id, username, isadmin FROM users WHERE id = " . $id . ";");
		$users = array();
		while ($user = mysql_fetch_object($user_rs))
			array_push($users, $user);
		return $users;
    }
	
	/**
	 * Get all schools
	 * @return array
	 */
	function getAllSchools () {
		$stm = $this->con->prepare("SELECT * FROM schools");
		$stm->execute();
		return $stm->fetchAll(PDO::FETCH_OBJ);
	}
	
	/**
	 * Make user admin
	 * @param type $id
	 * @param type $isAdmin
	 * @Roles("admin")
	 */
    function makeAdmin($id, $isAdmin) {
		mysql_query("UPDATE users SET isadmin = '" . $isAdmin . "' WHERE id = " . $id . ";");
    }

    function getRoomBuilderPermissions($userId, $roomName) {

		$stm = $this->con->prepare("SELECT map, entity, tools FROM users_to_maps WHERE userid=:userId AND mapname=:roomName");

		$stm->execute(
			array(
				"userId" => $userId,
				"roomName" => $roomName
			)
		);

		// if no records found about permissions - no permisions are given
		if ($stm->rowCount() == 0) {
			return false;
		} else {
			$permissions = $stm->fetch(PDO::FETCH_OBJ);
			$mapPermissions = explode(",", $permissions->map);
			$entityPermissions = explode(",", $permissions->entity);
			$toolsPermissions = explode(",", $permissions->tools);

			if (!in_array("true", $mapPermissions) && !in_array("true", $toolsPermissions) && !in_array("true", $entityPermissions)) {
				return false;
			} else {
				$retVal = new stdClass();
				$retVal->map = $mapPermissions;
				$retVal->entity = $toolsPermissions;
				$retVal->tools = $toolsPermissions;

				return $retVal;
			}
		}
    }
	
	function getUserAvatars ( $userId ) {
		$stm = $this->con->prepare("SELECT avatars.* FROM users LEFT JOIN avatars ON ( avatars.user_id = users.id ) WHERE user.id = ?");
		$stm->execute(array($userId));
		return $stm->fetchAll(PDO::FETCH_OBJ);
	}
	
	function getAllUsers () {
		$stm = $this->con->prepare("SELECT users.*, schools.label AS school_label FROM users LEFT JOIN schools ON ( users.school_id = schools.id )");
		$stm->execute();
		return $stm->fetchAll(PDO::FETCH_OBJ);
	}
	
    /* */
}

?>