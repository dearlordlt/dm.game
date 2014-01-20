<?php

/*
 *  All rights reserved
 */

/**
 * Notifications
 *
 * @version $Id$
 */
class Notifications {
	
	/**
	 * {DO connection
	 * @var PDO
	 */
	private $con;
	
	/**
	 * Constructor
	 */
	function __construct () {
		$this->con = PDOConnection::con(  basename( __DIR__ ) );
	}
	
	/**
	 * Create function
	 * @param type $label
	 * @param array $params
	 * @param type $title
	 * @return \stdClass
	 */
	public static function createFunction ( $label, array $params = array(), $title = "" ) {
		$retVal = new stdClass();
		$retVal->label = $label;
		$retVal->title	= $title;
		
		$paramsConverted = array();
		
		// convert to real format
		foreach ($params as $key => $value) {
			$param = new stdClass();
			$param->label = $key;
			$param->value = $value;
			$paramsConverted[] = $param;
		}		
		
		$retVal->params = $paramsConverted;
		return $retVal;
	}
	
	/**
	 * Add notification
	 * @see example Friends	for #addRealFriend()
	 * @param type $avatarId
	 * @param type $notificationTemplateId
	 * @param stdClass $function1		first function to execute by user (eg.confirm something). Can be null
	 *		JSON	format	{label:string, title:string, params:[ {label:string, value:object} ]}
	 * @param type $function2			alternative function to execute (eg. decline something)	same as function1. Can be null
	 * @param array $templateParams
	 * @param type $notificationOffset
	 * @return type
	 */
	function addNotification( $avatarId, $notificationTemplateId, stdClass $function1 = null, stdClass $function2 = null, array $templateParams = array(), $notificationOffset = 0 ) {
		
		$notificationTextStm = $this->con->prepare("SELECT text FROM notification_templates WHERE id = ?");
		$notificationTextStm->execute( array($notificationTemplateId) );
		
		$notificationText = $notificationTextStm->fetchColumn(0);
		
		$notificationText = call_user_func_array(sprintf, array_merge(array( $notificationText ), $templateParams));
		
		$stm = $this->con->prepare("INSERT INTO notifications ( avatar_id, notification, function_1, function_2, notification_time ) VALUES ( :avatarId, :notification, :function1, :function2, ADDDATE( NOW(), INTERVAL :notificationOffset MINUTE ) )");
		
		return $stm->execute( 
			array(
				"avatarId" => $avatarId,
				"notification" => $notificationText,
				"function1" => json_encode( $function1 ),
				"function2" => json_encode( $function2 ),
				"notificationOffset" => $notificationOffset
			) 
		);
		
	}
	
	/**
	 * Remove notification
	 * @param type $notificationId
	 * @return type
	 */
	function removeNotification ( $notificationId ) {
		$stm = $this->con->prepare("DELETE FROM notifications WHERE id = ?");
		return $stm->execute( array($notificationId) );
	}
	
	/**
	 * Get all notifications for avatar
	 * @param type $avatarId
	 * @return type
	 */
	function getNotifications( $avatarId ) {
		
		$stm = $this->con->prepare("SELECT * FROM notifications WHERE avatar_id = ? AND notification_time < NOW() GROUP BY notification_time ASC");
		
		$stm->execute(
			array ( $avatarId )
		);
		
		return $stm->fetchAll(PDO::FETCH_OBJ);
		
	}
		
	
}

?>
