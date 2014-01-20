<?php

/**
 * PDOConnection
 *
 * @author $Id$
 */
class PDOConnection {

		/* @var $connection PDO */
		private static $connection = array();
		
		/**
		 * Get pdo connection
		 * @return PDO
		 */
		public static function con ( $db = "mk2" ) {
			
			$host = "localhost";
			$name = "mk2_user";
			$password = "undWrGxGfdn3qrjL";
			$database = $db;			
			
			if ( !self::$connection[$database] ) {
				self::$connection[$database] = new PDO(sprintf( 'mysql:host=%s;dbname=%s;charset=UTF-8', $host, $database ), $name, $password );
				self::$connection[$database]->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
				self::$connection[$database]->exec("set names utf8");
			}
			return self::$connection[$database];
		}
		
		private static function getCallingMethodName(){
		    $e = new Exception();
		    $trace = $e->getTrace();
		    //position 0 would be the line that called this function so we ignore it
		    $last_call = $trace[1];
		    print_r($last_call);
		}

}

?>
