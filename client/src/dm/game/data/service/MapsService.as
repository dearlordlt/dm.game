package dm.game.data.service {
	import ucc.data.service.Service;
	

/**
 * 
 * @version $Id: MapsService.as 212 2013-09-26 05:52:06Z rytis.alekna $
 */
public class MapsService extends Service {
		
	/** SERVICE_NAME */
	public static const SERVICE_NAME : String = "dm.Maps.";
	
	/**
	 * (Constructor)
	 * - Returns a new MapsService instance
	 */
	public function MapsService() {
		
	}
	
	public static function getAllSkyboxes() : Service {
		return createService( SERVICE_NAME + "getAllSkyboxes" );
	}
	
}

}