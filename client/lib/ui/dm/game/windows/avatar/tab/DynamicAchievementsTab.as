package dm.game.windows.avatar.tab {
	import dm.game.data.service.AchievementsService;
	import dm.game.managers.MyManager;
	import dm.game.windows.alert.Alert;
	import fl.controls.DataGrid;
	import fl.events.ListEvent;
	import ucc.ui.dataview.ColumnFactory;
	import ucc.ui.dataview.DataViewBuilder;
	import ucc.ui.window.tab.TabView;
	

/**
 * 
 * @version $Id: DynamicAchievementsTab.as 199 2013-07-30 08:38:17Z rytis.alekna $
 */
public class DynamicAchievementsTab extends TabView {
	
	/** List */
	public var listDO		: DataGrid;
	
	/** avatarId */
	protected var avatarId : Number;
	
	/**
	 * (Constructor)
	 * - Returns a new DynamicAchievement instance
	 */
	public function DynamicAchievementsTab( avatarId : Number = NaN ) {

		if ( avatarId ) {
			this.avatarId = avatarId;
		} else {
			this.avatarId = MyManager.instance.avatar.id;
		}		
		
		( new DataViewBuilder( this.listDO ) )
			.createColumn( "label", _("Label") )
			.createColumn( "progress", _("Progress"))
			.setService( AchievementsService.getAvatarAchievements( this.avatarId ) )
			.refresh()
		
		this.listDO.addEventListener( ListEvent.ITEM_CLICK, this.onListItemClick );
			
	}
	
	/**
	 *	On list item click
	 */
	protected function onListItemClick ( event : ListEvent ) : void {
		Alert.show( event.item.description, event.item.label );
	}
	
}

}