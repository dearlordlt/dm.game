<?php

class Shop {
	
	/**
	 *
	 * @var PDO
	 */
	private $con;
	
    function __construct() { //Constructor
		$this->con = PDOConnection::con(basename(__DIR__));
    }

    function getAllShops() {
        $shop_rs = mysql_query("SELECT * FROM shops;");
        while ($shop = mysql_fetch_object($shop_rs))
            $shops[] = $shop;
        return $shops;
    }

    function getUserShops($userId) {
        $userId = mysql_real_escape_string($userId);

        $admin_rs = mysql_query("SELECT * FROM users WHERE id=$userId AND isadmin='Y';");
        if (mysql_num_rows($admin_rs) > 0)
            return $this->getAllShops();

        $shop_rs = mysql_query("SELECT * FROM shop WHERE id IN (SELECT object_id FROM object_permissions WHERE object_type='shop' AND moderator_id=$userId);");

        while ($shop = mysql_fetch_object($shop_rs))
            $shops[] = $shop;
        
        return $shops;
    }

    function getShopById($shopId) {
		
		$stm = $this->con->prepare("SELECT * FROM shops WHERE id=?");
		$stm->execute( array( $shopId ) );
		$shop = $stm->fetchObject();
		
		$stm = $this->con->prepare("SELECT items.* FROM items_to_shops LEFT JOIN items ON items_to_shops.item_id=items.id WHERE items_to_shops.shop_id=?");
		$stm->execute( array( $shopId ) );
		$shop->items = $stm->fetchAll(PDO::FETCH_OBJ);
        return $shop;
    }

    function saveShop($shop, $userId) {
        if ($shop->id == 0) {
            mysql_query("INSERT INTO shops (label, sell_proc, buy_proc, is_buying, last_modified, last_modified_by) VALUES ('$shop->label', $shop->sell_proc, $shop->buy_proc, $shop->is_buying, NOW(), $userId);");
            $shop->id = mysql_insert_id();
            mysql_query("INSERT INTO object_permissions (object_type, object_id, moderator_id) VALUES ('shop', $shop->id, $userId);");
        } else
            mysql_query("UPDATE shops SET label='$shop->label', sell_proc=$shop->sell_proc, buy_proc=$shop->buy_proc, is_buying=$shop->is_buying, last_modified=NOW(), last_modified_by=$userId WHERE id=$shop->id;");

        mysql_query("DELETE FROM items_to_shops WHERE shop_id=$shop->id;");

        foreach ($shop->itemIds as $itemId)
            mysql_query("INSERT INTO items_to_shops (item_id, shop_id) VALUES ($itemId, $shop->id);");
        return $shop->label;
    }

}
?>