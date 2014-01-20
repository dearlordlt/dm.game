<?php

/**
 * Timeouts
 *
 * @author $Id$
 */
class Timeouts {

	/**
	 *
	 * @var PDO
	 */
	private $con;
	
    function __construct() { //Constructor
		$this->con = PDOConnection::con(basename(__DIR__));
	}
	
	
	function timeoutPassed ($avatarId, $timeoutLabel) {
		
		$stm = $this->con->prepare("SELECT ( NOW() > timeout_date ) AS passed FROM timeouts WHERE avatar_id=? AND label=?");
		$stm->execute( array( $avatarId, $timeoutLabel ) );
		if ( $stm->rowCount() == 0 ) {
			return true;
		} else {
			return ( $stm->fetchObject()->passed == true );
		}
		
	}
	
	function setTimeout ( $avatarId, $timeoutLabel, $timeout, $unit ) {
		
		$unit = strtoupper($unit);
		
		if (!in_array( $unit, array('SECOND', 'MINUTE', 'HOUR', 'DAY', 'WEEK', 'MONTH'))) {
			return false;
		}
		
		try {
		
			$stm = $this->con->prepare("INSERT INTO timeouts (avatar_id, label, timeout_date) VALUES ( :avatarId, :label, TIMESTAMPADD( $unit, :timeout, NOW() ) ) ON DUPLICATE KEY UPDATE timeout_date=TIMESTAMPADD( $unit, :timeout, NOW() ) ");

			$stm->execute(
				array(
					"avatarId" => $avatarId,
					"label" => $timeoutLabel,
					"timeout" => $timeout
				)
			);
			
			return true;
			
		} catch ( PDOException $error ) {
			return array (
				"error" => $error->getMessage()
			);
		}
	}
	
}

?>
