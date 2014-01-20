package dm.game {
	import dm.game.managers.MyManager;
	import dm.game.windows.chat.ChatServerManager;
	import fl.controls.Button;
	import fl.controls.TextInput;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	

/**
 * 
 * @version $Id: ChatTest.as 214 2013-09-28 18:03:54Z rytis.alekna $
 */
public class ChatTest extends Sprite {
	
	/** Input */
	public var inputDO		: TextInput;

	/** Submit */
	public var submitDO		: Button;	
	
	public var roomDO		: TextInput;
	
	public var joinDO		: Button;
	
	/** chatManager */
	protected var chatManager : ChatServerManager;
	
	/**
	 * (Constructor)
	 * - Returns a new ChatTest instance
	 */
	public function ChatTest() {
		
		MyManager.instance.avatar = { };
		MyManager.instance.avatar.name = "arytis1"
		MyManager.instance.avatar.id = 0;
		MyManager.instance.avatar.character_type = 0;
		MyManager.instance.school =  { id : 0 };
		
		this.chatManager = ChatServerManager.getInstance();
		
		this.chatManager.setConnectionCredentials( "213.190.49.139:9899", "ChatZone" );
		this.chatManager.connect();
		
		
		this.submitDO.addEventListener( MouseEvent.CLICK, this.onSubmitClick );
		
		this.joinDO.addEventListener( MouseEvent.CLICK, this.onJoinClick );
		
	}
	
	/**
	 *	
	 */
	protected function onSubmitClick ( event : MouseEvent) : void {
		this.chatManager.sendPublicMessage( this.inputDO.text, this.roomDO.text );
	}
	
	/**
	 *	On join click
	 */
	protected function onJoinClick ( event : MouseEvent) : void {
		this.chatManager.joinRoom( this.roomDO.text );
	}
	
}

}