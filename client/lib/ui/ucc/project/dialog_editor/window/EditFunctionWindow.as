package ucc.project.dialog_editor.window {
	import dm.game.windows.alert.Alert;
	import dm.game.windows.DmWindow;
	import fl.controls.DataGrid;
	import fl.controls.SelectableList;
	import fl.data.DataProvider;
	import fl.events.ListEvent;
	import flash.display.DisplayObjectContainer;
	import fl.controls.Button;
	import fl.controls.ComboBox;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.StringUtils;
	import ucc.project.data_finder.DataFinder;
	import ucc.project.dialog_editor.service.ConditionsService;
	import ucc.project.dialog_editor.service.DialogEditorService;
	import ucc.project.dialog_editor.vo.FunctionParam;
	import ucc.project.dialog_editor.vo.FunctionVO;
	import ucc.project.dialog_editor.vo.Phrase;
	import ucc.ui.dataview.ColumnFactory;
	import ucc.util.ArrayMatcher;
	

/**
 * Edit condition window
 * @version $Id: EditFunctionWindow.as 207 2013-09-04 14:31:08Z rytis.alekna $
 */
public class EditFunctionWindow extends DmWindow {
	
	/** Available conditions */
	private static var availableOptions	: Array;
	
	/** Params history */
	private static var paramsHistory	: Dictionary = new Dictionary();
	
	/** Findable data definitions */
	private static var findableData		: Object = { 
		"joinRoom_label" : ["rooms", ["id", "map_id","label"], "label", "label", false ],
		"loot_lootId" : ["loot", ["id", "label", "spawn_period"], "label", "id", false ],
		"addItem_itemId" : ["items", ["id", "label", "description"], "label", "id", false ],
		"removeItem_itemId" : ["items", ["id", "label", "description"], "label", "id", false ],
		"openDialog_dialogId" : ["dialog_dialogs", ["id", "name", "last_modified_date"], "name", "id", false ],
		"setVar_label" : ["avatar_vars_labels", ["label", "comment"], "label", "label", false ],
		"modifyVar_label" : ["avatar_vars_labels", ["label", "comment"], "label", "label", false ],
		"removeVar_label" : ["avatar_vars_labels", ["label", "comment"], "label", "label", false ],
		"playAudio_audioId" : ["audio", ["id", "label"], "label", "id" ],
		"openMedia_mediaId" : ["media", ["id", "label", "type", "last_modified"], "label", "id", false ],
		"addQuest_questId"	: [ "quests", [ "id", "label", "last_modified_by"], "label", "id", false ],
		"completeQuest_questId"	: [ "quests", [ "id", "label", "last_modified_by"], "label", "id", false ]
	};
	
	/** Option name combo box */
	public var optionNameComboBoxDO		: ComboBox;

	/** Params list */
	public var paramsListDO				: DataGrid;

	/** Save button */
	public var saveButtonDO				: Button;

	/** Close button */
	public var closeWindowButtonDO		: Button;

	/** Find data button */
	public var findDataButtonDO			: Button;
	
	/** option */
	protected var option 				: FunctionVO;

	/** phraseId */
	protected var phrase 				: Phrase;
	
	/** functionsListDO */
	protected var functionsListDO 		: SelectableList;
	
	/**
	 * Class constructor
	 */
	public function EditFunctionWindow( phrase : Phrase, option : FunctionVO = null, functionsListDO : SelectableList = null, parent:DisplayObjectContainer=null ) {
		this.functionsListDO = functionsListDO;
		this.phrase = phrase;
		this.option = option;
		super(parent, _("Edit function"));
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function initialize () : void {
		
		this.closeWindowButtonDO.addEventListener( MouseEvent.CLICK, this.onCloseButtonClick )
		
		this.paramsListDO.addColumn( 
			( new ColumnFactory("label") )
				.setHeaderText( _("Param name") )
				.setEditable( false )
				.getColumn()
		)
		
		this.paramsListDO.addColumn(
			( new ColumnFactory("value") )
				.setHeaderText( _("Value") )
				.setEditable( true )
				.setLabelFunction( this.trimValue )
				.getColumn()
		)
		
		if ( !availableOptions ) {
			DialogEditorService.getAllFunctions()
				.addResponders( this.onOptionsLabelsLoaded )
				.call();
		} else {
			this.setUpDataView();
		}
		
		
	}
	
	/**
	 * Trim value
	 * @param	item
	 * @return
	 */
	protected function trimValue ( item : Object ) : String {
		item.value = StringUtils.trimToEmpty( item.value );
		return item.value;
	}	
	
	/**
	 * On conditions labels loaded
	 * @param	conditions
	 */
	protected function onOptionsLabelsLoaded ( options : Array ) : void {
		availableOptions = options;
		this.setUpDataView();
	}
	
	/**
	 * Set up dat view
	 */
	protected function setUpDataView () : void {
		
		this.saveButtonDO.addEventListener( MouseEvent.CLICK, this.onSaveButtonClick );
		this.closeWindowButtonDO.addEventListener( MouseEvent.CLICK, this.onCloseButtonClick );
		this.optionNameComboBoxDO.dataProvider = new DataProvider( availableOptions );
		
		if ( this.option ) {
			this.paramsListDO.dataProvider = new DataProvider( this.option.params );
			
			for each( var item : Object in availableOptions ) {
				if ( item.label == this.option.label ) {
					this.optionNameComboBoxDO.selectedItem = item;
					break;
				}
			}
			
		}
		
		this.optionNameComboBoxDO.addEventListener( Event.CHANGE, this.onOptionChange );
		this.onOptionChange( null );
		this.findDataButtonDO.addEventListener( MouseEvent.CLICK, this.onFindDataButtonClick );
		this.paramsListDO.addEventListener( ListEvent.ITEM_CLICK, this.onParamsListItemClick );
		
	}
	
	/**
	 *	On save button click
	 */
	protected function onSaveButtonClick ( event : MouseEvent) : void {
		
		var item : Object;		
		
		for each( item in this.paramsListDO.dataProvider.toArray() ) {
			if ( !item.value || ( StringUtils.trimToEmpty( item.value ) == "" ) ) {
				Alert.show( _("Parameters values can\'t be empty!"), _("Dialgo editor") );
				return;
			}
		}		
		
		if ( !this.option ) {
			this.option = new FunctionVO();
			this.phrase.functions.push( this.option );
			this.functionsListDO.addItem( this.option );
		}
		
		// if label is new, remove all params
		if ( this.option.label != this.optionNameComboBoxDO.selectedItem.label ) {
			
			this.option.label = this.optionNameComboBoxDO.selectedItem.label;
			
			var functionParam : FunctionParam;
			
			// clear all params
			this.option.params.length = 0;
			
			for each( item in this.paramsListDO.dataProvider.toArray() ) {
				functionParam = new FunctionParam();
				functionParam.label = item.label;
				functionParam.value = StringUtils.trimToEmpty( item.value );
				this.option.params.push( functionParam );
			}
			
		}
		
		this.functionsListDO.invalidateItem( this.option );
		this.destroy();
		
	}
	
	/**
	 * On close button click
	 */
	protected function onCloseButtonClick ( event : MouseEvent ) : void {
		this.destroy();
	}
	
	/**
	 *	On option change
	 */
	protected function onOptionChange ( event : Event ) : void {
		
		if ( this.option && ( this.optionNameComboBoxDO.selectedItem.label == this.option.label ) ) {
			this.paramsListDO.dataProvider = new DataProvider( this.option.params );
		} else {
			
			this.paramsListDO.dataProvider = new DataProvider();
			
			var functionParam : FunctionParam;
			
			var functionDef : Object;
			
			if ( this.optionNameComboBoxDO.selectedItem ) {
				functionDef = this.optionNameComboBoxDO.selectedItem;
			} else {
				functionDef = this.optionNameComboBoxDO.getItemAt(0);
			}
			
			for each( var item : Object in functionDef.params ) {
				functionParam = new FunctionParam();
				functionParam.label = item.label;
				this.paramsListDO.addItem( item );
			}
			
		}
		
	}
	
	/**
	 *	On find data buton click
	 */
	protected function onFindDataButtonClick ( event : MouseEvent) : void {
		if ( this.paramsListDO.selectedItem ) {
			ClassUtils.newInstance( DataFinder, ( findableData[ this.optionNameComboBoxDO.selectedItem.label + "_" + this.paramsListDO.selectedItem.label ] as Array ).concat( [ this.setDataToParam ] ) )
		} else {
			trace( "[ucc.project.dialog_editor.window.EditFunctionWindow.onFindDataButtonClick()]" );
		}
		
	}
	
	protected function setDataToParam ( data : * ) : void {
		if ( this.paramsListDO.selectedItem && findableData[ this.optionNameComboBoxDO.selectedItem.label + "_" + this.paramsListDO.selectedItem.label ] ) {
			this.paramsListDO.selectedItem.value = data;
			this.paramsListDO.invalidateItem( this.paramsListDO.selectedItem );
		}
	}
	
	/**
	 *	On params list item click
	 */
	protected function onParamsListItemClick ( event : ListEvent) : void {
		if ( findableData[ this.optionNameComboBoxDO.selectedItem.label + "_" + event.item.label ] ) {
			this.findDataButtonDO.enabled = true;
			this.onFindDataButtonClick( null );
		} else {
			this.findDataButtonDO.enabled = false;
		}
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function destroy () : void {
		this.saveButtonDO.removeEventListener( MouseEvent.CLICK, this.onSaveButtonClick );
		this.closeWindowButtonDO.removeEventListener( MouseEvent.CLICK, this.onCloseButtonClick );
		super.destroy();
	}
	
}

}