package dm.game.windows.intro {
	import dm.game.windows.DmWindow;
	import dm.game.windows.DmWindowManager;
	import fl.controls.Button;
	import fl.video.FLVPlayback;
	import fl.video.VideoEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	

/**
 * Intro video player
 * @version $Id: IntroVideoPlayer.as 105 2013-04-25 12:19:35Z rytis.alekna $
 */
public class IntroVideoPlayer extends DmWindow {
	
	/** Video url */
	private static const VIDEO_URL 		: String = "assets/video/zaidimo_intro_draft.flv";
	
	/** Player */
	public var playerDO					: FLVPlayback;

	/** Play pause button */
	public var playPauseButtonDO		: PlayPauseButton;

	/** Skip intro button */
	public var skipIntroButtonDO		: Button;
	
	/** Volume bar */
	public var volumeBarDO				: VolumeBar;

	/** Seek bar */
	public var seekBarDO				: SeekBar;	
	
	/**
	 * Class constructor
	 */
	public function IntroVideoPlayer () {
		super( null, _("Intro") );
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function initialize (  ) : void {
		
		this.playerDO.playPauseButton 	= this.playPauseButtonDO;
		this.playerDO.seekBar 			= this.seekBarDO;
		this.playerDO.volumeBar 		= this.volumeBarDO;
		
		this.playerDO.addEventListener(VideoEvent.COMPLETE, this.onVideoComplete );
		
		
		
		this.skipIntroButtonDO.addEventListener( MouseEvent.CLICK, this.onSkipIntroButtonClick );
		
		this.playerDO.source = VIDEO_URL;
		
		DmWindowManager.instance.showVideoBackground();
		
	}
	
	/**
	 *	On video complete
	 */
	protected function onVideoComplete ( event : VideoEvent) : void {
		this.destroy();
	}
	
	/**
	 *	On skip intro button click
	 */
	protected function onSkipIntroButtonClick ( event : MouseEvent) : void {
		
		if ( this.playerDO.playing ) {
			this.playerDO.stop();
		}
		
		this.destroy();
		
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function destroy () : void {
		DmWindowManager.instance.hideVideoScreen();
		this.playerDO.getVideoPlayer(0).close();
		super.destroy();
	}
	
}

}