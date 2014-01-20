package dm.builder.interfaces {
	import com.bit101.components.PushButton;
	import dm.builder.interfaces.BuilderWindow;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	import net.richardlord.ash.signals.Signal1;
	
	/**
	 * ...
	 * @author
	 */
	public class YNMessage extends BuilderWindow {
		public var selectSignal:Signal1;
		
		public function YNMessage(parent:DisplayObjectContainer, name:String, message:String, yesBtnLabel:String = "Yes", noBtnLabel:String = "No") {
			super(parent, name, 210, 100);
			
			selectSignal = new Signal1(int);
			
			var message_lbl:BuilderLabel = new BuilderLabel(_body, 10, 10, message);
			message_lbl.textAlign = TextFormatAlign.CENTER;
			message_lbl.multiline = true;
			message_lbl.wordWrap = true;
			
			message_lbl.width = 190;
			message_lbl.height = 50;
			
			var yes_btn:PushButton = new PushButton(_body, 20, message_lbl.y + message_lbl.textHeight + 15, yesBtnLabel, onYesBtn);
			yes_btn.width = 70;
			var no_btn:PushButton = new PushButton(_body, yes_btn.x + yes_btn.width + 10, message_lbl.y + message_lbl.textHeight + 15, noBtnLabel, onNoBtn);
			no_btn.width = 70;
		}
		
		private function onYesBtn(e:MouseEvent):void {
			selectSignal.dispatch(1);
			destroy();
		}
		
		private function onNoBtn(e:MouseEvent):void {
			selectSignal.dispatch(0);
			destroy();
		}
	}

}