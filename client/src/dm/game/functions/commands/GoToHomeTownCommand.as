package dm.game.functions.commands {
	import dm.game.data.service.AvatarService;
	import dm.game.functions.BaseExecutable;
	import dm.game.managers.EsManager;
	import dm.game.managers.MyManager;
	

/**
 * Go to home town command
 * @version $Id: GoToHomeTownCommand.as 212 2013-09-26 05:52:06Z rytis.alekna $
 */
public class GoToHomeTownCommand extends BaseExecutable {
	
	/**
	 * (Constructor)
	 * - Returns a new GoToHomeTownCommand instance
	 */
	public function GoToHomeTownCommand() {
		
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function execute () : void {
		
		AvatarService.getAvatarHomeTown( MyManager.instance.avatar.id )
			.addResponders( this.onHomeTownFound )
			.call();
		
	}
	
	/**
	 * On home town found
	 */
	protected function onHomeTownFound ( townLabel : String ) : void {
		EsManager.instance.joinRoom( townLabel );
		this.onResult( true );
	}
	
}

}