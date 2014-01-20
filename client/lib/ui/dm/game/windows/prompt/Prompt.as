package dm.game.windows.prompt {
	import dm.game.windows.DmWindow;
	import fl.controls.Button;
	import fl.controls.Label;
	import fl.controls.TextInput;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import org.as3commons.lang.ClassNotFoundError;
	import org.as3commons.lang.ClassUtils;
	

/**
 * Prompt
 * @version $Id: Prompt.as 153 2013-06-04 07:07:12Z rytis.alekna $
 */
public class Prompt extends DmWindow {
	
	
	/** Spacing between message and OK button */
	private static const SPACING		: Number = 16;

	/** Default title */
	private static const DEFAULT_TITLE	: String = "Prompt";	
	
	/** Message */
	public var messageTF				: Label;
	
	/** Text input */
	public var textInputDO				: TextInput;
	
	/** Ok button */
	public var okButtonDO				: Button;
	
	/** title */
	protected var title 				: String;

	/** message */
	protected var message 				: String;
	
	/** onOkCallback */
	protected var onOkCallback 			: Function;	
	
	/** defaultValue */
	protected var defaultValue 			: String;
	
	/** cast */
	protected var cast 					: String;
	
	
	/**
	 * Show promt window
	 * @param	message
	 * @param	title
	 * @param	defaultValue
	 * @param	onOkCallback	Must align with this signature ( value : cast ) => *
	 * @param	cast			Class name to cast value into
	 * @param	parent
	 */
	public static function show ( message : String = "", title : String = null, defaultValue : String = "", onOkCallback : Function = null, cast : String = "String", parent : DisplayObjectContainer = null ) : void {
		new Prompt( parent, message, title, defaultValue, onOkCallback, cast );
	}
	
	public function Prompt( parent : DisplayObjectContainer = null, message : String = "", title : String = null, defaultValue : String = "", onOkCallback : Function = null, cast : String = "String" ) {
		this.cast = cast;
		
		this.defaultValue = defaultValue;
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
		this.textInputDO.text = defaultValue;
		
		this.redraw();
		this.okButtonDO.y = Math.max( 28, this.messageTF.textField.textHeight ) + this.messageTF.y + this.textInputDO.height + SPACING;
		
		
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
			
			try {
				var castClass : Class = ClassUtils.forName( this.cast );
			} catch ( error : ClassNotFoundError ) {
				castClass = String;
			}
			
			this.onOkCallback( castClass( this.textInputDO.text ) );
			
		}
		
		this.okButtonDO.removeEventListener( MouseEvent.CLICK, this.onOkButtonClick );
		this.destroy();
		
	}	
	
}

}