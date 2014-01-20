package ucc.project.dialog_editor.window {
	import dm.game.managers.MyManager;
	import dm.game.windows.alert.Alert;
	import dm.game.windows.DmWindow;
	import dm.game.windows.Tooltip;
	import fl.controls.TextInput;
	import fl.controls.DataGrid;
	import fl.controls.Button;
	import fl.controls.CheckBox;
	import fl.controls.Label;	
	import fl.events.ListEvent;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import ucc.project.dialog_editor.DialogEditor;
	import ucc.project.dialog_editor.service.DialogEditorService;
	import ucc.ui.dataview.ColumnFactory;
	import ucc.ui.dataview.DataViewBuilder;
	import ucc.util.DisplayObjectUtil;

/**
 * Create new dialog window
 * @version $Id: CreateNewDialogWindow.as 78 2013-04-12 00:45:21Z rytis.alekna $
 */
public class CreateNewDialogWindow extends DmWindow {
	
	/** Dialog name text input */
	public var dialogNameTextInputDO		: TextInput;

	/** Filter text input */
	public var filterTextInputDO			: TextInput;

	/** List do */
	public var listDo						: DataGrid;

	/** Create button */
	public var createButtonDO				: Button;

	/** Mask check box */
	public var maskCheckBoxDO				: CheckBox;

	/** From template check box */
	public var fromTemplateCheckBoxDO		: CheckBox;

	/** Filter label */
	public var filterLabelDO				: Label;	
	
	/** Data view builder */
	protected var dataViewBuilder			: DataViewBuilder;
	
	/** Editor */
	protected var editor 					: DialogEditor;	
	
	/** Template controls */
	protected var templateControls			: Array;
	
	/**
	 * Class constructor
	 */
	public function CreateNewDialogWindow( parent:DisplayObjectContainer, editor : DialogEditor ) {
		this.editor = editor;
		
		this.templateControls = [
			this.filterLabelDO,
			this.listDo,
			this.filterTextInputDO,
			this.maskCheckBoxDO
		];
		
		super(parent, _("New dialog"));
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function draw (  ) : void {
		super.draw();
		Tooltip.setTooltip( this.maskCheckBoxDO, _("You can use Regular Expresions for filter") );
		Tooltip.setTooltip( this.fromTemplateCheckBoxDO, _("Create a copy from existing dialog") );
		
		// this.displayTemplatesList( false );
		
	}
	
	/**
	 * Display templates list
	 * @param	value
	 */
	protected function displayTemplatesList ( value : Boolean ) : void {
		this.filterLabelDO.visible		=
		this.listDo.visible				=
		this.filterTextInputDO.visible	=
		this.maskCheckBoxDO.visible		= value;
		
		
		
		if ( value ) {
			DisplayObjectUtil.addSpecifiedChildren( this, this.templateControls );
			this.createButtonDO.y = this.listDo.y + this.listDo.height + 12;
		} else {
			DisplayObjectUtil.removeSpecifiedChildren( this.templateControls );
			this.createButtonDO.y = this.dialogNameTextInputDO.y + this.dialogNameTextInputDO.height + 12;
		}
		
		this.redraw();
		
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function initialize () : void {
		
		this.dataViewBuilder = ( new DataViewBuilder( this.listDo ) )
			.addColumn(
				( new ColumnFactory( "name" ) )
					.setHeaderText( _("Name") )
					.getColumn()
			)
			.addColumn(
				( new ColumnFactory( "last_modified_date" ) )
					.setHeaderText( _("Last modified") )
					.setWidth( 115 )
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
		
		this.createButtonDO.addEventListener( MouseEvent.CLICK, this.onCreateButtonClick );
		
		this.fromTemplateCheckBoxDO.addEventListener( Event.CHANGE, this.onFromTemplateCheckBoxChange );
		
		this.listDo.addEventListener(ListEvent.ITEM_CLICK, this.onListItemClick );
		
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
	protected function onCreateButtonClick ( event : MouseEvent ) : void {
		
		if ( this.fromTemplateCheckBoxDO.selected ) {
			if ( !this.listDo.selectedItem ) {
				Alert.show( _("You have not selected template!"), _("Dialog editor") );
				return;
			}
			this.editor.createNewDialog( this.listDo.selectedItem.id, this.dialogNameTextInputDO.text );
		} else {
			this.editor.createNewDialog( NaN, this.dialogNameTextInputDO.text );
		}
		
		this.destroy();
		
	}
	
	/**
	 *	On from template check box change
	 */
	protected function onFromTemplateCheckBoxChange ( event : Event) : void {
		this.displayTemplatesList( this.fromTemplateCheckBoxDO.selected );
	}
	
	/**
	 *	On list item click
	 */
	protected function onListItemClick ( event : ListEvent ) : void {
		this.dialogNameTextInputDO.text = event.item.name + __(" #{copy}");
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function destroy (  ) : void {
		
		this.filterTextInputDO.removeEventListener( Event.CHANGE, this.onFilterChange );
		this.maskCheckBoxDO.removeEventListener( Event.CHANGE, this.onFilterChange );
		this.createButtonDO.removeEventListener( MouseEvent.CLICK, this.onCreateButtonClick );		
		this.fromTemplateCheckBoxDO.removeEventListener( Event.CHANGE, this.onFromTemplateCheckBoxChange );
		super.destroy();
		
	}	
	
}

}