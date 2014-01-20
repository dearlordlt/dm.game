package dm.game.data.service  {
	import ucc.data.service.Service;
	
/**
 * Avatar service
 *
 * @version $Id: AvatarService.as 212 2013-09-26 05:52:06Z rytis.alekna $
 */
public class AvatarService extends Service {
	
	/** SERVICE_NAME */
	public static const SERVICE_NAME : String = "dm.Avatar.";
	
	/**
	 * Get var
	 * @param	avatarId
	 * @param	label
	 * @return
	 */
	public static function getVar ( avatarId : int, label : String ) : Service {
		return createService( SERVICE_NAME + "getVar", [ avatarId, label ] );
	}
	
	/**
	 * Get stats
	 * @param	avatarId
	 * @return
	 */
	public static function getStats ( avatarId : int ) : Service {
		return createService( SERVICE_NAME + "getStats", [avatarId] );
	}
	
	/**
	 * Get avatar description
	 * @param	avatarId
	 * @return
	 */
	public static function getAvatarDescription ( avatarId : int ) : Service {
		return createService( SERVICE_NAME + "getAvatarDescription", [avatarId] );
	}
	
	/**
	 * Set avatar description
	 * @param type $avatarId
	 */
	public static function setAvatarDescription ( avatarId : int, description : String ) : Service {
		return createService( SERVICE_NAME + "setAvatarDescription", [avatarId, description] );
	}
	
	/**
	 * Get avatar profession stats
	 * @param	avatarId
	 * @return
	 */
	public static function getAvatarProfessionStats ( avatarId : int ) : Service {	
		return createService( SERVICE_NAME + "getAvatarProfessionStats", [avatarId] );
	}
	
	/**
	 * Get avatar picture
	 * @param	$avatarId
	 */
	public static function getAvatarPicture ( avatarId : int ) : Service {
		return createService( SERVICE_NAME + "getAvatarPicture", [avatarId] );
	}
	
	/**
     * Get avatar by id
     * @param type $avatarId
     */
    public static function getAvatarByName( avatarName : String ) : Service {
		return createService( SERVICE_NAME + "getAvatarByName", [avatarName] );
	}
	
	public static function getAvatarLastLocation( avatarId : int ) : Service {
		return createService( SERVICE_NAME + "getAvatarLastLocation", [avatarId] );
	}
	
	public static function getLastAvatarRoomLabel ( avatarId : int ) : Service {
		return createService( SERVICE_NAME + "getLastAvatarRoomLabel", [avatarId] );
	}
	
	public static function getAvatarHomeTown ( avatarId : int ) : Service {
		return createService( SERVICE_NAME + "getAvatarHomeTown", [avatarId] );
	}
	
}
	
}