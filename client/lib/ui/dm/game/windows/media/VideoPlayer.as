package dm.game.windows.media {
	import dm.game.windows.DmWindow;
	import flash.display.DisplayObjectContainer;
	
	import fl.controls.Button;
	import fl.video.FLVPlayback;
	import fl.video.VideoEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;	
	

/**
 * 
 * @version $Id: VideoPlayer.as 156 2013-06-04 10:54:35Z rytis.alekna $
 */
public class VideoPlayer extends DmWindow implements MediaPlayer {
	
	/** Player */
	public var playerDO					: FLVPlayback;

	/** Play pause button */
	public var playPauseButtonDO		: PlayPauseButton;

	/** Volume bar */
	public var volumeBarDO				: VolumeBar;

	/** Seek bar */
	public var seekBarDO				: SeekBar;		
	
	/**
	 * (Constructor)
	 * - Returns a new VideoPlayer instance
	 */
	public function VideoPlayer() {
		super(parent, _("Video player"));
			
	}
	
	/**
	 *	@inheritDoc 
	 */
	public function setFilePath (value : String ) : void {
		this.playerDO.source = value;
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function initialize (  ) : void {
		
		this.playerDO.playPauseButton 	= this.playPauseButtonDO;
		this.playerDO.seekBar 			= this.seekBarDO;
		this.playerDO.volumeBar 		= this.volumeBarDO;
		
	}	
	
	
	/**
	 *	@inheritDoc
	 */
	public override function destroy () : void {
		
		if ( this.playerDO.playing ) {
			this.playerDO.stop();
		}
		
		super.destroy();
	}
	
}

}