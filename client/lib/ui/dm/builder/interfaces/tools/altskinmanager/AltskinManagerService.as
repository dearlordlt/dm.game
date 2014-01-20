package dm.builder.interfaces.tools.altskinmanager {
	import ucc.data.service.Service;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class AltskinManagerService extends Service {
		
		/** SERVICE_NAME */
		public static const SERVICE_NAME:String = "dm.AltSkin.";

		public static function getUserAltskins(userId:int):Service {
			return createService(SERVICE_NAME + "getUserAltskins", [userId]);
		}
		
		public static function getAllCategories():Service {
			return createService("dm.Category.getAllCategories");
		}
		
		public static function getAltskinById(altskinId:int):Service {
			return createService(SERVICE_NAME + "getAltskinById", [altskinId]);
		}
		
		public static function saveAltskin(altskin:Object, userId:int):Service {
			return createService(SERVICE_NAME + "saveAltskin", [altskin, userId]);
		}

	
	}

}