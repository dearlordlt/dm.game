package dm.game.media {
	import dm.game.data.service.MediaService;
	import dm.game.functions.BaseExecutable;
	import dm.game.windows.alert.Alert;
	import dm.game.windows.media.ImageViewer;
	import dm.game.windows.media.MediaPlayer;
	import dm.game.windows.media.VideoPlayer;
	

/**
 * Open media command
 * @version $Id: OpenMediaCommand.as 153 2013-06-04 07:07:12Z rytis.alekna $
 */
public class OpenMediaCommand extends BaseExecutable {
	
	/** Players by type */
	private static const playersByType		: Object = {
		"image"	: ImageViewer,
		"swf"	: ImageViewer,
		"video"	: VideoPlayer
	};
		
	/** MEDIA_ID */
	public static const MEDIA_ID 			: String = "mediaId";
	
	/** Path on server */
	public static const PATH_ON_SERVER		: String = "http://vds000004.hosto.lt/dm_media_uploads/";
	
	/**
	 * (Constructor)
	 * - Returns a new OpenMediaCommand instance
	 */
	public function OpenMediaCommand() {
		
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function execute () : void {
		
		MediaService.getMediaById( this.getParamValueByLabel( MEDIA_ID ) )
			.addResponders( this.onMediaInfoLoaded, this.onMediaNotFound )
			.call();
			
		
	}
	
	
	/**
	 *	On media not found
	 */
	protected function onMediaNotFound ( response : Object ) : void {
		
		trace( "[dm.game.media.OpenMediaCommand.onMediaNotFound] response : " + JSON.stringify( response, null, 4 ) );
		
		Alert.show( __( "#{Media with id } [" + this.getParamValueByLabel( MEDIA_ID ) + "] {not found!}" ), _("Media manager") );
	}
	
	
	/**
	 *	On media info loaded
	 */
	protected function onMediaInfoLoaded ( mediaItem : Object ) : void {
		
		if ( playersByType[ mediaItem.type ] ) {
			
			var mediaPlayer : MediaPlayer = new playersByType[ mediaItem.type ]();
			
			mediaPlayer.setFilePath( PATH_ON_SERVER + mediaItem.type + "/" + mediaItem.path );
			
			this.onResult( true );
			
		} else {
			
			Alert.show( __( "#{Media of type} [" + mediaItem.type + "] {doesn\'t have associated player!}" ), _("Media manager") );
			this.onResult( false );
			
		}
		
		
		
	}
	
}

}