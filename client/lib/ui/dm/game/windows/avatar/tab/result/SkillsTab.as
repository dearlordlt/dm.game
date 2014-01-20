package dm.game.windows.avatar.tab.result {
	import dm.game.data.service.AvatarService;
	import dm.game.managers.MyManager;
	import fl.controls.DataGrid;
	import ucc.ui.dataview.DataViewBuilder;
	import ucc.ui.window.tab.TabView;
	

/**
 * 
 * @version $Id: SkillsTab.as 198 2013-07-29 23:05:53Z rytis.alekna $
 */
public class SkillsTab extends TabView {
	
	/** List */
	public var listDO		: DataGrid;	
	
	/** avatarId */
	protected var avatarId 	: Number;
	
	/**
	 * Class constructor
	 */
	public function SkillsTab( avatarId : Number = NaN ) {
		
		if ( avatarId ) {
			this.avatarId = avatarId;
		} else {
			this.avatarId = MyManager.instance.avatar.id;
		}
		
		
		
		( new DataViewBuilder( this.listDO ) )
			.createColumn("profession", _("Profesion"))
			.createColumn("profession_level", _("Level"))
			.createColumn("profession_points", _("Points"), 30 )
			.createColumn("sub_profession", _("Specialization"))
			.setDataTransformer( this.translateProfessions )
			.setService( AvatarService.getAvatarProfessionStats( this.avatarId ) )
			.refresh();
			
		
	}
	
	
	/**
	 *	Translate professions
	 */
	protected function translateProfessions ( data : Array ) : Array {
		
		var retVal : Array = [];
		
		for each( var item : Object in data ) {
			
			if ( !this.translateOrTrimProperty( item, "profession" ) ) {
				continue;
			}
			
			this.translateOrTrimProperty( item, "profession_level" );
			this.translateOrTrimProperty( item, "sub_profession" );
			
			retVal.push( item );
			
		}
		
		return retVal;
		
	}
	
	/**
	 * Translate or trim property
	 * @param	object
	 * @param	field
	 * @return
	 */
	private function translateOrTrimProperty ( object : Object, field : String ) : Boolean {
		if ( object && object.hasOwnProperty( field ) && ( object[field] is String ) && ( object[field] != "null" ) && ( object[field].length > 0 ) ) {
			object[field] = _(object[field]);
			return true;
		} else {
			object[field] = "";
			return false;
		}
	}
	
}

}