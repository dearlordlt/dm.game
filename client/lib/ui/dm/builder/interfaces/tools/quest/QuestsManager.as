package dm.builder.interfaces.tools.quest {
	import dm.game.data.service.QuestsService;
	import dm.game.data.service.RoomsService;
	import dm.game.managers.MyManager;
	import dm.game.windows.alert.Alert;
	import dm.game.windows.DmWindow;
	import fl.controls.Button;
	import fl.controls.ComboBox;
	import fl.controls.DataGrid;
	import fl.controls.TextArea;
	import fl.controls.TextInput;
	import fl.events.DataGridEvent;
	import fl.events.ListEvent;
	import flash.events.MouseEvent;
	import ucc.ui.dataview.DataViewBuilder;
	

/**
 * Quests manager
 * @version $Id: QuestsManager.as 198 2013-07-29 23:05:53Z rytis.alekna $
 */
public class QuestsManager extends DmWindow {
	
	/** List */
	public var listDO							: DataGrid;

	/** Label text input */
	public var labelTextInputDO					: TextInput;

	/** Map label text input */
	public var mapLabelTextInputDO				: TextInput;

	/** Description text input */
	public var descriptionTextInputDO			: TextArea;

	/** Marker x text input */
	public var markerXTextInputDO				: TextInput;

	/** Marker y text input */
	public var markerYTextInputDO				: TextInput;

	/** Save button */
	public var saveButtonDO						: Button;

	/** New quest button */
	public var newQuestButtonDO					: Button;

	/** Room combo box */
	public var roomComboBoxDO					: ComboBox;
	
	/** Data view builder */
	protected var dataViewBuilder				: DataViewBuilder;
	
	/** Rooms data view builder */
	protected var roomsDataViewBuilder			: DataViewBuilder;
	
	/** Current item */
	protected var currentItem 					: Object;
	
	/**
	 * (Constructor)
	 * - Returns a new QuestsManager instance
	 */
	public function QuestsManager() {
		super(null, _("Quests manager") );
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function initialize (  ) : void {
		
		this.dataViewBuilder = ( new DataViewBuilder( this.listDO ) )
			.createColumn( "label", _("Label"), 150 )
			.createColumn( "description", _("Description") )
			.createColumn( "room_label", _("Room") )
			.createColumn( "username", _("Last modified by"), 150 )
			.setService( QuestsService.getAllQuests() )
			.refresh();
		
		this.roomsDataViewBuilder = ( new DataViewBuilder( this.roomComboBoxDO.dropdown, this.roomComboBoxDO ) )
			.createColumn( "label", _("Label") )
			.setService( RoomsService.getAllRooms() )
			.refresh();
		
		this.listDO.addEventListener(ListEvent.ITEM_CLICK, this.onListItemClick );
		
		this.saveButtonDO.addEventListener( MouseEvent.CLICK, this.onSaveButtonClick );
		
		this.newQuestButtonDO.addEventListener( MouseEvent.CLICK, this.onNewQuestButtonClick );
		
	}
	
	/**
	 *	On list item focus in
	 */
	protected function onListItemClick ( event : ListEvent) : void {
		
		this.currentItem = event.item;
		
		this.labelTextInputDO.text 			= currentItem.label;
		this.descriptionTextInputDO.text	= currentItem.description;
		this.mapLabelTextInputDO.text		= currentItem.map_label;
		this.markerXTextInputDO.text		= currentItem.marker_x;
		this.markerYTextInputDO.text		= currentItem.marker_y;
		
		if ( this.currentItem.room_id ) {
			trace( "[dm.builder.interfaces.tools.quest.QuestsManager.onListItemClick] currentItem.room_id : " + currentItem.room_id );
			this.roomsDataViewBuilder.selectItemByPropertyValue( { id : currentItem.room_id } );
		}
		
	}
	
	/**
	 *	On save button click
	 */
	protected function onSaveButtonClick ( event : MouseEvent) : void {
		
		if ( ( isNaN( parseInt( this.markerXTextInputDO.text ) ) ) || ( isNaN( parseInt( this.markerYTextInputDO.text ) ) ) ) {
			Alert.show( _("Invalid quest marker!"), _("Quest manager") );
			return;
		}
		
		if ( this.currentItem.id ) {
			QuestsService.updateQuest( this.currentItem.id, this.labelTextInputDO.text, this.descriptionTextInputDO.text, this.mapLabelTextInputDO.text, parseInt(this.markerXTextInputDO.text), parseInt(this.markerYTextInputDO.text), this.roomComboBoxDO.selectedItem.id, MyManager.instance.id )
				.addResponders( this.onQuestSaved )
				.call();
		} else {
			QuestsService.createQuest( this.labelTextInputDO.text, this.descriptionTextInputDO.text, this.mapLabelTextInputDO.text, parseInt(this.markerXTextInputDO.text), parseInt(this.markerYTextInputDO.text), this.roomComboBoxDO.selectedItem.id, MyManager.instance.id )
				.addResponders( this.onQuestSaved )
				.call();
		}
		
	}
	
	
	/**
	 *	On quest saved
	 */
	protected function onQuestSaved () : void {
		Alert.show( _("Quest succesfully saved!") );
		this.dataViewBuilder.refresh();
	}
	
	/**
	 *	On new quest button click
	 */
	protected function onNewQuestButtonClick ( event : MouseEvent) : void {
		
		this.currentItem = {};
		
		this.labelTextInputDO.text 			= "";
		this.descriptionTextInputDO.text	= "";
		this.mapLabelTextInputDO.text		= "";
		this.markerXTextInputDO.text		= "0";
		this.markerYTextInputDO.text		= "0";
		
	}
	
}

}