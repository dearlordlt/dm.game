package dm.game.windows.dialogviewer {
	
import flash.events.Event;
	
/**
 * Option event
 * 
 * @version $Id: OptionEvent.as 204 2013-08-27 08:53:09Z rytis.alekna $
 */
public class OptionEvent extends Event {
	
	/** Name event */
	public static const SELECTED 	: String = "dm.game.windows.dialogviewer.OptionEvent.SELECTED";
	
	
	/**
	 * Constructor
	 */
	public function OptionEvent( type : String ) { 
		super( type );
	} 
	
}

}