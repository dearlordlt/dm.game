package dm.game.data.service {
	import ucc.data.service.Service;
	

/**
 * Chat rooms
 * @version $Id: ChatRoomsService.as 213 2013-09-27 15:34:47Z rytis.alekna $
 */
public class ChatRoomsService extends Service {
		
	/** SERVICE_NAME */
	public static const SERVICE_NAME : String = "dm.ChatRooms.";
	
	/**
	 * (Constructor)
	 * - Returns a new ChatRoomsService instance
	 */
	public function ChatRoomsService() {
		
	}
	
	public static function addRoom ( label : String, description : String, createdBy : int ) : Service {
		return createService( SERVICE_NAME + "addRoom", [label, description, createdBy] );
	}
		
	public static function removeRoom ( id : int ) : Service {
		return createService( SERVICE_NAME + "removeRoom", [id] );
	}
	
	public static function updateRoom ( id : int, label : String, description : String, modifiedBy : int ) : Service {
		return createService( SERVICE_NAME + "updateRoom", [id, label, description, modifiedBy] );
	}
	
	public static function getAllRooms () : Service {
		return createService( SERVICE_NAME + "getAllRooms" );
	}
	
	
}

}