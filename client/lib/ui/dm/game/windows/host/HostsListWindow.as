package dm.game.windows.host {
	import dm.game.data.service.FriendsService;
	import dm.game.managers.EsManager;
	import dm.game.managers.MyManager;
	import dm.game.windows.DmWindow;
	import fl.controls.DataGrid;
	import fl.events.ListEvent;
	import ucc.ui.dataview.DataViewBuilder;
	

/**
 * Hosts (friends that allow avatar to visit thier home)
 * @version $Id: HostsListWindow.as 189 2013-07-18 13:29:57Z zenia.sorocan $
 */
public class HostsListWindow extends DmWindow {
	
	/** List */
	public var listDO				: DataGrid;
	
	/** avatarId */
	protected var avatarId : Number;
	
	/**
	 * (Constructor)
	 * - Returns a new HostsListWindow instance
	 */
	public function HostsListWindow ( avatarId : Number = NaN ) {
		this.avatarId = avatarId;
		super( null, _("Hosts") );
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function initialize () : void {
		
		if ( isNaN( this.avatarId ) ) {
			this.avatarId = MyManager.instance.avatar.id;
		}
		
		( new DataViewBuilder( this.listDO ) )
			.createColumn( "name", _("Name") )
			.setService( FriendsService.getAllFriendsThatCanBeVisited( this.avatarId ) )
			.refresh();
		
		this.listDO.addEventListener(ListEvent.ITEM_CLICK, this.onListItemClick );
			
	}
	
	/**
	 *	On list item click
	 */
	protected function onListItemClick ( event : ListEvent) : void {
		
		var avatarId : int = event.item.id;
		
		EsManager.instance.joinRoom(EsManager.HOME_ROOM_NAME + '@' + avatarId);
		
	}
	
}

}