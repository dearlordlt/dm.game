package dm.game.data.service.friend {
	
/**
 * Friendship status
 * 
 * @version $Id: FriendshipStatus.as 139 2013-05-27 06:01:17Z rytis.alekna $
 */
public class FriendshipStatus {
	
	public static const NOT_FRIENDS 					: int = 0;
	public static const CONFIRMED 						: int = 1;
	public static const AWAITING_AVATAR_CONFIRMATION 	: int = 2;
	public static const AWATING_FRIEND_CONFIRMATION 	: int = 3;
	public static const BLOCKED_BY_AVATAR 				: int = 4;
	public static const BLOCKED_BY_FRIEND 				: int = 5;
	public static const BLOCKED_BY_BOTH 				: int = 6;
	
}

}