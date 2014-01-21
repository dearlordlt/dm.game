package dm.game.windows.social_capital {
	import dm.game.data.service.AvatarService;
	import dm.game.windows.DmWindow;
	import fl.controls.DataGrid;
	import fl.controls.TextInput;
	import ucc.ui.dataview.DataViewBuilder;
	

/**
 * 
 * @version $Id$
 */
public class SocialCapitalWindow extends DmWindow {
	
	/** Users list */
	public var usersListDO				: DataGrid;
	
	/** Avatars list */
	public var avatarsListDO			: DataGrid;

	/** Search text input */
	public var searchTextInputDO		: TextInput;

	/** Capital list */
	public var capitalListDO			: DataGrid;
	
	/** Data view builder */
	protected var dataViewBuilder		: DataViewBuilder;
	
	/**
	 * (Constructor)
	 * - Returns a new SocialCapitalWindow instance
	 */
	public function SocialCapitalWindow() {
		super( null, _("Social capital") );
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function initialize (  ) : void {
		
		this.dataViewBuilder = ( new DataViewBuilder( this.avatarsListDO ) )
			.createColumn( "id", _("Id") )
			.createColumn( "username", _("User name") )
			.createColumn( "school", _("School") )
			.setService( AvatarService )
		
	}
	
	
}

}