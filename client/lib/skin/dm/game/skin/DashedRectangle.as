package dm.game.skin {
	
import flash.display.Shape;
import flash.display.Sprite;
import ucc.ui.graphic.DashedLine;
	
/**
 * Dashed rectangle
 * 
 * @version $Id: DashedRectangle.as 128 2013-05-22 08:15:58Z rytis.alekna $
 */
public class DashedRectangle extends Sprite {
	
	/** Dash line */
	private static const INTERVAL		: Array = [5,3];
	
	/** Rectangle */
	public var rectangle : DashedLine;
	
	/**
	 * Class constructor
	 */
	public function DashedRectangle () {
		
		this.rectangle = new DashedLine( 1, 0x0, INTERVAL );
		this.addChild( rectangle );
		
		
	}
	
	
	private function draw () : void {
		
		
		
		
	}
	
	
}

}