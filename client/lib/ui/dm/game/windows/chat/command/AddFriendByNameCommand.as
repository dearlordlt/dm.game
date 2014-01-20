package dm.game.windows.chat.command {
	import dm.game.data.service.FriendsService;
	import dm.game.functions.BaseExecutable;
	import dm.game.managers.MyManager;
	import dm.game.data.service.friend.FriendshipStatus;
	import ucc.logging.Logger;
	

/**
 * Add friend by name command
 * @version $Id: AddFriendByNameCommand.as 204 2013-08-27 08:53:09Z rytis.alekna $
 */
public class AddFriendByNameCommand extends BaseExecutable {
		
	/**
	 * Class constructor
	 */
	public function AddFriendByNameCommand () {
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function execute () : void {
		
		var friendName : String = this.getParamValueByLabel( "friendName" );
		
		FriendsService
			.addFriendByName( MyManager.instance.avatar.id, friendName )
			.addResponders( this.onResponse, this.onError )
			.call();
		
	}
	
	protected function onResponse ( result : Object ) : void {
		
		var friendName : String = this.getParamValueByLabel("friendName");
		
		if ( result === false ) {
			
			this.onResult( __("#{Avatar with name}" + friendName + "#{not found}"), true );
			
		} else {
			
			var resultTexts	: Object = {};
			var errorTexts	: Object = {};
			
			resultTexts[ FriendshipStatus.CONFIRMED ] 					= __("#{You are now friends with} " + friendName );
			resultTexts[ FriendshipStatus.AWATING_FRIEND_CONFIRMATION ] 	= __("#{Your friendship request is waiting for confirmation by} " + friendName );
			
			errorTexts[ FriendshipStatus.BLOCKED_BY_FRIEND ] 	= __( friendName + " #{doesn\'t want to be your friend!}");
			errorTexts[ FriendshipStatus.BLOCKED_BY_AVATAR ] 	= __( "#{You have blocked}" + friendName + " #{from beeing your friend}");
			errorTexts[ FriendshipStatus.BLOCKED_BY_BOTH ] 		= __( "#{You have blocked}" + friendName + " #{from beeing your friend}");
			
			if ( resultTexts[ result ] ) {
				this.onResult( resultTexts[ result ], false );
			} else if ( errorTexts[ result ] ) {
				this.onResult( errorTexts[ result ], true );
			} else {
				this.onResult( _("Unknown error has occoured!"), true );
			}
			
		}
		
	}
	
	protected function onError ( result : Object ) : void {
		Logger.log( result, Logger.LEVEL_ERROR, this );
		this.onResult( _("Unknown server error has occoured!"), true );
	}
	
}

}