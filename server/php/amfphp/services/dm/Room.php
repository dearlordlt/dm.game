<?php
/**
 * Base class for users operations
 * Users
 */
class Room
{	
    function Room() //Constructor
	{
    	include_once 'DBConnection.php';
	}
	
	function getRoomByLabel($label) {
		$room_rs = mysql_query("SELECT * FROM rooms WHERE label='".$label."';");
		return (mysql_num_rows($room_rs) > 0) ? mysql_fetch_object($room_rs) : false;
	}
	
	function saveRoom($id, $label, $mapId) {
		if ($id == 0)
			mysql_query("INSERT INTO rooms (label, map_id) VALUES ('".$label."', ".$mapId.");");
		else 
			mysql_query("UPDATE rooms SET label='".$label."', map_id=".$mapId." WHERE id=".$id.";");
	}
	
	function getAllRooms() {
		$result = mysql_query("SELECT * FROM rooms ORDER BY id;");
		$rooms = array();
		while ($room = mysql_fetch_object($result)) {
			array_push($rooms, $room);
		}
		return $rooms;
	}
}
?>