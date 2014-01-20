package dm.game.friend.command {
	import dm.game.data.service.FriendsService;
	import dm.game.functions.BaseExecutable;
	

/**
 * Remove friend command
 * @version $Id: RemoveFriendCommand.as 142 2013-05-28 08:07:55Z rytis.alekna $
 */
public class RemoveFriendCommand extends BaseExecutable {
	
	/**
	 * (Constructor)
	 * - Returns a new RemoveFriendCommand instance
	 */
	public function RemoveFriendCommand() {
		
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function execute () : void {
		
		FriendsService
			.removeFromFriends( getParamValueByLabel( "avatarId" ), getParamValueByLabel( "friendId" ), getParamValueByLabel( "blocked" ) || false )
			.addResponders( onResult )
			.call();			
		
	}
	
	
	
}

}