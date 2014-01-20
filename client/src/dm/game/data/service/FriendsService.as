package dm.game.data.service {
	import ucc.data.service.Service;
	

/**
 * Friends service
 * @version $Id: FriendsService.as 185 2013-07-17 09:37:30Z rytis.alekna $
 */
public class FriendsService extends Service {
		
	/** SERVICE_NAME */
	public static const SERVICE_NAME : String = "dm.Friends.";
	
	
	public static function addFriend ( avatarId : int, friendId : int ) : Service {
		return createService( SERVICE_NAME + "addFriend", [ avatarId, friendId ] );
	}
	
	public static function getFriendshipStatus ( avatarId : int, friendId : int ) : Service {
		return createService( SERVICE_NAME + "getFriendshipStatus", [avatarId, friendId] );
	}
	
	
	public static function getAllAcceptedFriends ( avatarId : int ) : Service {
		return createService( SERVICE_NAME + "getAllAcceptedFriends", [avatarId] );
	}
	
	public static function removeFromFriends ( avatarId : int, friendId : int, block : Boolean = false ) : Service {
		return createService( SERVICE_NAME + "removeFromFriends", [ avatarId, friendId, block ] );
	}
	
	public static function addFriendByName ( avatarId : int, friendName : String ) : Service {
		return createService( SERVICE_NAME + "addFriendByName", [avatarId, friendName] );
	}
	
	public static function getAllFriendsThatCanBeVisited ( avatarId : int ) : Service {
		return createService( SERVICE_NAME + "getAllFriendsThatCanBeVisited", [avatarId] );
	}
	
	public static function makeFriendGuest ( avatarId : int, friendId : int, make : Boolean = true ) : Service {
		return createService( SERVICE_NAME + "makeFriendGuest", [avatarId, friendId, make] );
	}
	
}

}