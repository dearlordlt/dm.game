package dm.builder.interfaces.tools.roomeditor {

import dm.builder.interfaces.map.SelectMap;
import dm.game.data.service.RoomService;
import dm.game.data.service.RoomsService;
import dm.game.managers.MyManager;
import dm.game.windows.alert.Alert;
import dm.game.windows.DmWindow;
import fl.controls.Button;
import fl.controls.ComboBox;
import fl.controls.DataGrid;
import fl.controls.List;
import fl.controls.TextInput;
import fl.data.DataProvider;
import fl.events.ListEvent;
import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.events.MouseEvent;
import org.as3commons.lang.StringUtils;
import ucc.ui.dataview.ColumnFactory;
import ucc.ui.dataview.DataViewBuilder;
import ucc.util.ArrayUtil;
import utils.AMFPHP;

/**
 * ...
 * @author zenia
 */
public class RoomEditor extends DmWindow {
	
	private const URL : String = "http://vds000004.hosto.lt/dm/?room=";
	
	private var dataViewBuilder : DataViewBuilder;
	
	/** Room_dg */
	public var roomsDataGridDO								: DataGrid;

	/** Label_ti */
	public var roomLabelTextInputDO							: TextInput;

	/** Map_cb */
	public var mapComboBoxDO								: ComboBox;

	/** Browse maps_btn */
	public var browseMapsButtonDO							: Button;

	/** Url_ti */
	public var urlTextInputDO								: TextInput;

	/** Assigned state_list */
	public var assignedStatesListDO							: List;

	/** Available state_list */
	public var availableStatesListDO						: List;

	/** Add state_btn */
	public var addStateButttonDO							: Button;

	/** Remove state_btn */
	public var removeStateButtonDO							: Button;

	/** State duration_ti */
	public var stateDurationTextInputDO						: TextInput;

	/** Save_btn */
	public var saveButtonDO									: Button;

	/** Add room_btn */
	public var addRoomButtonDO								: Button;

	/** Room filter text input */
	public var roomFilterTextInputDO						: TextInput;

	/** Map filter text input */
	public var mapFilterTextInputDO							: TextInput;
	
	/** Selected room */
	protected var selectedRoom								: Object;
	
	/**
	 * (Constructor)
	 * - Returns a new RoomEditor instance
	 * @param	parent
	 */
	public function RoomEditor( parent : DisplayObjectContainer = null ) {
		super( parent, _( "Room editor" ) );
	}
	
	public override function initialize() : void {
		
		this.dataViewBuilder = ( new DataViewBuilder( this.roomsDataGridDO ) )
			.createColumn( "id", _( "Id" ), 35  )
			.createColumn( "label", _("Name"), 220 )
			.createColumn( "map", _("Map"), 115 )
			.createColumn( "last_modified", _( "Last modified"), 115 )
			.createColumn( "last_modifed_by", _( "Modified by" ), 78 )
			.setService( RoomService.getAllRooms() )
			.refresh();
		
		roomsDataGridDO.addEventListener( ListEvent.ITEM_CLICK, onRoomSelected );
		
		this.addRoomButtonDO.addEventListener( MouseEvent.CLICK, onAddRoomButtonClick );
		
		saveButtonDO.addEventListener( MouseEvent.CLICK, onSaveButtonClick );
		
		mapComboBoxDO.addEventListener( Event.CHANGE, onMapChange );
		
		browseMapsButtonDO.addEventListener( MouseEvent.CLICK, onBrowseMapsButtonClick );
		addStateButttonDO.addEventListener( MouseEvent.CLICK, onAddStateButtonClick );
		removeStateButtonDO.addEventListener( MouseEvent.CLICK, onRemoveStateBtn );
		
		this.mapFilterTextInputDO.addEventListener( Event.CHANGE, this.onRoomFilter );
		this.roomFilterTextInputDO.addEventListener( Event.CHANGE, this.onRoomFilter );
		
		this.roomLabelTextInputDO.addEventListener(Event.CHANGE, this.onRoomLabelChange );
		
		new AMFPHP( onMaps ).xcall( "dm.Maps.getAllMaps" );
		new AMFPHP( onStatesLoaded ).xcall( "dm.EnvironmentStateEditor.getAllStates" );
		// new AMFPHP( onRooms ).xcall( "dm.Room.getAllRooms" );
	}
	
	private function onMaps( response : Object ) : void {
		mapComboBoxDO.dataProvider = new DataProvider( response );
	}
	
	private function onMapChange( e : Event ) : void {
		urlTextInputDO.text = URL + roomLabelTextInputDO.text;
	}
	
	private function onRoomSelected( e : ListEvent ) : void {
		this.roomLabelTextInputDO.text = e.item.label;
		
		for each ( var map : Object in mapComboBoxDO.dataProvider.toArray() )
			if ( map.id == e.item.map_id ) {
				mapComboBoxDO.selectedItem = map;
				break;
			}
		
		urlTextInputDO.text = URL + roomLabelTextInputDO.text;
		
		var availableStates : Array = this.availableStatesListDO.dataProvider.toArray();
		
		this.assignedStatesListDO.dataProvider = new DataProvider();
		
		for each( var state : Object in e.item.states ) {
			this.assignedStatesListDO.dataProvider.addItem( ArrayUtil.getElementByPropertyValue( availableStates, "id", state.id ) );
		}
		
		stateDurationTextInputDO.text = e.item.state_duration || "";
		
		this.selectedRoom = e.item;
		
	}
	
	private function onBrowseMapsButtonClick( e : MouseEvent ) : void {
		new SelectMap( null ).mapSelectedSignal.add( onMapSelected );
		
		function onMapSelected( mapInfo : Object ) : void {
			for each ( var map : Object in mapComboBoxDO.dataProvider.toArray() )
				if ( map.id == mapInfo.id ) {
					mapComboBoxDO.selectedItem = map;
					break;
				}
		}
	}
	
	private function onAddStateButtonClick( e : MouseEvent ) : void {
		if ( availableStatesListDO.selectedItem ) {
			assignedStatesListDO.addItem( availableStatesListDO.selectedItem );
		}
	}
	
	private function onRemoveStateBtn( e : MouseEvent ) : void {
		if ( assignedStatesListDO.selectedItem ) {
			assignedStatesListDO.removeItem( assignedStatesListDO.selectedItem );
		}
	}
	
	private function onStatesLoaded( response : Object ) : void {
		availableStatesListDO.dataProvider = new DataProvider( response );
	}
	
	private function onSaveButtonClick( e : MouseEvent ) : void {
		
		if ( !StringUtils.trimToNull( this.roomLabelTextInputDO.text ) ) {
			Alert.show( _( "Room label must be not empty!" ) );
			return;
		}
		
		var room : Object = { label: StringUtils.trimToEmpty( roomLabelTextInputDO.text ), map_id: mapComboBoxDO.selectedItem.id, state_duration: stateDurationTextInputDO.text, states: assignedStatesListDO.dataProvider.toArray() };
		
		if ( this.selectedRoom ) {
			room.id = this.selectedRoom.id;
		}
		
		RoomService.saveRoom( room, MyManager.instance.id )
			.addResponders( this.onRoomSaved )
			.call();
	}
	
	/**
	 * On room save
	 */
	private function onRoomSaved() : void {
		this.dataViewBuilder.refresh();
	}
	
	/**
	 * On add room button click
	 */
	private function onAddRoomButtonClick( e : MouseEvent ) : void {
		
		this.roomsDataGridDO.selectedIndex = -1;
		this.selectedRoom = null;
		
		this.roomLabelTextInputDO.text = _("New_room");
		this.urlTextInputDO.text = URL + this.roomLabelTextInputDO.text;
		
		this.assignedStatesListDO.dataProvider = new DataProvider();
		
		// room_dg.addItemAt({ label: "New room" }, 0 );
	}
	
	/**
	 * On rooms
	 */
	private function onRooms( response : Object ) : void {
		roomsDataGridDO.dataProvider = new DataProvider( response );
	}
	
	/**
	 *	On room filter
	 */
	protected function onRoomFilter ( event : Event) : void {
		this.dataViewBuilder.filterListByEquality( { __plain__label : this.roomFilterTextInputDO.text, __plain__map : this.mapFilterTextInputDO.text } );
	}
	
	/**
	 *	On room label change
	 */
	protected function onRoomLabelChange ( event : Event) : void {
		this.urlTextInputDO.text = URL + this.roomLabelTextInputDO.text;
	}

}

}