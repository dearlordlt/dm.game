<?php

/**
 * Base class for users operations
 * Users
 */
class Item {
	
	/**
	 *
	 * @var PDO
	 */
	private $con;
	
    function __construct() { //Constructor
		$this->con = PDOConnection::con(basename(__DIR__));
        include_once 'Functions.php';
        include_once 'Conditions.php';
    }

    function getAllItems() {
		
		$stm = $this->con->prepare("SELECT * FROM items");
		
		$stm->execute();
		return $stm->fetchAll(PDO::FETCH_OBJ);
		
    }

    function getUserItems($userId) {
        $userId = mysql_real_escape_string($userId);

        $admin_rs = mysql_query("SELECT * FROM users WHERE id=$userId AND isadmin='Y';");
        if (mysql_num_rows($admin_rs) > 0)
            return $this->getAllItems();

        $item_rs = mysql_query("SELECT * FROM items WHERE id IN (SELECT object_id FROM object_permissions WHERE object_type='item' AND moderator_id=$userId);");
        $items = array();
        while ($item = mysql_fetch_object($item_rs))
            array_push($items, $item);
        return $items;
    }

    function saveItem($item, $userId) {

        $userId = mysql_real_escape_string($userId);
        $item->label = mysql_real_escape_string($item->label);
        $item->icon = mysql_real_escape_string($item->icon);
        $item->description = mysql_real_escape_string($item->description);
        $item->color = mysql_real_escape_string($item->color);
        $item->useCount = mysql_real_escape_string($item->useCount);
        $item->cooldown = mysql_real_escape_string($item->cooldown);
        $item->price = mysql_real_escape_string($item->price);
        $item->is_sellable = mysql_real_escape_string($item->is_sellable);

        if ($item->id == 0) {
            mysql_query("INSERT INTO items (label, icon, description, color, price, is_sellable, number_of_uses, cooldown, last_modified, last_modified_by, category_id) VALUES ('$item->label', '$item->icon', '$item->description', '$item->color', $item->price, $item->is_sellable, $item->useCount, $item->cooldown, NOW(), $userId, $item->category_id);");
            $itemId = mysql_insert_id();
            mysql_query("INSERT INTO object_permissions (object_type, object_id, moderator_id) VALUES ('item', $itemId, $userId);");
        } else {
            $itemId = $item->id;
            mysql_query("UPDATE items SET label='$item->label', icon='$item->icon', description='$item->description', color='$item->color', price=$item->price, is_sellable=$item->is_sellable, number_of_uses=$item->useCount, cooldown=$item->cooldown, last_modified=NOW(), last_modified_by=$userId, category_id=$item->category_id WHERE id=$itemId;");
            mysql_query("DELETE FROM functions_to_items WHERE item_id=$itemId;");
            mysql_query("DELETE FROM conditions_to_items WHERE item_id=$itemId;");
        }

        foreach ($item->functionIds as $functionId)
            mysql_query("INSERT INTO functions_to_items (item_id, function_id) VALUES ($itemId, $functionId);");

        foreach ($item->conditionIds as $conditionId)
            mysql_query("INSERT INTO conditions_to_items (item_id, condition_id) VALUES ($itemId, $conditionId);");

        return mysql_error();
        return $this->getItemById($itemId);
    }

    function getItemById($itemId) {
        $itemId = mysql_real_escape_string($itemId);

        $item_rs = mysql_query("SELECT * FROM items WHERE id=$itemId;");
        $item = mysql_fetch_object($item_rs);

        $item->functions = $this->getItemFunctions($itemId);
        $item->conditions = $this->getItemConditions($itemId);

        return $item;
    }

    function getItemByI2aId($i2aId) {
        $query = "SELECT items.id,
                         items_to_avatars.id AS i2a_id,
                         label,
                         icon,
                         description,
                         color,
                         is_sellable,
                         price,
                         number_of_uses,
                         cooldown,
                         uses_left,
                         last_used,
                         cooldown - TIME_TO_SEC(TIMEDIFF(NOW(), last_used)) AS time_left
                         FROM `items_to_avatars` LEFT JOIN items ON item_id=items.id WHERE items_to_avatars.id=$i2aId;";
        $item_rs = mysql_query($query);

        return mysql_fetch_object($item_rs);
    }

    function useItem($i2aId) {
        mysql_query("UPDATE items_to_avatars SET uses_left=uses_left-1, last_used=NOW() WHERE id=$i2aId;");
        mysql_query("DELETE FROM items_to_avatars WHERE uses_left<=0 AND item_id IN (SELECT id FROM items WHERE number_of_uses>0);");
    }

    function buyItem($avatarId, $shopId, $itemId) {
        $money = mysql_fetch_object(mysql_query("SELECT value FROM avatar_vars WHERE label='money' AND avatar_id=$avatarId;"))->value; 
        $sell_proc = mysql_fetch_object(mysql_query("SELECT sell_proc FROM shops WHERE id=$shopId;"))->sell_proc;
        $price = mysql_fetch_object(mysql_query("SELECT price FROM items WHERE id=$itemId;"))->price * (1 + $sell_proc / 100);       

        if ($money >= $price) {
            mysql_query("UPDATE avatar_vars SET value=value-$price WHERE label='money' AND avatar_id=$avatarId;");
            $this->addItem($avatarId, $itemId);
            return true;
        } else {
			return false;
		}
            
    }

    function sellItem($avatarId, $shopId, $i2aId) {
        $buy_proc = mysql_fetch_object(mysql_query("SELECT buy_proc FROM shops WHERE id=$shopId;"))->buy_proc;
        $price = mysql_fetch_object(mysql_query("SELECT price FROM items WHERE id IN (SELECT item_id FROM items_to_avatars WHERE id=$i2aId);"))->price * (1 - $buy_proc / 100);
        //if ($price)

        mysql_query("UPDATE avatar_vars SET value=value+$price WHERE label='money' AND avatar_id=$avatarId;");
        mysql_query("DELETE FROM items_to_avatars WHERE id=$i2aId;");
		return true;
    }

    function getAvatarItems($avatarId) {
        $avatarId = mysql_real_escape_string($avatarId);

        $query = "SELECT items.id,
                         items_to_avatars.id AS i2a_id,
                         label,
                         icon,
                         description,
                         color,
                         is_sellable,
                         price,
                         number_of_uses,
                         cooldown,
                         uses_left,
                         last_used,
                         cooldown - TIME_TO_SEC(TIMEDIFF(NOW(), last_used)) AS time_left
                         FROM `items_to_avatars` LEFT JOIN items ON item_id=items.id WHERE avatar_id=$avatarId;";

        $item_rs = mysql_query($query);
        $items = array();

        while ($item = mysql_fetch_object($item_rs)) {
            $item->functions = $this->getItemFunctions($item->id);
            $item->conditions = $this->getItemConditions($item->id);
            $items[] = $item;
        }

        return $items;
    }

    function getItemFunctions($itemId) {
        $function_rs = mysql_query("SELECT * FROM functions_to_items WHERE item_id=$itemId;");
        $functionsClass = new Functions();
        $functions = array();
        while ($function = mysql_fetch_object($function_rs))
            $functions[] = $functionsClass->getFunctionById($function->function_id);
        return $functions;
    }

    function getItemConditions($itemId) {
        $condition_rs = mysql_query("SELECT * FROM conditions_to_items WHERE item_id=$itemId;");
        $conditionsClass = new Conditions();
        $conditions = array();
        while ($condition = mysql_fetch_object($condition_rs))
            $conditions[] = $conditionsClass->getConditionById($condition->condition_id);
        return $conditions;
    }

    function addItem($avatarId, $itemId) {
        $avatarId = mysql_real_escape_string($avatarId);
        $itemId = mysql_real_escape_string($itemId);

        $item_rs = mysql_query("SELECT * FROM items WHERE id=$itemId;");
        $item = mysql_fetch_object($item_rs);

        mysql_query("INSERT INTO items_to_avatars (avatar_id, item_id, uses_left, last_used) VALUES ($avatarId, $itemId, $item->number_of_uses, DATE_SUB(NOW(), INTERVAL $item->cooldown SECOND));");
    }

    function removeItem($avatarId, $itemId) {
        $avatarId = mysql_real_escape_string($avatarId);
        $itemId = mysql_real_escape_string($itemId);

        mysql_query("DELETE FROM items_to_avatars WHERE avatar_id=$avatarId AND item_id=$itemId LIMIT 1;");
    }

    function executeDeal($myId, $partnerId, $data) {
        mysql_query("UPDATE avatar_vars SET value=value-$data->moneyToGive+$data->moneyToGet WHERE avatar_id=$myId AND label='money';");
        mysql_query("UPDATE avatar_vars SET value=value+$data->moneyToGive-$data->moneyToGet WHERE avatar_id=$partnerId AND label='money';");


        foreach ($data->itemsToGiveIds as $i2aId)
            mysql_query("UPDATE items_to_avatars SET avatar_id=$partnerId WHERE id=$i2aId;");


        foreach ($data->itemsToGetIds as $i2aId)
            mysql_query("UPDATE items_to_avatars SET avatar_id=$myId WHERE id=$i2aId;");
    }
	
	function hasItemCondition ( $avatarId, $itemId ) {
		$stm = $this->con->prepare("SELECT * FROM items_to_avatars WHERE avatar_id=? AND item_id=?");
		$stm->execute( array( $avatarId, $itemId ) );
		return ( $stm->rowCount() > 0 );
		
	}
	
	function hasMoreOrEqualItemsCondition ( $avatarId, $itemId, $amount ) {
		
		$stm = $this->con->prepare("SELECT COUNT(*) FROM items_to_avatars WHERE avatar_id = ? AND item_id = ?");
		$stm->execute( array($avatarId, $itemId) );
		
		return ( $stm->fetchColumn(0) >= $amount );
		
	}
	
}

?>