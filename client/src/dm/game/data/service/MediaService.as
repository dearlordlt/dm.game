package dm.game.data.service {
	import ucc.data.service.Service;
	

/**
 * Media service
 * @version $Id: MediaService.as 191 2013-07-25 12:00:17Z rytis.alekna $
 */
public class MediaService extends Service {
		
	/** SERVICE_NAME */
	public static const SERVICE_NAME : String = "dm.Media.";
	
	public static function getAllMedia () : Service {
		return createService( SERVICE_NAME + "getAllMedia" );
	}
	
	public static function getMediaById ( id : int ) : Service {
		return createService( SERVICE_NAME + "getMediaById", [id] );
	}
	
	public static function getAllMediaCategories () : Service {
		return createService( SERVICE_NAME + "getAllMediaCategories" );
	}
	
	public static function createNewCategory ( label : String ) : Service {
		return createService( SERVICE_NAME + "createNewCategory", [label] );
	}
	
}

}