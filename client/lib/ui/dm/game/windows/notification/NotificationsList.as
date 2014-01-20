package dm.game.windows.notification  {
	import dm.game.data.service.NotificationsService;
	import dm.game.managers.MyManager;
	import dm.game.windows.DmWindow;
	import dm.game.windows.menu.Menu;
	import fl.controls.DataGrid;
	import fl.events.ListEvent;
	import ucc.ui.dataview.DataViewBuilder;
	
/**
 * Notifications list
 *
 * @version $Id: NotificationsList.as 153 2013-06-04 07:07:12Z rytis.alekna $
 */
public class NotificationsList extends DmWindow {
	
	/** List */
	public var listDO					: DataGrid;	
	
	/** Data view builder */
	protected var dataViewBuilder		: DataViewBuilder;
	
	/**
	 * Class constructor
	 */
	public function NotificationsList () {
		super( null, _("Notifications") )
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function initialize () : void {
		
		this.dataViewBuilder = new DataViewBuilder( this.listDO );
		
		this.dataViewBuilder
			.createColumn( "notification", _("Notification") )
			.createColumn( "notification_time", _("Time") )
			.setService( NotificationsService.getNotifications( MyManager.instance.avatar.id ) );
			
		this.update();
		
		this.listDO.addEventListener( ListEvent.ITEM_CLICK, this.onListItemClick );
		
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function update ( ...data ) : void {
		this.dataViewBuilder.refresh();
	}
	
	/**
	 * Inspect notifications
	 * @param	data
	 * @return
	 */
	protected function inspectNotifications ( data : Array ) : Array {
		return data;
	}
	
	/**
	 *	On list item click
	 */
	protected function onListItemClick ( event : ListEvent) : void {
		new NotificationView( event.item );
	}
	
}
	
}