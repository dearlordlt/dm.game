package dm.game.data.service {
	import ucc.data.service.Service;
	

/**
 * 
 * @version $Id: ItemsService.as 216 2013-10-02 05:00:40Z rytis.alekna $
 */
public class ItemsService extends Service {
		
	/** SERVICE_NAME */
	public static const SERVICE_NAME : String = "dm.Item.";
	
	/**
	 * (Constructor)
	 * - Returns a new ItemsService instance
	 */
	public function ItemsService() {
		
	}
	
	public static function getAvatarItems( avatarId : int ) : Service {
		return createService( SERVICE_NAME + "getAvatarItems", [avatarId] );
	}
	
	public static function sellItem( avatarId : int, shopId : int, i2aId : int ) : Service {
		return createService( SERVICE_NAME + "sellItem", [avatarId, shopId, i2aId] );
	}
	
	public static function useItem( i2aId : int ) : Service {
		return createService( SERVICE_NAME + "useItem", [i2aId] );
	}
	
	public static function buyItem( avatarId : int, shopId : int, itemId : int ) : Service {
		return createService( SERVICE_NAME + "buyItem", [avatarId, shopId, itemId] );
	}
	
	public static function hasItemCondition ( avatarId : int, itemId : int ) : Service {
		return createService( SERVICE_NAME + "hasItemCondition", [avatarId, itemId] );
	}
	
	public static function hasMoreOrEqualItemsCondition ( avatarId : int, itemId : int, amount : int ) : Service {
		return createService( SERVICE_NAME + "hasMoreOrEqualItemsCondition", [avatarId, itemId, amount] );
	}
	
}

}