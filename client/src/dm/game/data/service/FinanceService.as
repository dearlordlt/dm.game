package dm.game.data.service {
	import ucc.data.service.Service;
	

/**
 * Finance service
 * @version $Id: FinanceService.as 215 2013-09-29 14:28:49Z rytis.alekna $
 */
public class FinanceService extends Service {
		
	/** SERVICE_NAME */
	public static const SERVICE_NAME : String = "dm.Finance.";
	
	public static function getAvatarFinanceLog ( avatarId : int ) : Service {
		return createService( SERVICE_NAME + "getAvatarFinanceLog", [avatarId] );
	}
	
}

}