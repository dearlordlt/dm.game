package ucc.i18n  {
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import org.as3commons.lang.IllegalArgumentError;
	import org.as3commons.lang.StringUtils;
	import ucc.error.IllegalArgumentException;
	import ucc.util.DisplayObjectUtil;
	import ucc.util.sprintf;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	
/**
 * Localization
 *
 * @version $Id: Localization.as 42 2013-09-29 14:29:29Z rytis.alekna $
 */
[Event(name="ucc.i18n.LocalizationEvent.UNTRANSLATED_STRING", type="ucc.i18n.LocalizationEvent")]
public class Localization extends EventDispatcher {

	/** Singleton instance */
	private static var instance 			: Localization;
	
	/** Tranlatable text field pattern */
	public static const TRANSLATE_PATTERN	: RegExp = /(?:\#\{)([^\}]+)(?:\})/g;
	
	/** 
	 * Invisible character. 
	 * It is added to a beginning of traslated string that is added to automaticaly translated text field. 
	 * User can't see it, but computer does :)
	 */
	public static const INVISIBLE_CHAR		: String = "\u2063";
	
	public static const INVISIBLE_CHAR_2	: String = "\x20";
	
	/** Dictionary to store original texts of all text fields for interactive retranslation */
	private static const ORIGINAL_TEXTS		: Dictionary = new Dictionary( true );
	
	private static const REPLACE_PATTERN	: String = "$1";
	
	/** Localization data */
	protected var localizationData	: LocalizationData;
	
	/** Untranslated strings */
	protected var untranslatedStrings		: Object = {};
	
	/** Raw data */
	protected var rawData					: Object;
	
	/** TLFTTextField class */
	protected var TLFTextFieldClass			: Class;
	
	/**
	 * Get singleton instance of class
	 * @return 	singleton instance	Localization
	 */
	public static function getInstance () : Localization {
		return Localization.instance ? Localization.instance : ( Localization.instance = new Localization() );
	}
	
	/**
	 * Class constructor
	 */
	public function Localization () {
		
		if ( ApplicationDomain.currentDomain.hasDefinition( "fl.text.TLFTextField" ) ) {
			this.TLFTextFieldClass = getDefinitionByName( "fl.text.TLFTextField" ) as Class;
		}
		
	}
	
	/**
	 * Get localized string
	 * @param	msg	Message
	 * @param	... params	params to pass
	 * @return	localized string if translation exist ,else orginal procesed string
	 */
	public function getLocalizedString ( msg : String, ... params : * ) : String {
		
		if ( !msg ) {
			return "null";
		}
		
		if ( this.localizationData ) {
			if ( this.localizationData.getString( msg ) ) {
				return sprintf.apply( null, [ this.localizationData.getString( msg ) ].concat(params) );
			} else {
				if ( !this.untranslatedStrings[ msg ] ) {
					this.untranslatedStrings[ msg ] = true;
					this.dispatchEvent( new LocalizationEvent( LocalizationEvent.UNTRANSLATED_STRING, msg ) );
				}
				return sprintf.apply( null, [ msg ].concat(params) );
			}
			
		} else {
			return sprintf.apply( null, [ msg ].concat( params ) );
		}
		
	}
	
	/**
	 * Set current language
	 */
	public function setCurrentLanguage ( language : String ) : void {
		this.getLocalizationData().setLanguage( language );
	}
	
	/**
	 * Set localization data
	 * @param	data
	 */
	public function setLocalizationData ( data : LocalizationData ) : void {
		this.localizationData = data;
		this.rawData = this.localizationData.getRawData();
	}
	
	/**
	 * Get localization data
	 * @return
	 */
	public function getLocalizationData () : LocalizationData {
		return this.localizationData;
	}
	
	/**
	 * Get untranslated strings
	 */
	public function getUntranslatedStrings () : Array {
		
		var retVal : Array = [];
		
		for ( var stringId : String in this.untranslatedStrings ) {
			if ( !this.rawData[ stringId ] ) {
				retVal.push( stringId );
			}
		}
		
		return retVal;
		
	}
	
	/**
	 * Translate text fields
	 * @param	containerDO	container where to search for text fields
	 */
	public function translateTextFields ( containerDO : DisplayObjectContainer ) : void {
		
		var allTextFields : Array = DisplayObjectUtil.getDescendantsByType( containerDO, TextField );
		
		if ( this.TLFTextFieldClass ) {
			allTextFields = allTextFields.concat( DisplayObjectUtil.getDescendantsByType( containerDO, this.TLFTextFieldClass ) )
		}
		
		
		allTextFields.forEach( iterate );
		
	}
	
	/**
	 * Translate complex phrase.
	 * @param	phrase	Words or phrases are encapsulated in with notation #{phrase to translate}. Example: "#{Loading}: 20%"
	 * @return
	 */
	public function translateComplexPhrase ( phrase : String ) : String {
		if ( phrase == null ) {
			return "";
		}
		
		if ( ( StringUtils.trimToEmpty( phrase ) == "" ) ) {
			return phrase;
		}
		
		return phrase.replace( TRANSLATE_PATTERN, this.translate );
	}
	
	/**
	 * Translate string
	 */
	private function translate ( ... args ) : String {
		return _(args[1]);
	}
	
	/**
	 * Iterate throught text fields
	 */
	private function iterate ( item : * , index : int, array : Array ) : void {
		
		if ( ORIGINAL_TEXTS[item] ) {
			item.text = ORIGINAL_TEXTS[item].replace( TRANSLATE_PATTERN, this.translate );
		} else {
			// store original text
			ORIGINAL_TEXTS[ item ] = item.text;
			item.text = item.text.replace( TRANSLATE_PATTERN, this.translate );
		}
		
	}
	
	/**
	 * Translate single text field
	 * @param	textField
	 */
	public function translateTextField ( textField : * ) : void {
		if ( !( textField is TextField ) && ( !this.TLFTextFieldClass || !( textField is this.TLFTextFieldClass ) ) ) {
			throw new IllegalArgumentException( "Suplied parameter must be text field!" );
		}
		this.iterate( textField, 0, null );
		
	}
	
}
	
}