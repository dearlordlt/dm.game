package ucc.i18n {
	
import flash.events.Event;
	
/**
 * Localization event
 * 
 * @version $Id: LocalizationEvent.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class LocalizationEvent extends Event {
	
	/** Untranslated string occourence event */
	public static const UNTRANSLATED_STRING 		: String = "ucc.i18n.LocalizationEvent.UNTRANSLATED_STRING";
	
	/** string */
	public var string : String;
	
	/**
	 * Constructor
	 */
	public function LocalizationEvent( type : String, string : String ) { 
		
		super( type );
		this.string = string;
		
	} 
	
}

}