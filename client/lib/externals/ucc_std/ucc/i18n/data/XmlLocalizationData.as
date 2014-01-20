package ucc.i18n.data  {
	import ucc.i18n.LocalizationData;
	
/**
 * Xml localization data
 *
 * @version $Id: XmlLocalizationData.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class XmlLocalizationData implements LocalizationData {
	
	/** Strings xml */
	protected var xml	: XML;
	
	/**
	 * Class constructor
	 */
	public function XmlLocalizationData ( xml : XML ) {
		this.xml = xml;
	}
	
	/** 
	 *	@inheritDoc 
	 */
	public function getString( messageId : String ) : String {
		
		return this.xml.msg.(msgid == messageId ).msgstr;
		
	}
	
	/**
	 *	@inheritDoc
	 */
	public function setLanguage ( language : String ) : void {
		
	}
	
	/**
	 *	@inheritDoc
	 */
	public function getLanguage () : String {
		return null;
	}
	
	/**
	 * Get raw data
	 */
	public function getRawData () : * {
		return this.xml;
	}	
	
}
	
}