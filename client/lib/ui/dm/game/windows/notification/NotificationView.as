package dm.game.windows.notification {
	import dm.game.data.service.NotificationsService;
	import dm.game.functions.FunctionExecutor;
	import dm.game.windows.DmWindow;
	import fl.controls.Button;
	import fl.controls.Label;
	import fl.data.DataProvider;
	import flash.events.MouseEvent;
	import ucc.logging.Logger;
	import ucc.util.Delegate;
	

/**
 * Notifications view
 * @version $Id: NotificationView.as 153 2013-06-04 07:07:12Z rytis.alekna $
 */
public class NotificationView extends DmWindow {
	
	/** Message label */
	public var messageLabelDO						: Label;

	/** Close button */
	public var bigCloseButtonDO						: Button;

	/** Function 1 button */
	public var function1ButtonDO					: Button;

	/** Function 2 button */
	public var function2ButtonDO					: Button;	
	
	/** notification */
	protected var notification 						: Object;
	
	/** function1 */
	protected var function1 						: Object;
	
	/** function2 */
	protected var function2 						: Object;
	
	/** notificationsDataProvider */
	protected var notificationsDataProvider 		: DataProvider;
	
	/**
	 * Class constructor
	 */
	public function NotificationView( notification : Object, notificationsDataProvider : DataProvider = null ) {
		this.notificationsDataProvider = notificationsDataProvider;
		this.notification = notification;
		super( null, _("Notification") );
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function initialize () : void {
		
	}
	
	/**
	 *	Post initialize
	 * 	@inheritDoc
	 */
	public override function postInitialize () : void {
		
		if ( this.notification.function_1 ) {
			
			function1 = JSON.parse( this.notification.function_1 );
			trace( "[dm.game.windows.notification.NotificationView.initialize] function1 : " + JSON.stringify( function1, null, 4 ) );
			this.function1ButtonDO.label = function1.title;
			this.function1ButtonDO.addEventListener( MouseEvent.CLICK, this.onFunction1ButtonClick );
			
		} else {
			this.function1ButtonDO.visible = false;
		}
		
		if ( this.notification.function_2 ) {
			
			function2 = JSON.parse( this.notification.function_2 );
			this.function2ButtonDO.label = function2.title;
			this.function2ButtonDO.addEventListener( MouseEvent.CLICK, this.onFunction2ButtonClick );
			
		} else {
			this.function2ButtonDO.visible = false;
		}
		
		this.bigCloseButtonDO.addEventListener( MouseEvent.CLICK, Delegate.createWithCallArgsIgnore( this.destroy ) );		
		
		this.messageLabelDO.text = this.notification.notification;
		
		this.bigCloseButtonDO.y 	= 
		this.function1ButtonDO.y 	=
		this.function2ButtonDO.y 	= this.messageLabelDO.y + this.messageLabelDO.textField.textHeight + 12;
		
	}
	
	/**
	 * 
	 * @param	event
	 */
	protected function onFunction1ButtonClick ( event : MouseEvent) : void {
		( new FunctionExecutor() ).executeFunction( this.function1, this.onResult );
	}
	
	/**
	 *	On function2 button click
	 */
	protected function onFunction2ButtonClick ( event : MouseEvent) : void {
		( new FunctionExecutor() ).executeFunction( this.function2, this.onResult );
	}
	
	/**
	 *	On result
	 */
	protected function onResult ( response : Object ) : void {
		
		if ( response ) {
			
			NotificationsService
				.removeNotification( this.notification.id )
				.addResponders( this.onNotificationRemoved )
				.call();
		} else {
			Logger.log( response, Logger.LEVEL_ERROR, this );
		}
		
	}
	
	/**
	 *	On notification removed.
	 */
	protected function onNotificationRemoved () : void {
		Logger.log( "Notification removed", Logger.LEVEL_INFO, this );
		
		if ( this.notificationsDataProvider ) {
			this.notificationsDataProvider.removeItem( this.notification );
		}
		
		this.destroy();
	}
	
}

}