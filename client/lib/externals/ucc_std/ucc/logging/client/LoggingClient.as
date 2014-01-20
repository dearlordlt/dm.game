package ucc.logging.client {
	
/**
 * ...
 * @version $Id: LoggingClient.as 30 2013-05-13 07:04:00Z rytis.alekna $
 */
public interface LoggingClient {
	
	/**
	 * Trace message
	 * 
	 * @param	message mesage
	 * @param	level debug level, one of Debug.LEVEL_*
	 */
	function output( message : *, level : String, caller : * = null ) : void;
	
}
	
}