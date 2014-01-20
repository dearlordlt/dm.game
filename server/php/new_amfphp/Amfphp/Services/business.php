<?php
class business
{
	/*
	var $dbhost = '10.20.51.10';	
	var $dbname = 'verslo_zaidimas';	
	var $dbuser = 'verslo_zaidimas';
	var $dbpass = 'yfYf6pNb6zEfTSHR';
	*/
	
	var $dbhost = 'localhost';	
	var $dbname = 'dm';	
	var $dbuser = 'verslo_zaidimas';
	var $dbpass = 'yfYf6pNb6zEfTSHR';
	
	/*
	var $dbhost = '10.20.40.11';	
	var $dbname = '000110';	
	var $dbuser = '000110';
	var $dbpass = 'Iv2012';
    */
	
    /**
     * PDO connection
     * @var PDO
     */
    private $con;	
	
	function __construct() {
		
		$this->con = PDOConnection::con("dm");
		
		$conn = mysql_pconnect($this->dbhost, $this->dbuser, $this->dbpass);
		mysql_select_db ($this->dbname);

		if (!mysql_set_charset('utf8', $conn)) 
		{
    			echo "Error: Unable to set the character set.\n";
    			exit;
		}

		// echo 'Your current character set is: ' .  mysql_client_encoding($conn);
		mysql_query("SET NAMES 'utf8;'");
	}  

	function getCanvasesByOwner($ownerName)
	{
		$ownerName = mysql_real_escape_string($ownerName);

		$ownerID = $this->getUserByName($ownerName); 
		$result = mysql_query("SELECT * FROM verslas_canvases WHERE verslas_canvases.owner_id = '$ownerID';");
		$canvases = array();
		while($canvas = mysql_fetch_object($result))
			array_push($canvases, $canvas);
		return $canvases;
	}

	function getKitosIslaidos($canvasName)
	{
		$canvasName = mysql_real_escape_string($canvasName);

		$canvasID = $this->getCanvasByName($canvasName); 
		$result = mysql_query("SELECT kitosIslaidos FROM verslas_canvases WHERE ID = '$canvasID';");
        $result = mysql_fetch_row($result);
		return $result[0];
	}

	function isSudeliota($canvasName)
	{
		$canvasName = mysql_real_escape_string($canvasName);

		$canvasID = $this->getCanvasByName($canvasName); 
		$result = mysql_query("SELECT sudeliota FROM verlas_canvases WHERE ID = '$canvasID';");
        $result = mysql_fetch_row($result);
		if ($result[0] > 0)
			return true;
		else
			return false;
	}

	function isElementNameTaken($elementName, $canvasName)
	{
		$elementName = mysql_real_escape_string($elementName);
		$canvasName = mysql_real_escape_string($canvasName);

		$canvasID = $this->getCanvasByName($canvasName); 
		$result = mysql_query("SELECT * FROM verslas_canvas_elements WHERE verslas_canvas_elements.name = '$elementName' AND verslas_canvas_elements.owner_id = '$canvasID';");
        $result = mysql_fetch_row($result);
		if ($result[0] > 0)
			return true;
		else
			return false;
	}

	function getElementsByCanvas($canvasName)
	{
		$canvasName = mysql_real_escape_string($canvasName);

		$canvasID = $this->getCanvasByName($canvasName); 
		$result = mysql_query("SELECT * FROM verslas_canvas_elements WHERE owner_id = '$canvasID';");
		$elements = array();
		while($element = mysql_fetch_object($result))
			array_push($elements, $element);
		return $elements;
	}

	function getPublicCanvases()
	{
		$result = mysql_query("SELECT * FROM verslas_canvases WHERE type = 1;");
		$canvases = array();
		while($canvas = mysql_fetch_object($result))
			array_push($canvases, $canvas);
		return $canvases;
  }

	function getVisitingCanvases($userName)
	{
		$userName = mysql_real_escape_string($userName);

		$userID = $this->getUserByName($userName); 
		$result = mysql_query("SELECT verslas_canvases.name, verslas_canvases.id FROM verslas_canvases, verslas_groups_users, verslas_groups_canvases WHERE '$userID' = verslas_groups_users.user_id and verslas_groups_users.group_id = verslas_groups_canvases.group_id and verslas_canvases.id = verslas_groups_canvases.canvas_id");
		$canvases = array();
		while($canvas = mysql_fetch_object($result))
			array_push($canvases, $canvas);
		return $canvases;
	}

	function getCanvasInformation($canvasName)
	{
		$canvasName = mysql_real_escape_string($canvasName);

		$result = mysql_query("SELECT * FROM verslas_canvases WHERE name='".$canvasName."';");
        	$result = mysql_fetch_row($result);
       		return $result;
	}

	function getUsers()
	{
		$result = mysql_query("SELECT id, username AS name, username AS surname FROM users;");
		$users = array();
		while($user = mysql_fetch_object($result))
			array_push($users, $user);
		return $users;
  }

	function getGroupMembersByName($groupName)
  {
		$groupName = mysql_real_escape_string($groupName);

		$groupID = $this->getGroupByName($groupName); 
		$result = mysql_query("SELECT verslas_users.name, verslas_users.surname, verslas_users.id FROM verslas_users, verslas_groups_users WHERE verslas_groups_users.group_id = '$groupID' AND verslas_groups_users.user_id = verslas_users.id;");
	
		$users = array();
		while($user = mysql_fetch_object($result)) 
			array_push($users, $user);
		return $users;
  }


	function getGroupMembers($groupID)
	{
		$result = mysql_query("SELECT verslas_users.name, verslas_users.surname, verslas_users.id FROM verslas_users, verslas_groups_users WHERE verslas_groups_users.group_id = '$groupID' AND verslas_groups_users.user_id = verslas_users.id;");
		
		$users = array();
		while($user = mysql_fetch_object($result)) 
			array_push($users, $user);
		return $users;
  }

	function getGroups()
  {
		$result = mysql_query("SELECT * FROM verslas_groups;");
		$groups = array();
		while($group = mysql_fetch_object($result))
			array_push($groups, $group);
		return $groups;
  }

	function getLinkedGroups($canvasName)
	{
		$canvasName = mysql_real_escape_string($canvasName);

		$canvasID = $this->getCanvasByName($canvasName); 
		$result = mysql_query("SELECT verslas_groups.ID, verslas_groups.name FROM verslas_groups, verslas_groups_canvases WHERE verslas_groups_canvases.canvas_id = '$canvasID' AND verslas_groups_canvases.group_id = verslas_groups.ID;");
		$groups = array();
		while($group = mysql_fetch_object($result))
			array_push($groups, $group);
		return $groups;
	}

	function createGroup($name, $userID)
	{
		$name = mysql_real_escape_string($name);

		$userID = $this->getUserByName($userID); 
		return mysql_query("INSERT INTO verslas_groups (name, owner_id) VALUES ('$name', '$userID');");
  }

	function linkCanvasWithGroups($canvasName, $group_idArray)
	{
		$canvasName = mysql_real_escape_string($canvasName);

		$canvasID = $this->getCanvasByName($canvasName); 
		mysql_query("DELETE FROM verslas_groups_canvases WHERE canvas_id = '$canvasID';");
		foreach ($group_idArray as $group_id)
		{
		    $gp = $group_id['data'];
		    mysql_query("INSERT INTO verslas_groups_canvases (canvas_id, group_id) VALUES ('$canvasID', '$gp');");
		}
		return true;
	}

	function linkGroupWithUsers($group_id, $user_idArray)
	{
		foreach ($user_idArray as $user_id)
		{
		    $usId = $user_id['data'];
		    $groupId = $this->getGroupByName($group_id); 
		    mysql_query("INSERT INTO verslas_groups_users (user_id, group_id) VALUES ('$usId','$groupId');");
		}
		return true;
    }

	function getCanvasByName($canvasName)
	{
		$canvasName = mysql_real_escape_string($canvasName);

		$result = mysql_query("SELECT id FROM verslas_canvases WHERE name='".$canvasName."';");
		$result = mysql_fetch_row($result);
		return (int) $result[0];
	}

	function getGroupByName($groupName) 
  {		
		$groupName = mysql_real_escape_string($groupName);

		$result = mysql_query("SELECT id FROM verslas_groups WHERE name='".$groupName."';");
    $result = mysql_fetch_row($result);
    return (int) $result[0];
  }	

	function getUserByName($userName) 
	{		
		$userName = mysql_real_escape_string($userName);

		$result = mysql_query("SELECT id FROM verslas_users WHERE login='".$userName."';");
		$result = mysql_fetch_row($result);
      return (int) $result[0];
	}	
   
   function removeCanvas($canvasName)
   {
		$canvasName = mysql_real_escape_string($canvasName);

   	$canvasID = $this->getCanvasByName($canvasName); 
   	$result = mysql_query("DELETE FROM verslas_canvases WHERE ID = '$canvasID';");
   }

	function removeGroup($groupId)
   {
		$result = mysql_query("DELETE FROM verslas_groups WHERE id = '$groupId';");
	}
	
	function removeElement($elementID)
	{
		$result = mysql_query("DELETE FROM verslas_canvas_elements WHERE ID = '$elementID';");
	}

	function removeGroupByName($groupName)
  {
		$groupName = mysql_real_escape_string($groupName);

		$groupId = $this->getGroupByName($groupName); 
		$result = mysql_query("DELETE FROM verslas_groups WHERE id = '$groupId';");
  }

	function groupExists($groupName) 
	{
		$groupName = mysql_real_escape_string($groupName);

		$groupId = $this->getGroupByName($groupName);
		$result = mysql_query("SELECT name FROM verslas_groups WHERE id=".$groupId.";");
		return (mysql_num_rows($result) > 0) ? true : false;
	}

	function login($name, $password) {
		
		$stm = $this->con->prepare("SELECT username FROM users WHERE username=? AND password=?");
		
		if ( $stm->execute( array( $name, $password ) ) ) {
			
			if ( $stm->rowCount() > 0 ) {
				return true;
			} else {
				return false;
			}
			
		} else {
			return false;
		}
		
   }

	function register($login, $password, $firstName, $lastName)
  {
		$login = mysql_real_escape_string($login);
		$password = mysql_real_escape_string($password);
		$firstName = mysql_real_escape_string($firstName);
		$lastName = mysql_real_escape_string($lastName);

		mysql_query("INSERT INTO verslas_users (username, password, name, surname) VALUES ('$login', '$password', '$firstName', '$lastName');");
  }

	function isLoginAvailable($login)
	{
		$login = mysql_real_escape_string($login);

		$result = mysql_query("SELECT username FROM users WHERE username = '$login'");
		if (mysql_num_rows($result) > 0)
			return false;
		else
			return true;
	}

	function isCanvasNameAvailable($name)
	{
		$name = mysql_real_escape_string($name);

		$result = mysql_query("SELECT name FROM verslas_canvases WHERE name = '$name'");
		if (mysql_num_rows($result) > 0)
		    return false;
		else
		    return true;
	}

	function getUsersByCanvas($canvasName)
	{
		$canvasName = mysql_real_escape_string($canvasName);

		$canvasID = $this->getCanvasByName($canvasName); 
		// $result = mysql_query("SELECT verslas_users.name, verslas_users.id, verslas_users.name, verslas_users.surname FROM verslas_users, verslas_groups_users, verslas_groups_canvases WHERE verslas_groups_canvases.canvas_id = $canvasID AND verslas_groups_canvases.group_id = verslas_groups_users.group_id AND verslas_users.id = verslas_groups_users.user_id");
		$result = mysql_query("SELECT users.username, users.id, users.name, users.surname FROM users, verslas_groups_users, verslas_groups_canvases WHERE verslas_groups_canvases.canvas_id = $canvasID AND verslas_groups_canvases.group_id = verslas_groups_users.group_id AND verslas_users.id = verslas_groups_users.user_id");
		$users = array();
		if ( $result ) {
			while($user = mysql_fetch_object($result)) {
				array_push($users, $user);
			}
		}
		return $users;	
	}

	function insertCanvas($canvasName, $information, $type, $owner_name)
	{
		$owner_id = mysql_real_escape_string($owner_id);
		$owner_id = $this->getUserByName($owner_name); 
		mysql_query("INSERT INTO verslas_canvases (name, information, type, owner_id, kitosIslaidos, sudeliota) VALUES ('$canvasName', '$information', '$type', '$owner_id', 0, 0);");
	}

	function insertCanvasElement($name, $info, $segm_type, $count, $owner_id, $elementType, $meshName, $signName)
	{
		$owner_id = mysql_real_escape_string($owner_id);
		$info = mysql_real_escape_string($info);

		$owner_id = $this->getCanvasByName($owner_id); 
       		mysql_query("INSERT INTO verslas_canvas_elements (name, info, segm_type, count, owner_id, income_type, elementType, income_var1, income_var2, income_var3, income_var4, income_var5, income_var6, client_segment, meshName, varf, vark1, vark2, vark3, vark4, counto, client_segmento, signName) VALUES ('$name', '$info', '$segm_type', '$count','$owner_id', 13, '$elementType',0,0,0,0,0,0,0,'$meshName', 0, 0, 0, 0, 0, 0, 0, '$signName');");
	}

	function isertCanvasPiece($name, $info, $owner_id, $segmType)
	{
		$owner_id = mysql_real_escape_string($owner_id);
		$name = mysql_real_escape_string($name);
		$info = mysql_real_escape_string($info);

		$owner_id = $this->getCanvasByName($owner_id); 
    mysql_query("INSERT INTO verslas_canvas_pieces (name, info, owner_id, segmType) VALUES ('$name', '$info', '$owner_id', '$segmType');");
	}

	function updateCanvasPiece($owner_id, $name, $info,$segmType)
	{
		$owner_id = mysql_real_escape_string($owner_id);
		$name = mysql_real_escape_string($name);
		$info = mysql_real_escape_string($info);

		$owner_id = $this->getCanvasByName($owner_id); 
		$result = mysql_query("UPDATE verslas_canvas_pieces SET name = '$name' WHERE owner_id = '$owner_id' AND segmType = '$segmType'");
		$result = mysql_query("UPDATE verslas_canvas_pieces SET info = '$info'  WHERE owner_id = '$owner_id' AND segmType = '$segmType'");
	}
	
	function getCanvasPiece($owner_id, $segmType)
	{
		$owner_id = mysql_real_escape_string($owner_id);

		$canvasID = $this->getCanvasByName($owner_id); 
		$result = mysql_query("SELECT * FROM verslas_canvas_pieces WHERE owner_id = '$canvasID' AND segmType = '$segmType';");
		$result = mysql_fetch_row($result);
      return $result;
	}

	function getCanvasPieces($owner_id)
	{
		$owner_id = mysql_real_escape_string($owner_id);

		$canvasID = $this->getCanvasByName($canvasName); 
		$result = mysql_query("SELECT * FROM verslas_canvas_pieces WHERE owner_id = '$canvasID';");
		$elements = array();
		while($element = mysql_fetch_object($result))
			array_push($elements, $element);
		return $elements;
	}

	//this one is used from normal interface when in edit mode
	function updateCanvasElement($name, $info, $segm_type, $count, $owner_id, $elementType, $meshName, $ID, $signName)
	{
		$name = mysql_real_escape_string($name);
		$info = mysql_real_escape_string($info);

		$owner_id = $this->getCanvasByName($owner_id); 
		$result = mysql_query("UPDATE verslas_canvas_elements SET name = '$name' WHERE id = '$ID'");
		$result = mysql_query("UPDATE verslas_canvas_elements SET info = '$info' WHERE id = '$ID'");
		$result = mysql_query("UPDATE verslas_canvas_elements SET segm_type = '$segm_type' WHERE id = '$ID'");
		$result = mysql_query("UPDATE verslas_canvas_elements SET count = '$count' WHERE id = '$ID'");
		$result = mysql_query("UPDATE verslas_canvas_elements SET owner_id = '$owner_id' WHERE id = '$ID'");
		$result = mysql_query("UPDATE verslas_canvas_elements SET elementType = '$elementType' WHERE id = '$ID'");
		$result = mysql_query("UPDATE verslas_canvas_elements SET meshName = '$meshName' WHERE id = '$ID'");
		$result = mysql_query("UPDATE verslas_canvas_elements SET signName = '$signName' WHERE id = '$ID'");
	}
	
	//This update is used in the income/outcome counters
	function updateProduct($ID, $var1, $var2, $var3, $var4, $var5, $var6, $income_type, $client_segment, $count)
	{
		$result = mysql_query("UPDATE verslas_canvas_elements SET income_var1 = '$var1' WHERE id = '$ID'");
		$result = mysql_query("UPDATE verslas_canvas_elements SET income_var2 = '$var2' WHERE id = '$ID'");
		$result = mysql_query("UPDATE verslas_canvas_elements SET income_var3 = '$var3' WHERE id = '$ID'");
		$result = mysql_query("UPDATE verslas_canvas_elements SET income_var4 = '$var4' WHERE id = '$ID'");
		$result = mysql_query("UPDATE verslas_canvas_elements SET income_var5 = '$var5' WHERE id = '$ID'");
		$result = mysql_query("UPDATE verslas_canvas_elements SET income_var6 = '$var6' WHERE id = '$ID'");
		$result = mysql_query("UPDATE verslas_canvas_elements SET income_type = '$income_type' WHERE id = '$ID'");
		$result = mysql_query("UPDATE verslas_canvas_elements SET client_segment = '$client_segment' WHERE id = '$ID'");
    $result = mysql_query("UPDATE verslas_canvas_elements SET count = '$count' WHERE id = '$ID'");
	}

	function updateProductKastai($ID, $vark1, $vark2, $vark3, $vark4, $varf, $counto, $client_segmento)
	{
		$result = mysql_query("UPDATE verslas_canvas_elements SET counto = '$counto' WHERE id = '$ID'");
		$result = mysql_query("UPDATE verslas_canvas_elements SET client_segmento = '$client_segmento' WHERE id = '$ID'");
		$result = mysql_query("UPDATE verslas_canvas_elements SET varf = '$varf' WHERE id = '$ID'");
		$result = mysql_query("UPDATE verslas_canvas_elements SET vark1 = '$vark1' WHERE id = '$ID'");
		$result = mysql_query("UPDATE verslas_canvas_elements SET vark2 = '$vark2' WHERE id = '$ID'");
		$result = mysql_query("UPDATE verslas_canvas_elements SET vark3 = '$vark3' WHERE id = '$ID'");
		$result = mysql_query("UPDATE verslas_canvas_elements SET vark4 = '$vark4' WHERE id = '$ID'");
	}

	function updateKitosIslaidos($canvasName, $kitosIslaidos)
	{
		$canvasName = mysql_real_escape_string($canvasName);
		$canvasID = $this->getCanvasByName($canvasName); 
		$result = mysql_query("UPDATE verslas_canvases SET kitosIslaidos = '$kitosIslaidos' WHERE id = '$canvasID'");
	}
	
	function updateCanvasByName($canvasName, $information, $type, $newName)
	{
		$canvasName = mysql_real_escape_string($canvasName);
		$information = mysql_real_escape_string($information); 
		$type = mysql_real_escape_string($type);
		$newName = mysql_real_escape_string($newName);

		$canvasID = $this->getCanvasByName($canvasName); 
		$result = mysql_query("UPDATE verslas_canvases SET type = '$type' WHERE ID = '$canvasID'");
		$result = mysql_query("UPDATE verslas_canvases SET information = '$information' WHERE ID = '$canvasID'");
		$result = mysql_query("UPDATE verslas_canvases SET name = '$newName' WHERE ID = '$canvasID'");
	}

	function markCanvasAsSudeliota($canvasName)
	{
		$canvasName = mysql_real_escape_string($canvasName);
		$canvasID = $this->getCanvasByName($canvasName); 
		$result = mysql_query("UPDATE verslas_canvases SET sudeliota = 1 WHERE id = '$canvasID'");
	}
    
    function insertVideo($canvasName, $information, $link, $name)
    {
			$canvasName = mysql_real_escape_string($canvasName);
			$information = mysql_real_escape_string($information);
			$link = mysql_real_escape_string($link);	
			$name = mysql_real_escape_string($name);

			$canvasID = $this->getCanvasByName($canvasName); 
      mysql_query("INSERT INTO verslas_videos (owner_id, link, info, name) VALUES ('$canvasID', '$link', '$information', '$name');");
    }

    function insertImage($canvasName, $information, $link, $name)
    {
			$canvasName = mysql_real_escape_string($canvasName);
			$information = mysql_real_escape_string($information);
			$link = mysql_real_escape_string($link);	
			$name = mysql_real_escape_string($name);
			$canvasID = $this->getCanvasByName($canvasName); 
      mysql_query("INSERT INTO verslas_images (owner_id, link, info) VALUES ('$canvasID', '$link', '$information', '$name');");
    }
    
    function getElementVideos($elementID)
    {
			$result = mysql_query("SELECT * FROM verslas_videos WHERE videos.owner_id = '$elementID';");
			$videos = array();
			while($video = mysql_fetch_object($result))
				array_push($videos, $video);
			return $videos;
    }

    function getElementImages($elementID)
    {
			$result = mysql_query("SELECT * FROM verslas_images WHERE images.owner_id = '$elementID';");
			$images = array();
			while($image2 = mysql_fetch_object($result))
				array_push($images, $image2);
			return $images;
    }

}
?>
