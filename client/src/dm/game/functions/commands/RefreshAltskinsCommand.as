package dm.game.functions.commands 
{
	import dm.game.functions.BaseExecutable;
	import dm.game.systems.AltSkinManager;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class RefreshAltskinsCommand extends BaseExecutable 
	{
		
		public override function execute():void {
			trace("FunctionExecutor: RefreshAltskinsCommand");
			AltSkinManager.instance.recheckAltSkinConditions();
			onResult(true);
		}
		
	}

}