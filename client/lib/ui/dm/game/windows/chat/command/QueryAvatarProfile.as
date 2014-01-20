package dm.game.windows.chat.command {
	import dm.game.data.service.AvatarService;
	import dm.game.functions.BaseExecutable;
	import dm.game.windows.avatar.AvatarProfile;
	

/**
 * Query avatar profile
 * @version $Id: QueryAvatarProfile.as 204 2013-08-27 08:53:09Z rytis.alekna $
 */
public class QueryAvatarProfile extends BaseExecutable {
	
	/** AVATAR_NAME */
	public static const AVATAR_NAME : String = "avatarName";
	
	/**
	 * (Constructor)
	 * - Returns a new QueryAvatarProfile instance
	 */
	public function QueryAvatarProfile() {
		
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function execute (  ) : void {
		
		AvatarService.getAvatarByName( this.getParamValueByLabel( AVATAR_NAME ) )
			.addResponders( this.onAvatarRetrieved, this.onAvatarNotFound )
			.call();
		
	}
	
	/**
	 *	On avatar retrieved
	 */
	protected function onAvatarRetrieved ( response : Object ) : void {
		new AvatarProfile( response.id );
	}
	
	/**
	 *	On avatar not found
	 */
	protected function onAvatarNotFound () : void {
		this.onResult( __("#{Avatar with a name} " + this.getParamValueByLabel( AVATAR_NAME ) + " #{not found}!"), true );
	}
	
}

}