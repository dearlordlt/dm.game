package dm.game.windows.avatar.tab {
	import dm.game.data.service.FriendsService;
	import dm.game.managers.MyManager;
	import dm.game.windows.alert.Alert;
	import fl.controls.Button;
	import fl.controls.DataGrid;
	import fl.events.ListEvent;
	import flash.events.MouseEvent;
	import ucc.ui.dataview.DataViewBuilder;
	import ucc.ui.window.tab.TabView;
	

/**
 * Friends tab
 * @version $Id: FriendsTab.as 204 2013-08-27 08:53:09Z rytis.alekna $
 */
public class FriendsTab extends TabView {
	
	/** List */
	public var listDO					: DataGrid;	
	
	/** Allow friend to visit  */
	public var allowVisitButtonDO		: Button;
	
	/** Disallow visit */
	public var disallowVisitButtonDO	: Button;
	
	/** Data view builder */
	protected var dataViewBuilder		: DataViewBuilder;	
	
	/** avatarId */
	protected var avatarId 				: Number;
	
	/**
	 * Friends tab
	 */
	public function FriendsTab( avatarId : Number = NaN ) {
		
		if ( avatarId ) {
			this.avatarId = avatarId;
		} else {
			this.avatarId = MyManager.instance.avatar.id;
		}
		
		this.dataViewBuilder = new DataViewBuilder( this.listDO );
		
		this.dataViewBuilder
			.createColumn( "name", _("Name") )
			.createColumn( "can_visit", _("Can visit") )
			.setService( FriendsService.getAllAcceptedFriends( this.avatarId ) )
			.refresh();
		
		if ( this.isOwner() ) {
			this.allowVisitButtonDO.addEventListener( MouseEvent.CLICK, this.onAllowVisitButtonClick );
			this.disallowVisitButtonDO.addEventListener( MouseEvent.CLICK, this.onDisallowVisitButtonClick );
			this.listDO.addEventListener( ListEvent.ITEM_CLICK, this.onListItemClick );
		} else {
			this.allowVisitButtonDO.visible = false;
			this.disallowVisitButtonDO.visible = false;
		}
			
	}
	
	/**
	 * Determinates whether avatar is owner of this profile.
	 */
	protected function isOwner () : Boolean {
		return ( this.avatarId == MyManager.instance.avatar.id );
	}
	
	/**
	 *	On allow visit button click
	 */
	protected function onAllowVisitButtonClick ( event : MouseEvent) : void {
		
		FriendsService.makeFriendGuest( MyManager.instance.avatar.id, this.listDO.selectedItem.id, true )
			.addResponders( this.onPermissionChanged )
			.call();
		
	}
	
	/**
	 *	On list item click
	 */
	protected function onListItemClick ( event : ListEvent) : void {
		
		var canVisit : Boolean = Boolean( int( event.item.can_visit ) );
		
		this.allowVisitButtonDO.enabled = !canVisit;
		
		this.disallowVisitButtonDO.enabled = canVisit;
		
	}
	
	
	/**
	 *	On permission changed
	 */
	protected function onPermissionChanged () : void {
		Alert.show( _("Permission to visit your home changed!") );
		this.dataViewBuilder.refresh();
	}
	
	/**
	 *	On disallow visit button click
	 */
	protected function onDisallowVisitButtonClick ( event : MouseEvent) : void {
		FriendsService.makeFriendGuest( MyManager.instance.avatar.id, this.listDO.selectedItem.id, false )
			.addResponders( this.onPermissionChanged )
			.call();
		
	}
	
}

}