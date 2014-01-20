package ucc.project.dialog_editor.window {
	import dm.game.managers.MyManager;
	import dm.game.windows.DmWindow;
	import dm.game.windows.Tooltip;
	import fl.controls.TextInput;
	import fl.controls.DataGrid;
	import fl.controls.Button;
	import fl.controls.CheckBox;
	import fl.events.ComponentEvent;
	import flare.events.MouseEvent3D;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import ucc.project.dialog_editor.DialogEditor;
	import ucc.project.dialog_editor.service.DialogEditorService;
	import ucc.ui.dataview.ColumnFactory;
	import ucc.ui.dataview.DataViewBuilder;
	

/**
 * Open dialog window
 * @version $Id: OpenDialogWindow.as 78 2013-04-12 00:45:21Z rytis.alekna $
 */
public class OpenDialogWindow extends DmWindow {
	
	/** Filter text input */
	public var filterTextInputDO		: TextInput;

	/** List do */
	public var listDo					: DataGrid;

	/** Open button */
	public var openButtonDO				: Button;	
	
	/** Mask checkbox. If checked, filter will work using regExp mask */
	public var maskCheckBoxDO			: CheckBox;
	
	/** Data view builder */
	protected var dataViewBuilder		: DataViewBuilder;
	
	/** Editor */
	protected var editor 				: DialogEditor;
	
	/**
	 * Class constructor
	 */
	public function OpenDialogWindow( parent:DisplayObjectContainer, editor : DialogEditor ) {
		this.editor = editor;
		super(parent, _("Open dialog"));
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function draw (  ) : void {
		super.draw();
		Tooltip.setTooltip( this.maskCheckBoxDO, _("You can use Regular Expresions for filter") );
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function initialize () : void {
		
		this.dataViewBuilder = ( new DataViewBuilder( this.listDo ) )
			.addColumn(
				( new ColumnFactory( "id" ) )
					.setHeaderText( _("Id") )
					.setWidth( 35 )
					.getColumn()
			)
			.addColumn(
				( new ColumnFactory( "name" ) )
					.setHeaderText( _("Name") )
					.setWidth( 220 )
					.getColumn()
			)
			.addColumn(
				( new ColumnFactory( "last_modified_date" ) )
					.setHeaderText( _("Last modified") )
					.setWidth( 115 )
					.getColumn()
			)
			.addColumn(
				( new ColumnFactory( "username" ) )
					.setHeaderText( _("Modified by") )
					.setWidth( 78 )
					.getColumn()
			)			
			.addColumn(
				( new ColumnFactory( "topic" ) )
					.setHeaderText( _("Topic") )
					.setWidth( 45 )
					.getColumn()
			)
			.setService( DialogEditorService.getAllDialogsHeaders( MyManager.instance.id ) )
			.refresh()
		
		this.filterTextInputDO.addEventListener( Event.CHANGE, this.onFilterChange );
		
		this.maskCheckBoxDO.addEventListener( Event.CHANGE, this.onFilterChange );
		
		this.openButtonDO.addEventListener( MouseEvent.CLICK, this.onOpenButtonClick );
		
	}
	
	/**
	 *	On key up - filter dialogs
	 */
	protected function onFilterChange ( event : Event ) : void {
		this.dataViewBuilder.filterListByString( "name", this.filterTextInputDO.text, this.maskCheckBoxDO.selected );
	}
	
	/**
	 *	On open button click
	 */
	protected function onOpenButtonClick ( event : MouseEvent ) : void {
		
		if ( this.listDo.selectedItem ) {
			this.editor.loadDialog( this.listDo.selectedItem.id );
			this.destroy();
		}
		
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function destroy (  ) : void {
		
		this.filterTextInputDO.removeEventListener( Event.CHANGE, this.onFilterChange );
		this.maskCheckBoxDO.removeEventListener( Event.CHANGE, this.onFilterChange );
		this.openButtonDO.removeEventListener( MouseEvent.CLICK, this.onOpenButtonClick );		
		
		super.destroy();
		
	}
	
}

}