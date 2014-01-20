package dm.game.data.service {
	import ucc.data.service.Service;
	

/**
 * 
 * @version $Id: AchievementsService.as 198 2013-07-29 23:05:53Z rytis.alekna $
 */
public class AchievementsService extends Service {
		
	/** SERVICE_NAME */
	public static const SERVICE_NAME : String = "dm.Achievements.";
	
	/**
	 * Gets the avatar achievements of the specified avatar
	 * @param	avatarId
	 * @return
	 */
	public static function getAvatarAchievements ( avatarId : int ) : Service {
		return createService( SERVICE_NAME + "getAvatarAchievements", [avatarId] );
	}
	
}

}