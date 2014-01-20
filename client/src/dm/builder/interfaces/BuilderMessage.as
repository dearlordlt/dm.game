package dm.builder.interfaces {
import com.bit101.components.PushButton;
import flash.display.DisplayObjectContainer;
import flash.events.MouseEvent;
import flash.text.TextFormatAlign;

/**
 * ...
 * @author ...
 */
public class BuilderMessage extends BuilderWindow {
	
	/** On Ok button click callback */
	protected var onOkButtonClickCallback : Function;
	
	public function BuilderMessage( parent : DisplayObjectContainer, name : String, message : String, onOkButtonClickCallback : Function = null ) {
		super( parent, name, 210, 100 );
		
		/** this.onOkButtonPressCallback */
		this.onOkButtonClickCallback = onOkButtonClickCallback;
		
		var message_lbl : BuilderLabel = new BuilderLabel( _body, 10, 10, message );
		message_lbl.textAlign = TextFormatAlign.CENTER;
		message_lbl.multiline = true;
		message_lbl.wordWrap = true;
		
		message_lbl.width = 190;
		message_lbl.height = 50;
		
		var ok_btn : PushButton = new PushButton( _body, _width / 2, message_lbl.y + message_lbl.textHeight + 15, "OK", onOkBtn );
		ok_btn.x -= ok_btn.width * 0.5;
	}
	
	/**
	 * On ko button click
	 * @param	e
	 */
	private function onOkBtn( e : MouseEvent ) : void {
		if ( this.onOkButtonClickCallback ) {
			this.onOkButtonClickCallback();
			this.onOkButtonClickCallback = null;
		}
		destroy();
	}

}

}