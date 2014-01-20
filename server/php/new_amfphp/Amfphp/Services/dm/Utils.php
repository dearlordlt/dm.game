<?php
/**
 * Base class for users operations
 * Users
 */
class Utils
{
    function __construct() { //Constructor
	}
        
        function deleteUnusedF3d() {
            
        }
	
	function deleteAnimationByCharacterType($charTypeId) {
		mysql_query ("DELETE FROM animations WHERE character_type_id = ".$charTypeId.";"); //naudojant zodzius reikia ' pries "
		return mysql_affected_rows()." eiluciu istrinta";
	}
	
	function fixEtities2() {
		$entity_rs = mysql_query("SELECT * FROM entities WHERE id IN (SELECT entity_id FROM entities_to_maps WHERE map_id=341) AND id NOT IN (SELECT entity_id FROM components_to_entities WHERE component_type='Skin3D') GROUP BY label");
		$data = array();
		while($entity = mysql_fetch_object($entity_rs)) {
			$component_rs = mysql_query("SELECT * FROM components_to_entities WHERE entity_id IN (SELECT id FROM entities WHERE label='".$entity->label."') LIMIT 1;");
			$component = mysql_fetch_object($component_rs);
			array_push($data, "\$idMap['".$entity->label."'] = ".$component->component_id);
		}
		return $data;
	}

	function fixEntities() {
		//$mapId['brajeras'] = "
		$idMap['dubutis'] = 287;
		$idMap['dvaras'] = 469;
		$idMap['gotika'] = 400;
		$idMap['laikrastis'] = 533;
		$idMap['lempa'] = 480;
		$idMap['masina'] = 478;
		$idMap['namas'] = 361;
		$idMap['Savininkas'] = 8;
		//$idMap['sawiwaldybe'] = "
		$idMap['siuksle'] = 533;
		$idMap['siuksles'] = 531;
		$idMap['siuksline'] = 471;
		$idMap['siuskle'] = 525;
		$idMap['suoliukas'] = 261;
		$idMap['sawiwaldybe'] = 376;
		//$idMap['super'] = "

	/*
		$idMap['bakas'] = 471;
		$idMap['bazn'] = 537;
		$idMap['dm_ccentre_2'] = 369;
		$idMap['dm_ccentre_5'] = 373;
		$idMap['dm_centre_3'] = 370;
		$idMap['dm_gothic'] = 375;
		$idMap['dm_gothic_2'] = 398;
		$idMap['dm_gothic_4'] = 155;
		$idMap['dm_ren_1'] = 162;
		$idMap['dm_ren_2'] = 163;
		$idMap['dm_ren_4'] = 165;
		$idMap['dm_ren_6'] = 167;
		$idMap['gywatwore'] = 461;
		$idMap['krumas'] = 582;
		$idMap['sketis'] = 384;
		$idMap['table'] = 335;
		$idMap['tiltas'] = 581;
		$idMap['tree'] = 383;
		$idMap['tvora'] = 459;
		$idMap['zenklas'] = 508;
		$idMap['zibintas'] = 480;
	*/
		$entity_rs = mysql_query("SELECT * FROM entities WHERE id IN (SELECT entity_id FROM entities_to_maps WHERE map_id=341) AND id NOT IN (SELECT entity_id FROM components_to_entities WHERE component_type='Skin3D');");
		$entitiesFixed = 0;
		$entitiesNotFixed = 0;
		//$insertedObjects = array();
		while($entity = mysql_fetch_object($entity_rs)) {
			//array_push($insertedObjects, $entity->label.": ".$idMap[$entity->label]);
			if (isset($idMap[$entity->label])) {
				mysql_query("INSERT INTO components_to_entities (entity_id, component_type, component_id) VALUES (".$entity->id.", 'Skin3D', ".$idMap[$entity->label].");");
				$entitiesFixed++;
			} else {
				$entitiesNotFixed++;
			}
		}
		//return $insertedObjects;
		return "Fixed: ".$entitiesFixed." / Not Fixed: ".$entitiesNotFixed;
	}


	function testBoolean($test) {
		return (Boolean)$test;
	}

	function copyAnimations($from, $to) {
		$rs = mysql_query("SELECT * FROM animations WHERE character_type_id=".$from.";");
		while($a = mysql_fetch_object($rs)) {
			mysql_query("INSERT INTO animations (character_type_id, label, start_frame, end_frame) VALUES (".$to.", '".$a->label."', ".$a->start_frame.", ".$a->end_frame.");");
		}
		return mysql_error();
	}

	function clearEntities() {
		mysql_query("DELETE FROM entities WHERE id NOT IN (SELECT entity_id FROM entities_to_maps);");
		return mysql_affected_rows();
	}

	function insertCharTextures() {
		$charNum = 3;
		$charName = "professor_m";
		$charParts = array("top");
		$textureTypes = array("diff", "nml", "spm");

		for ($i=1; $i<=$charNum; $i++) {
			foreach ($textureTypes as $type) {
				foreach ($charParts as $part) {
					$textureName = $charName.'_'.$part.'_'.$i.'_1_'.$type.'.png';
					mysql_query("INSERT INTO skin3d_textures (label, skin_type,	subtype, path) VALUES ('".$textureName."', 3, '".$charName."', 'assets/textures/character/".$charName."/".$textureName."');");
					//return mysql_error();
				}
			}
		}
	}

	function updateTextureTypes() {
		$texture_rs = mysql_query("SELECT * FROM skin3d_textures;");
		while($texture = mysql_fetch_object($texture_rs)) {
			if (strpos($texture->label, 'spm') !== false)
				mysql_query("UPDATE skin3d_textures SET type='spm' WHERE id=".$texture->id.";");
			if (strpos($texture->label, 'nml') !== false)
				mysql_query("UPDATE skin3d_textures SET type='nml' WHERE id=".$texture->id.";");
		}
	}

	function insertCharModels() {
		$charNum = 3;
		$charName = "professor_m";
		$charParts = array("accessories");

		for ($i=1; $i<=$charNum; $i++) {
			foreach ($charParts as $part) {
				$label = $charName.'_'.$part.'_'.$i;
				$textureName = $charName.'_'.$part.'_'.$i.'.f3d';
				mysql_query("INSERT INTO skin3d_elements (skin3d_type, subtype, label, path) VALUES (3, '".$charName."', '".$label."', 'assets/characters/".$charName."/".$label.".f3d');");
					//return mysql_error();
			}
		}
		mysql_query("INSERT INTO skin3d_elements (skin3d_type, subtype, label, path) VALUES (3, '".$charName."', '".$charName."_animation', 'assets/characters/".$charName."/".$charName."_animation.f3d');");
	}

	function addLocationAvatars() {
		$avatar_rs = mysql_query("SELECT * FROM avatars;");
		while($avatar = mysql_fetch_object($avatar_rs)) {
			$location_rs = mysql_query("SELECT * FROM avatar_last_location WHERE avatar_id=".$avatar->id.";");
			if (mysql_num_rows($location_rs) == 0)
				mysql_query("INSERT INTO avatar_last_location (avatar_id, room_id, x, y, z) VALUES (".$avatar->id.", 146, 0,0,0);");
		}
	}

	function makeSkinsFromElements() {
		$element_rs = mysql_query("SELECT * FROM skin3d_elements WHERE id > 11;");
		while($element = mysql_fetch_object($element_rs)) {
			mysql_query("INSERT INTO skin3d (type, label) VALUES (2, '".$element->label."');");
			$skin3d_id = mysql_insert_id();
			mysql_query("INSERT INTO skin3d_elements_to_skins (skin3d_id, element_id) VALUES (".$skin3d_id.", ".$element->id.");");
		}
	}

	function clearDuplicateComponents() {
		$c2e_rs = mysql_query("SELECT * FROM components_to_entities;");
		$uniqueValues = array();
		$rowsDeleted = 0;
		while ($c2e = mysql_fetch_object($c2e_rs)) {
			if ($uniqueValues[$c2e->entity_id] == $c2e->component_id) {
				mysql_query("DELETE FROM components_to_entities WHERE id=".$c2e->id.";");
				$rowsDeleted++;
			} else {
				$uniqueValues[$c2e->entity_id] = $c2e->component_id;
			}
		}
		return $rowsDeleted;
	}
}
?>