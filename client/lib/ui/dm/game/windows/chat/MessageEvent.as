package dm.game.windows.chat {
	
import com.electrotank.electroserver5.api.PublicMessageEvent;
import com.electrotank.electroserver5.zone.Room;
import flash.events.Event;
	
/**
 * PublicMessageEvent wrapper
 * 
 * @version $Id: MessageEvent.as 212 2013-09-26 05:52:06Z rytis.alekna $
 */
public class MessageEvent extends Event {
	
	/** Name event */
	public static const PUBLIC_MESSAGE 	: String = "dm.game.windows.chat.MessageEvent.PUBLIC_MESSAGE";
	
	/** Room */
	public var room					: Room;
	
	/** Public message event */
	public var publicMessageEvent	: PublicMessageEvent;
	
	/**
	 * Constructor
	 */
	public function MessageEvent( type : String, publicMessageEvent : PublicMessageEvent, room : Room ) { 
		super( type );
		this.publicMessageEvent = publicMessageEvent;
		this.room = room;
		
	} 
	
}

}