package dm.game.windows.quest {
	import dm.game.data.service.QuestsService;
	import dm.game.functions.FunctionExecutor;
	import dm.game.Main;
	import dm.game.managers.MyManager;
	import dm.game.windows.DmWindow;
	import fl.controls.Button;
	import fl.controls.DataGrid;
	import fl.events.ListEvent;
	import flash.events.MouseEvent;
	import ucc.ui.dataview.ColumnFactory;
	import ucc.ui.dataview.DataViewBuilder;
	

/**
 * Quest window
 * @version $Id: QuestsWindow.as 198 2013-07-29 23:05:53Z rytis.alekna $
 */
public class QuestsWindow extends DmWindow {
	
	/** List */
	public var listDO							: DataGrid;
	
	/** Go to quest button */
	public var gotoQuestButtonDO				: Button;
	
	/** Dat view builder */
	protected var dataViewBuilder				: DataViewBuilder;
	
	/**
	 * (Constructor)
	 * - Returns a new QuestsWindow instance
	 */
	public function QuestsWindow() {
		super(null, _( "Quests") );
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function initialize (  ) : void {
		
		this.dataViewBuilder = ( new DataViewBuilder( this.listDO) )
			.createColumn( "label", _("Label"), 100 )
			.createColumn( "description", _("Description") )
			.addColumn( 
				( new ColumnFactory("completed") )
					.setHeaderText( "Completed" )
					.setLabelFunction( this.transformColumnText )
					.getColumn()
			)
			.createColumn("room_label", _("Room") )
			.setService( QuestsService.getAllQuestsForAvatar( MyManager.instance.avatar.id ) )
			.refresh();
			
		this.listDO.addEventListener( ListEvent.ITEM_CLICK, this.onListItemClick );
		
		this.gotoQuestButtonDO.addEventListener(MouseEvent.CLICK, this.onGoToQuestButtonClick );
		
		
	}
	
	/**
	 *	On list item click
	 */
	protected function onListItemClick ( event : ListEvent) : void {
		this.gotoQuestButtonDO.enabled = ( event.item.completed == 0 );
	}
	
	
	/**
	 *	Count quests
	 */
	protected function countQuests ( data : Array ) : Array {
		
		var retVal : Array = [];
		
		
		
		return retVal;
		
	}
	
	
	/**
	 *	Transform column text
	 */
	protected function transformColumnText ( item : Object ) : String {
		return ( ( item.completed == 1 ) ? _("Yes") : _("No") );
	}
	
	/**
	 *	On go to quest button click
	 */
	protected function onGoToQuestButtonClick ( event : MouseEvent ) : void {
		var quest : Object = this.listDO.selectedItem;
		
		if ( Main.getInstance().getCurrentRoomName() != quest.room_label ) {
			var functionExecutor : FunctionExecutor = new FunctionExecutor();
			functionExecutor.executeFunction( { label:"joinRoom", params:[ { label : "label", value : quest.room_label } ] }, this.onResult );
		}
		
	}
	
	protected function onResult ( result : Object ) : void {
		
	}
	
}

}