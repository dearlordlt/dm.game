package dm.game.friend.command {
	import dm.game.data.service.FriendsService;
	import dm.game.functions.BaseExecutable;
	

/**
 * 
 * @version $Id: AddFriendCommand.as 142 2013-05-28 08:07:55Z rytis.alekna $
 */
public class AddFriendCommand extends BaseExecutable {
	
	public function AddFriendCommand() {
		
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function execute () : void {
			
		FriendsService
			.addFriend( getParamValueByLabel( "avatarId" ), getParamValueByLabel( "friendId" ) )
			.addResponders( onResult )
			.call();		
	}
	
}

}