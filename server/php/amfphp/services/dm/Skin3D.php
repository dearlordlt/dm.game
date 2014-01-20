<?php
/**
 * Base class for users operations
 * Users
 */
class Skin3D
{	
    function Skin3D() //Constructor
	{
    	include_once 'DBConnection.php';
	}
	
	function getAllCategories() {
		$result = mysql_query("SELECT * FROM skin3d_categories;");
		$categories = array();
		while($category = mysql_fetch_object($result))
			array_push($categories, $category);
		return $categories;
	}
	
	function getSkinById($skinId) {
		$result = mysql_query("SELECT * FROM skin3d WHERE id=".$skinId.";");
		$skin = mysql_fetch_object($result);
		$result = mysql_query("SELECT * FROM skin3d_elements_to_skins RIGHT JOIN skin3d_elements ON skin3d_elements.id=skin3d_elements_to_skins.element_id WHERE skin3d_id=".$skinId.";");
		$elements = array();
		while ($element = mysql_fetch_object($result)) {
			$texture_rs = mysql_query("SELECT * FROM skin3d_textures_to_elements RIGHT JOIN skin3d_textures ON skin3d_textures.id=skin3d_textures_to_elements.texture_id WHERE elements_to_skins_id=".$element->id0.";");
			$textures = array();
			while($texture = mysql_fetch_object($texture_rs))
				array_push($textures, $texture);
			$element->textures = $textures;
			array_push($elements, $element);
		}
		$skin->elements = $elements;
		return $skin;
	}
	
	function saveSkin($skin) {
		$subtype = (isset($skin['subtype'])) ? $skin['subtype'] : '';
		mysql_query("INSERT INTO skin3d (type, subtype, label) VALUES (".$skin['type'].", '".$subtype."', '".$skin['label']."');");
		$skinId = mysql_insert_id();
		//return mysql_error();
		foreach	($skin['elements'] as $element) {
			mysql_query("INSERT INTO skin3d_elements_to_skins (skin3d_id, element_id, x, y, z) VALUES (".$skinId.", ".$element['id'].", ".$element['x'].", ".$element['y'].", ".$element['z'].");");
			$elementToSkinId = mysql_insert_id();
			if (isset($element['textures']))
				foreach ($element['textures'] as $texture)
					mysql_query("INSERT INTO skin3d_textures_to_elements (elements_to_skins_id, texture_id, part_name) VALUES (".$elementToSkinId.", ".$texture['id'].", '".$texture['part_name']."');");
			if (isset($element['color'])) {
				$colorId = $this->insertColorInTextures($element['color']);
				mysql_query("INSERT INTO skin3d_textures_to_elements (elements_to_skins_id, texture_id, part_name) VALUES (".$elementToSkinId.", ".$colorId.", '".$texture['part_name']."');");
			}
				
		}
		return $this->getSkinById($skinId);
	}
	
	function insertColorInTextures($color) {
		$color_rs = mysql_query("SELECT * FROM skin3d_textures WHERE path='".$color."';");
		if (mysql_num_rows($color_rs) > 0) {
			$color = mysql_fetch_object($color_rs);
			return $color->id;
		} else {
			mysql_query("INSERT INTO skin3d_textures (label, type, path) VALUES ('".$color."', 'color', '".$color."');");
			return mysql_insert_id();
		}
	}
	
	function getAllSolidObjects() {
		$skin_rs = mysql_query("SELECT * FROM skin3d WHERE type=2");
		$solidObjects = array();
		while($skin3d = mysql_fetch_object($skin_rs)) {
			$solidObject = $this->getSkinById($skin3d->id);
			array_push($solidObjects, $solidObject);
		}
		return $solidObjects;
	}
	
	function getAllSkins() {
		$skin_rs = mysql_query("SELECT * FROM skin3d;");
		$skins = array();
		$solidObjects = array();
		while($skin3d = mysql_fetch_object($skin_rs)) {
			$skin = $this->getSkinById($skin3d->id);
			array_push($skins, $skin);
		}
		return $skins;
	}
	
	function getAllCustomBuildings() {
		$result = mysql_query("SELECT * FROM skin3d_elements WHERE skin3d_type=1;");
		$elements = array();
		while($element = mysql_fetch_object($result))
			array_push($elements, $element);
		return $elements;
	}
	
	function getAllCharacters() {
		$result = mysql_query("SELECT * FROM skin3d_elements WHERE skin3d_type=3;");
		$elements = array();
		while($element = mysql_fetch_object($result))
			array_push($elements, $element);
		return $elements;
	}
	
	function getAllAnimations() {
		$result = mysql_query("SELECT * FROM animations;");
		$animations = array();
		while($animation = mysql_fetch_object($result))
			array_push($animations, $animation);
		return $animations;
	}
	
	function getAllTextures() {
		$result = mysql_query("SELECT * FROM skin3d_textures WHERE skin_type<>3 AND type<>'color';");
		$textures = array();
		while($texture = mysql_fetch_object($result))
			array_push($textures, $texture);
		return $textures;
	}
	
	function getAllCharacterTextures() {
		$result = mysql_query("SELECT * FROM skin3d_textures WHERE skin_type=3;");
		$textures = array();
		while($texture = mysql_fetch_object($result))
			array_push($textures, $texture);
		return $textures;
	}
	
	function getAnimationsByCharacterType($characterTypeId) {
		$result = mysql_query("SELECT * FROM animations WHERE character_type_id=".$characterTypeId.";");
		$animations = array();
		while($animation = mysql_fetch_object($result))
			array_push($animations, $animation);
		return $animations;
	}
}
?>