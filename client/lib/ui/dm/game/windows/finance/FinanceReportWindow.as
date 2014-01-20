package dm.game.windows.finance {
	import dm.game.data.service.FinanceService;
	import dm.game.managers.MyManager;
	import dm.game.util.AvatarUtil;
	import dm.game.windows.DmWindow;
	import fl.controls.DataGrid;
	import flash.display.DisplayObjectContainer;
	import ucc.ui.dataview.ColumnFactory;
	import ucc.ui.dataview.DataViewBuilder;
	

/**
 * Finance report
 * @version $Id: FinanceReportWindow.as 215 2013-09-29 14:28:49Z rytis.alekna $
 */
public class FinanceReportWindow extends DmWindow {
	
	/** Report list */
	public var reportListDO				: DataGrid;	
	
	/** avatarId */
	protected var avatarId 				: Number;
	
	/** Data view builder */
	protected var dataViewBuilder		: DataViewBuilder;
	
	/**
	 * (Constructor)
	 * - Returns a new FinanceReportWindow instance
	 */
	public function FinanceReportWindow(parent:DisplayObjectContainer = null, avatarId : Number = NaN ) {
		
		if ( isNaN( avatarId ) ) {
			this.avatarId = MyManager.instance.avatarId;
		} else {
			this.avatarId = avatarId;
		}
		
		super(parent, _("Finance report"));
			
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function initialize () : void {
		
		this.dataViewBuilder = ( new DataViewBuilder( this.reportListDO ) )
			.createColumn( "time", _("Time"), 140 )
			.addColumn(
				( new ColumnFactory( "amount" ) )
					.setCellRenderer( AmountCellRenderer )
					.setWidth( 60 )
					.setHeaderText( _("Amount") )
					.getColumn()
			)
			.createColumn( "total_money_before", _("Balance before") )
			.setService( FinanceService.getAvatarFinanceLog( this.avatarId ) )
			.refresh();
		
	}
	
}

}