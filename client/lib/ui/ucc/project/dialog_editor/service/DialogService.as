package ucc.project.dialog_editor.service {
import ucc.data.service.Service;

/**
 *	Dialog service
 * @version $Id: DialogService.as 64 2013-03-11 12:23:32Z rytis.alekna $
 */
public class DialogService extends Service {
	
	/** SERVICE_NAME */
	public static const SERVICE_NAME : String = "dm.Dialog.";
	
	/**
	 * Get dialog by id
	 * @param	dialogId
	 * @return	dialog with all phrases
	 */
	public static function getDialogById( dialogId : int ) : Service {
		return createService( SERVICE_NAME + "getDialogById", [ dialogId ] );
	}
	
	
}

}