<?php
/**
 * Base class for users operations
 * Users
 */
class Item
{	
    function Item() //Constructor
	{
    	include_once 'DBConnection.php';
		include_once 'Functions.php';
		include_once 'Conditions.php';
	}
	
	function getAllItems() {
		$item_rs = mysql_query("SELECT id, label FROM items;");
		$items = array();
		while($item = mysql_fetch_object($item_rs))
			array_push($items, $item);
		return $items;
	}
	
	function getUserItems($userId) {
		$admin_rs = mysql_query("SELECT * FROM users WHERE id=".$userId." AND isadmin='Y';");
		if (mysql_num_rows($admin_rs) > 0)
			return $this->getAllItems();
	
		$item_rs = mysql_query("SELECT * FROM item WHERE id IN (SELECT object_id FROM object_permissions WHERE object_type='item' AND moderator_id=".$userId.");");
		$items = array();
		while($item = mysql_fetch_object($item_rs))
			array_push($items, $item);
		return $items;
	}
	
	function saveItem($item, $userId) {
		if ($item['id'] == 0) {
			mysql_query("INSERT INTO items (label, icon, description, cant_use_msg, color, consumable, last_modified, last_modified_by) VALUES ('".$item['label']."', '".$item['icon']."', '".$item['description']."', '".$item['ccut']."', '".$item['color']."', ".$item['consumable'].", NOW(), ".$userId.");");
			$itemId = mysql_insert_id();
			mysql_query("INSERT INTO object_permissions (object_type, object_id, moderator_id) VALUES ('item', ".$itemId.", ".$userId.");");
		} else {
			$itemId = $item['id'];
			mysql_query("UPDATE items SET label='".$item['label']."', icon='".$item['icon']."', description='".$item['description']."', cant_use_msg='".$item['ccut']."', color='".$item['color']."', consumable=".$item['consumable'].", last_modified=NOW(), last_modified_by=".$userId." WHERE id=".$itemId.";");
			mysql_query("DELETE FROM functions_to_items WHERE item_id=".$itemId.";");
			mysql_query("DELETE FROM conditions_to_items WHERE item_id=".$itemId.";");
		}
		foreach($item['functionIds'] as $functionId)
			mysql_query("INSERT INTO functions_to_items (item_id, function_id) VALUES (".$itemId.", ".$functionId.");");
			
		foreach($item['conditionIds'] as $conditionId)
			mysql_query("INSERT INTO conditions_to_items (item_id, condition_id) VALUES (".$itemId.", ".$conditionId.");");
			
		return mysql_error();
		return $this->getItemById($itemId);
	}
	
	function getItemById($itemId) {
		$item_rs = mysql_query("SELECT * FROM items WHERE id=".$itemId.";");
		$item = mysql_fetch_object($item_rs);
		
		$function_rs = mysql_query("SELECT * FROM functions_to_items WHERE item_id=".$itemId.";");
		$functionsClass = new Functions();
		$item->functions = array();
		while($function = mysql_fetch_object($function_rs))
			array_push($item->functions, $functionsClass->getFunctionById($function->function_id));
			
		$condition_rs = mysql_query("SELECT * FROM conditions_to_items WHERE item_id=".$itemId.";");
		$conditionsClass = new Conditions();
		$item->conditions = array();
		while($condition = mysql_fetch_object($condition_rs))
			array_push($item->conditions, $conditionsClass->getConditionById($condition->condition_id));
			
		return $item;
	}
	
	function getAvatarItems($avatarId) {
		$item_rs = mysql_query("SELECT * FROM items_to_avatars WHERE avatar_id=".$avatarId.";");
		$items = array();
		while($item = mysql_fetch_object($item_rs))
			array_push($items, $this->getItemById($item->item_id));
		return $items;
	}
	
	function addItem($avatarId, $itemId) {
		$avatarId = mysql_real_escape_string($avatarId);
        $itemId = mysql_real_escape_string($itemId);
		error_log("additem: $avatarId, $itemId");
		mysql_query("INSERT INTO items_to_avatars (avatar_id, item_id) VALUES (".$avatarId.", ".$itemId.");");
	}
	
	function removeItem($avatarId, $itemId) {
		mysql_query("DELETE FROM items_to_avatars WHERE avatar_id=".$avatarId." AND item_id=".$itemId." LIMIT 1;");
	}

}
?>