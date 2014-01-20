package dm.game.functions.commands 
{
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
	public class CompleteQuestCommand extends BaseExecutable 
	{
		
		public override function execute():void {
			// var amfphp:AMFPHP = new AMFPHP(onResponse).xcall("dm.Quest.completeAvatarQuest", getParamValueByLabel("avatarId"), getParamValueByLabel("questId"));
			QuestsService.completeAvatarQuest( MyManager.instance.avatar.id, getParamValueByLabel("questId") )
				.addResponders( this.onResponse )
				.call();
		}
		
		private function onResponse(response:Object):void {
			Minimap(WindowsManager.getInstance().getWindowByClass(Minimap)).refreshQuestMarkers();
			onResult(true);
		}
		
	}

}