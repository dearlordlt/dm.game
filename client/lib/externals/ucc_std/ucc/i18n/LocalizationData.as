package ucc.i18n {
	
/**
 * Localization data prototype
 * @author Rytis Alekna
 * @version $Id: LocalizationData.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public interface LocalizationData {
	
	/**
	 * Get raw translated string (unprocessed)
	 * @param	messageId
	 * @return
	 */
	function getString ( messageId : String ) : String;
	
	/**
	 * Set current language
	 * @param	language
	 */
	function setLanguage ( language : String ) : void;
	
	/**
	 * Get current language
	 * @return
	 */
	function getLanguage () : String;
	
	/**
	 * Get raw data
	 */
	function getRawData () : * ;
	
}
	
}