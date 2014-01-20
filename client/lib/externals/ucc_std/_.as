package   {
	import ucc.i18n.Localization;
	
/**
 * Translation shortcut
 *
 * @version $Id: _.as 2 2013-01-04 10:56:02Z rytis.alekna $
 */
public function _( msg : String, ... params ) : String {
	return Localization.getInstance().getLocalizedString.apply( null, [ msg ].concat( params ) );
}

	
}