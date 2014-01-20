package dm.game.data.service {
	import ucc.data.service.Service;
	

/**
 * 
 * @version $Id: RoomService.as 205 2013-08-29 07:02:08Z rytis.alekna $
 */
public class RoomService extends Service {
	
	/** SERVICE_NAME */
	public static const SERVICE_NAME : String = "dm.Room.";	
	
	/**
	 * (Constructor)
	 * - Returns a new RoomService instance
	 */
	public function RoomService() {
		
	}
	
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