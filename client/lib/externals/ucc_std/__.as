package   {
	import ucc.i18n.Localization;
	
/**
 * Translate complex string
 * @param	msg	Words or phrases are encapsulated in with notation #{phrase to translate}. Example: "#{Loading}: 20%"
 * @version $Id: __.as 2 2013-01-04 10:56:02Z rytis.alekna $
 */

public function __( msg : String ) : String {
	return Localization.getInstance().translateComplexPhrase( msg );
}
	
}