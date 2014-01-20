package dm.builder.interfaces.tools.mediamanager {
	import dm.game.data.service.MediaService;
	import dm.game.functions.FunctionExecutor;
	import dm.game.managers.MyManager;
	import dm.game.windows.alert.Alert;
	import dm.game.windows.DmWindow;
	import fl.controls.Button;
	import fl.controls.ComboBox;
	import fl.controls.DataGrid;
	import fl.controls.Label;
	import fl.controls.TextInput;
	import fl.events.ListEvent;
	import flare.events.MouseEvent3D;
	import flash.display.DisplayObjectContainer;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import org.as3commons.lang.StringUtils;
	import ucc.ui.dataview.DataViewBuilder;
	

/**
 * Builder media uploader
 * @version $Id: MediaManager.as 215 2013-09-29 14:28:49Z rytis.alekna $
 */
public class MediaManager extends DmWindow {
	
	/** Media manager path */
	private static const MEDIA_MANAGER_PATH		: String = "http://vds000004.hosto.lt/dm_dev/MediaManager.php";
	
	/** List */
	public var listDO							: DataGrid;

	/** Label text input */
	public var labelTextInputDO					: TextInput;

	/** File type label */
	public var fileTypeLabelDO					: Label;

	/** Local file path label */
	public var localFilePathLabelDO				: Label;
	
	/** Remote file path label */
	public var remoteFilePathLabelDO			: Label;
	
	/** Entry id label */
	public var entryIdLabelDO					: Label;
	
	/** Preview button */
	public var previewButtonDO					: Button;
	
	/** Browse button */
	public var browseButtonDO					: Button;

	/** Save button */
	public var saveButtonDO						: Button;

	/** Delete button */
	public var deleteButtonDO					: Button;	
	
	/** New entry button */
	public var newEntryButtonDO					: Button;
	
	/** Category combo box */
	public var categoryComboBoxDO				: ComboBox;	
	
	/** Category combo box */
	public var categoryFilterComboBoxDO			: ComboBox;
	
	/** Category label */
	public var categoryLabelTextInputDO			: TextInput;
	
	/** Create category button */
	public var createCategoryButtonDO			: Button;
	
	/** label filter text input */
	public var labelFilterTextInputDO			: TextInput;
	
	/** List data builder */
	protected var listDataBuilder				: DataViewBuilder;
	
	/** Category data view builder */
	protected var categoryListDataBuilder		: DataViewBuilder;
	
	/** Category data view builder */
	protected var categoryFilterListDataBuilder	: DataViewBuilder;
	
	/** Entry id */
	protected var entryId						: Number;
	
	/** fileReference */
	protected var fileReference 				: FileReference;
	
	/**
	 * (Constructor)
	 * - Returns a new VideoUploader instance
	 */
	public function MediaManager(parent:DisplayObjectContainer=null) {
		super( parent, _("Media manager"));
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function initialize (  ) : void {
		
		this.listDataBuilder = new DataViewBuilder( this.listDO )
			.createColumn( "id", _("Id"), 15 )
			.createColumn( "label", _("Label"), 200 )
			.createColumn( "type", _("Media type"), 50 )
			.createColumn( "username", _("Modified by") )
			.createColumn( "last_modified", _("Date") )
			.createColumn( "category_label", _("Category") )
			.setService( MediaService.getAllMedia() )
			.refresh();
			
		this.categoryListDataBuilder = ( new DataViewBuilder( this.categoryComboBoxDO.dropdown, this.categoryComboBoxDO ) )
			.createColumn( "label", _("Label") )
			.setService( MediaService.getAllMediaCategories() )
			.refresh();
			
		this.categoryFilterListDataBuilder = ( new DataViewBuilder( this.categoryFilterComboBoxDO.dropdown, this.categoryFilterComboBoxDO ) )
			.createColumn( "label", _("Label") )
			.prependData( [ {label: "", id : null } ] )
			.setService( MediaService.getAllMediaCategories() )
			.refresh();
			
			
		this.listDO.addEventListener(ListEvent.ITEM_CLICK, this.onListItemClick );
		
		this.saveButtonDO.addEventListener( MouseEvent.CLICK, this.onSaveButtonClick );
		
		this.newEntryButtonDO.addEventListener( MouseEvent.CLICK, this.onNewEntryButtonClick );
		
		this.deleteButtonDO.addEventListener( MouseEvent.CLICK, this.onDeleteButtonClick );
		
		this.browseButtonDO.addEventListener( MouseEvent.CLICK, this.onBrowseButtonClick );
		
		this.previewButtonDO.addEventListener( MouseEvent.CLICK, this.onPreviewButtonClick )
		
		this.createCategoryButtonDO.addEventListener( MouseEvent.CLICK, this.onCreateCategoryButtonClick );
		
		this.categoryFilterComboBoxDO.addEventListener( Event.CHANGE, this.onFilterChange );
		
		this.labelFilterTextInputDO.addEventListener( Event.CHANGE, this.onFilterChange );
	}
	
	/**
	 *	On list item click
	 */
	protected function onListItemClick ( event : ListEvent ) : void {
		
		var item : Object = event.item;
		
		this.entryId = item.id;
		
		this.labelTextInputDO.text = item.label;
		
		this.localFilePathLabelDO.text = "";
		
		this.fileTypeLabelDO.text = __("#{Media type}: ") + item.type;
		
		this.remoteFilePathLabelDO.text = __("#{File on server}:") + item.path;
		
		this.entryIdLabelDO.text = __( "#{Id}: " + this.entryId );
		
		this.categoryListDataBuilder.selectItemByPropertyValue( { id : item.category_id } );
		
		this.fileReference =  null;
		
		this.saveButtonDO.enabled = true;
		this.deleteButtonDO.enabled = true;
		this.browseButtonDO.enabled = true;
		this.newEntryButtonDO.enabled = true;
		this.previewButtonDO.enabled = true;
		
	}
	
	/**
	 *	On save button click
	 */
	protected function onSaveButtonClick ( event : MouseEvent) : void {
		
		var request : URLRequest = new URLRequest( MEDIA_MANAGER_PATH );
		request.data = new URLVariables();
		request.data["user"] = MyManager.instance.id;
		if ( !isNaN( this.entryId ) ) {
			request.data["id"] = this.entryId;
		}
		request.data["label"] = this.labelTextInputDO.text;
		
		request.data["category_id"] = this.categoryComboBoxDO.selectedItem.id;
		
		// request.method = URLRequestMethod.;
		
		if ( this.fileReference ) {
			
			trace( "[dm.builder.interfaces.tools.mediamanager.MediaManager.onSaveButtonClick] : startinbg upload" );
			
			// this.fileReference.addEventListener( Event.COMPLETE, this.onUrlLoadComplete );
			this.fileReference.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, this.onUrlLoadComplete );
			this.fileReference.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.onHttpStatus );
			this.fileReference.upload(request);
			
		} else {
			
			var urlLoader : URLLoader = new URLLoader( request );
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, this.onUrlLoadComplete );			
			
		}
		
	}
	
	/**
	 *	On new entry button click
	 */
	protected function onNewEntryButtonClick ( event : MouseEvent) : void {
		
		this.entryId = NaN;
		
		this.listDO.selectedIndex = -1;
		
		this.fileReference = null;
		this.labelTextInputDO.text = "";
		this.localFilePathLabelDO.text = "";
		this.remoteFilePathLabelDO.text = "";
		this.saveButtonDO.enabled = false;
		this.deleteButtonDO.enabled = false;
		this.categoryComboBoxDO.selectedIndex = 0;
		
	}
	
	/**
	 *	On delete button click
	 */
	protected function onDeleteButtonClick ( event : MouseEvent) : void {
		
		var request : URLRequest = new URLRequest( MEDIA_MANAGER_PATH );
		
		var urlVariables : URLVariables = new URLVariables();
		urlVariables["delete"] = true;
		urlVariables["id"] = this.entryId;
		urlVariables["user"] = MyManager.instance.id;
		
		request.data = urlVariables;
		request.method = URLRequestMethod.POST;
		
		var urlLoader : URLLoader = new URLLoader();
		urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
		urlLoader.addEventListener(Event.COMPLETE, this.onEntryDeleteComplete );
		urlLoader.load( request );
		
	}
	
	/**
	 *	On url load complete
	 */
	protected function onUrlLoadComplete ( event : Event ) : void {
		
		trace( "[dm.builder.interfaces.tools.mediamanager.MediaManager.onUrlLoadComplete] event.target : " + event.target );
		
		var responseData : Object;
		
		if ( event is DataEvent ) {
			responseData = JSON.parse( DataEvent( event ).data );
		} else {
			responseData = JSON.parse( ( event.target as URLLoader ).data );
		}
		
		trace( "[dm.builder.interfaces.tools.mediamanager.MediaManager.onUrlLoadComplete] responseData : " + JSON.stringify( responseData, null, 4 ) );
		
		if ( responseData.result == 1 ) {
			Alert.show( "Operation completed", _("Media manager") );
		} else {
			Alert.show( "Operation error", _("Media manager") );
		}
		
		this.fileReference = null;
		
		this.listDataBuilder.refresh();
		
	}
	
	/**
	 *	On browse button click
	 */
	protected function onBrowseButtonClick ( event : MouseEvent) : void {
		
		var fileReference = new FileReference();
		fileReference.addEventListener(Event.SELECT, this.onFileSelect );
		// fileReference.addEventListener(Event.CANCEL, this.onFileBrowseCanceled );
		fileReference.browse( [new FileFilter(_("Media files"), "*.jpg;*.jpeg;*.png;*.gif;*.swf;*.flv;*.f4v;")] );
		
	}
	
	/**
	 *	On file select
	 */
	protected function onFileSelect ( event : Event ) : void {
		
		this.fileReference = event.target as FileReference;
		
		if ( StringUtils.trimToEmpty( this.labelTextInputDO.text ) == "" ) {
			this.labelTextInputDO.text =  this.fileReference.name;
		} 
		
		this.localFilePathLabelDO.text = __("#{Selected file: }") + this.fileReference.name;
		
		this.saveButtonDO.enabled = true;
		
		
	}
	
	/**
	 *	On entry delete complete
	 */
	protected function onEntryDeleteComplete ( event : Event) : void {
		
		var responseData : Object = JSON.parse( ( event.target as URLLoader ).data );
		
		trace( "[dm.builder.interfaces.tools.mediamanager.MediaManager.onEntryDeleteComplete] responseData : " + JSON.stringify( responseData, null, 4 ) );
		
		if ( responseData.result == 1 ) {
			Alert.show( _("Entry deleted"), _("Media manager") );
		} else {
			Alert.show( _("Entry wasn\'t deleted because of error"), _("Media manager") );
		}
		
		this.listDataBuilder.refresh();		
		
	}
	
	/**
	 *	On preview button click
	 */
	protected function onPreviewButtonClick ( event : MouseEvent) : void {
		var functionExecutor : FunctionExecutor = new FunctionExecutor();
		functionExecutor.executeFunction( { label : "openMedia", params : [ { label : "mediaId", value : this.entryId } ] }, this.onMediaPreviewed );
	}
	
	
	/**
	 *	On media previewed
	 */
	protected function onMediaPreviewed ( result : Boolean ) : void {
		
		if ( !result ) {
			this.previewButtonDO.enabled = false;
		}
		
	}
	
	/**
	 *	On http status
	 */
	protected function onHttpStatus ( event : HTTPStatusEvent) : void {
		
		trace( "[dm.builder.interfaces.tools.mediamanager.MediaManager.onHttpStatus] event.status : " + JSON.stringify( event.status, null, 4 ) );
		
	}
	
	/**
	 *	On create category button click
	 */
	protected function onCreateCategoryButtonClick ( event : MouseEvent) : void {
		if ( StringUtils.trimToNull( this.categoryLabelTextInputDO.text ) ) {
			MediaService.createNewCategory( StringUtils.trimToEmpty( this.categoryLabelTextInputDO.text ) )
				.addResponders( this.onCategoryCreated )
				.call();
			
		}
	}
	
	
	/**
	 *	On category created
	 */
	protected function onCategoryCreated () : void {
		Alert.show( _("Category successfuly created!") );
		this.categoryLabelTextInputDO.text = "";
		this.categoryListDataBuilder.refresh();
		this.categoryFilterListDataBuilder.refresh();
	}
	
	/**
	 *	On category filter change
	 */
	protected function onFilterChange ( event : Event) : void {
		
		var filter : Object = { };
		
		filter.__plain__label = StringUtils.trimToEmpty( this.labelFilterTextInputDO.text );
		
		if ( this.categoryFilterComboBoxDO.selectedItem.id ) {
			filter.category_id = this.categoryFilterComboBoxDO.selectedItem.id;
		}
		
		this.listDataBuilder.filterListByEquality( filter );
		
	}

	
}

}