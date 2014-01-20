<?php

/**
 * Finance
 *
 * @author $Id$
 */
class Finance {

	/**
	 *
	 * @var PDO
	 */
	private $con;
	
	function __construct() { //Constructor
		$this->con = PDOConnection::con(basename(__DIR__));
	}
	
	function getAvatarFinanceLog ( $avatarId ) {
		$stm = $this->con->prepare("SELECT * FROM finance_history WHERE avatar_id=? ORDER BY time DESC");
		$stm->execute( array($avatarId) );
		return $stm->fetchAll(PDO::FETCH_OBJ);
	}
	
}

?>
