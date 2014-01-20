package dm.game.managers  {
	import dm.game.data.service.NotificationsService;
	import org.as3commons.lang.ArrayUtils;
	import org.as3commons.lang.ObjectUtils;
	import ucc.ui.window.WindowsManager;
	
/**
 * Notifications manager
 *
 * @version $Id: NotificationsManager.as 153 2013-06-04 07:07:12Z rytis.alekna $
 */
public class NotificationsManager {
	
	/** Singleton instance */
	private static var instance : NotificationsManager;
	
	/** Notifications */
	protected var notifications	: Array = [];
	
	/**
	 * Get singleton instance of class
	 * @return 	singleton instance	NotificationsManager
	 */
	public static function getInstance () : NotificationsManager {
		return NotificationsManager.instance ? NotificationsManager.instance : ( NotificationsManager.instance = new NotificationsManager() );
	}
	
	/**
	 * Class constructor
	 */
	public function NotificationsManager () {
		
	}
	
	/**
	 * Check for new notifications
	 */
	public function checkForNewNotifications () : void {
		
		NotificationsService
			.getNotifications( MyManager.instance.avatar.id )
			.addResponders( this.onNotificationsLoaded )
		
	}
	
	/**
	 * Get the notifications number.
	 */
	public function getNotificationsNumber () : int {
		
	}
	
	/**
	 *	On notifications loaded
	 */
	protected function onNotificationsLoaded ( response : Array ) : void {
		
		if ( this.notifications && ( response[0].notification_time != this.notifications[0].notification_time ) ) {
			
			this.notifications = response;
			
			
			WindowsManager.getInstance().getWindowByClass
			
		}
		
	}
	
}
	
}