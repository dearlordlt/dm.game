package ucc.util  {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.setTimeout;
	import ucc.data.event.FrameImpulse;
	
/**
 * Function utils
 *
 * @version $Id: FunctionUtil.as 31 2013-05-14 12:06:40Z rytis.alekna $
 */
public class FunctionUtil {
	
	/**
	 * Calls function later
	 * @param	callback
	 * @param	...args
	 */
	public static function callLater ( callback : Function, ...args ) : void {
		setTimeout.apply( null, ( [callback, 1] ).concat( args ) );
	}
	
}
	
}