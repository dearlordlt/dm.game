package dm.game.conditions.impl {
	import dm.game.conditions.BaseCondition;
	import dm.game.data.service.ItemsService;
	import dm.game.managers.MyManager;
	

/**
 * 
 * @version $Id: HasEqualOrMoreItemsCondition.as 216 2013-10-02 05:00:40Z rytis.alekna $
 */
public class HasEqualOrMoreItemsCondition extends BaseCondition {
	
	/** AMOUNT */
	public static const AMOUNT : String = "amount";
		
	/** ITEM_ID */
	public static const ITEM_ID : String = "itemId";
	
	/**
	 *	@inheritDoc
	 */
	public override function execute (  ) : void {
		ItemsService.hasMoreOrEqualItemsCondition( MyManager.instance.avatarId, this.getParamValueByLabel( ITEM_ID ), this.getParamValueByLabel( AMOUNT ) )
			.addResponders( this.onResult, this.onResult )
			.call();
	}	
	
}

}