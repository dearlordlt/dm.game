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
			
			if ( !isset(self::$connection[$database]) ) {
				self::$connection[$database] = new PDO(sprintf( 'mysql:host=%s;dbname=%s;charset=UTF-8', $host, $database ), $name, $password );
				self::$connection[$database]->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
				self::$connection[$database]->exec("set names utf8");
			}
			return self::$connection[$database];
		}
		
}

?>
