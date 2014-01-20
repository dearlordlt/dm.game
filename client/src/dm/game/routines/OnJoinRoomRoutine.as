package dm.game.routines {
	
	import dm.builder.interfaces.map.World3D;
	import dm.game.managers.EsManager;
	import dm.game.managers.MapManager;
	import dm.game.managers.MyManager;
	import dm.game.managers.UserManager;
	import dm.game.systems.render.SkinFactory;
	import dm.game.systems.render.SkinRecipient;
	import dm.game.windows.DmWindowManager;
	import flare.core.Pivot3D;
	import ucc.logging.Logger;
	import ucc.util.Delegate;
	import utils.AMFPHP;
	
	/**
	 * On join room routine
	 * @version $Id: OnJoinRoomRoutine.as 215 2013-09-29 14:28:49Z rytis.alekna $
	 */
	public class OnJoinRoomRoutine implements SkinRecipient {
		
		private var _world:World3D;
		
		public function OnJoinRoomRoutine(world:World3D) {
			_world = world;
		}
		
		public function execute():void {
			//UserManager.instance.removeAllAvatars();
			MapManager.instance.loadMap(EsManager.instance.roomData.map_id);
			MapManager.instance.mapLoadedSignal.add(onMapLoaded);
		}
		
		private function onMapLoaded():void {
			Logger.log("[dm.game.routines.OnJoinRoomRoutine.onMapLoaded]");
			UserManager.instance.skinsLoadedSignal.add(onAvatarsLoaded);
			UserManager.instance.createUserAvatars();
		}
		
		private function onAvatarsLoaded():void {
			Logger.log("[dm.game.routines.OnJoinRoomRoutine.onAvatarsLoaded]");
			var amfphp:AMFPHP = new AMFPHP(onCharacterSkinDataLoaded, Delegate.createWithCallArgsIgnore(this.onCharacterSkinDataLoadFail, MyManager.instance.avatar.skin3d_id));
			amfphp.xcall("dm.Skin3D.getSkinById", MyManager.instance.avatar.skin3d_id);
		}
		
		private function onCharacterSkinDataLoaded(response:Object):void {
			Logger.log("[dm.game.routines.OnJoinRoomRoutine.onCharacter]");
			SkinFactory.createSkin(response, this);
		}
		
		public function receive(skin:Pivot3D, skinInfo:Object):void {
			Logger.log("[dm.game.routines.OnJoinRoomRoutine.receive] : My character skin created");
			var avatarSpawnRoutine:AvatarSpawnRoutine = new AvatarSpawnRoutine(skin);
			avatarSpawnRoutine.execute();
		}
		
		/**
		 *	On character data load fail
		 */
		protected function onCharacterSkinDataLoadFail(skinId:int):void {
			Logger.log("[dm.game.routines.OnJoinRoomRoutine.onCharacterSkinDataLoadFail] failed to load skin with id : " + skinId, Logger.LEVEL_ERROR);
		}
	
	}

}