package dm.game.util  {
	import dm.game.managers.MyManager;
	import org.as3commons.lang.IllegalStateError;
	
/**
 * Various avatr utils
 *
 * @version $Id: AvatarUtil.as 214 2013-09-28 18:03:54Z rytis.alekna $
 */
public class AvatarUtil {
	
	public static function isAvatarMe ( avatarId : int ) : Boolean {
		if ( !MyManager.instance.avatar ) {
			throw new IllegalStateError("Avatar is not selected!");
		}
		return ( MyManager.instance.avatar.id == avatarId );
	}
	
}
	
}