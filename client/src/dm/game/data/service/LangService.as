package dm.game.data.service {
	import ucc.data.service.Service;
	

/**
 * Language service
 * @version $Id: LangService.as 50 2013-03-04 07:47:35Z rytis.alekna $
 */
public class LangService extends Service {
		
	/** SERVICE_NAME */
	public static const SERVICE_NAME : String = "dm.Lang.";
	
	/**
	 * Update translation string
	 * @param type $originalEnString
	 * @param type $enString
	 * @param type $ltString
	 * @param type $ruString
	 * @param type $plString
	 * @return type
	 */
    function updateStringTranlation ( originalEnString : String, enString : String, ltString : String = "", ruString : String = "", plString : String = "" ) : Service {
		return createService( SERVICE_NAME + "updateStringTranlation", [originalEnString, enString, ltString, ruString, plString] );
	}
	
	
	/**
	 * Enter non translated string
	 * @param type $enString
	 * @return type
	 */
	public static function addNonDefinedString ( enString : String ) : Service {
		return createService( SERVICE_NAME + "addNonDefinedString", [enString] );
	}
	
	/**
	 * Get translation data
	 * @return
	 */
	public static function getTranslationData () : Service {
		return createService( SERVICE_NAME + "getTranslationData" );
	}
	
	/**
	 * Get traslations rowset
	 * @return type
	 */
    public static function getAllWords() : Service {
		return createService( SERVICE_NAME + "getAllWords" );
	}
	
}

}