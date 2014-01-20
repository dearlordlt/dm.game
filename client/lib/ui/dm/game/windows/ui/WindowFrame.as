package dm.game.windows.ui {
	
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import ucc.util.MathUtil;
	
/**
 * Window frame
 * 
 * @version $Id: WindowFrame.as 112 2013-05-06 05:55:58Z rytis.alekna $
 */
public class WindowFrame extends Sprite implements IWindowFrame {
	
	/** Min widow width */
	private static const MIN_WIDTH		: Number = 230;
	
	/** Min window height */
	private static const MIN_HEIGHT		: Number = 40;
	
	/** Min heiding background width */
	private static const MIN_HEADING_WIDTH		: Number = 198;
	
	/** Close button padding */
	public static const CLOSE_BUTTON_PADDING 	: Number = 6;
	
	/** Right padding */
	private static const RIGHT_PADDING	: Number = 12;
	
	/** Top padding */
	public static const TOP_PADDING	: Number = 36;
	
	public static const BOTTOM_PADDING	: Number = 12;
	
	/** Heading padding */
	public static const HEADING_PADDING : Number = 20;
	
	/** Close button */
	public var closeButtonDO			: DisplayObject;
	
	/** Drag zone */
	public var dragZoneDO				: SimpleButton;

	/** Title */
	public var titleTF					: TextField;

	/** Heading background */
	public var headingBackgroundDO		: MovieClip;

	/** Chrome */
	public var chromeDO					: MovieClip;	
	
	/** Min width */
	protected var minWidth				: Number;
	
	/** Min height */
	protected var minHeight				: Number;
	
	/**
	 * Class constructor
	 */
	public function WindowFrame () {
		this.init();
	}
	
	protected function init () : void {
	}
	
	/**
	 * Resize window
	 */
	public function draw ( width : Number, height : Number ) : void {
		
		this.titleTF.autoSize = TextFieldAutoSize.LEFT;
		this.dragZoneDO.tabEnabled = false;
		
		this.minWidth = width;
		this.minHeight = height;
		
		this.headingBackgroundDO.width = Math.max( this.titleTF.width + HEADING_PADDING, MIN_HEADING_WIDTH );
		
		this.chromeDO.width 	= 
		this.dragZoneDO.width	= Math.max( MIN_WIDTH, width );
		
		this.dragZoneDO.width -= 20;
		
		this.chromeDO.height 	= Math.max( MIN_HEIGHT, height );
		this.closeButtonDO.x = this.chromeDO.width - CLOSE_BUTTON_PADDING;
		
	}
	
	/**
	 * Set title
	 */
	public function setTitle ( title : String ) : void {
		this.titleTF.text = title;
		this.draw( Math.max( this.titleTF.width, this.minWidth ), this.minHeight );
	}
	
	/**
	 * Get title
	 */
	public function getTitle () : String {
		return this.titleTF.text;
	}
	
}

}