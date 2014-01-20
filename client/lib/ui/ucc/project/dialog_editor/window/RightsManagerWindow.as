package ucc.project.dialog_editor.window {
	import dm.game.managers.MyManager;
	import dm.game.windows.DmWindow;
	import fl.controls.DataGrid;
	import fl.controls.TextInput;
	import fl.controls.CheckBox;
	import fl.controls.Button;	
	import fl.events.ListEvent;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import ucc.data.service.Service;
	import ucc.project.dialog_editor.service.DialogEditorService;
	import ucc.ui.dataview.ColumnFactory;
	import ucc.ui.dataview.DataViewBuilder;
	import ucc.util.Delegate;

/**
 * Right manager window
 * @version $Id: RightsManagerWindow.as 64 2013-03-11 12:23:32Z rytis.alekna $
 */
public class RightsManagerWindow extends DmWindow {
	
	/** Dialogs list */
	public var dialogsListDO								: DataGrid;

	/** Dialogs filter text input */
	public var dialogsFilterTextInputDO						: TextInput;

	/** Dialogs filter use reg exp check box */
	public var dialogsFilterUseRegExpCheckBoxDO				: CheckBox;

	/** Assigned users list */
	public var assignedUsersListDO							: DataGrid;

	/** Assigned users filter text input */
	public var assignedUsersFilterTextInputDO				: TextInput;

	/** Assigned users filter use reg exp check box */
	public var assignedUsersFilterUseRegExpCheckBoxDO		: CheckBox;

	/** All users list */
	public var allUsersListDO								: DataGrid;

	/** All users filter text input */
	public var allUsersFilterTextInputDO					: TextInput;

	/** All users filter use reg exp check box */
	public var allUsersFilterUseRegExpCheckBoxDO			: CheckBox;

	/** Add user button */
	public var addUserButtonDO								: Button;

	/** Add user button */
	public var removeUserButtonDO							: Button;	
	
	/** Dialog list data view builder */
	protected var dialogListDataBuilder						: DataViewBuilder;
	
	/** Assigned users list data builder */
	protected var assignedUsersListDataBuilder				: DataViewBuilder;
	
	/** All users list data builder */
	protected var allUsersListDataBuilder					: DataViewBuilder;
	
	/**
	 * Rights manager window
	 */
	public function RightsManagerWindow( parent : DisplayObjectContainer = null ) {
		super( parent, _("Dialog rights manager") );
	}
	
	
	/**
	 *	@inheritDoc
	 */
	public override function initialize () : void {
		
		this.dialogListDataBuilder = ( new DataViewBuilder( this.dialogsListDO ) )
			.addColumn(
				( new ColumnFactory( "id" ) )
					.setHeaderText( _("Id") )
					.setWidth( 40 )
					.getColumn()
			)
			.addColumn(
				( new ColumnFactory( "name" ) )
					.setHeaderText( _("Name") )
					.getColumn()
			)
			.addColumn(
				( new ColumnFactory( "last_modified_date" ) )
					.setHeaderText( _("Last modified") )
					.getColumn()
			)
			.addColumn(
				( new ColumnFactory( "username" ) )
					.setHeaderText( _("Modified by") )
					.getColumn()
			)
			.setService( DialogEditorService.getAllDialogsHeaders( MyManager.instance.id ) )
			.refresh();
			
		this.assignedUsersListDataBuilder = ( new DataViewBuilder( this.assignedUsersListDO ) )
			.createColumn( "id", _("Id"), 40 )
			.createColumn( "username", _("Username") )
			
		
		this.allUsersListDataBuilder = ( new DataViewBuilder( this.allUsersListDO ) )
			.createColumn( "id", _("Id"), 40 )
			.createColumn( "username", _("Username") )
			.setService( DialogEditorService.getAllUsers() )
			.refresh()
		
		this.dialogsListDO.addEventListener( ListEvent.ITEM_CLICK, this.onDialogListItemClick );
		
		this.allUsersListDO.addEventListener( ListEvent.ITEM_CLICK, this.onAllUsersListItemClick );
		this.assignedUsersListDO.addEventListener( ListEvent.ITEM_CLICK, this.onAssignedUsersListItemClick );
		
		this.addUserButtonDO.addEventListener( MouseEvent.CLICK, this.addUserToDialog );
		this.removeUserButtonDO.addEventListener( MouseEvent.CLICK, this.removeUserFromDialog );
		
		this.dialogsFilterTextInputDO.addEventListener( Event.CHANGE, Delegate.createWithCallArgsIgnore( this.filterList, "name", this.dialogListDataBuilder, this.dialogsFilterTextInputDO, this.dialogsFilterUseRegExpCheckBoxDO ) );
		this.assignedUsersFilterTextInputDO.addEventListener( Event.CHANGE, Delegate.createWithCallArgsIgnore( this.filterList, "username", this.assignedUsersListDataBuilder, this.assignedUsersFilterTextInputDO, this.assignedUsersFilterUseRegExpCheckBoxDO ) );
		this.allUsersFilterTextInputDO.addEventListener( Event.CHANGE, Delegate.createWithCallArgsIgnore( this.filterList, "username", this.allUsersListDataBuilder, this.allUsersFilterTextInputDO, this.allUsersFilterUseRegExpCheckBoxDO ) );
		
	}
	
	/**
	 *	On dialog list item click
	 */
	protected function onDialogListItemClick ( event : ListEvent ) : void {
		this.assignedUsersListDataBuilder
			.setService( DialogEditorService.getAllUsersAssignedToDialog( event.item.id ) )
			.refresh();
	}
	
	/**
	 *	On all user list item click
	 */
	protected function onAllUsersListItemClick ( event : ListEvent ) : void {
		this.addUserButtonDO.enabled = true;
	}
	
	/**
	 *	On assigned user list item click
	 */
	protected function onAssignedUsersListItemClick ( event : ListEvent) : void {
		this.removeUserButtonDO.enabled = true;
	}
	
	/**
	 * Assign user to dialog
	 */
	protected function addUserToDialog ( event : Event ) : void {
		this.assignedUsersListDO.addItem( this.allUsersListDO.selectedItem );
		DialogEditorService.addPermisionToDialog( this.dialogsListDO.selectedItem.id, this.allUsersListDO.selectedItem.id )
			.call();
	}
	
	/**
	 * Remove user from dialog
	 */
	protected function removeUserFromDialog ( event : Event ) : void {
		var user : Object = this.assignedUsersListDO.selectedItem;
		this.assignedUsersListDO.removeItem( user );
		DialogEditorService.removePermisionFromDialog( this.dialogsListDO.selectedItem.id, user.id )
			.call();
	}
	
	/**
	 * Filter list
	 */
	protected function filterList ( dataField : String, dataViewBuilder : DataViewBuilder, textInputDO : TextInput, regExpCheckBoxDO : CheckBox ) : void {
		dataViewBuilder.filterListByString( dataField, textInputDO.text, regExpCheckBoxDO.selected );
	}
	
}

}