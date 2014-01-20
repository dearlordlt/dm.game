<?php

/**
 * AuthenticationTest
 * @Roles("admin")
 * @Roles("user")
 * @author $Id$
 */
class AuthenticationTest2 {

	function __construct() {
		
	}
	
	function adminDo () {
		return "I am admin";
	}
	
	
	function userDo () {
		return "I am user";
	}
	
	public function testObject ( $obj ) {
		
		return $obj["labas"];
		
	}
	
}

?>
