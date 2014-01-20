<?php

/**
 * DialogException. Thrown when malformed dialog data given to service
 *
 * @author $Id$
 */
class DialogException extends Exception {

	function __construct( string $message = "", int $code = 0, Exception $previous = NULL ) {
		parent::__construct( $message, $code, $previous );
	}

}

?>
