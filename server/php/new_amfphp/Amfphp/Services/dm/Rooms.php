<?php
/**
 * Base class for users operations
 * Users
 */
require_once('Maps.php');
 
class Rooms
{
    function __construct() { //Constructor
	}
	
	/**
	 * Gets room id by name
	 * @returns User's recordset
	 */
	function getRoomByName($roomName) {		
		$result = mysql_query("SELECT * FROM rooms WHERE name='".$roomName."';");
		return mysql_fetch_object($result);
	}
	
	/**
	 * Checks if user is room's moderator
	 * @returns true or false
	 */
	function isModerator($userId, $roomName) {
		$result = mysql_query("SELECT id FROM user_vars WHERE user_id=".$userId." AND param_name='isAdmin';");
		if (mysql_num_rows($result) > 0)
			return true;
		$roomId = $this->getRoomIdByName($roomName);
		$result = mysql_query("SELECT id FROM u2r WHERE user_id=".$userId." AND room_id=".$roomId.";");
		return (mysql_num_rows($result) > 0) ? true : false;
	}
	
	function getRoomIdByName($roomName) {
		$result = mysql_query("SELECT id FROM rooms WHERE name='".$roomName."';");
		$result = mysql_fetch_row($result);
		return (int) $result[0];
	}
	
	function addModeratorToRoom($userId, $roomId) {
		return mysql_query("INSERT INTO u2r (user_id, room_id) VALUES (".$userId.", ".$roomId.");");
	}
	
	function removeModeratorFromRoom($u2rId) {
		return mysql_query("DELETE FROM u2r WHERE id=".$u2rId.";");
	}
	
	function getUserRooms($userId) {
		$result = mysql_query("SELECT u2r.id, name FROM u2r, rooms WHERE user_id=".$userId." AND rooms.id=room_id;");
		$rooms = array();
		while($room = mysql_fetch_object($result))
			array_push($rooms, $room);
		return $rooms;
	}
	
	function getAllRooms() {
		$result = mysql_query("SELECT * FROM rooms;");
		$rooms = array();
		while($room = mysql_fetch_object($result))
			array_push($rooms, $room);
		return $rooms;
	}
	
	function changeLabel($roomId, $newLabel) {
		return mysql_query("UPDATE rooms SET label='".$newLabel."' WHERE id=".$roomId.";");
	}
	
	function cloneRoom($roomName, $avatarId) {
		$maps = new Maps();
		$result = mysql_query("SELECT * FROM rooms WHERE name='".$roomName."';");
		$roomToClone = mysql_fetch_object($result);		
		
		// clone map
		$mapId = $roomToClone->template;
		$maps->_decodeMap($mapId.'@'.$avatarId, $maps->encodeMap($mapId));	
		
		// clone room
		mysql_query("INSERT INTO rooms (name, template, label) VALUES ('".$roomName.'@'.$avatarId."', '".$mapId.'@'.$avatarId."', '".$roomToClone->label."');");
		$clonedRoomId = mysql_insert_id();
		
		// clone NPC
		$result = mysql_query("SELECT * FROM npc_npcs WHERE room_id=".$roomToClone->id.";");
		while ($npc = mysql_fetch_object($result))
			mysql_query("INSERT INTO npc_npcs (name, skin_id, animation_time, room_id, x, y, direction) VALUES ('".$npc->name."', ".$npc->skin_id.", ".$npc->animation_time.", ".$clonedRoomId.", ".$npc->x.", ".$npc->y.", ".$npc->direction.");");		
	}
	
	function deleteRoomWithMap($roomName) {
		$maps = new Maps();
		$mapId = mysql_query("SELECT template FROM rooms WHERE name='".$roomName."';");
		$mapId = mysql_fetch_row($mapId);
		$mapId = $mapId[0];
		$maps->deleteMap($mapId);
		mysql_query("DELETE FROM rooms WHERE name='".$roomName."';");
	}
}
?>