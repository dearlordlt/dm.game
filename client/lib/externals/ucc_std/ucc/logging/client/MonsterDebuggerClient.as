package ucc.logging.client  {
	import com.demonsters.debugger.MonsterDebugger;
	import flash.display.DisplayObjectContainer;
	import ucc.util.sprintf;
	
/**
 * Monster debugger client
 *
 * @version $Id: MonsterDebuggerClient.as 30 2013-05-13 07:04:00Z rytis.alekna $
 */
public class MonsterDebuggerClient implements LoggingClient {
	
	public static var LEVEL_TO_COLOR	: Object = {
		DEBUG	: 0x0,
		INFO	: 0x666666,
		WARN	: 0xFF6600,
		ERROR	: 0x990000,
		FATAL	: 0xFF0000
	}
	
	/**
	 * Class constructor
	 */
	public function MonsterDebuggerClient ( root : DisplayObjectContainer ) {
		MonsterDebugger.initialize( root );
	}

	/**
	 *	@inheritDoc
	 */
	public function output ( message : *,  level : String, caller : * = null ) : void {
		// MonsterDebugger.log( sprintf( "Log(%s): %s", level, message ) )
		
		MonsterDebugger.trace( caller, message, "", level, LEVEL_TO_COLOR[level] || LEVEL_TO_COLOR["DEBUG"], 10 );
		trace( sprintf( "Log(%s): %s", level, String( message ) ) );
	}
	
}
	
}