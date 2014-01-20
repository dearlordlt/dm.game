<?php
/**
 * Base class for users operations
 * Users
 */
class Maps
{	
    function Maps() //Constructor
	{
    	include_once 'DBConnection.php';
		include_once 'Entity.php';
	}
	
	function getAllMaps() {
		$map_rs = mysql_query("SELECT * FROM maps;");
		$maps = array();
		while ($map = mysql_fetch_object($map_rs))
			array_push($maps, $map);
		return $maps;
	}
	
	function getMapById($mapId) {
	
		$entityClass = new Entity();
	
		$map_rs = mysql_query("SELECT * FROM maps WHERE id=".$mapId.";");
		$map = mysql_fetch_object($map_rs);
		
		$avatarSpawnPoint_rs = mysql_query("SELECT * FROM map_avatar_spawnpoints WHERE map_id=".$mapId.";");
		$avatarSpawnPoints = array();
		while($avatarSpawnPoint = mysql_fetch_object($avatarSpawnPoint_rs)) {
			$conditionsToAvatarSpawnPoints_rs = mysql_query("SELECT * FROM conditions_to_avatar_spawnpoints WHERE avatar_spawnpoint_id=".$avatarSpawnPoint->id.";");
			$conditions = array();
			while($conditionsToAvatarSpawnPoints = mysql_fetch_object($conditionsToAvatarSpawnPoints_rs))
				array_push($conditions, $this->_getConditionById($conditionsToAvatarSpawnPoints->condition_id));
			$avatarSpawnPoint->conditions = $conditions;
			array_push($avatarSpawnPoints, $avatarSpawnPoint);
		}
		$map->avatarSpawnPoints = $avatarSpawnPoints;
		
		$entity_rs = mysql_query("SELECT * FROM entities_to_maps WHERE map_id=".$mapId.";");

		$entities = array();
		while ($entity_to_map = mysql_fetch_object($entity_rs)) {
			$entity = $entityClass->getEntityById($entity_to_map->entity_id);
			$entity->x = $entity_to_map->x;
			$entity->y = $entity_to_map->y;
			$entity->z = $entity_to_map->z;
			$entity->rotationX = $entity_to_map->rotationX;
			$entity->rotationY = $entity_to_map->rotationY;
			$entity->rotationZ = $entity_to_map->rotationZ;
			array_push($entities, $entity);
		}
		
		$skybox_rs = mysql_query("SELECT * FROM skyboxes WHERE id=".$map->skybox_id.";");
		$map->skybox = mysql_fetch_object($skybox_rs);
		
		$map->entities = $entities;
		
		return $map;
	}
	
	function _getConditionById($conditionId) {
			$condition_rs = mysql_query("SELECT * FROM conditions WHERE id=".$conditionId.";");
			$condition = mysql_fetch_object($condition_rs);
			$param_rs = mysql_query("SELECT * FROM condition_params WHERE condition_id=".$conditionId.";");
			$params = array();
			while($param = mysql_fetch_object($param_rs))
				array_push($params, $param);
			$condition->params = $params;
			return $condition;
		}
	
	function getAllSkyboxes() {
		$map_rs = mysql_query("SELECT * FROM skyboxes;");
		$skyboxes = array();
		while ($skybox = mysql_fetch_object($map_rs))
			array_push($skyboxes, $skybox);
		return $skyboxes;
	}
	
	function saveMap($map, $userId) {
		mysql_query("INSERT INTO maps (label, width, height, skybox_id, user_id, datetime, active) VALUES ('".$map['label']."', ".$map['width'].", ".$map['height'].", ".$map['skybox_id'].", ".$userId.", NOW(), 1);");
		//return "INSERT INTO maps (label, width, height, skybox_id, user_id, datetime, active) VALUES ('".$map['label']."', ".$map['width'].", ".$map['height'].", ".$map['skybox_id'].", ".$userId.", NOW(), 1);";
		$mapId = mysql_insert_id();

		foreach($map['avatarSpawnPoints'] as $avatarSpawnPoint) {
			mysql_query("INSERT INTO map_avatar_spawnpoints (map_id, x, y, z) VALUES (".$mapId.", ".$avatarSpawnPoint['x'].", ".$avatarSpawnPoint['y'].", ".$avatarSpawnPoint['z'].");");
			$avatarSpawnPointId = mysql_insert_id();
			foreach($avatarSpawnPoint['conditions'] as $condition)
				mysql_query("INSERT INTO conditions_to_avatar_spawnpoints (avatar_spawnpoint_id, condition_id) VALUES (".$avatarSpawnPointId.", ".$condition['id'].");");
		}
		//return mysql_error();
		foreach($map['entities'] as $entity) {
			//$entityId = $entity['id'];
			//if ($entityId == 0) {
				mysql_query("INSERT INTO entities (label) VALUES ('".$entity['label']."');");
				$entityId = mysql_insert_id();
			//}			
			mysql_query("INSERT INTO entities_to_maps (map_id, entity_id, x, y, z, rotationX, rotationY, rotationZ) VALUES (".$mapId.", ".$entityId.", ".$entity['x'].", ".$entity['y'].",  ".$entity['z'].", ".$entity['rotationX'].", ".$entity['rotationY'].", ".$entity['rotationZ'].");");
			mysql_query("DELETE FROM components_to_entities WHERE entity_id=".$entityId.";");
			foreach($entity['components'] as $component)
				mysql_query("INSERT INTO components_to_entities (entity_id, component_type, component_id) VALUES (".$entityId.", '".$component['type']."', ".$component['id'].");");
		}
		
		return $map;
	}
	
	function addMapToUser($userid, $mapid, $mapname)
	{
		mysql_query("INSERT INTO users_to_maps (userid, mapid, mapname) VALUES(".$userid.", ".$mapid.", '".$mapname."')");
		return mysql_insert_id();
	}
	
	function getMapListByUserId($userid)
	{
		$map_rs = mysql_query("SELECT * FROM users_to_maps WHERE userid = ".$userid.";");
		$maps = array();
		while ($map = mysql_fetch_object($map_rs))
			array_push($maps, $map);
		return $maps;
	}
	
	function getMapToUserById($id)
	{
		$map_rs = mysql_query("SELECT * FROM users_to_maps WHERE id = ".$id.";");
		$maps = array();
		while ($map = mysql_fetch_object($map_rs))
			array_push($maps, $map);
		return $maps;
	}
	
	function updatePermisions($id, $map, $entity, $tools)
	{
		mysql_query("UPDATE users_to_maps SET map = '".$map."', entity = '".$entity."', tools = '".$tools."' WHERE id = ".$id.";");
	}

}
?>