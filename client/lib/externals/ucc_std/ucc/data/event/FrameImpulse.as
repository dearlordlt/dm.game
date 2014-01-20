package ucc.data.event {
	
import ucc.error.IllegalArgumentException;
import ucc.util.ArrayUtil;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.utils.getTimer;
	
/**
 * OnEnterFrame event provider
 * 
 * @version $Id: FrameImpulse.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */

[Event(name="com.pepiplay.data.event.TimeDeltaEvent.TIMER", type="com.pepiplay.data.event.TimeDeltaEvent")]
[Event(name="enterFrame", type="flash.events.Event")]
public class FrameImpulse implements IEventDispatcher {
	
	/** Supported event types */
	private static const supportedEventTypes	: Array = [ Event.ENTER_FRAME, TimeDeltaEvent.TIMER ];
	
	/** Enter frame source */
	private var enterFrameSource	: Sprite = new Sprite();
	
	/** Last timer */
	private var lastTimer			: int;
	
	/** Singleton instance */
	private static var instance 	: FrameImpulse;
	
	/** Enter frame listeners */
	protected var eventListeners	: Object = {};
	
	/**
	 * Get singleton instance of class
	 * @return 	singleton instance	FrameImpulse
	 */
	public static function getInstance () : FrameImpulse {
		
		return FrameImpulse.instance ? FrameImpulse.instance : ( FrameImpulse.instance = new FrameImpulse() );
	}
	
	/**
	 * Private class constructor
	 * @private
	 */
	public function FrameImpulse () {
		for each( var type : String in supportedEventTypes ) {
			this.eventListeners[ type ] = [];
		}
		
		this.enterFrameSource.addEventListener( Event.ENTER_FRAME, this.onEnterFrame );
		this.lastTimer = getTimer();
		
	}
	
	/**
	 * On enter frame event handler
	 */
	protected function onEnterFrame ( event : Event ) : void {
		var currentTimer : int = getTimer();
		var delta : int = currentTimer - this.lastTimer;
		this.lastTimer = currentTimer;
		this.dispatchEvent( event );
		this.dispatchEvent( new TimeDeltaEvent( TimeDeltaEvent.TIMER, delta ) );
	}
	
	
	/**
	 *	@inheritDoc
	 */
	public function addEventListener ( type : String ,  listener : Function ,  useCapture : Boolean  = false,  priority : int  = 0,  useWeakReference : Boolean  = false ) : void {
		if ( supportedEventTypes.indexOf( type ) > -1 ) {
			if ( this.eventListeners[type].indexOf( listener ) == -1 ) {
				this.eventListeners[type].push( listener );
			}
		} else {
			throw new IllegalArgumentException( "Event of type [" + type + "] is not supported!" );
		}
	}
	
	
	/**
	 *	@inheritDoc
	 */
	public function removeEventListener ( type : String ,  listener : Function ,  useCapture : Boolean  = false ) : void {
		if ( supportedEventTypes.indexOf( type ) > -1 ) {
			if ( this.eventListeners[type].indexOf( listener ) > -1 ) {
				ArrayUtil.removeElementByReference( this.eventListeners[type], listener );
			}
		} else {
			throw new IllegalArgumentException( "Event of type [" + type + "] is not supported!" );
		}
	}
	
	/**
	 *	@inheritDoc
	 */
	public function dispatchEvent ( event : Event ) : Boolean {
		if ( supportedEventTypes.indexOf( event.type ) > -1 ) {
			for each( var listener : Function in this.eventListeners[event.type] ) {
				listener( event );
			}
		}	
		return true;
	}
	
	/**
	 *	@inheritDoc
	 */
	public function hasEventListener (type : String ) : Boolean {
		return this.eventListeners[type].length > 0;
	}
	
	/**
	 *	@inheritDoc
	 */
	public function willTrigger (type : String ) : Boolean {
		return this.hasEventListener( type );
	}
	
	/**
	 * Remove all listeners
	 */
	public function removeAllListeners () : void {
		
		this.eventListeners = { };
		
		for each( var type : String in this.eventListeners ) {
			this.eventListeners[type].length = 0;
		}
		
	}
	
	/**
	 * Dispose this event dispatcher
	 */
	public function dispose () : void {
		this.eventListeners = null;
		this.enterFrameSource.removeEventListener( Event.ENTER_FRAME, this.onEnterFrame );
		this.enterFrameSource = null;
		instance = null;
	}
	
}

}