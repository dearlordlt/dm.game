package dm.game.conditions.impl {
	import dm.game.conditions.BaseCondition;
	import dm.game.data.service.QuestsService;
	import dm.game.managers.MyManager;

/**
 * 
 * @version $Id: HasNotQuestCondition.as 198 2013-07-29 23:05:53Z rytis.alekna $
 */
public class HasNotQuestCondition extends BaseCondition {
	
	/**
	 *	@inheritDoc
	 */
	public override function execute () : void {
		QuestsService.hasNotQuest( this.getParamValueByLabel("questId"), MyManager.instance.avatar.id )
			.addResponders( this.onResult, this.onResult )
			.call();
	}	
	
}

}