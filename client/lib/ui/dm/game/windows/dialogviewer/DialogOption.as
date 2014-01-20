package dm.game.windows.dialogviewer {
	
	import dm.game.functions.commands.AskQuestionCommand;
	import fl.controls.Button;
	import fl.controls.Label;
	import fl.controls.TextInput;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	import org.as3commons.lang.StringUtils;
	import ucc.ui.style.DynamicStyleManager;
	import ucc.util.ArrayUtil;
	
	/**
	 * Dialog option
	 * @version $Id: DialogOption.as 212 2013-09-26 05:52:06Z rytis.alekna $
	 */
	[Event(name="dm.game.windows.dialogviewer.OptionEvent.SELECTED", type="dm.game.windows.dialogviewer.OptionEvent")]
	public class DialogOption extends Sprite {
		
		/** ASK_QUESTION */
		public static const ASK_QUESTION 	: String = "askQuestion";
		
		/** Max width */
		private const MAX_WIDTH				: Number = 440;
		
		/** Answer text input */
		public var answerTextInputDO		: TextInput;

		/** Submit button */
		public var submitButtonDO			: Button;

		/** Text label */
		public var textLabelDO				: Label;		
		
		/** Phrase */
		private var _phrase					: Object;
		
		/** background */
		private var backgroundDO			: Sprite;
		
		/**
		 * (Constructor)
		 * - Returns a new DialogOption instance
		 * @param	phrase
		 */
		public function DialogOption(phrase:Object) {
			_phrase = phrase;
			setTimeout( this.postInitialize, 1 );
			
		}
		
		/**
		 * Post initialize
		 */
		protected function postInitialize () : void {
			draw();
		}
		
		/**
		 *	On mouse click
		 */
		protected function onMouseClick ( event : MouseEvent) : void {
			this.dispatchEvent( new OptionEvent( OptionEvent.SELECTED ) );
		}
		
		/**
		 *	On submit button click
		 */
		protected function onSubmitButtonClick ( event : MouseEvent) : void {
			var question : Object = ArrayUtil.getElementByPropertyValue( this.phrase.functions, "label", ASK_QUESTION );
			question.params.push( { label : AskQuestionCommand.ANSWER_TEXT, value : StringUtils.trimToEmpty( this.answerTextInputDO.text ) } );
			this.dispatchEvent( new OptionEvent( OptionEvent.SELECTED ) );
		}
		
		/**
		 * On mouse out
		 */
		private function onMouseOut(e:MouseEvent):void {
			backgroundDO.visible = false;
			// tf.textColor = 0x777777;
		}
		
		/**
		 * On mouse over
		 */
		private function onMouseOver(e:MouseEvent):void {
			backgroundDO.visible = true;
			// tf.textColor = 0xFFFFFF;
		}
		
		/**
		 * draw
		 */
		private function draw():void {
			
			this.textLabelDO.text = unescape(_phrase.text);
			
			this.textLabelDO.drawNow();
			
			// this.textLabelDO.height = this.textLabelDO.textField.textHeight;
			
			var textHeight	: Number = this.textLabelDO.textField.textHeight;
			
			this.answerTextInputDO.visible 	= 
			this.submitButtonDO.visible 	= this.isQuestion();
			
			if ( this.isQuestion() ) {
				
				this.answerTextInputDO.visible 	= 
				this.submitButtonDO.visible 	= true;
				
				this.answerTextInputDO.y 	= 
				this.submitButtonDO.y 		= textHeight + 15;
				
				this.submitButtonDO.addEventListener( MouseEvent.CLICK, this.onSubmitButtonClick );
				
				
			// draw answer background button
			} else {
				
				this.answerTextInputDO.visible 	= 
				this.submitButtonDO.visible 	= false;
				
				
				this.addEventListener( MouseEvent.CLICK, this.onMouseClick );
				this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);				
				
				this.backgroundDO = new Sprite();
				this.addChildAt( this.backgroundDO, 0 );
				backgroundDO.visible = false;			
				
				backgroundDO.graphics.lineStyle(0, 0, 0);
				backgroundDO.graphics.beginFill( DynamicStyleManager.getStyleForClass( DialogOption, "buttonColor" ) );
				backgroundDO.graphics.moveTo(0, 0);
				backgroundDO.graphics.lineTo(MAX_WIDTH + 15, 0);
				backgroundDO.graphics.lineTo(MAX_WIDTH + 20, (textHeight + 15) * 0.5);
				backgroundDO.graphics.lineTo(MAX_WIDTH + 15, (textHeight + 15));
				backgroundDO.graphics.lineTo(0, (textHeight + 15));
				backgroundDO.graphics.lineTo(0, 0);
				backgroundDO.graphics.endFill();			
			}
			
		}
		
		/**
		 * Determinates whether this instance is a Question.
		 * @return
		 */
		public function isQuestion () : Boolean {
			
			if ( this.phrase.functions ) {
				return ( ArrayUtil.getElementByPropertyValue( this.phrase.functions, "label", ASK_QUESTION ) != null )
			} else {
				return false;
			}
			
		}
		
		
		
		public function getHeight () : Number {
			return this.textLabelDO.textField.textHeight + ( this.isQuestion() ? 45 : 15 );
		}
		
		public function get phrase():Object {
			return _phrase;
		}
	
	}

}