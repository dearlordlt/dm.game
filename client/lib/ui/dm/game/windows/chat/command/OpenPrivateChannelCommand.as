package dm.game.windows.chat.command {
	import dm.game.functions.BaseExecutable;
	import dm.game.windows.chat.Chat;
	import ucc.ui.window.WindowsManager;
	

/**
 * 
 * @version $Id: OpenPrivateChannelCommand.as 214 2013-09-28 18:03:54Z rytis.alekna $
 */
public class OpenPrivateChannelCommand extends BaseExecutable {
	
	/**
	 * (Constructor)
	 * - Returns a new OpenPrivateChannelCommand instance
	 */
	public function OpenPrivateChannelCommand() {
		
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function execute (  ) : void {
		
		var chat : Chat = WindowsManager.getInstance().getWindowByClass( Chat ) as Chat;
		
		if ( !chat ) {
			return;
		}
		
		if ( !chat.visible ) {
			chat.visible = true;
		}
		
		chat;
		
		super.execute();
	}
	
}

}