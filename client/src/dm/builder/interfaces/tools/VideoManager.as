package dm.builder.interfaces.tools {
	import dm.game.windows.DmWindow;
	import flash.display.DisplayObjectContainer;
	

/**
 * 
 * @version $Id: VideoManager.as 153 2013-06-04 07:07:12Z rytis.alekna $
 */
public class VideoManager extends DmWindow {
	
	/**
	 * Class constructor
	 */
	public function VideoManager( parent:DisplayObjectContainer = null ) {
		super(parent, _("Video manager"));
			
	}
	
}

}