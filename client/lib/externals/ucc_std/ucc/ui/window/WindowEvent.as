package ucc.ui.window {
	
import flash.events.Event;
	
/**
 * Window event
 * 
 * @version $Id: WindowEvent.as 22 2013-04-24 14:27:48Z rytis.alekna $
 */
public class WindowEvent extends Event {
	
	/** Close event */
	public static const CLOSE 					: String = "ucc.ui.window.WindowEvent.CLOSE";
	
	/** Window focus in event */
	public static const WINDOW_FOCUS_IN 		: String = "ucc.ui.window.WindowEvent.WINDOW_FOCUS_IN";
	
	/** Window focus out event */
	public static const WINDOW_FOCUS_OUT 		: String = "ucc.ui.window.WindowEvent.WINDOW_FOCUS_OUT";
	
	/** REDRAW event */
	public static const REDRAW 					: String = "ucc.ui.window.WindowEvent.REDRAW";
	
	/**
	 * Constructor
	 */
	public function WindowEvent( type : String, bubbles : Boolean = false ) { 
		super( type, bubbles );
	} 
	
	
	/**
	 *	@inheritDoc
	 */
	public override function clone () : Event {
		return new WindowEvent( this.type, this.bubbles );
	}
	
}

}