<?php

/**
 * DialogException. Thrown when malformed dialog data given to service
 *
 * @author $Id$
 */
class DialogException extends Exception {

	function __construct( $message = "", $code = 0, Exception $previous = NULL ) {
		parent::__construct( $message, $code, $previous );
	}

}

/**
 * DialogEditor
 *
 * @author $Id$
 */
class DialogEditor {
    
    /**
     * @var PDO 
     */
    private $con;
    
    /**
     * Constructor
     */
    function DialogEditor() {
		$this->con = PDOConnection::con( basename(__DIR__) ); 
		// require_once("RemoteEcho.php");
 
		// Start a Remote Echo session
		// RemoteEcho::Start("454240feea8393d683ac79a211987699"); // This session ID must match the session ID in the URL in your browser
 
    }
    
    
    /**
     * Get all dialogs
     * @return type
     */
    function getAllDialogsHeaders ( $userId ) {
		if ($this->isUserAdmin($userId) ) {
			$stm = $this->con->prepare("
				SELECT 
					dialog_dialogs.id, 
					dialog_dialogs.name, 
					dialog_dialogs.last_modified_date, 
					users.username, 
					dialog_topics.label AS topic 
					FROM dialog_dialogs 
					LEFT JOIN users 
						ON ( dialog_dialogs.last_modified_by = users.id ) 
					LEFT JOIN dialog_topics 
						ON ( dialog_topics.id = dialog_dialogs.topic_id ) 
					ORDER BY last_modified_date DESC
			");
			$stm->execute();
		} else {
			$stm = $this->con->prepare("
				SELECT 
					dialog_dialogs.id, 
					dialog_dialogs.name, 
					dialog_dialogs.last_modified_date, 
					users.username, 
					dialog_topics.label AS topic 
					FROM dialog_dialogs 
					LEFT JOIN users 
						ON ( dialog_dialogs.last_modified_by = users.id ) 
					LEFT JOIN dialog_permisions 
						ON ( dialog_dialogs.id = dialog_permisions.dialog_id ) 
					LEFT JOIN dialog_topics 
						ON ( dialog_topics.id = dialog_dialogs.topic_id ) 
					WHERE dialog_permisions.user_id = :user_id 
					ORDER BY last_modified_date DESC
			");
			$stm->execute(
				array (
					"user_id" => $userId
				)
			);
		}
		return $stm->fetchAll(PDO::FETCH_OBJ);
    }
    
	/**
	 * Is user admin?
	 * @param int $userId
	 * @return true if yes
	 */
	function isUserAdmin ( $userId ) {
		$stm = $this->con->prepare("SELECT isadmin FROM users WHERE id=:id");
		$stm->execute(
				array (
					"id" => $userId
				)
		);
		
		return ( $stm->fetchColumn() == "Y" );
		
	}
	
	/**
	 * Set permision to dialog
	 */
	function addPermisionToDialog ( $dialogId, $userId ) {
		
		try {
			$stm = $this->con->prepare("INSERT IGNORE INTO dialog_permisions (dialog_id, user_id) VALUES (:dialog_id, :user_id)");
			return $stm->execute(
					array (
						"dialog_id" => $dialogId,
						"user_id" => $userId
					)
			);
			
		} catch ( PDOException $error ) {
			
			return false;
			
		}
		
	}
	
	/**
	 * Set permision to dialog
	 */
	function removePermisionFromDialog ( $dialogId, $userId ) {
		
			$stm = $this->con->prepare("DELETE FROM dialog_permisions WHERE dialog_id = :dialog_id AND user_id = :user_id");
			return $stm->execute(
					array (
						"dialog_id" => $dialogId,
						"user_id" => $userId
					)
			);
		
	}	
	
	function hasPermisionToDialog ( $dialogId, $userId ) {
		if ( $this->isUserAdmin($userId) ) {
			return true;
		} else {
			
			$stm = $this->con->prepare("SELECT * FROM dialog_permisions WHERE dialog_id = :dialog_id AND user_id = :user_id");
			$stm->execute(
					array (
						"dialog_id" => $dialogId,
						"user_id" => $userId
					)
			);
			
			return ( $stm->rowCount() == 1 );
			
		}
	}
	
	function getAllUsersAssignedToDialog ( $dialogId ) {
		
		$stm = $this->con->prepare("SELECT users.id, users.username FROM users LEFT JOIN dialog_permisions ON (dialog_permisions.user_id = users.id) WHERE dialog_permisions.dialog_id = :dialog_id");
		$stm->execute(
				array (
					"dialog_id" => $dialogId,
				)
		);
		
		return $stm->fetchAll(PDO::FETCH_OBJ);
		
	}
	
	function getAllUsers () {
		$stm = $this->con->prepare("SELECT users.id, users.username FROM users");
		$stm->execute();
		return $stm->fetchAll(PDO::FETCH_OBJ);
	}
	
    /**
     * Get dialog header (without phrases)
     * @param int $id	duialog id
     * @return dialog header
     */
    function getDialogHeaderById ( $id ) {
	
	$dialogStm = $this->con->prepare("SELECT * FROM dialog_dialogs WHERE id=:id");
	$dialogStm->execute(
		array(
		    "id" => $id
		)
	);
	return $dialogStm->fetch(PDO::FETCH_OBJ);
	
    }    
    
    /**
     * Get dialog by id
     * @return	dialog->
     *		    phrases[
     *			phrase->
     *			    conditions[
     *				condition[id, label, param]
     *			    ],
     *			    functions[
     *				function[id, label, param]
     *			    ]
     *		    ]
     *		
     *	
     */
    function getDialogById ( $id ) {
		$dialog = $this->getDialogHeaderById ( $id );
    }
    
    /**
     * 
     * @param type $id
     * @return [
     *			phrase->
     *			    conditions[
     *				condition[id, label, param]
     *			    ],
     *			    functions[
     *				function[id, label, param]
     *			    ]
     *		]
     */
    function getPhrasesByDialogId ( $id ) {

		$phrasesStm = $this->con->prepare("SELECT * FROM dialog_phrases WHERE dialog_id=:id");

		$phrasesStm->execute(
			array(
				"id" => $id
			)
		);
    }
    
    /**
     * Get phrase functions
     * @param type $id
     * @return [
     *	    function[
     *		id, 
     *		function_to_phrase_id, 
     *		label, phrase_id, 
     *		params [
     *		    param[label, value]
     *		]
     *	    ]
     *	]
     */
    function getFunctionsByPhraseId ( $id ) {
		$stm = $this->con->prepare("SELECT functions_to_phrases.id AS function_to_phrase_id
			FROM functions_to_phrases LEFT JOIN functions ON () WHERE phrase_id=:id");

		$stm->execute(
			array(
				"id" => $id
			)
		);	
		return;
    }
    
    function getFunctionParamsByFunctionId ( $id ) {
	
    }
    
    /**
     * Get all functions
     * @return [
     *	    function[
     *		label,
     *		params[
     *		   id,
     *		   label
     *		]
     *	    ]
     *	]
     */
    function getAllFunctions () {
	
		$functionsStm = $this->con->prepare("SELECT * FROM function_labels");
		$functionsStm->execute();

		$functions = $functionsStm->fetchAll(PDO::FETCH_OBJ);

		$labelsStm = $this->con->prepare("SELECT * FROM function_param_labels WHERE function_id=:functionId");

		foreach ($functions as $function) {

			$labelsStm->execute(
				array (
					"functionId" => $function->id
				)
			);

			$function->params = $labelsStm->fetchAll(PDO::FETCH_OBJ);

		}

		return $functions;
    }
    
    
    /**
     * Get all conditions
     * @return [
     *	    condition[
     *		label,
     *		params[
     *		   id,
     *		   label
     *		]
     *	    ]
     *	]
     */
    function getAllConditions () {
	
		$conditionsStm = $this->con->prepare("SELECT * FROM condition_labels");
		$conditionsStm->execute();

		$conditions = $conditionsStm->fetchAll(PDO::FETCH_OBJ);

		$labelsStm = $this->con->prepare("SELECT * FROM condition_param_labels WHERE condition_id=:conditionId");

		foreach ($conditions as $condition) {

			$labelsStm->execute(
				array (
				"conditionId" => $condition->id
				)
			);

			$condition->params = $labelsStm->fetchAll(PDO::FETCH_OBJ);

		}

		return $conditions;
    }    
    
    /**
     * Get phrase conditions
     * @param type $id
     * @return [
     *	    condition[id, label, param]
     *	]
     */
    function getConditionsByPhraseId ( $id ) {
		return;
    }    
    
    /**
     * Save dialog
     * @param  object
	 * @return int dialog id
     */
    function saveDialog ( $dialog ) {
		
		// this line converts associative array to object.
		// this is needed because AmfPhp unregistered classes converts to associative arrays
		// $dialog = (object)$dialog;
		
		$dialog = json_decode($dialog, false);
		
		// return var_export($dialog, true);
		
		try {

			$this->con->beginTransaction();
			
			$dialogId = 0;
			
			if ( isset($dialog->id) ) {
				
				$stm = $this->con->prepare("UPDATE dialog_dialogs SET name=:name, last_modified_by=:last_modified_by, topic_id=:topic_id, last_modified_date=NOW(), x_y=:x_y WHERE id=:id ");
				$stm->execute(
					array (
						"name" => $dialog->name,
						"last_modified_by" => $dialog->last_modified_by,
						"topic_id" => $dialog->topic_id,
						"id" => $dialog->id,
						"x_y" => $dialog->x_y
					)
				);
				
				$dialogId = $dialog->id;
				
			} else {
				
				$stm = $this->con->prepare("INSERT INTO dialog_dialogs ( name, last_modified_by, topic_id, created_by, created_date, last_modified_date, x_y ) VALUES ( :name, :last_modified_by, :topic_id, :created_by, NOW(), NOW(), :x_y )");
				$stm->execute(
					array (
						"name" => $dialog->name,
						"last_modified_by" => $dialog->last_modified_by,
						"created_by" => $dialog->last_modified_by,
						"topic_id" => $dialog->topic_id,
						"x_y" => $dialog->x_y
					)
				);
				
				$dialogId = $this->con->lastInsertId();
				
				$this->addPermisionToDialog($dialogId, $dialog->last_modified_by);
				
			}
			
			// temporal to real id coversion table
			$tempToRealIdTable = array();
			
			$tempIdToTempParentIdTable = array();
			
			foreach ($dialog->phrases as $phrase) {
				$phrase->dialog_id = $dialogId;
				$phrase->last_modified_by = $dialog->last_modified_by;
				
				// TODO: add temporary parent phrase id swap to permanent system
				
				$phraseTempId = $phrase->id;
				
				$tempIdToTempParentIdTable[ $phraseTempId ] = $phrase->parent_id;
				
				$tempToRealIdTable[$phraseTempId] = $this->savePhrase($phrase);
				
			}
			
			// error_log( "tempToRealIdTable: ".var_export($tempToRealIdTable, true) );
			// error_log( "tempIdToTempParentIdTable: ".var_export($tempIdToTempParentIdTable, true) );
			
			foreach ($tempToRealIdTable as $tempId => $permId) {
				if ( $tempIdToTempParentIdTable[ $tempId ] == 0 ) {
					$this->savePhraseRealParentId( $permId, 0 );
				} else {
					$this->savePhraseRealParentId( $permId, $tempToRealIdTable[ $tempIdToTempParentIdTable[ $tempId ] ] );
				}
				
			}
			
			foreach ($dialog->deletedPhrases as $phrase) {
				$this->deletePhrase($phrase);
			}
			
			$this->con->commit();
			
			
		} catch (PDOException $exc) {

			$this->con->rollBack();

			return array(
				"error" => $exc->getMessage(),
				"stackTrace" => $exc->getTraceAsString()
			);
			
		} catch ( DialogException $exc ) {
			
			$this->con->rollBack();
			
			return array(
				"error" => $exc->getMessage()
			);
			
		}
    	
		return $dialogId;
		
    }
    
	private function savePhraseRealParentId ( $phraseId, $parentId ) {
		
		$stm = $this->con->prepare("UPDATE dialog_phrases SET parent_id=:parent_id WHERE id=:id");
		$stm->execute(
			array (
				"id" => $phraseId,
				"parent_id" => $parentId
			)
		);
		
	}
	
	/**
	 * Return id that 
	 * @param type $phrase
	 * @return id
	 */
    private function savePhrase ( $phrase ) {
		
		if ( !isset( $phrase->dialog_id ) ) {
			throw new DialogException("Given phrase doesn\'t have dialog id!");
		}
		
		if ( $phrase->id > 0 ) {
			$stm = $this->con->prepare("UPDATE dialog_phrases SET 
			text=:text, 
			x_y=:x_y, 
			subject=:subject, 
			parent_id=:parent_id,
			dialog_id=:dialog_id,
			last_modified_by=:last_modified_by,
			priority=:priority,
			last_modified_date=NOW()
			WHERE id=:id");

			$stm->execute(
				array(
					"text"=>$phrase->text, 
					"x_y"=>$phrase->x_y, 
					"subject"=>$phrase->subject, 
					"parent_id"=>$phrase->parent_id,
					"dialog_id"=>$phrase->dialog_id,
					"last_modified_by"=>$phrase->last_modified_by,
					"priority"=>$phrase->priority,
					"id"=>$phrase->id
				)
			);
			
			foreach ($phrase->deletedFunctions as $function) {
				$this->deleteFunction($function);
			}
			
			foreach ($phrase->deletedConditions as $condition) {
				$this->deleteCondition($condition);
			}
			
		} else {
			$stm = $this->con->prepare("INSERT INTO dialog_phrases 
				( text, x_y, subject, parent_id, dialog_id, created_by, last_modified_by, priority, created_date, last_modified_date )
			 VALUES ( :text, :x_y, :subject, :parent_id, :dialog_id, :created_by, :last_modified_by, :priority, NOW(), NOW() ) ");

			$stm->execute(
				array(
					"text"=>$phrase->text, 
					"x_y"=>$phrase->x_y, 
					"subject"=>$phrase->subject, 
					"parent_id"=>$phrase->parent_id,
					"dialog_id"=>$phrase->dialog_id,
					"created_by"=>$phrase->last_modified_by,
					"last_modified_by"=>$phrase->last_modified_by,
					"priority"=>$phrase->priority
				)
			);

			$phrase->id = $this->con->lastInsertId("id");
			// return "passed:".$this->con->lastInsertId("id");

		}
		
		foreach ($phrase->functions as $function) {
			$function->phrase_id = $phrase->id;
			$this->saveFunction($function);
		}
		
		foreach ($phrase->conditions as $condition) {
			$condition->phrase_id = $phrase->id;
			$this->saveCondition($condition);
		}
		
		return $phrase->id;
		
    }
    
	private function deletePhrase ( $phrase ) {
		
		// if there is no id, then it mean phrase is not saved
		if ( !isset( $phrase->id ) ) {
			return false;
		}
		
		$stm = $this->con->prepare("DELETE FROM dialog_phrases WHERE id=:id");
		
		return $stm->execute( array ( "id" => $phrase->id ) );
		
	}
	
	private function deleteFunction ( $function ) {
		
		if ( !isset($function->id) ) {
			return false;
		}
		
		$stm = $this->con->prepare("DELETE FROM functions WHERE id=:id");
		
		return $stm->execute( array ( "id" => $function->id ) );
		
	}
	
	private function deleteCondition ( $condition ) {
		
		if ( !isset($condition->id) ) {
			return false;
		}
		
		$stm = $this->con->prepare("DELETE FROM conditions WHERE id=:id");
		
		return $stm->execute( array ( "id" => $condition->id ) );
		
	}
	
    private function saveFunction ( $function ) {
		
		if ( !isset( $function->phrase_id ) ) {
			throw new DialogException("Given function doesn\'t have phrase id!");
		}
		
		if ( isset( $function->id ) ) {
			// check if function label has changed - if so than all it's params must be deleted
			$stm = $this->con->prepare("SELECT * FROM functions WHERE id=:id");
			$stm->execute( array ( "id" => $function->id ));
			if ( $stm->fetch(PDO::FETCH_OBJ)->label !== $function->label  ) {
				
				$stm = $this->con->prepare("UPDATE functions SET label = :label WHERE id = :id");
				$stm->execute(
					array( 
						"id" => $function->id,
						"label" => $function->label
					) 
				);
				
				// replacing all params (because it easier)
				$stm = $this->con->prepare("DELETE FROM function_params WHERE function_id=:function_id");

				$stm->execute( 
						array( 
							"function_id" => $function->id 
						) 
				);				
			}
			

			
			$functionId = $function->id;
			
		} else {
			$stm = $this->con->prepare("INSERT INTO functions (label) VALUES (:label)");
			$stm->execute( array ( "label"=>$function->label ));

			$functionId = $this->con->lastInsertId();

			$stm = $this->con->prepare("INSERT INTO functions_to_phrases (phrase_id, function_id) VALUES (:phrase_id, :function_id)");
			$stm->execute( 
				array ( 
				"phrase_id" => $function->phrase_id,
				"function_id" => $functionId
				)
			);

		}
		
		foreach ($function->params as $param) {
			$param->function_id = $functionId;
			$this->saveFunctionParam($param);
		}		
	
    }
    
    private function saveFunctionParam ( $param ) {
		
		if ( !isset( $param->function_id ) ) {
			throw new DialogException("Given function param doesn\'t have function id!");
		}
		
		if ( isset( $param->id ) ) {

			$stm = $this->con->prepare("UPDATE function_params SET value=:value WHERE id=:id");
			$stm->execute(
				array(
					"value" => $param->value,
					"id" => $param->id
				)
			);

		} else {
			$stm = $this->con->prepare("INSERT INTO function_params (label, value, function_id) VALUES (:label, :value, :function_id)");
			$stm->execute(
				array(
					"value"			=> $param->value,
					"label"			=> $param->label,
					"function_id"	=> $param->function_id
				)
			);
		}
		
    }
	
    private function saveCondition ( $condition ) {
		
		if ( !isset( $condition->phrase_id ) ) {
			throw new DialogException("Given condition doesn\'t have phrase id!");
		}
		
		if ( isset( $condition->id ) ) {
			// check if condition label has changed - if so than all it's params must be deleted
			$stm = $this->con->prepare("SELECT * FROM conditions WHERE id=:id");
			$stm->execute( array ( "id" => $condition->id ));
			
			$currentConditionState = $stm->fetch(PDO::FETCH_OBJ);
			
			if ( $currentConditionState->label !== $condition->label  ) {
				
				$stm = $this->con->prepare("UPDATE conditions SET label = :label WHERE id = :id");
				$stm->execute(
					array( 
						"id" => $condition->id,
						"label" => $condition->label
					) 
				);			
				
				$stm = $this->con->prepare("DELETE FROM condition_params WHERE condition_id=:condition_id");
				$stm->execute( array( "condition_id" => $condition->id ) );				
			}
			

			
			$conditionId = $condition->id;
			
		} else {
			$stm = $this->con->prepare("INSERT INTO conditions (label) VALUES (:label)");
			$stm->execute( array ( "label"=>$condition->label ));

			$conditionId = $this->con->lastInsertId();

			$stm = $this->con->prepare("INSERT INTO conditions_to_phrases (phrase_id, condition_id) VALUES (:phrase_id, :condition_id)");
			$stm->execute( 
				array ( 
					"phrase_id" => $condition->phrase_id,
					"condition_id" => $conditionId
				)
			);

		}
		
		foreach ($condition->params as $param) {
			$param->condition_id = $conditionId;
			$this->saveConditionParam($param);
		}		
	
    }
    
    private function saveConditionParam ( $param ) {
		
		if ( !isset( $param->condition_id ) ) {
			throw new DialogException("Given condition param doesn\'t have condition id!");
		}
		
		if ( isset( $param->id ) ) {

			$stm = $this->con->prepare("UPDATE condition_params SET value=:value WHERE id=:id");
			$stm->execute(
				array(
					"value" => $param->value,
					"id" => $param->id
				)
			);

		} else {
			$stm = $this->con->prepare("INSERT INTO condition_params (label, value, condition_id) VALUES (:label, :value, :condition_id)");
			$stm->execute(
				array(
					"value"			=> $param->value,
					"label"			=> $param->label,
					"condition_id"	=> $param->condition_id
				)
			);
		}
		
    }
    
	/**
	 * Delete dialog by id
	 * @param int $id
	 * @return bool true on success
	 */
	function deleteDialogById ( $id ) {		
		$stm = $this->con->prepare("DELETE FROM dialog_dialogs WHERE id=:id");
		
		return $stm->execute( array ("id" => $id ) );
		
	}
	
	/**
	 * Utility to fix all phrases that was escaped in Flash with escape() function
	 */
    function decodeUrlEncodedPhrases () {
		
		$stm = $this->con->prepare("SELECT * FROM dialog_phrases");
		
		$stm->execute();
		
		$phrases = $stm->fetchAll(PDO::FETCH_OBJ);
		
		$stm = $this->con->prepare("UPDATE dialog_phrases SET text=:text WHERE id=:id");
		
		foreach ($phrases as $phrase) {
			$stm->execute(
					array (
						"text" => $this->unescape( $phrase->text ),
						"id" => $phrase->id
					)
			);
		}
		
	}
	
	/**
	 * Url raw decode
	 * @param type $raw_url_encoded
	 * @return decoded string
	 */
	function unescape($source) {
		return html_entity_decode(preg_replace("/%u([0-9a-f]{3,4})/i","&#x\\1;", urldecode($source)), null, 'UTF-8');
	}	
	
	// voting ----------------------------------------
	
	/**
	 * Get avatar vote for dialog
	 * @param type $dialogId
	 * @param type $avatarId
	 * @return "Y" or "N" if vote exist or false if user haven't voted
	 */
	function getAvatarVoteForDialog ( $dialogId, $avatarId ) {
		$stm = $this->con->prepare("SELECT rating FROM dialog_ratings WHERE dialog_id = :dialogId AND avatar_id = :avatarId");
		
		$stm->execute(
			array (
				"dialogId" => $dialogId,
				"avatarId" => $avatarId
			)				
		);
		
		if ( $stm->rowCount() > 0 ) {
			return $stm->fetchColumn();
		} else {
			return false;
		}
		
		
	}
	
	/**
	 * Add vote for dialog
	 * @param type $dialogId
	 * @param type $avatarId
	 * @param type $vote
	 * @return dialog rating
	 */
	function addVoteForDialog ( $dialogId, $avatarId, $rating ) {
		
		$stm = $this->con->prepare("
			INSERT INTO dialog_ratings (dialog_id, avatar_id, rating) VALUES ( :dialogId, :avatarId, :rating )
			ON DUPLICATE KEY UPDATE rating=VALUES(rating)
		");
		
		$stm->execute(
			array(
				"dialogId"	=> $dialogId,
				"avatarId"	=> $avatarId,
				"rating"	=> $rating
			)
		);
		
		return $this->getDialogRating($dialogId, $avatarId);
		
	}
	
	/**
	 * Remove vote from dialog
	 * @param type $dialogId
	 * @param type $avatarId
	 * @return dialog rating
	 */
	function removeVoteFromDialog ( $dialogId, $avatarId ) {
		$stm = $this->con->prepare("DELETE FROM dialog_ratings WHERE dialog_id = :dialogId AND avatar_id = :avatarId");
		
		$stm->execute(
			array (
				"dialogId" => $dialogId,
				"avatarId" => $avatarId
			)
		);
		
		return $this->getDialogRating($dialogId, $avatarId);
		
	}
	
	/**
	 * Get dialog rating
	 * @param type $dialogId
	 * @return object with int attributes int 'positive', int 'negative' and string 'own'
	 */
	function getDialogRating ( $dialogId, $avatarId ) {
		$stm = $this->con->prepare("
			SELECT 
				( SELECT COUNT(*) FROM dialog_ratings WHERE dialog_id = :dialogId AND rating = 'Y') AS positive,
				( SELECT COUNT(*) FROM dialog_ratings WHERE dialog_id = :dialogId AND rating = 'N') AS negative
		");
		
		$stm->execute(
			array (
				"dialogId" => $dialogId
			)
		);
		
		$retVal = $stm->fetchObject();
		$retVal->own = $this->getAvatarVoteForDialog($dialogId, $avatarId);
		return $retVal;
		
	}
	
	/**
	 * Get all topics
	 */
	function getAllTopics () {
		$stm = $this->con->prepare("SELECT * FROM dialog_topics");
		$stm->execute();
		return $stm->fetchAll(PDO::FETCH_OBJ);
	}
	
}

?>
