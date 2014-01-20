package ucc.project.data_finder {
	import dm.game.windows.DmWindow;
	import fl.controls.Button;
	import fl.controls.CheckBox;
	import fl.controls.DataGrid;
	import fl.controls.TextInput;
	import fl.events.ListEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import ucc.project.data_finder.service.DataListerService;
	import ucc.ui.dataview.ColumnFactory;
	import ucc.ui.dataview.DataViewBuilder;
	

/**
 * Data finder utility
 * @version $Id: DataFinder.as 207 2013-09-04 14:31:08Z rytis.alekna $
 */
public class DataFinder extends DmWindow {
	
	/** Filter text input */
	public var filterTextInputDO		: TextInput;	
	
	/** Mask checkbox. If checked, filter will work using regExp mask */
	public var maskCheckBoxDO			: CheckBox;	
	
	/** Use data button */
	public var useButtonDO				: Button;
	
	/** Results list */
	public var listDO					: DataGrid;
	
	/** Allow multiple selection? */
	protected var multipleValues 		: Boolean;

	/** callback */
	protected var callback 				: Function;

	/** filterField */
	protected var filterField 			: String;

	/** fields */
	protected var fields 				: Array;

	/** table */
	protected var table 				: String;
	
	/** Data view builder */
	protected var dataViewBuilder		: DataViewBuilder;
	
	/** returnField */
	protected var returnField : String;
	
	/**
	 * Constructor
	 * @param	table	table name in DB
	 * @param	fields	columns to display
	 * @param	filterField	against which field use text filter
	 * @param	callback	function to whick selected data will be returned
	 */
	public function DataFinder( table : String, fields : Array, filterField : String, returnField : String, multipleValues : Boolean, callback : Function ) {
		this.returnField = returnField;
		this.table = table;
		this.fields = fields;
		this.filterField = filterField;
		this.multipleValues = multipleValues;
		this.callback = callback;
		super( null, _("Data finder") );
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function draw () : void {
		
		this.listDO.width = this.filterTextInputDO.width = Math.max( 170, this.fields.length * 150 );
		this.addChild( this.listDO );
		super.draw();
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function initialize (  ) : void {
		
		this.dataViewBuilder = ( new DataViewBuilder( this.listDO ) )
			.setService( DataListerService.getData( this.table, this.fields ) )
		
		for each( var item : String in  this.fields ) {
			this.dataViewBuilder.addColumn(
				( new ColumnFactory( item ) )
					.getColumn()
			)
		}
		
		this.dataViewBuilder.refresh();
		
		this.filterTextInputDO.addEventListener( Event.CHANGE, this.onFilterChange );
		
		this.useButtonDO.addEventListener( MouseEvent.CLICK, this.onUseButtonClick );
		
		this.listDO.addEventListener( ListEvent.ITEM_CLICK, this.onListItemClick );
		this.listDO.addEventListener( ListEvent.ITEM_DOUBLE_CLICK, this.onListItemDoubleClick );
		
		this.listDO.allowMultipleSelection = this.multipleValues;
		
		trace( "[ucc.project.data_finder.DataFinder.initialize] this.listDO.allowMultipleSelection : " + this.listDO.allowMultipleSelection );
		
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function postInitialize () : void {
		this.listDO.allowMultipleSelection = this.multipleValues;
		
		trace( "[ucc.project.data_finder.DataFinder.postInitialize] this.listDO.allowMultipleSelection : " + this.listDO.allowMultipleSelection );
		
	}
	
	/**
	 *	On filter change
	 */
	protected function onFilterChange ( event : Event) : void {
		this.dataViewBuilder.filterListByString( this.filterField, this.filterTextInputDO.text, this.maskCheckBoxDO.selected );
	}
	
	/**
	 *	On use button click
	 */
	protected function onUseButtonClick ( event : MouseEvent) : void {
		
		if ( this.listDO.selectedItems.length > 0 ) {
			if ( this.multipleValues ) {
				
				var values : Array = this.listDO.selectedItems.map( 
					function ( item : * , index : int, array : Array ) : * {
						return item[this.returnField];
					}, this
				)
				
				this.callback( values.join() );
				
			} else {
				this.callback( this.listDO.selectedItem[ this.returnField ] );
			}
			
			this.destroy();
		}
		
	}
	
	/**
	 *	On list item click
	 */
	protected function onListItemClick ( event : ListEvent) : void {
		this.useButtonDO.enabled = true;
	}
	
	/**
	 *	On list item double click
	 */
	protected function onListItemDoubleClick ( event : ListEvent ) : void {
		this.callback( event.item[ this.returnField ] );
		this.destroy();
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function destroy () : void {
		this.filterTextInputDO.removeEventListener( Event.CHANGE, this.onFilterChange );
		this.useButtonDO.removeEventListener( MouseEvent.CLICK, this.onUseButtonClick );
		this.listDO.removeEventListener( ListEvent.ITEM_CLICK, this.onListItemClick );
		this.listDO.removeEventListener( ListEvent.ITEM_DOUBLE_CLICK, this.onListItemDoubleClick );
		super.destroy();
	}
	
}

}