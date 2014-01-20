package dm.game.windows.competition  {
	import dm.game.data.service.CompetitionService;
	import dm.game.windows.DmWindow;
	import fl.controls.DataGrid;
	import flash.display.DisplayObjectContainer;
	import ucc.ui.dataview.ColumnFactory;
	import ucc.ui.dataview.DataViewBuilder;
	
/**
 * Bullying competition statistics view
 *
 * @version $Id: BullyingCompetition.as 28 2013-02-21 15:32:33Z rytis.alekna $
 */
public class BullyingCompetition extends DmWindow {
	
	/** List */
	public var listDO					: DataGrid;
	
	/** Data view builder */
	protected var dataViewBuilder		: DataViewBuilder;
	
	/**
	 * Class constructor
	 */
	public function BullyingCompetition ( parentWindow : DisplayObjectContainer = null ) {
		super( parentWindow, "Konkursas", 280, 310 );
	}
	
	/**
	 * Init
	 */
	override public function initialize () : void {
		
		this.dataViewBuilder = ( new DataViewBuilder( this.listDO ) )
			.addColumn( 
				( new ColumnFactory( "progress" ) )
					.setHeaderText( _("Taškai") )
					.setWidth( 100 )
					.getColumn()
			)
			.addColumn(
				( new ColumnFactory( "name" ) )
					.setHeaderText( "Vardas" )
					.getColumn()
			)
			.setService( CompetitionService.getBullyingCompetitionTopChart() )
			.refresh();
			
			
		this.setChildIndex( listDO, this.numChildren - 1 );
	}
	
	
}
	
}