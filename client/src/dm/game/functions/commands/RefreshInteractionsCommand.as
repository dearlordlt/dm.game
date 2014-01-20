package dm.game.functions.commands 
{
	import dm.game.functions.BaseExecutable;
	import dm.game.systems.InteractionSystem;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class RefreshInteractionsCommand extends BaseExecutable 
	{
		
		public override function execute():void {
			InteractionSystem.instance.recheckInteractionConditions();
			onResult(true);
		}
		
	}

}