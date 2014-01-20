package dm.game.data.service {
	import ucc.data.service.Service;
	

/**
 * User service
 * @version $Id: UserService.as 207 2013-09-04 14:31:08Z rytis.alekna $
 */
public class UserService extends Service {
	
	/** SERVICE_NAME */
	public static const SERVICE_NAME : String = "dm.User.";
	
	/**
	 * Class constructor
	 */
	public function UserService() {
		
	}
	
	/**
	 * Get room builder permissions
	 * @param	userId
	 * @param	roomName
	 * @return
	 */
	public static function getRoomBuilderPermissions ( userId : int, roomName : String ) : Service {
		return createService( SERVICE_NAME + "getRoomBuilderPermissions", [userId, roomName] );
	}
	
	/**
	 * Register user
	 * @param	username
	 * @param	password
	 * @param	external	true if user login is externa
	 * @return	true on success
	 */
	public static function register( username : String, password : String, external : Boolean = false ) : Service {
		return createService( SERVICE_NAME + "register", [username, password, external] );
	}
	
	/**
	 * Login
	 * @param	username
	 * @param	password
	 * @param	moodle true if using moodle login
	 */
	public static function login( username : String, password : String, moodle : Boolean ) : Service {
		return createService( SERVICE_NAME + "login", [username, password, moodle] );
	}
	
	/**
	 * Is user info set
	 * @param	id
	 * @return	
	 */
	public static function isUserInfoSet ( id : int ) : Service {
		return createService( SERVICE_NAME + "isUserInfoSet", [id] );
	}
	
	/**
	 * Set user info
	 * @param	id
	 * @param	name
	 * @param	surname
	 * @param	email
	 * @param	schoolId
	 * @param	schoolClass
	 * @param	city
	 * @return
	 */
	public static function setUserInfo ( id : int, name : String, surname : String, email : String, schoolId : int, schoolClass : String, city : String, isParent : Boolean ) : Service {
		return createService( SERVICE_NAME + "setUserInfo", [id, name, surname, email, schoolId, schoolClass, city, isParent ] );
	}
	
	/**
	 * Get the all schools
	 * @return	schools
	 */
	public static function getAllSchools () : Service {
		return createService( SERVICE_NAME + "getAllSchools" );
	}
	
}

}