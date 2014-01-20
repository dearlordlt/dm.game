package dm.game.windows.confirm {
	import dm.game.windows.DmWindow;
	import fl.controls.Button;
	import fl.controls.Label;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	

/**
 * Confirmation window
 * @version $Id: Confirm.as 123 2013-05-13 07:08:24Z rytis.alekna $
 */
public class Confirm extends DmWindow {
	
	/** Spacing between message and buttons */
	private static const SPACING		: Number = 8;	
	
	/** Default title */
	private static const DEFAULT_TITLE	: String = "Confirm";
	
	/** onNoCallback */
	protected var onNoCallback : Function;

	/** onYesCallback */
	protected var onYesCallback : Function;
	
	/** message */
	protected var message 		: String;
	
	/** title */
	protected var title 		: String;
	
	/** Message */
	public var messageTF		: Label;

	/** Yes button */
	public var yesButtonDO		: Button;

	/** No button */
	public var noButtonDO		: Button;	
	
	public static function show ( message : String = "", title : String = null, onYesCallback : Function = null, onNoCallback : Function = null, parent : DisplayObjectContainer = null ) : void {
		new Confirm( parent, message, title, onYesCallback, onNoCallback );
	}	
	
	/**
	 * Class constructor
	 */
	public function Confirm ( parent : DisplayObjectContainer = null, message : String = "", title : String = null, onYesCallback : Function = null, onNoCallback : Function = null ) {
		this.message = message;
		this.onYesCallback = onYesCallback;
		this.onNoCallback = onNoCallback;
		if ( !title ) {
			title = _( DEFAULT_TITLE );
		}
		this.title = title;
		super( parent, title );
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function isCloseable (  ) : Boolean {
		return false;
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function postInitialize (  ) : void {
		this.messageTF.text = this.message;
		this.yesButtonDO.y 	= 
		this.noButtonDO.y	= Math.max( 28, this.messageTF.textField.textHeight ) + this.messageTF.y + SPACING;
		this.redraw();
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function initialize () : void {
		this.yesButtonDO.addEventListener( MouseEvent.CLICK, this.onYesButtonClick );
		this.noButtonDO.addEventListener( MouseEvent.CLICK, this.onNoButtonClick );
	}
	
	/**
	 *	On ok button click
	 */
	protected function onYesButtonClick ( event : MouseEvent) : void {
		if ( this.onYesCallback ) {
			this.onYesCallback();
		}
		
		this.destroy();
		
	}	
	
	/**
	 *	On no button click
	 */
	protected function onNoButtonClick ( event : MouseEvent) : void {
		if ( this.onNoCallback ) {
			this.onNoCallback();
		}
		this.destroy();		
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function destroy (  ) : void {
		this.yesButtonDO.removeEventListener( MouseEvent.CLICK, this.onYesButtonClick );
		super.destroy();
	}
	
}

}