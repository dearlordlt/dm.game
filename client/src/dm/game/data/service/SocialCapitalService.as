package dm.game.data.service {
	import ucc.data.service.Service;
	import ucc.error.IllegalArgumentException;
	

/**
 * 
 * @version $Id: SocialCapitalService.as 216 2013-10-02 05:00:40Z rytis.alekna $
 */
public class SocialCapitalService extends Service {
		
	/** SERVICE_NAME */
	public static const SERVICE_NAME : String = "dm.SocialCapital.";
		
	/** MESSAGE */
	public static const MESSAGE : String = "message";
		
	/** TRADE */
	public static const TRADE : String = "trade";
		
	/** CHEAT */
	public static const CHEAT : String = "cheat";
	
	public static function logInteraction ( avatarId : int, toAvatarId : int, interactionType : String ) : Service {
		
		if ( ( [MESSAGE, TRADE, CHEAT] as Array ).indexOf( interactionType.toLowerCase() ) == -1 ) {
			throw new IllegalArgumentException("Interaction type must be one of the provided values: 'message','trade','cheat'!");
		}
		
		return createService( SERVICE_NAME + "logInteraction", [avatarId, toAvatarId, interactionType.toLowerCase()] );
		
	}
	
	public static function getAvatarSocialCapital ( avatarId : int ) : Service {
		return createService( SERVICE_NAME + "getAvatarSocialCapital", [avatarId] );
	}
	
}

}