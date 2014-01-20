package ucc.i18n.data  {
	import ucc.i18n.LocalizationData;
	
/**
 * Row set localization data
 *
 * @version $Id: RowSetLocalizationData.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class RowSetLocalizationData implements LocalizationData {
	
	/** Data */
	protected var data				: Object;
	
	/** Current language */
	protected var currentLanguage	: String;
	
	/** Default language */
	protected var defaultLanguage	: String;
	
	/**
	 * Class constructor
	 */
	public function RowSetLocalizationData ( data : Object, currentLanguage : String, defaultLanguage : String ) {
		this.data = data;
		this.currentLanguage = currentLanguage;
	}
	
	/**
	 *	@inheritDoc
	 */
	public function getString ( messageId : String ) : String {
		if ( this.data[ messageId ] ) {
			
			return this.data[ messageId ][ this.currentLanguage ];
			
			/*
			if ( this.data[ messageId ][ this.currentLanguage ] ) {
				return this.data[ messageId ][ this.currentLanguage ];
			} else if ( this.data[ messageId ][ this.defaultLanguage ] ) {
				return this.data[ messageId ][ this.defaultLanguage ];
			} else {
				return messageId;
			}
			*/
			
		} else {
			return null;
		}
	}
	
	/**
	 *	@inheritDoc
	 */
	public function setLanguage ( language : String ) : void {
		this.currentLanguage = language;
	}
	
	/**
	 *	@inheritDoc
	 */
	public function getLanguage () : String {
		return this.currentLanguage;
	}
	
	/**
	 * Get raw data
	 */
	public function getRawData () : * {
		return this.data;
	}
	
}
	
}