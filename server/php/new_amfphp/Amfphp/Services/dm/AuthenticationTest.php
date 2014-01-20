<?php

/**
 * AuthenticationTest
 *
 * @author $Id$
 */
class AuthenticationTest {

	function AuthenticationTest() {
		
	}
	
	function login ( $user, $password ) {
		
		if ( ( $user == "admin" ) && ( $password == "password" ) ) {
			AmfphpAnnotatedAuthentication::addRole("admin");
			AmfphpAnnotatedAuthentication::addRole("user");
		} else {
			AmfphpAnnotatedAuthentication::addRole("user");
		}
		return true;
	}
	
	function logout () {
		AmfphpAnnotatedAuthentication::clearSessionInfo();
		return true;
	}
	
	/**
	 * @Roles("admin")
	 * @return string
	 */
	function adminDo () {
		return "I am admin";
	}
	
	/**
	 * @Roles("user")
	 * @return string
	 */
	function userDo () {
		return "I am user";
	}
	
}

?>
