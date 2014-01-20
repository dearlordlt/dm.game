<?php

	//This file is intentionally left blank so that you can add your own global settings
	//and includes which you may need inside your services. This is generally considered bad
	//practice, but it may be the only reasonable choice if you want to integrate with
	//frameworks that expect to be included as globals, for example TextPattern or WordPress

	//Set start time before loading framework
	list($usec, $sec) = explode(" ", microtime());
	$amfphp['startTime'] = ((float)$usec + (float)$sec);
	
	$servicesPath = "services/";
	$voPath = "services/vo/";
	
	//As an example of what you might want to do here, consider:
	
	/*
	if(!PRODUCTION_SERVER)
	{
		define("DB_HOST", "localhost");
		define("DB_USER", "root");
		define("DB_PASS", "");
		define("DB_NAME", "amfphp");
	}
	*/
	

	
	// class mappings
	// $GLOBALS['amfphp']['customMappingsPath'] = $voPath;
	// $GLOBALS['amfphp']['outgoingClassMappings']['ucc.project.view.ui.announcement.AnnouncementVO'] = 'ucc.project.data.vo.AnnouncementVO';
	
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