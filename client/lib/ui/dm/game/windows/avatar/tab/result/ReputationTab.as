package dm.game.windows.avatar.tab.result {
	import dm.game.managers.MyManager;
	import fl.controls.DataGrid;
	import ucc.project.tag.service.TagsService;
	import ucc.ui.dataview.DataViewBuilder;
	import ucc.ui.window.tab.TabView;
	

/**
 * Reputation tab
 * @version $Id: ReputationTab.as 198 2013-07-29 23:05:53Z rytis.alekna $
 */
public class ReputationTab extends TabView {
	
	/** avatarId */
	protected var avatarId : Number;
	
	/** List */
	public var listDO		: DataGrid;	
	
	/**
	 * Reputation tab
	 */
	public function ReputationTab( avatarId : Number = NaN ) {
		
		if ( avatarId ) {
			this.avatarId = avatarId;
		} else {
			this.avatarId = MyManager.instance.avatar.id;
		}
		
		( new DataViewBuilder( this.listDO ) )
			.createColumn( "label", _("Competence") )
			.createColumn( "value", _("Points"), 50 )
			.setDataTransformer( this.translateCompetences )
			.setService( TagsService.getAvatarTagsByGroupLabel( this.avatarId, "progress" ) )
			.refresh();
		
	}
	
	/**
	 *	Translate competence
	 */
	protected function translateCompetences ( data : Array ) : Array {
		
		for each( var item : Object in data ) {
			item.label = _(item.label);
		}
		
		return data;
		
	}
	
}

}