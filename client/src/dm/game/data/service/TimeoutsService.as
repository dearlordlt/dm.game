package dm.game.data.service {
	import ucc.data.service.Service;
	import ucc.error.IllegalArgumentException;
	

/**
 * 
 * @version $Id: TimeoutsService.as 214 2013-09-28 18:03:54Z rytis.alekna $
 */
public class TimeoutsService extends Service {
		
	/** SECOND */
	public static const SECOND : String = "second";
		
	/** MINUTE */
	public static const MINUTE : String = "minute";
		
	/** HOUR */
	public static const HOUR : String = "hour";
		
	/** DAY */
	public static const DAY : String = "day";
		
	/** WEEK */
	public static const WEEK : String = "week";
		
	/** MONTH */
	public static const MONTH : String = "month";
		
	/** SERVICE_NAME */
	public static const SERVICE_NAME : String = "dm.Timeouts.";
	
	/**
	 * (Constructor)
	 * - Returns a new TimeoutsService instance
	 */
	public function TimeoutsService() {
		
	}
	
	public static function setTimeout ( avatarId : int, timeoutLabel : String, timeout : int, unit : String ) : Service {
		timeout = Math.max( 0, timeout );
		if ( ( [ SECOND, MINUTE, HOUR, DAY, WEEK, MONTH ] as Array ).indexOf( unit.toLowerCase() ) == -1 ) {
			throw new IllegalArgumentException( "You must use one these units [ SECOND, MINUTE, HOUR, DAY, WEEK, MONTH ]!" );
		}
		
		return createService( SERVICE_NAME + "setTimeout", [avatarId, timeoutLabel, timeout, unit] );
	}
	
	public static function timeoutPassed ( avatarId : int, timeoutLabel : String ) : Service {
		return createService( SERVICE_NAME + "timeoutPassed", [avatarId, timeoutLabel] );
	}
	
}

}