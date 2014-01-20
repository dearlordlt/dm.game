package dm.game.data.service {
	import ucc.data.service.Service;
	

/**
 * Notifications service
 * @version $Id: NotificationsService.as 142 2013-05-28 08:07:55Z rytis.alekna $
 */
public class NotificationsService extends Service {
		
	/** SERVICE_NAME */
	public static const SERVICE_NAME : String = "dm.Notifications.";
	
	/**
	 * Get notifications
	 * @param	avatarId
	 * @return
	 */
	public static function getNotifications( avatarId : int ) : Service {
		return createService( SERVICE_NAME + "getNotifications", [avatarId] );
	}
	
	/**
	 * Removes notification.
	 * @param	notificationId
	 * @return
	 */
	public static function removeNotification ( notificationId : int ) : Service {
		return createService( SERVICE_NAME + "removeNotification", [notificationId] );
	}
	
}

}