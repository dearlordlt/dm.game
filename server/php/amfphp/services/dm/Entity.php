<?php
/**
 * Base class for users operations
 * Users
 */
class Entity
{	
    function Entity() //Constructor
	{
    	include_once 'DBConnection.php';
		include_once 'Skin3D.php';
		include_once 'NPC.php';
		include_once 'Interaction.php';
	}
	
	function getPresets() {
		$entity_rs = mysql_query("SELECT * FROM entities WHERE use_as_preset=1;");
		$entities = array();
		while ($entity = mysql_fetch_object($entity_rs))
			array_push($entities, $this->getEntityById($entity->id));
		return $entities;
	}
	
	function getAllEntities() {
		$entity_rs = mysql_query("SELECT * FROM entities;");
		$entities = array();
		while ($entity = mysql_fetch_object($entity_rs))
			array_push($entities, $this->getEntityById($entity->id));
		return $entities;
	}
	
	function getEntityById($entityId) {
		$entity_rs = mysql_query("SELECT * FROM entities WHERE id=".$entityId.";");
		$entity = mysql_fetch_object($entity_rs);
		
		$component_rs = mysql_query("SELECT * FROM components_to_entities WHERE entity_id=".$entityId.";");
		$entity->components = array();
		while ($component = mysql_fetch_object($component_rs))		
			array_push($entity->components, $this->_getComponent($component));
		$entity->x = 0;
		$entity->y = 0;
		$entity->z = 0;
		$entity->rotationX = 0;
		$entity->rotationY = 0;
		$entity->rotationZ = 0;
		return $entity;
	}
	
	function _getComponent($component) {
		switch ($component->component_type) {
			case 'Skin3D':
				$skin3dClass = new Skin3D;
				$component->data = $skin3dClass->getSkinById($component->component_id);
				break;
			case 'NPC':
				$npcClass = new NPC;
				$component->data = $npcClass->getNpcById($component->component_id);
				break;
			case "Interaction":
				$interactionClass = new Interaction;
				$component->data = $interactionClass->getInteractionById($component->component_id);
				break;
			case "Audio":
				$audio_rs = mysql_query("SELECT * FROM audio WHERE id=".$component->component_id.";");
				$component->data = mysql_fetch_object($audio_rs);
				break;
		}
		return $component;
	}

}
?>