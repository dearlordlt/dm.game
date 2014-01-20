package ucc.ui.skin.pink {
	
import flash.display.MovieClip;
import ucc.ui.graphic.DashedLine;
	
/**
 * Dashed square
 * 
 * @version $Id: DashedSquare.as 112 2013-05-06 05:55:58Z rytis.alekna $
 */
public class DashedSquare extends MovieClip {
	
	/** Dash color */
	public static const COLOR			: uint = 0x575756;
	
	/** Dash interval */
	public static const	DASH_INTERVAL	: Array = [5,3];
	
	/** Square */
	protected var square				: DashedLine;
	
	/**
	 * Class constructor
	 */
	public function DashedSquare () {
		
		this.square = new DashedLine(1, COLOR, 0.6, DASH_INTERVAL );
		
		// trace( "[ucc.ui.skin.pink.DashedSquare.DashedSquare] this.width, this.height : " + this.width, this.height );
		
		// this.drawSquare( this.width, this.height );
		
		this.addChild( this.square );
		
	}
	
	protected function drawSquare ( width : Number, height : Number ) : void {
		this.square.clear();
		
		
		// horizontal lines
		this.square.setLengthsArray( [ DASH_INTERVAL[0] / this.scaleX, DASH_INTERVAL[1] / this.scaleX ] )
		this.square.moveTo( 0, 0 );
		this.square.lineTo( width, 0 );
		this.square.moveTo( 0, height );
		this.square.lineTo( width, height );
		
		// vertical
		this.square.setLengthsArray( [ DASH_INTERVAL[0] / this.scaleY, DASH_INTERVAL[1] / this.scaleY ] )
		this.square.moveTo( 0, 0 );
		this.square.lineTo( 0, height );
		this.square.moveTo( width, 0 );
		this.square.lineTo( width, height );
	}
	
	public override function set width ( value : Number ) : void {
		
		this.removeChild( this.square );
		super.width = value;
		
		
		this.drawSquare( value / this.scaleX, this.height )
		// this.square.scaleX = this.scaleX;
		this.addChild( this.square );
		
	}
	
	
	public override function set height ( value : Number ) : void {
		this.removeChild( this.square );
		super.height = value;
		// this.square.scaleY = 1;
		// trace( "[ucc.ui.skin.pink.DashedSquare.height] this.width, value : " + this.width, value );
		
		this.drawSquare( this.width / this.scaleX, value / this.scaleY );
		this.addChild( this.square );
		// this.square.scaleY = this.scaleY;
	}
	
	
}

}