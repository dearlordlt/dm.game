<?php

/**
 * Base class for users operations
 * Users
 */
class Lang {

    function Lang() { //Constructor
		include_once 'DBConnection.php';
    }

    function getLanguageWords($language) {
		$result = mysql_query("SELECT en, " . $language . " FROM languages;");
		$words = array();
		while ($word = mysql_fetch_object($result))
			$words[$word->en] = $word->$language;
		return $words;
    }
	
	/**
	 * Get traslations rowset
	 * @return type
	 */
    function getAllWords() {
		$result = mysql_query("SELECT * FROM languages;");
		$words = array();
		while ($word = mysql_fetch_object($result)) {
			$words[$word->en]['en'] = $word->en;
			$words[$word->en]['lt'] = $word->lt;
			$words[$word->en]['ru'] = $word->ru;
			$words[$word->en]['pl'] = $word->pl;
		}
		return $words;
    }
	
	/**
	 * Get specified language data (useless)
	 * @param type $lang
	 * @return array|boolean
	 */
    function getLangData($lang) {
		if (($lang == 'en') or ($lang == 'lt') or ($lang == 'ru')) {
			$result = mysql_query("SELECT name, " . $lang . " AS translation FROM langs;");
			$data = array();
			while ($expression = mysql_fetch_object($result)) {
			array_push($data, $expression);
			}
			return $data;
		} else {
			return false;
		}
    }
    
	/**
	 * Update translation string
	 * @param type $originalEnString
	 * @param type $enString
	 * @param type $ltString
	 * @param type $ruString
	 * @param type $plString
	 * @return type
	 */
    function updateStringTranlation ( $originalEnString, $enString, $ltString = "", $ruString = "", $plString = "" ) {
	
		$con = PDOConnection::con("dm");

		$stm = $con->prepare("UPDATE languages SET en=:enString, lt=:ltString, ru=:ruString, pl=:plString WHERE en=:originalEnString");

		return $stm->execute( array( "originalEnString" => $originalEnString, "enString" => $enString, "ltString" => $ltString, "ruString" => $ruString, "plString" => $plString ) );

	}
	
	/**
	 * Enter non translated string
	 * @param type $enString
	 * @return type
	 */
	function addNonDefinedString ( $enString ) {

		$con = PDOConnection::con("dm");

		$stm = $con->prepare("INSERT IGNORE INTO languages (en) VALUES (:enString)");

		return $stm->execute( array( "enString" => $enString ) );

	}

	function getTranslationData () {

		$con = PDOConnection::con("dm");

		$stm = $con->prepare("SELECT en AS original_en_string, en, lt, ru, pl FROM languages");

		$stm->execute();	

		return $stm->fetchAll(PDO::FETCH_ASSOC);
	
    }
	
    
}

?>