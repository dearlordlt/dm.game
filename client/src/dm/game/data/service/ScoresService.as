package dm.game.data.service {
	import ucc.data.service.Service;
	

/**
 * Top scores service
 * @version $Id: ScoresService.as 212 2013-09-26 05:52:06Z rytis.alekna $
 */
public class ScoresService extends Service {
		
	/** SERVICE_NAME */
	public static const SERVICE_NAME : String = "dm.Scores.";
	
	/**
	 * Gets the top schools
	 */
	public static function getTopSchools () : Service {
		return createService( SERVICE_NAME + "getTopSchools" );
	}
	
	/**
	 * Gets the school top players
	 */
	public static function getSchoolTopPlayers ( schoolId : int ) : Service {
		return createService( SERVICE_NAME + "getSchoolTopPlayers", [schoolId] );
	}
	
	/**
	 * Gets the top players
	 */
	public static function getTopPlayers () : Service {
		return createService( SERVICE_NAME + "getTopPlayers" );
	}
	
}

}