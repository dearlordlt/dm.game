package dm.game.data.service {
	import org.as3commons.lang.IllegalArgumentError;
	import ucc.data.service.Service;
	import ucc.error.IllegalArgumentException;
	

/**
 * Gallery service
 * @version $Id: GalleryService.as 215 2013-09-29 14:28:49Z rytis.alekna $
 */
public class GalleryService extends Service {
		
	/** Y */
	public static const Y : String = "Y";
		
	/** N */
	public static const N : String = "N";
		
	/** SERVICE_NAME */
	public static const SERVICE_NAME : String = "dm.Gallery.";
	
	public static function getAvatarImages ( avatarId : int ) : Service {
		return createService( SERVICE_NAME + "getAvatarImages", [avatarId] );
	}
	
	public static function getImageRating ( imageId : int, ratersId : int ) : Service {
		return createService( SERVICE_NAME + "getImageRating", [imageId, ratersId] );
	}
	
	public static function rateImage ( ratersId : int, imageId : int, rating : String ) : Service {
		if ( ([Y,N] as Array ).indexOf( rating ) == -1 ) {
			throw new IllegalArgumentException("Rating must be Y or N");
		}
		return createService( SERVICE_NAME + "rateImage", [ratersId, imageId, rating] );
	}
	
	public static function removeRating ( ratersId : int, imageId : int ) : Service {
		return createService( SERVICE_NAME + "removeRating", [ratersId, imageId] );
	}

}

}