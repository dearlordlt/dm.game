package dm.game.windows.menu {
	
import flash.display.MovieClip;
import flash.display.Sprite;
import ucc.util.MathUtil;
	
/**
 * Statistics progress bar
 * 
 * @version $Id: StatisticsProgressBar.as 9 2013-01-09 09:53:24Z rytis.alekna $
 */
public class StatisticsProgressBar extends MovieClip {
	
	/** Bar */
	public var barDO	: MovieClip;
	
	/**
	 * Class constructor
	 */
	public function StatisticsProgressBar () {
		
	}
	
	/**
	 * Set progress
	 */
	public function setProgress ( value : Number ) : void {
		this.barDO.scaleX = MathUtil.normalize( value, 0, 1 );
	}
	
}

}