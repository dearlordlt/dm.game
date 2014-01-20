<?php
/**
 * Base class for users operations
 * Users
 */
class Dialog
{	
    
	/**
	 *	PDO connection
	 * @var PDO
	 */
	private $con;
	
	function __construct() { //Constructor
		$this->con = PDOConnection::con( basename(__DIR__) );
		include_once 'Functions.php';
		include_once 'Conditions.php';
	}
	
	
	function getDialogById($dialogId) {
		$dialog_rs = mysql_query("SELECT dialog_dialogs.*, dialog_topics.label AS topic FROM dialog_dialogs LEFT JOIN dialog_topics ON ( dialog_topics.id = dialog_dialogs.topic_id ) WHERE dialog_dialogs.id = ".$dialogId.";");
		$dialog = mysql_fetch_object($dialog_rs);
		$phrase_rs = mysql_query("SELECT * FROM dialog_phrases WHERE dialog_id=".$dialogId.";");
		$dialog->phrases = array();
		while($phrase = mysql_fetch_object($phrase_rs)) {
			$phrase->conditions = $this->getPhraseConditions($phrase->id);
			$phrase->functions = $this->getPhraseFunctions($phrase->id);
			array_push($dialog->phrases, $phrase);
		}
		return $dialog;
	}
	
	function getAllDialogs() {
		$dialog_rs = mysql_query("SELECT id, name AS label FROM dialog_dialogs;");
		$dialogs = array();
		while($dialog = mysql_fetch_object($dialog_rs))
			$dialogs[] = $dialog;
		return $dialogs;
	}
	
	function getPhraseFunctions($phraseId) {
		$function_rs = mysql_query("SELECT * FROM functions_to_phrases WHERE phrase_id=".$phraseId.";");
		$functionsClass = new Functions();
		$functions = array();
		while($function = mysql_fetch_object($function_rs))
			array_push($functions, $functionsClass->getFunctionById($function->function_id));
		return $functions;
	}
	
	function getPhraseConditions($phraseId) {
		$condition_rs = mysql_query("SELECT * FROM conditions_to_phrases WHERE phrase_id=".$phraseId.";");
		$conditionsClass = new Conditions();
		$conditions = array();
		while($condition = mysql_fetch_object($condition_rs))
			array_push($conditions, $conditionsClass->getConditionById($condition->condition_id));
		return $conditions;
	}
}
?>