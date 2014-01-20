package dm.game.conditions.impl {
	import dm.game.conditions.BaseCondition;
	import dm.game.functions.commands.AskQuestionCommand;
	

/**
 * 
 * @version $Id: AnswerToQuestionIncorrectCondition.as 204 2013-08-27 08:53:09Z rytis.alekna $
 */
public class AnswerToQuestionIncorrectCondition extends BaseCondition {
	
	/** QUESTION_LABEL */
	public static const QUESTION_LABEL 	: String = "questionLabel";	
		
	/** EXPECTED_ANSWER */
	public static const EXPECTED_ANSWER : String = "expectedAnswer";	
	
	/**
	 * (Constructor)
	 * - Returns a new AnswerToQuestionIncorrectCondition instance
	 */
	public function AnswerToQuestionIncorrectCondition() {
		
	}

	/**
	 *	@inheritDoc
	 */
	public override function execute () : void {
		
		var answer : String = AskQuestionCommand.getQuestionAnswer( this.getParamValueByLabel( QUESTION_LABEL ) );
		
		if ( answer && ( answer == this.getParamValueByLabel( EXPECTED_ANSWER ) ) ) {
			this.onResult( false );
		} else {
			this.onResult( true );
		}		
		
	}
	
}

}