package dm.game.functions.commands {
	import dm.game.functions.BaseExecutable;
	

/**
 * Ask question command
 * @version $Id: AskQuestionCommand.as 204 2013-08-27 08:53:09Z rytis.alekna $
 */
public class AskQuestionCommand extends BaseExecutable {
	
	/** QUESTION_LABEL */
	public static const QUESTION_LABEL 	: String = "questionLabel";
		
	/** QUESTION_TEXT */
	public static const ANSWER_TEXT 	: String = "answerText";
	
	/** Answers */
	private static const answers		: Object = { };
	
	/**
	 * (Constructor)
	 * - Returns a new AskQuestionCommand instance
	 */
	public function AskQuestionCommand() {
		
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function execute () : void {
		setQuestionAnswer( this.getParamValueByLabel( QUESTION_LABEL ), this.getParamValueByLabel( ANSWER_TEXT ) );
		this.onResult(true);
	}
	
	/**
	 * Set question answer
	 * @param	questLabel
	 * @param	answer
	 */
	public static function setQuestionAnswer ( questionLabel : String, answer : String ) : void {
		answers[ questionLabel ] = answer;
	}
	
	/**
	 * Gets the QuestionAnswer of the specified questionLabel.
	 * @param	questionLabel
	 * @return
	 */
	public static function getQuestionAnswer ( questionLabel : String ) : String {
		return answers[ questionLabel ];
	}
	
}

}