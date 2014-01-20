package dm.game.windows.alert  {
	import dm.game.windows.DmWindow;
	import fl.controls.Button;
	import fl.controls.Label;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
/**
 * Alert window
 *
 * @version $Id: Alert.as 123 2013-05-13 07:08:24Z rytis.alekna $
 */
public class Alert extends DmWindow {
	
	/** Spacing between message and OK button */
	private static const SPACING		: Number = 8;
	
	/** Default title */
	private static const DEFAULT_TITLE	: String = "Alert";
	
	/** Message */
	public var messageTF				: Label;

	/** Ok button */
	public var okButtonDO				: Button;
	
	/** title */
	protected var title : String;

	/** message */
	protected var message : String;
	
	/** onOkCallback */
	protected var onOkCallback : Function;
	
	/**
	 * Show alert window
	 * @param	message
	 * @param	title
	 * @param	onOkCallback
	 * @param	parent
	 */
	public static function show ( message : String = "", title : String = null, onOkCallback : Function = null, parent : DisplayObjectContainer = null ) : void {
		new Alert( parent, message, title, onOkCallback );
	}
	
	/**
	 * Class constructor
	 */
	public function Alert ( parent : DisplayObjectContainer = null, message : String = "", title : String = null, onOkCallback : Function = null ) {
		this.onOkCallback = onOkCallback;
		this.message = message;
		if ( !title ) {
			title = _( DEFAULT_TITLE );
		}
		this.title = title;
		super( parent, title );
		
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function postInitialize () : void {
		this.messageTF.text = this.message;
		this.okButtonDO.y = Math.max( 28, this.messageTF.textField.textHeight ) + this.messageTF.y + SPACING;
		this.redraw();
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function initialize () : void {
		this.okButtonDO.addEventListener( MouseEvent.CLICK, this.onOkButtonClick );
	}
	
	/**
	 *	On ok button click
	 */
	protected function onOkButtonClick ( event : MouseEvent) : void {
		if ( this.onOkCallback ) {
			this.onOkCallback();
		}
		this.okButtonDO.removeEventListener( MouseEvent.CLICK, this.onOkButtonClick );
		this.destroy();
		
	}
	
}
	
}