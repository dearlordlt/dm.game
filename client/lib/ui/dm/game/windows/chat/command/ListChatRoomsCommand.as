package dm.game.windows.chat.command {
	import dm.game.data.service.ChatRoomsService;
	import dm.game.functions.BaseExecutable;
	

/**
 * 
 * @version $Id: ListChatRoomsCommand.as 213 2013-09-27 15:34:47Z rytis.alekna $
 */
public class ListChatRoomsCommand extends BaseExecutable {
	
	/**
	 *	@inheritDoc
	 */
	public override function execute (  ) : void {
		
		ChatRoomsService.getAllRooms()
			.addResponders( this.onChatRoomsLoaded )
			.call();
		
	}
	
	/**
	 *	On chat rooms loaded
	 */
	protected function onChatRoomsLoaded ( response : Array ) : void {
		var roomsLabels  : Array = response.map( this.listFromData );
		this.onResult( roomsLabels, false );
	}
	
	/**
	 * List from data
	 * @param	item
	 * @param	index
	 * @param	array
	 * @return
	 */
	private function listFromData ( item : Object, index : int, array : Array ) : String {
		return item.label + "<br>";
	}
	
}

}