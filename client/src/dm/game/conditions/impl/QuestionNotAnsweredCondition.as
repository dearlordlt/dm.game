package dm.game.conditions.impl {
	import dm.game.conditions.BaseCondition;
	import dm.game.functions.commands.AskQuestionCommand;
	

/**
 * 
 * @version $Id: QuestionNotAnsweredCondition.as 204 2013-08-27 08:53:09Z rytis.alekna $
 */
public class QuestionNotAnsweredCondition extends BaseCondition {
	
	/** QUESTION_LABEL */
	public static const QUESTION_LABEL 	: String = "questionLabel";		
	
	/**
	 * (Constructor)
	 * - Returns a new QuestionNotAnswered instance
	 */
	public function QuestionNotAnswered() {
		
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function execute () : void {
		
		var answer : String = AskQuestionCommand.getQuestionAnswer( this.getParamValueByLabel( QUESTION_LABEL ) );
		this.onResult( !answer );
		
	}
	
}

}