package dm.builder.interfaces.tools.environmentstateeditor {

import dm.builder.interfaces.map.UploadSkybox;
import dm.game.data.service.EnvironmentStateEditorService;
import dm.game.data.service.MapsService;
import dm.game.managers.MyManager;
import dm.game.windows.alert.Alert;
import dm.game.windows.DmWindow;
import fl.controls.Button;
import fl.controls.ComboBox;
import fl.controls.DataGrid;
import fl.controls.dataGridClasses.DataGridColumn;
import fl.controls.Label;
import fl.controls.List;
import fl.controls.Slider;
import fl.controls.TextInput;
import fl.data.DataProvider;
import fl.events.ListEvent;
import fl.events.SliderEvent;
import flash.display.DisplayObjectContainer;
import flash.events.DataEvent;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.net.FileFilter;
import flash.net.FileReference;
import flash.net.URLRequest;
import org.as3commons.lang.StringUtils;
import ucc.ui.dataview.ColumnFactory;
import ucc.ui.dataview.DataViewBuilder;
import utils.AMFPHP;

/**
 * Environment state editor
 * @version $Id$
 */
public class EnvironmentStateEditor extends DmWindow {
	
	/** particleTexturesDataViewBuilder */
	protected var particleTexturesDataViewBuilder : DataViewBuilder;
	
	/** skyBoxesDataViewBuilder */
	protected var skyBoxesDataViewBuilder : DataViewBuilder;
	
	/** audioDataViewBuilder */
	protected var audioDataViewBuilder : DataViewBuilder;
	
	/** visualEffectsListDataViewBuilder */
	protected var visualEffectsListDataViewBuilder : DataViewBuilder;
	
	/** audioEffectDataViewBuilder */
	protected var audioEffectDataViewBuilder : DataViewBuilder;
	
	private var fileReference : FileReference;
	
	private var statesDataViewBuilder : DataViewBuilder;
	
	public var statesDataGridDO : DataGrid;
	
	public var addStateButtonDO : Button;
	
	public var labelTextInputDO : TextInput;
	
	public var skyboxComboBoxDO : ComboBox;
	
	public var uploadSkyboxButtonDO : Button;
	
	public var visualEffectDataGridDO : DataGrid;
	
	public var texturesComboBoxDO : ComboBox;
	
	public var uploadTexture_btn : Button;
	
	public var addParticleEffectButtonDO : Button;
	
	public var removeParticleEffectButtonDO : Button;
	
	public var intensitySliderDO : Slider;
	
	public var intensityLabelDO : Label;
	
	public var fallSpeedLabelDO	: Label;
	
	public var fallSpeedSliderDO : Slider;
	
	public var audioEffectDataGridDO : DataGrid;
	
	public var audioComboBoxDO : ComboBox;
	
	public var uploadAudioButtonDO : Button;
	
	public var addAudioEffectButtonDO : Button;
	
	public var removeAudioEffectButtonDO : Button;
	
	public var volumeSliderDO : Slider;
	
	public var saveButtonDO : Button;
	
	public var volumeLabelDO	: Label;
	
	/**
	 * (Constructor)
	 * - Returns a new EnvironmentStateEditor instance
	 */
	public function EnvironmentStateEditor( parent : DisplayObjectContainer = null ) {
		super( parent, _( "Environment state editor" ) );
	}
	
	/**
	 * Initializes this instance.
	 */
	public override function initialize() : void {
		
		this.statesDataViewBuilder = new DataViewBuilder( this.statesDataGridDO )
			.createColumn( "id", _( "Id" ), 35 )
			.createColumn( "label", _( "Name" ), 220 )
			.createColumn( "last_modified", _( "Last modified" ), 115 )
			.createColumn( "last_modified_by_username", _( "Last modified by" ), 78 )
			.setService( EnvironmentStateEditorService.getAllStates() )
			.refresh();
		
		this.particleTexturesDataViewBuilder = new DataViewBuilder( this.texturesComboBoxDO.dropdown, this.texturesComboBoxDO )
			.setService( EnvironmentStateEditorService.getAllParticleTextures() )
			.refresh();
		
		this.skyBoxesDataViewBuilder = new DataViewBuilder( this.skyboxComboBoxDO.dropdown, this.skyboxComboBoxDO )
			.setService( MapsService.getAllSkyboxes() )
			.refresh();
		
		this.audioDataViewBuilder = new DataViewBuilder( this.audioComboBoxDO.dropdown, audioComboBoxDO )
			.setService( EnvironmentStateEditorService.getAllAudios() )
			.refresh();
		
		this.visualEffectsListDataViewBuilder = new DataViewBuilder( this.visualEffectDataGridDO )
			.createColumn( "texture_path", _("Texture"), 200 )
			.createColumn( "intensity", _("Intensity") )
			.createColumn( "fall_speed", _("Fall speed") )
		
		this.audioEffectDataViewBuilder = new DataViewBuilder( this.audioEffectDataGridDO )
			.createColumn( "audio_path", _("Audio path"), 200 )
			.createColumn( "volume", _( "Volume" ) )
			
		statesDataGridDO.addEventListener( ListEvent.ITEM_CLICK, onStateSelect );
		
		addStateButtonDO.addEventListener( MouseEvent.CLICK, onAddStateButtonClick );
		
		saveButtonDO.addEventListener( MouseEvent.CLICK, onSaveButtonClick );
		
		uploadSkyboxButtonDO.addEventListener( MouseEvent.CLICK, onUploadSkyboxButtonClick );
		
		visualEffectDataGridDO.addEventListener( ListEvent.ITEM_CLICK, onVisualEffectClick );
		
		uploadTexture_btn.addEventListener( MouseEvent.CLICK, onUploadTextureButtonClick );
		uploadAudioButtonDO.addEventListener( MouseEvent.CLICK, onUploadAudioButtonClick );
		
		addParticleEffectButtonDO.addEventListener( MouseEvent.CLICK, onAddParticleEffectButtonClick );
		removeParticleEffectButtonDO.addEventListener( MouseEvent.CLICK, onRemoveParticleEffectButtonClick );
		
		texturesComboBoxDO.addEventListener( Event.CHANGE, this.onVisualEffectsControlsChange );
		intensitySliderDO.addEventListener( SliderEvent.CHANGE, this.onVisualEffectsControlsChange );
		fallSpeedSliderDO.addEventListener( SliderEvent.CHANGE, this.onVisualEffectsControlsChange );
		
		audioEffectDataGridDO.addEventListener( ListEvent.ITEM_CLICK, onAudioEffectClick );
		
		addAudioEffectButtonDO.addEventListener( MouseEvent.CLICK, onAddAudioEffectButtonClick );
		removeAudioEffectButtonDO.addEventListener( MouseEvent.CLICK, onRemoveAudioEffectButtonClick );
		
		audioComboBoxDO.addEventListener( Event.CHANGE, this.onAudioControlsChange );
		volumeSliderDO.addEventListener( SliderEvent.CHANGE, this.onAudioControlsChange );
	
	}
	
	/**
	 * Post initialize
	 */
	override public function postInitialize() : void {
		intensityLabelDO.text = String( intensitySliderDO.value );
		fallSpeedLabelDO.text = String( fallSpeedSliderDO.value );
		this.volumeLabelDO.text = String( volumeSliderDO.value );
	}
	
	/**
	 * On state select
	 */
	private function onStateSelect( event : ListEvent ) : void {
		
		labelTextInputDO.text = event.item.label;
		
		this.skyBoxesDataViewBuilder.selectItemByPropertyValue( { id : event.item.skybox_id } );
		
		this.visualEffectDataGridDO.dataProvider = new DataProvider( event.item.visualEffects );
		this.audioEffectDataGridDO.dataProvider = new DataProvider( event.item.audioEffects );
		
		this.saveButtonDO.enabled = true;
		
	}
	
	/**
	 * On visual effect click
	 */
	private function onVisualEffectClick( event : ListEvent ) : void {
		if ( event.item.texture_path ) {
			this.particleTexturesDataViewBuilder.selectItemByPropertyValue( { texture_path : event.item.texture_path } );
		}
		
		intensitySliderDO.value = event.item.intensity;
		fallSpeedSliderDO.value = event.item.fall_speed;
	}
	
	/**
	 * On audio effect click
	 */
	private function onAudioEffectClick( event : ListEvent ) : void {
		this.audioDataViewBuilder.selectItemByPropertyValue( { audio_path : event.item.audio_path } )
		volumeSliderDO.value = event.item.volume;
	}
	
	/**
	 * On add state btn
	 */
	private function onAddStateButtonClick( event : MouseEvent ) : void {
		
		this.labelTextInputDO.text 				= _("New state");
		
		// reset defaults
		this.visualEffectDataGridDO.dataProvider 	= new DataProvider();
		this.audioEffectDataGridDO.dataProvider 	= new DataProvider();
		this.intensitySliderDO.value = 200;
		this.fallSpeedSliderDO.value = 200;
		this.volumeSliderDO.value = 50;
		
		this.saveButtonDO.enabled = true;
	}
	
	/**
	 * On add particle effect button click
	 */
	private function onAddParticleEffectButtonClick( event : MouseEvent ) : void {
		visualEffectDataGridDO.addItem( { texture_path: this.texturesComboBoxDO.selectedItem.texture_path, intensity : this.intensitySliderDO.value, fall_speed : this.fallSpeedSliderDO.value } );
		this.removeParticleEffectButtonDO.enabled = true;
	}
	
	/**
	 * On remove particle effect button click
	 */
	private function onRemoveParticleEffectButtonClick( event : MouseEvent ) : void {
		try {
			visualEffectDataGridDO.removeItemAt( visualEffectDataGridDO.selectedIndex );
		} catch ( error : Error ) {
		}
		
		if ( this.visualEffectDataGridDO.selectedItem ) {
			this.visualEffectDataGridDO.removeItem( this.visualEffectDataGridDO.selectedItem );
		} else if ( this.visualEffectDataGridDO.length > 0 ) {
			this.visualEffectDataGridDO.removeItemAt( this.visualEffectDataGridDO.length - 1 );
		}
		
		if ( this.visualEffectDataGridDO.length == 0 ) {
			this.removeParticleEffectButtonDO.enabled = false;
		}		
		
	}
	
	/**
	 * On add audio effect button click
	 */
	private function onAddAudioEffectButtonClick( event : MouseEvent ) : void {
		trace( "[dm.builder.interfaces.tools.environmentstateeditor.EnvironmentStateEditor.onAddAudioEffectButtonClick] audio_path : " + this.audioComboBoxDO.selectedItem.audio_path );
		audioEffectDataGridDO.addItem( { audio_path : this.audioComboBoxDO.selectedItem.audio_path, volume : this.volumeSliderDO.value } );
		this.removeAudioEffectButtonDO.enabled = true;
	}
	
	/**
	 * On remove audio effect button click
	 */
	private function onRemoveAudioEffectButtonClick( event : MouseEvent ) : void {
		if ( this.audioEffectDataGridDO.selectedItem ) {
			this.audioEffectDataGridDO.removeItem( this.audioEffectDataGridDO.selectedItem );
		} else if ( this.audioEffectDataGridDO.length > 0 ) {
			this.audioEffectDataGridDO.removeItemAt( this.audioEffectDataGridDO.length - 1 );
		}
		
		if ( this.audioEffectDataGridDO.length == 0 ) {
			this.removeAudioEffectButtonDO.enabled = false;
		}
		
	}
	
	/**
	 * On save button click
	 */
	private function onSaveButtonClick( event : MouseEvent ) : void {
		
		if ( !StringUtils.trimToNull( this.labelTextInputDO.text ) ) {
			Alert.show( _("You must provide a name for state!") );
			return;
		}
		
		var state : Object = { id: ( statesDataGridDO.selectedItem ) ? statesDataGridDO.selectedItem.id : null, label: labelTextInputDO.text, skybox_id: skyboxComboBoxDO.selectedItem.id, visualEffects: visualEffectDataGridDO.dataProvider.toArray(), audioEffects: audioEffectDataGridDO.dataProvider.toArray() };
		EnvironmentStateEditorService.saveState( state, MyManager.instance.id ).addResponders( this.onStateSave ).call();
	}
	
	/**
	 * On state save
	 */
	private function onStateSave() : void {
		Alert.show( _("State successfuly saved!") );
		
		this.labelTextInputDO.text = "";
		this.visualEffectDataGridDO.dataProvider = new DataProvider();
		this.audioEffectDataGridDO.dataProvider = new DataProvider();
		
		this.skyboxComboBoxDO.selectedIndex = 0;
		this.audioComboBoxDO.selectedIndex = 0;
		this.texturesComboBoxDO.selectedIndex = 0;
		
		this.intensitySliderDO.value = 200;
		this.fallSpeedSliderDO.value = 200;
		this.volumeSliderDO.value 	= 50;
		
		this.saveButtonDO.enabled = false;		
		
		this.statesDataViewBuilder.refresh();
	}
	
	/**
	 * On upload audio button click
	 */
	private function onUploadAudioButtonClick( event : MouseEvent ) : void {
		fileReference = new FileReference();
		fileReference.addEventListener( Event.SELECT, onAudioFileSelect );
		var fileFil : FileFilter = new FileFilter( "Audio", "*.mp3" );
		fileReference.browse([ fileFil ] );
	}
	
	/**
	 * On audio file select
	 */
	private function onAudioFileSelect( event : Event ) : void {
		var request : URLRequest = new URLRequest( "http://vds000004.hosto.lt/dm/uploadAudio.php" );
		fileReference.addEventListener( DataEvent.UPLOAD_COMPLETE_DATA, onAudioUpload );
		fileReference.upload( request );
	}
	
	/**
	 * On audio upload
	 */
	private function onAudioUpload( event : DataEvent ) : void {
		this.audioDataViewBuilder.refresh();
	}
	
	/**
	 *
	 */
	private function onUploadTextureButtonClick( event : MouseEvent ) : void {
		fileReference = new FileReference();
		fileReference.addEventListener( Event.SELECT, onTextureFileSelect );
		var fileFil : FileFilter = new FileFilter( "Image", "*.png" );
		fileReference.browse([ fileFil ] );
	}
	
	/**
	 * On texture file select
	 */
	private function onTextureFileSelect( event : Event ) : void {
		var request : URLRequest = new URLRequest( "http://vds000004.hosto.lt/dm/uploadParticleTexture.php" );
		fileReference.addEventListener( DataEvent.UPLOAD_COMPLETE_DATA, onTextureUpload );
		fileReference.upload( request );
	}
	
	/**
	 * On texture upload
	 */
	private function onTextureUpload( event : DataEvent ) : void {
		Alert.show(_("Texture successfuly uploaded!") );
		this.particleTexturesDataViewBuilder.refresh();
	}
	
	/**
	 * On upload skybox button click
	 */
	private function onUploadSkyboxButtonClick( event : MouseEvent ) : void {
		var uploadSkybox : UploadSkybox = new UploadSkybox( null );
		uploadSkybox.skyboxUploadedSignal.add( onSkyboxUploaded );
	}
	
	/**
	 * On skybox uploaded
	 */
	private function onSkyboxUploaded() : void {
		Alert.show(_("Skybox successfuly uploaded!"));
		this.skyBoxesDataViewBuilder.refresh();
	}
	
	/**
	 * On visual effects controls change
	 */
	protected function onVisualEffectsControlsChange ( event : Event ) : void {
		
		fallSpeedLabelDO.text = String( fallSpeedSliderDO.value );
		intensityLabelDO.text = String( intensitySliderDO.value );
		
		if ( this.visualEffectDataGridDO.selectedItem ) {
			visualEffectDataGridDO.selectedItem.fall_speed = fallSpeedSliderDO.value;
			visualEffectDataGridDO.selectedItem.intensity = intensitySliderDO.value;
			visualEffectDataGridDO.selectedItem.texture_path = texturesComboBoxDO.selectedItem.texture_path;
			this.visualEffectDataGridDO.invalidateItem( this.visualEffectDataGridDO.selectedItem );
		}
		
	}
	
	/**
	 *	On audio controls change
	 */
	protected function onAudioControlsChange ( event : Event) : void {
		
		volumeLabelDO.text = String( volumeSliderDO.value );
		
		if ( audioEffectDataGridDO.selectedItem ) {
			audioEffectDataGridDO.selectedItem.audio_path = audioComboBoxDO.selectedItem.audio_path;
			audioEffectDataGridDO.selectedItem.volume = volumeSliderDO.value;
			this.audioEffectDataGridDO.invalidateItem( audioEffectDataGridDO.selectedItem );
		}
	}

}

}