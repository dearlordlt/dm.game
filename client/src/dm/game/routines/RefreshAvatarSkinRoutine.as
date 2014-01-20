package dm.game.routines {
	
	import dm.game.components.InputController;
	import dm.game.components.Skin3D;
	import dm.game.managers.MyManager;
	import dm.game.systems.CameraManager;
	import dm.game.systems.render.SkinFactory;
	import dm.game.systems.render.SkinRecipient;
	import flare.core.Pivot3D;
	import net.richardlord.ash.core.Entity;
	import utils.AMFPHP;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class RefreshAvatarSkinRoutine implements SkinRecipient {
		
		private var _avatarEntity:Entity;
		
		public function RefreshAvatarSkinRoutine(avatarEntity:Entity) {
			_avatarEntity = avatarEntity;
		}
		
		public function execute():void {
			var skin3dId:int = Skin3D(_avatarEntity.get(Skin3D)).skin.userData.id;
			new AMFPHP(onSkinData).xcall("dm.Skin3D.getSkinById", skin3dId);
		}
		
		private function onSkinData(response:Object):void {
			SkinFactory.createSkin(response, this);
		}
		
		public function receive(skin:Pivot3D, skinInfo:Object):void {			
			var oldSkin:Pivot3D = Skin3D(_avatarEntity.get(Skin3D)).skin;			
			skin.setPosition(oldSkin.x, oldSkin.y, oldSkin.z, 1);
			skin.setRotation(oldSkin.getRotation().x, oldSkin.getRotation().y, oldSkin.getRotation().z);			
			_avatarEntity.add(new Skin3D(skin));
			
			if (_avatarEntity == MyManager.instance.myAvatarEntity) {
				InputController(_avatarEntity.get(InputController)).skin = skin;
				CameraManager.instance.follow(skin);
				MyManager.instance.skin = skin;				
			}
		}
	
	}

}