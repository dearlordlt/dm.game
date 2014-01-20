package dm.game.data.service  {
	import ucc.data.service.Service;
	
/**
 * Competition service
 *
 * @version $Id: CompetitionService.as 22 2013-02-11 08:38:49Z rytis.alekna $
 */
public class CompetitionService extends Service {
		
	/** SERVICE_NAME */
	public static const SERVICE_NAME : String = "dm.Competition.";
	
	/** Get bullying competition top chart */
	public static function getBullyingCompetitionTopChart () : Service {
		return createService( SERVICE_NAME + "getBullyingCompetitionTopChart", [] );
	}
	
}
	
}