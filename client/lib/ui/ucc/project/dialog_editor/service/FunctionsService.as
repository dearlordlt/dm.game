package ucc.project.dialog_editor.service {
	import ucc.data.service.Service;
	

/**
 * 
 * @version $Id: FunctionsService.as 31 2013-02-25 10:11:00Z rytis.alekna $
 */
public class FunctionsService extends Service {
		
	/** SERVICE_NAME */
	public static const SERVICE_NAME : String = "dm.Functions.";
	
	/**
	 * Get all functions labels with params
	 * @return
	 */
	public static function getAllFunctionLabels() : Service {
		return createService( SERVICE_NAME + "getAllFunctionLabels" );
	}
	
}

}