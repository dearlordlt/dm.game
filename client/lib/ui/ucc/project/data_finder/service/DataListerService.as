package ucc.project.data_finder.service {
	import ucc.data.service.Service;
	

/**
 * Dat lister service
 * @version $Id: DataListerService.as 50 2013-03-04 07:47:35Z rytis.alekna $
 */
public class DataListerService extends Service {
		
	/** SERVICE_NAME */
	public static const SERVICE_NAME : String = "dm.DataLister.";
	
	/**
	 * Get all data from specified table
	 * @param table name
	 * @param list of fields
	 * @return type
	 */
	public static function getData ( table : String, fields : Array = null ) : Service {
		return createService( SERVICE_NAME + "getData", [table, fields] );
	}
	
}

}