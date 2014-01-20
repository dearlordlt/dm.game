package dm.game.data.service {
	import ucc.data.service.Service;
	

/**
 * 
 * @version $Id: ShopService.as 214 2013-09-28 18:03:54Z rytis.alekna $
 */
public class ShopService extends Service {
		
	/** SERVICE_NAME */
	public static const SERVICE_NAME : String = "dm.Shop.";
	
	/**
	 * (Constructor)
	 * - Returns a new ShopService instance
	 */
	public function ShopService() {
		
	}
	
	public static function getShopById( shopId : int ) : Service {
		return createService( SERVICE_NAME + "getShopById", [shopId] );
	}
	
}

}