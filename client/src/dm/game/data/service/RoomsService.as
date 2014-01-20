package dm.game.data.service {
	import ucc.data.service.Service;
	

/**
 * Rooms service
 * @version $Id: RoomsService.as 205 2013-08-29 07:02:08Z rytis.alekna $
 */
public class RoomsService extends Service {
		
	/** SERVICE_NAME */
	public static const SERVICE_NAME : String = "dm.Rooms.";
	
	/**
	 * Gets the all rooms.
	 */
	public static function getAllRooms() : Service {
		return createService( SERVICE_NAME + "getAllRooms" );
	}
	
	
	public static function saveRoom( room : Object, userId : int ) : Service {
		return createService( SERVICE_NAME + "saveRoom", [room, userId ] );
	}
	
	
}

}