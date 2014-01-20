package ucc.project.tag  {
	import com.electrotank.electroserver5.api.DataType;
	import dm.game.windows.alert.Alert;
	import dm.game.windows.DmWindow;
	import fl.controls.CheckBox;
	import fl.controls.DataGrid;
	import fl.controls.Label;
	import fl.controls.TextInput;
	import fl.controls.Button;
	import fl.controls.ComboBox;	
	import fl.data.DataProvider;
	import fl.events.ListEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import org.as3commons.lang.ArrayUtils;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.StringUtils;
	import ucc.project.tag.service.TagsService;
	import ucc.ui.dataview.DataViewBuilder;
	import ucc.util.Delegate;
	
/**
 * Tags manager
 *
 * @version $Id: TagsManager.as 111 2013-05-02 06:46:19Z rytis.alekna $
 */
public class TagsManager extends DmWindow {
	
	/** Avatars list */
	public var avatarsListDO		: DataGrid;

	/** Filter vars list */
	public var filterVarsListDO		: ComboBox;

	/** Operators list */
	public var operatorsListDO		: ComboBox;

	/** Filter value text input */
	public var filterValueTextInputDO		: TextInput;

	/** Filter button */
	public var filterButtonDO		: Button;

	/** Assignment vars list */
	public var assignmentVarsListDO		: ComboBox;

	/** Assign value text input */
	public var assignValueTextInputDO		: TextInput;

	/** Assign tag button */
	public var assignTagButtonDO		: Button;	
	
	/** Remove tag button */
	public var removeTagButtonDO		: Button;
	
	/** Tag groups manager button */
	public var tagGroupsManagerButtonDO	: Button;
	
	/** Avatar name label */
	public var avatarNameLabelDO		: Label;
	
	/** Avatar vars list */
	public var avatarVarsListDO			: DataGrid;
	
	/** All vars list */
	public var allVarsListDO			: DataGrid;
	
	/** Avatar name filter text input */
	public var avatarNameFilterTextInputDO	: TextInput;
	
	/** Name filter checkbox */
	public var nameFilterRegExpCheckBoxDO	: CheckBox;
	
	/** Avatar vars data builder */
	protected var avatarVarsDataBuilder		: DataViewBuilder;
	
	/** Avatars list data view builder */
	protected var avatarsListDataBuilder	: DataViewBuilder;
	
	/** All vars list data builder */
	protected var allVarsListDataBuilder	: DataViewBuilder;
	
	/**
	 * Class constructor
	 */
	public function TagsManager () {
		super(null, _("Vars manager"));
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function initialize () : void {
		
		this.filterButtonDO.addEventListener( MouseEvent.CLICK, this.onFilterButtonClick );
		
		this.avatarsListDO.addEventListener( Event.CHANGE, this.onAvatarsListItemClick );
		
		this.assignTagButtonDO.addEventListener( MouseEvent.CLICK, this.onAssignTagButtonClick );
		
		this.removeTagButtonDO.addEventListener( MouseEvent.CLICK, this.onRemoveTagButtonClick );
		
		this.avatarNameFilterTextInputDO.addEventListener( Event.CHANGE, this.onAvatarNameFilterChange );
		
		this.operatorsListDO.addEventListener(Event.CHANGE, this.onOperatorChange );
		
		this.tagGroupsManagerButtonDO.addEventListener( MouseEvent.CLICK, Delegate.createWithCallArgsIgnore( ClassUtils.newInstance, TagGroupsManager ) );
		
		this.avatarsListDataBuilder = ( new DataViewBuilder( this.avatarsListDO ) )
			.createColumn( "avatar_name", _("Avatar") )
			.createColumn( "user_name", _("User") )
			.createColumn( "school", _("School") )
			.setService( TagsService.getAvatarsByVarValue() )
			.refresh();
			
		this.avatarVarsDataBuilder = ( new DataViewBuilder( this.avatarVarsListDO ) )
			.createColumn( "label", _("Label") )
			.createColumn( "value", _("Value") )
		
		this.allVarsListDataBuilder = ( new DataViewBuilder( this.allVarsListDO ) )
			.createColumn( "label", _("Label") )
			.createColumn( "value", _("Value") )
			.setService( TagsService.getAllTags() )
			
			
		this.updateTagsList();
		
	}
	
	/**
	 * Update tags list
	 */
	protected function updateTagsList () : void {
		this.allVarsListDataBuilder.refresh()
	}
	
	/**
	 *	On tags loaded
	 */
	protected function onTagsLoaded ( response : Array ) : void {
		this.filterVarsListDO.dataProvider = this.assignmentVarsListDO.dataProvider = new DataProvider( response );
	}
	
	/**
	 *	On filter button click
	 */
	protected function onFilterButtonClick ( event : MouseEvent) : void {
		
		TagsService.getAvatarsByVarValue( this.filterVarsListDO.selectedLabel, this.operatorsListDO.selectedItem.data, this.filterValueTextInputDO.text )
			.addResponders( this.onFilteredAvatarsLoaded )
			.call();
		
	}
	
	/**
	 *	On filtered avatars loaded
	 */
	protected function onFilteredAvatarsLoaded ( response : Array ) : void {
		this.avatarsListDO.dataProvider = new DataProvider( response );
	}
	
	/**
	 *	On avatars list item click
	 */
	protected function onAvatarsListItemClick ( event : Event = null ) : void {
		
		this.avatarNameLabelDO.text = _("Vars of") + ": " + this.avatarsListDO.selectedItem.avatar_name;
		this.avatarVarsDataBuilder
			.setService( TagsService.getAvatarVars( this.avatarsListDO.selectedItem.id ) )
			.refresh();
		
	}
	
	/**
	 *	On assign tag button click
	 */
	protected function onAssignTagButtonClick ( event : MouseEvent ) : void {
		if ( this.avatarsListDO.selectedItems.length > 0 ) {
			
			var avatars : Array = this.avatarsListDO.selectedItems.map( function ( item : Object, index : int, array : Array ) : int { return item.id } )
			
			TagsService.setTagsToAvatars( avatars, this.allVarsListDO.selectedItem.label, this.assignValueTextInputDO.text  )
				.addResponders( this.onVarsAssigned )
				.call();
			
		}
	}
	
	
	/**
	 *	On vars assigned
	 */
	protected function onVarsAssigned () : void {
		Alert.show( _("Vars successfuly assigned!"), _("vars manager") );
		this.onAvatarsListItemClick();
	}
	
	/**
	 *	On remove tag button click
	 */
	protected function onRemoveTagButtonClick ( event : MouseEvent) : void {
		
			var avatars : Array = this.avatarsListDO.selectedItems.map( function ( item : Object, index : int, array : Array ) : int { return item.id } )
			
			TagsService.deleteAvatarsVar( avatars, this.assignmentVarsListDO.selectedLabel  )
				.addResponders( this.onVarDeleted )
				.call();	
	}
	
	/**
	 *	On var deleted
	 */
	protected function onVarDeleted () : void {
		Alert.show( _("Vars successfully removed!"), _("Vars manager") );
		this.onAvatarsListItemClick();
	}
	
	/**
	 *	On avatar name folter change
	 */
	protected function onAvatarNameFilterChange ( event : Event) : void {
		this.avatarsListDataBuilder.filterListByString( "avatar_name", this.avatarNameFilterTextInputDO.text, this.nameFilterRegExpCheckBoxDO.selected );
	}
	
	/**
	 *	On operator change
	 */
	protected function onOperatorChange ( event : Event) : void {
		
		var selectedData : int = this.operatorsListDO.selectedItem.data;
		
		switch (selectedData) {
			
			case 6:
			case 7:
				this.filterValueTextInputDO.enabled = false;
				break;
			default:
				this.filterValueTextInputDO.enabled = true;
				break;
			
		}
		
	}
	
}
	
}