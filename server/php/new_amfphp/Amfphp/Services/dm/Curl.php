<?php

/**
 * cURL utility
 *
 * @author $Id$
 */
class Curl {

	function Curl() {
		
	}
	
	/**
	 * Get page
	 */
	function getPage ( $url, $username, $password ) {
	
		// $username="mylogin@gmail.com"; 
		// $password="mypassword"; 
		// $url="http://www.myremotesite.com/index.php?page=login"; 
		$cookie="cookie.txt"; 

		$postdata = "username=".$username."&password=".$password; 

		$ch = curl_init(); 
		curl_setopt ($ch, CURLOPT_URL, $url); 
		curl_setopt ($ch, CURLOPT_SSL_VERIFYPEER, FALSE); 
		curl_setopt ($ch, CURLOPT_USERAGENT, "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6"); 
		curl_setopt ($ch, CURLOPT_TIMEOUT, 60); 
		curl_setopt ($ch, CURLOPT_FOLLOWLOCATION, 0); 
		curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1); 
		curl_setopt ($ch, CURLOPT_COOKIEJAR, $cookie); 
		curl_setopt ($ch, CURLOPT_REFERER, $url); 

		curl_setopt ($ch, CURLOPT_POSTFIELDS, $postdata); 
		curl_setopt ($ch, CURLOPT_POST, 1); 
		$result = curl_exec ($ch); 

		
		curl_close($ch);		
		return $result;
		
	}
	
}

?>
