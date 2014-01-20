package dm.game.windows.avatar.tab.result {
	import dm.game.managers.MyManager;
	import fl.controls.DataGrid;
	import fl.controls.Label;
	import flash.events.Event;
	import ucc.project.tag.service.TagsService;
	import ucc.ui.dataview.DataViewBuilder;
	import ucc.ui.window.tab.TabView;
	

/**
 * Achievements tab
 * @version $Id: AchievementsTab.as 198 2013-07-29 23:05:53Z rytis.alekna $
 */
public class AchievementsTab extends TabView {
	
	/** ACHIEVEMENTS */
	public static const ACHIEVEMENTS 				: String = "achievements";
	
	/** List */
	public var listDO								: DataGrid;

	/** Achievement description label */
	public var achievementDescriptionLabelDO		: Label;	
		
	/** All achievements */
	protected var allAchievements					: Array;
	
	/** avatarId */
	protected var avatarId : Number;
	
	/**
	 * Class constructor
	 */
	public function AchievementsTab( avatarId : Number = NaN ) {
		
		if ( avatarId ) {
			this.avatarId = avatarId;
		} else {
			this.avatarId = MyManager.instance.avatar.id;
		}		
		
		TagsService.getAllTagsByGroupLabel( ACHIEVEMENTS )
			.addResponders( this.onAllAchievementsLoaded )
			.call();
		
		( new DataViewBuilder( this.listDO ) )
			.createColumn( "translated_label", _("Achievement") )
			.setDataTransformer( this.translateLabel )
			.setService( TagsService.getAvatarTagsByGroupLabel( this.avatarId, ACHIEVEMENTS ) )
			.refresh();
			
		this.listDO.addEventListener(Event.CHANGE, this.onListChange );
	}
	
	/**
	 *	On all achievements loaded
	 */
	protected function onAllAchievementsLoaded ( data : Array ) : void {
		this.allAchievements = data;
	}
	
	/**
	 *	Translate competence
	 */
	protected function translateLabel ( data : Array ) : Array {
		
		for each( var item : Object in data ) {
			item.translated_label = _(item.label);
		}
		
		return data;
		
	}	
	
	/**
	 *	On list change
	 */
	protected function onListChange ( event : Event ) : void {
		
		var selectedLabel : String = this.listDO.selectedItem.label;
		
		for each( var item : Object in this.allAchievements ) {
			
			if ( item.label == selectedLabel ) {
				this.achievementDescriptionLabelDO.text = _(item.comment);
				return;
			}
			
		}
		
		this.achievementDescriptionLabelDO.text = "";
		
		
	}
	
}

}