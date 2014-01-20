package ucc.project.tag {
	import dm.game.windows.alert.Alert;
	import dm.game.windows.confirm.Confirm;
	import dm.game.windows.DmWindow;
	import fl.events.DataGridEvent;
	import fl.events.ListEvent;
	import flash.display.DisplayObjectContainer;
	import fl.controls.DataGrid;
	import fl.controls.TextInput;
	import fl.controls.Button;
	import fl.controls.CheckBox;	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import org.as3commons.lang.ArrayUtils;
	import org.as3commons.lang.StringUtils;
	import ucc.project.tag.service.TagsService;
	import ucc.ui.dataview.ColumnFactory;
	import ucc.ui.dataview.DataViewBuilder;
	import ucc.util.ArrayUtil;
	import ucc.util.Delegate;

/**
 * Tag groups manager. "Tag" in this class mean "var" and is used interchangeable
 * @version $Id: TagGroupsManager.as 206 2013-08-30 09:25:12Z rytis.alekna $
 */
public class TagGroupsManager extends DmWindow {
	
	/** Vars list */
	public var varsListDO						: DataGrid;

	/** Tag label text input */
	public var tagLabelTextInputDO				: TextInput;

	/** Save tag button */
	public var saveTagButtonDO					: Button;

	/** Tag comment text input */
	public var tagCommentTextInputDO			: TextInput;

	/** Groups list */
	public var groupsListDO						: DataGrid;

	/** Vars filter text input */
	public var varsFilterTextInputDO			: TextInput;

	/** Vars filter reg exp check box */
	public var varsFilterRegExpCheckBoxDO		: CheckBox;

	/** Group label text input */
	public var groupLabelTextInputDO			: TextInput;

	/** Create group button */
	public var createGroupButtonDO				: Button;

	/** Group comment text input */
	public var groupCommentTextInputDO			: TextInput;

	/** Groups filter text input */
	public var groupsFilterTextInputDO			: TextInput;

	/** Groups filter reg exp check box */
	public var groupsFilterRegExpCheckBoxDO		: CheckBox;

	/** Vars in group list */
	public var varsInGroupListDO				: DataGrid;

	/** Add var to group button */
	public var addVarToGroupButtonDO			: Button;

	/** Remove var from group button */
	public var removeVarFromGroupButtonDO		: Button;

	/** Assign as default var check box */
	public var assignAsDefaultVarCheckBoxDO		: CheckBox;

	/** Default value text input */
	public var defaultValueTextInputDO			: TextInput;

	/** New tag button */
	public var newTagButtonDO					: Button;

	/** Delete tag button */
	public var deleteTagButtonDO				: Button;
	
	/** Usage statistics button */
	public var usageStatisticsButtonDO			: Button;
	
	/** Default filter checkbox */
	public var defaultFilterCheckBoxDO			: CheckBox;
	
	/** Groups list data viever */
	protected var groupsListDataBuilder			: DataViewBuilder;
	
	/** Data view builder */
	protected var varsListDataBuilder			: DataViewBuilder;
	
	/** Vars in group list data builder */
	protected var varsInGroupListDataBuilder	: DataViewBuilder;
	
	/** selectedVar */
	protected var selectedVar : Object;
	/**
	 * Class constructor
	 */
	public function TagGroupsManager() {
		super(null, _("Var groups manager") );
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function initialize () : void {
		
		this.groupsListDataBuilder = new DataViewBuilder( this.groupsListDO )
			.createColumn( "label", _("Group name") )
			.createColumn( "comment", _("Comment") )
			.setService( TagsService.getAllGroups() )
			.refresh();
		
		this.varsListDataBuilder = new DataViewBuilder( this.varsListDO )
			.createColumn( "id", _("Id"), 30 )
			.createColumn( "label", _("Var name") )
			.createColumn( "comment", _("Comment") )
			.createColumn( "is_default", _("Default"), 20 )
			.setService( TagsService.getAllTags() )
			.refresh();
		
		this.varsInGroupListDataBuilder = new DataViewBuilder( this.varsInGroupListDO )
			.createColumn( "id", _("Id"), 30 )
			.createColumn( "label", _("Var name") )
			.createColumn( "comment", _("Comment") )
			.createColumn( "is_default", _("Default"), 20 )
		
		this.groupsListDO.addEventListener( Event.CHANGE, this.refreshVarsInGroupList );
		
		this.varsListDO.addEventListener( Event.CHANGE, this.onVarSelected ); // DataGridEvent.ITEM_EDIT_END, this.onVarsListItemEditEnd );
		this.varsInGroupListDO.addEventListener( Event.CHANGE, this.onVarSelected );
		
		this.addVarToGroupButtonDO.addEventListener( MouseEvent.CLICK, this.onAddVarToGroupButtonClick );
		this.removeVarFromGroupButtonDO.addEventListener( MouseEvent.CLICK, this.onRemoveVarFromGroupButtonClick );
		
		this.varsFilterTextInputDO.addEventListener( Event.CHANGE, this.onVarsFilterChange );
		this.varsFilterRegExpCheckBoxDO.addEventListener( Event.CHANGE, this.onVarsFilterChange );
		
		this.defaultFilterCheckBoxDO.addEventListener( Event.CHANGE, this.onVarsFilterChange );
		
		this.groupsFilterTextInputDO.addEventListener( Event.CHANGE, this.onGroupFilterChange );
		this.groupsFilterRegExpCheckBoxDO.addEventListener( Event.CHANGE, this.onGroupFilterChange );
		
		this.createGroupButtonDO.addEventListener( MouseEvent.CLICK, this.onCreateGroupButtonClick );
		
		this.saveTagButtonDO.addEventListener( MouseEvent.CLICK, this.onSaveVarButtonClick );
		
		this.newTagButtonDO.addEventListener( MouseEvent.CLICK, this.onNewVarButtonClick );
		
		this.usageStatisticsButtonDO.addEventListener( MouseEvent.CLICK, this.onUsageStatisticsButtonClick );
		
		this.deleteTagButtonDO.addEventListener( MouseEvent.CLICK, this.onDeleteTagButtonClick );
		
		
	}
	
	/**
	 *	On add var to group button click
	 */
	protected function onAddVarToGroupButtonClick ( event : MouseEvent) : void {
		
		if ( this.varsListDO.selectedItem && this.groupsListDO.selectedItem ) {
			
			TagsService.addVarToGroup( this.varsListDO.selectedItem.id, this.groupsListDO.selectedItem.id )
				.addResponders( this.varsInGroupListDataBuilder.refresh )
				.call();
			
		}
		
	}
	
	/**
	 *	Refresh vars in list
	 */
	protected function refreshVarsInGroupList ( event : Event = null ) : void {
		
		if ( this.groupsListDO.selectedItem ) {
			this.varsInGroupListDataBuilder
				.setService( TagsService.getAllTagsByGroupId( this.groupsListDO.selectedItem.id ) )
				.refresh();
		}
		
	}
	
	/**
	 *	On var filter change
	 */
	protected function onVarsFilterChange ( event : Event) : void {
		
		var filter : Object = {};
		
		if ( this.defaultFilterCheckBoxDO.selected ) {
			filter.is_default = 1;
		};
		
		if ( this.varsFilterRegExpCheckBoxDO.selected ) {
			filter.__rx__label = this.varsFilterTextInputDO.text;
		} else {
			filter.__plain__label = this.varsFilterTextInputDO.text;
		}
		
		this.varsListDataBuilder.filterListByEquality( filter );
		
		/*
		this.varsListDataBuilder
			.filterListByString( "label", this.varsFilterTextInputDO.text, this.varsFilterRegExpCheckBoxDO.selected );
		*/
	}
	
	/**
	 *	On group filter change
	 */
	protected function onGroupFilterChange ( event : Event) : void {
		
		this.groupsListDataBuilder
			.filterListByString( "label", this.groupsFilterTextInputDO.text, this.groupsFilterRegExpCheckBoxDO.selected );
		
	}
	
	/**
	 *	On create group button click
	 */
	protected function onCreateGroupButtonClick ( event : MouseEvent ) : void {
		
		if ( StringUtils.trimToNull( this.groupLabelTextInputDO.text ) ) {
			TagsService.createTagGroup( StringUtils.trimToEmpty( this.groupLabelTextInputDO.text ), this.groupCommentTextInputDO.text )
				.addResponders( this.groupsListDataBuilder.refresh )
				.call();
		} else {
			Alert.show( null, _("Label must be not empty!") );
		}
		
	}
	
	/**
	 *	On create tag button click
	 */
	protected function onSaveVarButtonClick ( event : MouseEvent) : void {
		
		if ( this.selectedVar && ( Boolean( parseInt( this.selectedVar.is_default ) ) != this.assignAsDefaultVarCheckBoxDO.selected ) ) {
			Confirm.show( _("You\'re about to change default assignment status of variable. This can break all game so before doing this consult developers or you realy know what you\'re doing and have backed up database. This action will be logged and if you break something your head will be chopped off using a chainsaw."), _("Var groups manager"), this.onSaveConfirmed );
			return;
		} else if ( !this.selectedVar && this.assignAsDefaultVarCheckBoxDO.selected ) {
			Confirm.show( _("Do you realy want to make this new var as default var? It will be assigned to all current avatars and future avatars of all users so check your spelling before proceding"), _("Var groups manager"), this.onSaveConfirmed );
			return;
		} else {
			this.onSaveConfirmed();
		}
		
	}
	
	/**
	 *	On remove var from group button click
	 */
	protected function onRemoveVarFromGroupButtonClick ( event : MouseEvent ) : void {
		if ( this.varsInGroupListDO.selectedItem ) {
			TagsService.removeVarFromGroup( this.varsInGroupListDO.selectedItem.id, this.groupsListDO.selectedItem.id )
				.addResponders( this.varsInGroupListDataBuilder.refresh )
				.call();
		}
	}
	
	/**
	 *	On vars list change
	 */
	protected function onVarSelected ( event : Event) : void {
		
		if ( event.target == this.varsListDO ) {
			
			this.selectedVar = this.varsListDO.selectedItem;
			this.varsInGroupListDO.selectedIndex = -1;
			
		} else if ( event.target == this.varsInGroupListDO ) {
			
			this.selectedVar = this.varsInGroupListDO.selectedItem;
			this.varsListDO.selectedIndex = -1;
			
		} else {
			this.clearVarEditForm();
			return;
		}
		
		this.usageStatisticsButtonDO.enabled = true;
		
		this.tagLabelTextInputDO.enabled = false;
		
		this.tagLabelTextInputDO.text = selectedVar.label;
		
		this.tagCommentTextInputDO.text = selectedVar.comment;
		
		this.assignAsDefaultVarCheckBoxDO.selected = Boolean( parseInt( selectedVar.is_default ) );
		
		this.saveTagButtonDO.enabled = true;
		this.deleteTagButtonDO.enabled = true;
		
	}
	
	protected function clearVarEditForm () : void {
		this.selectedVar = null;
		this.tagLabelTextInputDO.text = "";
		this.tagCommentTextInputDO.text = "";		
		this.defaultValueTextInputDO.text = "";
		this.assignAsDefaultVarCheckBoxDO.selected = false;
		this.deleteTagButtonDO.enabled = false;
		this.usageStatisticsButtonDO.enabled = false;
		this.saveTagButtonDO.enabled = false;
	}
	
	/**
	 * On save confirmed
	 */
	protected function onSaveConfirmed () : void {
		if ( this.selectedVar ) {
			
			TagsService.updateVar( this.selectedVar.id, this.selectedVar.label, this.tagCommentTextInputDO.text, this.assignAsDefaultVarCheckBoxDO.selected, this.defaultValueTextInputDO.text )
				.addResponders( this.onVarSaved, this.onVarSaveFailed )
				.call();
			
		} else {
			if ( !StringUtils.trimToNull( this.tagLabelTextInputDO.text ) ) {
				Alert.show( _("Label must be not empty!") );
				return;
			} 
			
			if ( ArrayUtil.getElementByPropertyValue( this.varsListDO.dataProvider.toArray(), "label", StringUtils.trimToEmpty( this.tagLabelTextInputDO.text ) ) ) {
				Alert.show( _("Such label already exist!") );
				return;
			}
			
			TagsService.createTag( StringUtils.trimToEmpty( this.tagLabelTextInputDO.text ), this.tagCommentTextInputDO.text, this.assignAsDefaultVarCheckBoxDO.selected, StringUtils.trimToEmpty( this.defaultValueTextInputDO.text ) )
				.addResponders( this.onVarSaved, this.onVarSaveFailed )
				.call();			
			
		}		
	}
	
	/**
	 *	On var saved
	 */
	protected function onVarSaved () : void {
		Alert.show( _("Var successfuly saved!") );
		this.varsListDataBuilder.refresh();
		this.refreshVarsInGroupList();
		this.clearVarEditForm();
	}
	
	/**
	 *	On var save failed
	 */
	protected function onVarSaveFailed () : void {
		Alert.show( _("An error occoured while saving var!") );
	}
	
	/**
	 *	On new var button click
	 */
	protected function onNewVarButtonClick ( event : MouseEvent) : void {
		
		this.varsListDO.selectedIndex = -1;
		this.varsInGroupListDO.selectedIndex = -1;
		this.clearVarEditForm();
		this.saveTagButtonDO.enabled = true;
	}
	
	/**
	 *	On usage statistics button click
	 */
	protected function onUsageStatisticsButtonClick ( event : MouseEvent) : void {
		TagsService.getTagUsageStatistics( this.selectedVar.label )
			.addResponders( this.onStatisticsLoaded )
			.call();
	}
	
	
	/**
	 *	On statistics loaded
	 */
	protected function onStatisticsLoaded ( response : Object ) : void {
		Alert.show( __( "#{Var used in} avatar_vars: " + response.avatar_vars + ", functions: " + response.functions + ", conditions: " + response.conditions ), _("Var usage statistics") );
	}
	
	/**
	 *	On delete tag button click
	 */
	protected function onDeleteTagButtonClick ( event : MouseEvent) : void {
		TagsService.getTagUsageStatistics( this.selectedVar.label )
			.addResponders( this.onStatisticsForDeletionLoaded )
			.call();
		
	}
	
	
	/**
	 *	On statistics for deletion loaded
	 */
	protected function onStatisticsForDeletionLoaded ( response : Object ) : void {
		
		if ( ( parseInt( response.functions ) > 0 ) || ( parseInt( response.conditions ) > 0 ) ) {
			Alert.show( __( "#{Var won\'t be deleted because it is used in}  functions: " + response.functions + " and conditions: " + response.conditions ) );
			return;
		} else {
			Confirm.show( __( "#{Do you realy want to delete this var?} #{Var used in} avatar_vars: " + response.avatar_vars + ", functions: " + response.functions + ", conditions: " + response.conditions ), _("Delete var"), this.onDeletionConfirmed )
		}
		
	}
	
	
	/**
	 *	On deletion confirmed
	 */
	protected function onDeletionConfirmed () : void {
		TagsService.deleteVar( this.selectedVar.label )
			.addResponders( this.onVarDeleted, Delegate.createWithCallArgsIgnore( Alert.show, _("An error occoured while deleting var!") ) )
			.call();
	}
	
	
	/**
	 *	On var deleted
	 */
	protected function onVarDeleted () : void {
		Alert.show( _("Var successfuly deleted!") );
		this.varsListDataBuilder.refresh(); 
		this.refreshVarsInGroupList();
		this.clearVarEditForm();
	}
	
	
	
}

}