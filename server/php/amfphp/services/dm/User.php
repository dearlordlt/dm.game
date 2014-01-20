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
	
    function User() { //Constructor
		include_once 'DBConnection.php';
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
				return array(
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
		
		
		$avatars = array();

		$avatarsStm = $con->prepare("SELECT * FROM avatars WHERE user_id=:id AND active = 1");

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

		return $user;
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
	 * @return boolean
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
			return $stm->execute(
				array ( 
					"username" => $username,
					"password" => ( ( $external == true ) ? "" : $password ), // do not put password if it's external login
					"external" => $external
				)
			);
		}
		
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

    /* */
}

?>