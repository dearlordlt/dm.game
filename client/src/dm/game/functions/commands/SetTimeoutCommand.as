package dm.game.functions.commands {
	import dm.game.data.service.TimeoutsService;
	import dm.game.functions.BaseExecutable;
	import dm.game.managers.MyManager;
	

/**
 * 
 * @version $Id: SetTimeoutCommand.as 214 2013-09-28 18:03:54Z rytis.alekna $
 */
public class SetTimeoutCommand extends BaseExecutable {
		
	/** TIMEOUT_LABEL */
	public static const TIMEOUT_LABEL : String = "timeoutLabel";
		
	/** TIMEOUT */
	public static const TIMEOUT : String = "timeout";
		
	/** UNIT */
	public static const UNIT : String = "unit";
	
	
	/**
	 *	@inheritDoc
	 */
	public override function execute (  ) : void {
		
		TimeoutsService.setTimeout( MyManager.instance.avatar.id, this.getParamValueByLabel( TIMEOUT_LABEL ), this.getParamValueByLabel( TIMEOUT ), this.getParamValueByLabel( UNIT ) )
			.addResponders( this.onResult )
			.call();
		
	}
	
}

}