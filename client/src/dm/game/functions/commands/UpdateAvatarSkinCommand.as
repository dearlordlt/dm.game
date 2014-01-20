package dm.game.functions.commands {
	
	import dm.game.functions.BaseExecutable;
	import dm.game.managers.MyManager;
	import dm.game.managers.UserManager;
	import dm.game.routines.RefreshAvatarSkinRoutine;
	import utils.AMFPHP;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class UpdateAvatarSkinCommand extends BaseExecutable {
		
		public override function execute():void {
			var amfphp:AMFPHP = new AMFPHP(onAvatarSkinUpdate).xcall("dm.Avatar.updateAvatarSkin", MyManager.instance.avatar.id, getParamValueByLabel("partToReplaceName"), getParamValueByLabel("partToReplaceWithNum"), getParamValueByLabel("textureSetNum"));
		}
		
		private function onAvatarSkinUpdate(response:Object):void {
			new RefreshAvatarSkinRoutine(MyManager.instance.myAvatarEntity).execute();
			UserManager.instance.broadcastAvatarSkinRefresh();
			onResult(true);
		}
	
	}

}