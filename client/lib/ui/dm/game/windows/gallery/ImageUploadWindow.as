package dm.game.windows.gallery {
	import dm.game.data.service.GalleryService;
	import dm.game.managers.MyManager;
	import dm.game.windows.alert.Alert;
	import dm.game.windows.DmWindow;
	import flash.display.DisplayObjectContainer;
	import fl.containers.UILoader;
	import fl.controls.TextInput;
	import fl.controls.TextArea;
	import fl.controls.Button;	
	import fl.controls.ProgressBar;
	import fl.controls.Label;	
	import flash.display.Loader;
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
	import ucc.ui.window.WindowsManager;
	

/**
 * Image upload window
 * @version $Id: ImageUploadWindow.as 215 2013-09-29 14:28:49Z rytis.alekna $
 */
public class ImageUploadWindow extends DmWindow {
	
	/** MEDIA_MANAGER_PATH */
	public static const GALLERY_MANAGER_PATH : String = "http://vds000004.hosto.lt/dm_dev/GalleryManager.php";	
	
	/** max upload size in bytes */
	public static const MAX_UPLOAD_SIZE		: Number = 512000;
	
	/** Image UI loader */
	public var imageUILoaderDO				: UILoader;

	/** Label text input */
	public var labelTextInputDO				: TextInput;

	/** Description text area */
	public var descriptionTextAreaDO		: TextArea;

	/** Save button */
	public var saveButtonDO					: Button;

	/** Delete button */
	public var deleteButtonDO				: Button;	
	
	/** Vote up button */
	public var voteUpButtonDO				: Button;

	/** Vote down button */
	public var voteDownButtonDO				: Button;

	/** Rating progress bar */
	public var ratingProgressBarDO			: ProgressBar;

	/** Positive rating label */
	public var positiveRatingLabelDO		: Label;

	/** Negative rating label */
	public var negativeRatingLabelDO		: Label;	
	
	/** Local file path label */
	public var localFilePathLabelDO			: Label;
	
	/** Select file button */
	public var selectFileButtonDO			: Button;
		
	/** image data */
	protected var imageData 				: Object;
	
	/** file reference */
	protected var fileReference 			: FileReference;
	
	/** gallery */
	protected var gallery 					: Gallery;
	
	/**
	 * (Constructor)
	 * - Returns a new ImageUploadWindow instance
	 */
	public function ImageUploadWindow(parent:DisplayObjectContainer = null, imageData : Object = null, gallery : Gallery = null ) {
		this.gallery = gallery;
		this.imageData = imageData;
		super( parent, _("Image"));
	}
	
	
	/**
	 *	@inheritDoc
	 */
	public override function postInitialize () : void {
		
		if ( this.imageData ) {
			
			this.labelTextInputDO.text 			= this.imageData.label;
			this.descriptionTextAreaDO.text		= this.imageData.description;
			this.imageUILoaderDO.source			= this.imageData.source;
			
			GalleryService.getImageRating( this.imageData.id, MyManager.instance.avatarId )
				.addResponders( this.onRatingLoaded )
				.call();
			
			this.voteUpButtonDO.addEventListener(Event.CHANGE, this.onVoteButtonClick );
			this.voteDownButtonDO.addEventListener( Event.CHANGE, this.onVoteButtonClick );		
			
				
		} else {
			this.ratingProgressBarDO.setProgress(1, 2);
			this.voteUpButtonDO.enabled 	= false;
			this.voteDownButtonDO.enabled 	= false;
			this.saveButtonDO.enabled 		= false;
			this.deleteButtonDO.enabled		= false;
		}
		
		this.selectFileButtonDO.addEventListener( MouseEvent.CLICK, this.onSelectFileButtonClick );
		
		this.saveButtonDO.addEventListener(MouseEvent.CLICK, this.onSaveButtonClick );
		this.deleteButtonDO.addEventListener(MouseEvent.CLICK, this.onDeleteButtonClick );
		
		
	}
	
	/**
	 *	On vote up button click
	 */
	protected function onVoteButtonClick ( event : Event ) : void {
		
		if ( Button( event.target ).selected ) {
			var vote : String = ( event.target == this.voteUpButtonDO ) ? "Y" : "N";
			GalleryService.rateImage( MyManager.instance.avatar.id, this.imageData.id, vote )
				.addResponders( this.onRatingLoaded )
				.call();
		} else {
			GalleryService.removeRating( MyManager.instance.avatar.id, this.imageData.id )
				.addResponders( this.onRatingLoaded )
				.call();
		}
		
	}	
	
	/**
	 *	On rating loaded
	 */
	protected function onRatingLoaded ( response : Object ) : void {
		
		var ratingSum 		: int = parseInt( response.positive ) + parseInt( response.negative );
		var maxRating		: int = ( ratingSum == 0 ) ? 2 : ratingSum;
		var positiveRating 	: int = ( ratingSum == 0 ) ? 1 : response.positive;
		
		this.ratingProgressBarDO.setProgress( positiveRating, maxRating );
		this.positiveRatingLabelDO.text = response.positive;
		this.negativeRatingLabelDO.text = response.negative;
		
		if ( response.own ) {
			this.voteDownButtonDO.selected = !( this.voteUpButtonDO.selected = ( response.own == "Y" ) );
		}
		
	}	
	
	/**
	 *	On select file button click
	 */
	protected function onSelectFileButtonClick ( event : MouseEvent) : void {
		
		var fileReference = new FileReference();
		fileReference.addEventListener(Event.SELECT, this.onFileSelect );
		// fileReference.addEventListener(Event.CANCEL, this.onFileBrowseCanceled );
		fileReference.browse( [new FileFilter(_("Image"), "*.jpg;*.jpeg;*.png;*.gif;")] );
		
	}
	
	/**
	 *	On file select
	 */
	protected function onFileSelect ( event : Event ) : void {
		
		var fileReference : FileReference = event.target as FileReference;
		
		if ( fileReference.size > MAX_UPLOAD_SIZE ) {
			Alert.show( _("Selected file size exceeds 500 Kb limit. Please resize image and try again!"), _("Image") );
			return;
		}
		
		this.fileReference = fileReference;
		
		if ( StringUtils.trimToEmpty( this.labelTextInputDO.text ) == "" ) {
			this.labelTextInputDO.text =  this.fileReference.name;
		} 
		
		this.localFilePathLabelDO.text = this.fileReference.name;
		
		this.saveButtonDO.enabled = true;
		
		this.fileReference.addEventListener(Event.COMPLETE, this.onFileLoaded );
		this.fileReference.load();
		
	}
	
	function onFileLoaded( event : Event ) : void {
		var loader:Loader = new Loader();
		this.imageUILoaderDO.loadBytes( event.target.data );
		this.fileReference.removeEventListener(Event.COMPLETE, this.onFileLoaded );
	}	
	
	/**
	 *	On save button click
	 */
	protected function onSaveButtonClick ( event : MouseEvent) : void {
		
		var request : URLRequest = new URLRequest( GALLERY_MANAGER_PATH );
		request.data = new URLVariables();
		request.data["avatar"] = MyManager.instance.avatarId;
		if ( this.imageData ) {
			request.data["id"] = this.imageData.id
		}
		request.data["label"] = this.labelTextInputDO.text;
		
		request.data["description"] = this.descriptionTextAreaDO.text;
		
		// request.method = URLRequestMethod.;
		
		if ( this.fileReference ) {
			
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
	 *	On delete button click
	 */
	protected function onDeleteButtonClick ( event : MouseEvent) : void {
		
		var request : URLRequest = new URLRequest( GALLERY_MANAGER_PATH );
		
		var urlVariables : URLVariables = new URLVariables();
		
		urlVariables["delete"] = true;
		urlVariables["avatar"] = MyManager.instance.avatarId;
		urlVariables["id"] = this.imageData.id;
		
		request.data = urlVariables;
		request.method = URLRequestMethod.POST;
		
		trace( "[dm.game.windows.gallery.ImageUploadWindow.onDeleteButtonClick] request.data : " + JSON.stringify( request.data, null, 4 ) );
		
		var urlLoader : URLLoader = new URLLoader();
		
		urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
		urlLoader.addEventListener(Event.COMPLETE, this.onEntryDeleteComplete );
		urlLoader.load( request );
		
	}
	
	/**
	 *	On http status
	 */
	protected function onHttpStatus ( event : HTTPStatusEvent) : void {
		trace( "[dm.game.windows.gallery.ImageUploadWindow.onHttpStatus] event.status : " + JSON.stringify( event.status, null, 4 ) );
	}
			
	/**
	 *	On url load complete
	 */
	protected function onUrlLoadComplete ( event : Event ) : void {
		
		var responseData : Object;
		
		trace( "[dm.game.windows.gallery.ImageUploadWindow.onUrlLoadComplete] responseData 1 : " + JSON.stringify( responseData, null, 4 ) );
		
		if ( event is DataEvent ) {
			responseData = JSON.parse( DataEvent( event ).data );
		} else {
			responseData = JSON.parse( ( event.target as URLLoader ).data );
		}
		
		trace( "[dm.game.windows.gallery.ImageUploadWindow.onUrlLoadComplete] responseData 2 : " + JSON.stringify( responseData, null, 4 ) );
		
		if ( responseData.result == 1 ) {
			this.fileReference = null;
			Alert.show( "Operation completed", _("Media manager") );
			this.refreshGallery();
		} else {
			Alert.show( "Operation error", _("Media manager") );
		}
		
	}	
	
	/**
	 *	On entry delete complete
	 */
	protected function onEntryDeleteComplete ( event : Event) : void {
		
		var responseData : Object = JSON.parse( ( event.target as URLLoader ).data );
		
		trace( "[dm.game.windows.gallery.ImageUploadWindow.onEntryDeleteComplete] responseData : " + JSON.stringify( responseData, null, 4 ) );
		
		if ( responseData.result == 1 ) {
			Alert.show( _("Entry deleted"), _("Image") );
			this.refreshGallery();
		} else {
			Alert.show( _("Entry wasn\'t deleted because of error"), _("Image") );
		}
		
		this.destroy();
		
	}	
	
	protected function refreshGallery () : void {
		if ( this.gallery && this.gallery.stage ) {
			this.gallery.refreshGallery();
		}
	}
	
}

}