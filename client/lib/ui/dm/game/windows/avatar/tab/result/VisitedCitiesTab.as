package dm.game.windows.avatar.tab.result {
	import dm.game.managers.MyManager;
	import fl.controls.DataGrid;
	import fl.controls.Label;
	import ucc.project.tag.service.TagsService;
	import ucc.ui.dataview.DataViewBuilder;
	import ucc.ui.window.tab.TabView;
	

/**
 * 
 * @version $Id: VisitedCitiesTab.as 215 2013-09-29 14:28:49Z rytis.alekna $
 */
public class VisitedCitiesTab extends TabView {
	
	/** avatarId */
	protected var avatarId : Number;
	
	/** List */
	public var listDO		: DataGrid;	
	
	/** Alert label */
	public var alertLabelDO	: Label;
	
	/**
	 * Class constructor
	 */
	public function VisitedCitiesTab( avatarId : Number = NaN ) {
		
		if ( avatarId ) {
			this.avatarId = avatarId;
		} else {
			this.avatarId = MyManager.instance.avatar.id;
		}
		
		( new DataViewBuilder( this.listDO ) )
			.createColumn( "translated_label", _("City") )
			.setDataTransformer( this.translateLabel )
			.setService( TagsService.getAvatarTagsByGroupLabel( this.avatarId, "visited_cities" ) )
			.refresh();
		
	}
	
	/**
	 *	Translate competence
	 */
	protected function translateLabel ( data : Array ) : Array {
		
		if ( data.length == 0 ) {
			this.alertLabelDO.text = _("There are no visited cities!");
		}
		
		for each( var item : Object in data ) {
			item.translated_label = _(item.label);
		}
		
		return data;	
	}
}

}