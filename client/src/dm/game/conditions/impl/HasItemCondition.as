package dm.game.conditions.impl {
	import dm.game.conditions.BaseCondition;
	import dm.game.data.service.ItemsService;
	import dm.game.managers.MyManager;
	

/**
 * 
 * @version $Id: HasItemCondition.as 216 2013-10-02 05:00:40Z rytis.alekna $
 */
public class HasItemCondition extends BaseCondition {
		
	/** ITEM_ID */
	public static const ITEM_ID : String = "itemId";
	
	/**
	 *	@inheritDoc
	 */
	public override function execute () : void {
		ItemsService.hasItemCondition( MyManager.instance.avatarId, this.getParamValueByLabel( ITEM_ID ) )
			.addResponders( this.onResult, this.onResult )
			.call();
	}
	
}

}
