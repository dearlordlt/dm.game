package dm.game.windows.gallery {
	import dm.game.data.service.GalleryService;
	import dm.game.managers.MyManager;
	import dm.game.util.AvatarUtil;
	import dm.game.windows.DmWindow;
	import fl.events.ListEvent;
	import flash.display.DisplayObjectContainer;
	import fl.controls.TileList;
	import fl.controls.Button;	
	import flash.events.MouseEvent;
	import ucc.ui.dataview.DataViewBuilder;
	

/**
 * 
 * @version $Id: Gallery.as 215 2013-09-29 14:28:49Z rytis.alekna $
 */
public class Gallery extends DmWindow {
	
	/** Gallery tile list */
	public var galleryTileListDO		: TileList;

	/** Add media button */
	public var addMediaButtonDO			: Button;	
	
	/** avatarId */
	protected var avatarId 				: Number;
	
	/** Data view builder */
	protected var dataViewBuilder		: DataViewBuilder;
	
	/**
	 * (Constructor)
	 * - Returns a new Gallery instance
	 */
	public function Gallery( parent : DisplayObjectContainer = null, avatarId : Number = NaN ) {
		if ( isNaN( avatarId ) ) {
			this.avatarId = MyManager.instance.avatarId;
		} else {
			this.avatarId = avatarId;
		}
		super( parent, _("Gallery") );
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function initialize (  ) : void {
		if ( AvatarUtil.isAvatarMe( this.avatarId ) ) {
			this.addMediaButtonDO.addEventListener(MouseEvent.CLICK, this.onAddMediaButtonClick );
		}
		
		this.dataViewBuilder = ( new DataViewBuilder( this.galleryTileListDO ) )
			.setService( GalleryService.getAvatarImages( this.avatarId ) )
		
		this.refreshGallery();
		
		this.galleryTileListDO.addEventListener(ListEvent.ITEM_CLICK, this.onImageClick );
		
	}
	
	public function refreshGallery () : void {
		this.dataViewBuilder.refresh();
	}
	
	/**
	 *	On add media button click
	 */
	protected function onAddMediaButtonClick ( event : MouseEvent) : void {
		new ImageUploadWindow( null, null, this );
	}
	
	/**
	 *	On image click
	 */
	protected function onImageClick ( event : ListEvent) : void {
		
		if ( AvatarUtil.isAvatarMe( this.avatarId ) ) {
			new ImageUploadWindow( null, event.item, this );
		} else {
			new GalleryImageViewer( null, event.item );
		}
		
	}
	
	
}

}