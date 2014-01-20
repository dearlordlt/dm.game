package dm.game.data.service {
	import ucc.data.service.Service;
	

/**
 * 
 * @version $Id: EnvironmentStateEditorService.as 212 2013-09-26 05:52:06Z rytis.alekna $
 */
public class EnvironmentStateEditorService extends Service {
		
	/** SERVICE_NAME */
	public static const SERVICE_NAME : String = "dm.EnvironmentStateEditor.";
	
	/**
	 * (Constructor)
	 * - Returns a new EnvironmentStateEditorService instance
	 */
	public function EnvironmentStateEditorService() {
		
	}
	
	/**
	 * Gets the all states
	 */
	public static function getAllStates() : Service {
		return createService( SERVICE_NAME + "getAllStates" );
	}
	
	/**
	 * Gets the state by the specified stateId.
	 */
	public static function getStateById( stateId : int ) : Service {
		return createService( SERVICE_NAME + "getStateById", [stateId] );
	}
	
	/**
	 * Save state
	 */
	public static function saveState( state : Object, userId : int ) : Service {
		return createService( SERVICE_NAME + "saveState", [state, userId] );
	}
	
	/**
	 * Gets the all particle textures
	 */
	public static function getAllParticleTextures() : Service {
		return createService( SERVICE_NAME + "getAllParticleTextures" );
	}
	
	/**
	 * Gets the all audios
	 */
	public static function getAllAudios() : Service {
		return createService( SERVICE_NAME + "getAllAudios" );
	}
	
	/**
	 * Save room
	 */
	public static function saveRoom( id : int, label : String, mapId : int ) : Service {
		return createService( SERVICE_NAME + "saveRoom", [id, label, mapId] );
	}
	
	/**
	 * Gets the all rooms
	 */
	public static function getAllRooms() : Service {
		return createService( SERVICE_NAME + "getAllRooms" );
	}
	
}

}