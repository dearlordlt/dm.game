package dm.game.windows.score {
	import dm.game.data.service.ScoresService;
	import dm.game.windows.DmWindow;
	import fl.controls.Button;
	import fl.controls.DataGrid;
	import fl.events.ListEvent;
	import flash.events.MouseEvent;
	import ucc.ui.dataview.DataViewBuilder;
	

/**
 * Players and cities scores
 * @version $Id: ScoresWindow.as 212 2013-09-26 05:52:06Z rytis.alekna $
 */
public class ScoresWindow extends DmWindow {
	
	/** SCHOOL_TOP_PLAYERS */
	public static const SCHOOL_TOP_PLAYERS : String = "schoolTopPlayers";
		
	/** TOP_PLAYERS */
	public static const TOP_PLAYERS 		: String = "topPlayers";
		
	/** TOP_SCHOOLS */
	public static const TOP_SCHOOLS 		: String = "topSchools";
	
	/** List */
	public var listDO						: DataGrid;

	/** Top schools button */
	public var topSchoolsButtonDO			: Button;

	/** Top school players button */
	public var topSchoolPlayersButtonDO		: Button;

	/** Top players button */
	public var topPlayersButtonDO			: Button;	
	
	/** Data view builder */
	protected var dataViewBuilder			: DataViewBuilder;
	
	/** Current mode */
	protected var currentMode				: String = TOP_SCHOOLS;
	
	/**
	 * (Constructor)
	 * - Returns a new ScoresWindow instance
	 */
	public function ScoresWindow() {
		super( null, _("Scores") );
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function initialize () : void {
		
		this.dataViewBuilder = new DataViewBuilder( this.listDO );
		
		this.topSchoolsButtonDO.addEventListener( MouseEvent.CLICK, this.onTopSchoolsButtonClick );
		
		this.topPlayersButtonDO.addEventListener( MouseEvent.CLICK, this.onTopPlayersButtonClick );
		
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function postInitialize (  ) : void {
		this.onTopSchoolsButtonClick( null );
	}
	
	/**
	 *	On top schools button click
	 */
	protected function onTopSchoolsButtonClick ( event : MouseEvent) : void {
		
		this.topPlayersButtonDO.enabled 		= true;
		this.topPlayersButtonDO.selected 		= false;
		
		
		this.topSchoolsButtonDO.enabled 		= false;
		this.topSchoolsButtonDO.selected		= true;
		
		this.topSchoolsButtonDO.emphasized			= true;
		this.topPlayersButtonDO.emphasized			= false;
		this.topSchoolPlayersButtonDO.emphasized 	= false;
		
		this.dataViewBuilder
			.removeAllColumns()
			.createColumn( "title", _("Title") )
			.createColumn( "balanced_score", _("Score"), 50 )
			.setService( ScoresService.getTopSchools() )
			.refresh();
		
		this.listDO.addEventListener( ListEvent.ITEM_CLICK, this.onSchoolItemClick );
			
	}
	
	/**
	 *	On top players button click
	 */
	protected function onTopPlayersButtonClick ( event : MouseEvent ) : void {
		
		this.topPlayersButtonDO.enabled 		=
		this.topSchoolPlayersButtonDO.enabled 	= false;
		
		this.topSchoolsButtonDO.emphasized			= false;
		this.topPlayersButtonDO.emphasized			= true;
		this.topSchoolPlayersButtonDO.emphasized 	= false;		
		
		
		this.topPlayersButtonDO.selected 		= true;
		
		this.topSchoolsButtonDO.enabled 		= true;
		this.topSchoolsButtonDO.selected 		= false;
		
		this.listDO.removeEventListener( ListEvent.ITEM_CLICK, this.onSchoolItemClick );
		;
		this.dataViewBuilder
			.removeAllColumns()
			.createColumn( "name", _("Name") )
			.createColumn( "school_title", _("School") )
			.createColumn( "balanced_score", _("Score"), 50 )
			.setService( ScoresService.getTopPlayers() )
			.refresh();
		
	}
	
	/**
	 *	On school item click
	 */
	protected function onSchoolItemClick ( event : ListEvent) : void {
		
		this.topSchoolsButtonDO.enabled 		= true;
		this.topSchoolsButtonDO.selected 		= false;
		
		this.topSchoolsButtonDO.emphasized			= false;
		this.topPlayersButtonDO.emphasized			= false;
		this.topSchoolPlayersButtonDO.emphasized 	= true;		
		
		this.topSchoolPlayersButtonDO.enabled	= false;
		this.topSchoolPlayersButtonDO.selected 	= true;
		
		this.listDO.removeEventListener( ListEvent.ITEM_CLICK, this.onSchoolItemClick );
		
		this.dataViewBuilder
			.removeAllColumns()
			.createColumn( "name", _("Name") )
			.createColumn( "balanced_score", _("Score"), 50 )
			.setService( ScoresService.getSchoolTopPlayers( event.item.id ) )
			.refresh();
		
	}
	
}

}