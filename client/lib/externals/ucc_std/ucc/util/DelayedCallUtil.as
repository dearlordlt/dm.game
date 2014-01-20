package ucc.util  {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import ucc.data.event.FrameImpulse;
	
/**
 * Delayed call util
 *
 * @version $Id: DelayedCallUtil.as 10 2013-02-25 10:12:47Z rytis.alekna $
 */
public class DelayedCallUtil {
	
	/** Listeners */
	private static var listeners	: Dictionary = new Dictionary();
	
	/** Listens to EnterFrameBeacon? */
	private static var listens		: Boolean;
	
	/** Exit frame beacon */
	private static var exitFrameBeacon	: Sprite = new Sprite();
	
	/**
	 * Cal method on next enter frame once
	 * @param	callback
	 * @param	... params
	 */
	public static function callLater ( listener : Function, ... params ) : void {
		
		if ( !listens ) {
			listens = true;
			exitFrameBeacon.addEventListener( Event.EXIT_FRAME, onEnterFrame, false, -int.MIN_VALUE );
		}
		
		listeners[ listener ] = params;
		
	}
	
	/**
	 * On enter frame
	 * @param	event
	 */
	private static function onEnterFrame ( event : Event ) : void {
		
		for ( var listener : Object in listeners ) {
			( listener as Function ).apply( null, listeners[listener] );
			delete listeners[listener];
		}
		
		listens = false;
		exitFrameBeacon.removeEventListener( Event.EXIT_FRAME, onEnterFrame );
		
	}
	
}
	
}