package ucc.project.dialog_editor.service {
	import ucc.data.service.Service;
	

/**
 * Conditions service
 * @version $Id: ConditionsService.as 31 2013-02-25 10:11:00Z rytis.alekna $
 */
public class ConditionsService extends Service {
		
	/** SERVICE_NAME */
	public static const SERVICE_NAME : String = "dm.Conditions.";
	
	/**
	 * Get all conditions labels
	 * @return
	 */
	public static function getAllConditionLabels() : Service {
		return createService( SERVICE_NAME + "getAllConditionLabels" );
	}
	
}

}