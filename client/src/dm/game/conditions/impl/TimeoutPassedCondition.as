package dm.game.conditions.impl {
	import dm.game.conditions.BaseCondition;
	import dm.game.data.service.TimeoutsService;
	import dm.game.managers.MyManager;
	

/**
 * 
 * @version $Id: TimeoutPassedCondition.as 214 2013-09-28 18:03:54Z rytis.alekna $
 */
public class TimeoutPassedCondition extends BaseCondition {
		
	/** TIMEOUT_LABEL */
	public static const TIMEOUT_LABEL : String = "timeoutLabel";
	
	/**
	 *	@inheritDoc
	 */
	public override function execute (  ) : void {
		
		TimeoutsService.timeoutPassed( MyManager.instance.avatar.id, this.getParamValueByLabel( TIMEOUT_LABEL ) )
			.addResponders( this.onResponse, this.onResponse )
			.call();
		
	}
	
	private function onResponse ( result : Boolean ) {
		this.onResult( result );
	}
	
}

}