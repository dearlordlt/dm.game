package dm.game.windows.avatar  {
	import dm.game.data.service.AvatarService;
	import dm.game.managers.MyManager;
	import dm.game.windows.alert.Alert;
	import dm.game.windows.avatar.tab.CommunitiesTab;
	import dm.game.windows.avatar.tab.DynamicAchievementsTab;
	import dm.game.windows.avatar.tab.FriendsTab;
	import dm.game.windows.avatar.tab.ResultsTab;
	import dm.game.windows.dialogviewer.DialogViewer;
	import dm.game.windows.DmWindow;
	import dm.game.windows.gallery.Gallery;
	import fl.controls.TextArea;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import ucc.ui.window.tab.TabButton;
	import ucc.ui.window.tab.TabManager;
	import fl.controls.Label;
	import fl.controls.Button;
	import fl.containers.UILoader;	
	import ucc.util.sprintf;
/**
 * Avatar profile
 *
 * @version $Id: AvatarProfile.as 215 2013-09-29 14:28:49Z rytis.alekna $
 */
public class AvatarProfile extends DmWindow {
	
	/** Upload target */
	private static const UPLOAD_URL					: String = "http://vds000004.hosto.lt/dm/uploadPic.php?avatarid=%s";
		
	/** IMAGE_FOLDER_PATH */
	public static const IMAGE_FOLDER_PATH 			: String = "http://vds000004.hosto.lt/dm_avatar_pics/";
		
	/** DAILY_AWARD_DIALOG_ID */
	public static const DAILY_AWARD_DIALOG_ID 		: int = 1165;
	
	/** Avatar name label */
	public var avatarNameLabelDO					: Label;

	/** Save avatar description button */
	public var saveAvatarDescriptionButtonDO		: Button;
	
	/** Daily award button */
	public var dailyAwardButtonDO					: Button;
	
	/** Avatar description text area */
	public var avatarDescriptionTextAreaDO			: TextArea;
	
	/** Avatar pic loader */
	public var avatarPicLoaderDO					: UILoader;	
	
	/** Gallery button */
	public var galleryButtonDO						: Button;
	
	/** This avatar id */
	protected var avatarId							: Number;
	
	/**
	 * Class constructor
	 */
	public function AvatarProfile ( avatarId : Number = NaN ) {
		this.avatarId = avatarId;
		super( null, _("Avatar profile") );
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function initialize () : void {
		
		( new TabManager(this, new Point( 170, 35 )) )
			.addTab( _("Results"), ResultsTab, true, [ this.avatarId ] )
			.addTab( _("Friends"), FriendsTab, true, [ this.avatarId ] )
			.addTab( _("Achievements"), DynamicAchievementsTab, true, [this.avatarId] )
			.draw()
			.openTab()
		
		if ( isNaN( this.avatarId ) ) {
			this.avatarId = MyManager.instance.avatar.id;
		}
			
		
		
		AvatarService.getAvatarDescription( this.avatarId )
			.addResponders( this.onAvatarDescriptionLoaded )
			.call();
			
		
		
		this.avatarPicLoaderDO.useHandCursor = true;
		
		AvatarService.getAvatarPicture( this.avatarId )
			.addResponders( this.onAvatarPicturePathLoaded )
			.call();
		
		this.avatarNameLabelDO.text = __("#{Avatar name}: ") + MyManager.instance.avatar.name;
		
		
		
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function postInitialize (  ) : void {
		
		this.dailyAwardButtonDO.enabled 			=
		this.saveAvatarDescriptionButtonDO.enabled 	= 
		this.avatarDescriptionTextAreaDO.editable	= this.isUserOwner();
		
		this.galleryButtonDO.addEventListener(MouseEvent.CLICK, this.onGalleryButtonClick );
		
		if ( this.isUserOwner() ) {
			this.saveAvatarDescriptionButtonDO.addEventListener( MouseEvent.CLICK, this.onSaveAvatarDescriptionButtonClick );
			this.dailyAwardButtonDO.addEventListener( MouseEvent.CLICK, this.onDailyAwardButtonClick );
			this.avatarPicLoaderDO.addEventListener( MouseEvent.CLICK, this.onAvatarPicLoaderClick );
		}
		
	}
	
	/**
	 *	Save description
	 */
	protected function onSaveAvatarDescriptionButtonClick ( event : MouseEvent) : void {
		AvatarService.setAvatarDescription( this.avatarId, this.avatarDescriptionTextAreaDO.text )
			.call();
	}
	
	private function isUserOwner () : Boolean {
		return ( this.avatarId == MyManager.instance.avatar.id );
	}
	
	/**
	 *	On descriptino loaded
	 */
	protected function onAvatarDescriptionLoaded ( result : String ) : void {
		this.avatarDescriptionTextAreaDO.text = result;
	}
	
	/**
	 *	On avatar pic loader click
	 */
	protected function onAvatarPicLoaderClick ( event : MouseEvent ) : void {
		
		var fileReference 	: FileReference = new FileReference();
		
		var imagesFilter	: FileFilter = new FileFilter( _("Images"), "*.jpg;*.png");
		
		fileReference.addEventListener(Event.SELECT, this.onFileSelected );
		fileReference.addEventListener(Event.CANCEL, this.onFileBrowseCancel );
		fileReference.browse( [imagesFilter] );
		
	}
	
	/**
	 *	On file selected
	 */
	protected function onFileSelected ( event : Event) : void {
		
		var fileReference 	: FileReference = event.target as FileReference;
		
		// if file is larger than two megs - stop
		if ( fileReference.size > 2097152 ) {
			Alert.show( null, _("Selected file must be not larger than 2 megabytes!"));
			return;
		}
		
		fileReference.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, this.onUploadCompleteData );
		fileReference.upload( new URLRequest( sprintf( UPLOAD_URL, MyManager.instance.avatar.id ) ) )
		
	}
	
	/**
	 *	On upload complete data
	 */
	protected function onUploadCompleteData ( event : DataEvent) : void {
		if ( event.data == "true" ) {
			
			Alert.show( _("Image successfuly uploaded!") );
			
			AvatarService.getAvatarPicture( this.avatarId )
				.addResponders( this.onAvatarPicturePathLoaded )
				.call();
			
		} else {
			Alert.show( _("Image upload failed!") );
		}
	}
	
	/**
	 *	On file browse cancel
	 */
	protected function onFileBrowseCancel ( event : Event) : void {
		
	}
	
	
	/**
	 *	On avatar picture path loaded
	 */
	protected function onAvatarPicturePathLoaded ( path : String ) : void {
		this.avatarPicLoaderDO.load( new URLRequest( IMAGE_FOLDER_PATH + path ) );
	}
	
	/**
	 *	On daily award button click
	 */
	protected function onDailyAwardButtonClick ( event : MouseEvent) : void {
		new DialogViewer( this, DAILY_AWARD_DIALOG_ID );
	}
	
	/**
	 *	On gallery button click
	 */
	protected function onGalleryButtonClick ( event : MouseEvent) : void {
		new Gallery( null, this.avatarId );
	}
	
}
	
}