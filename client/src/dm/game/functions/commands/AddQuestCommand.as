package dm.game.functions.commands {
	
	import dm.game.data.service.QuestsService;
	import dm.game.functions.BaseExecutable;
	import dm.game.managers.MyManager;
	import dm.game.windows.minimap.Minimap;
	import ucc.ui.window.WindowsManager;
	import utils.AMFPHP;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class AddQuestCommand extends BaseExecutable {
		
		public override function execute():void {
			QuestsService.addQuestToAvatar( getParamValueByLabel("questId"), MyManager.instance.avatar.id )
				.addResponders( this.onQuestAdd )
				.call();
		}
		
		private function onQuestAdd(response:Object):void {
			Minimap(WindowsManager.getInstance().getWindowByClass(Minimap)).refreshQuestMarkers();
			onResult(true);
		}
	
	}

}