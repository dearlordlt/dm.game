package dm.game.routines {
	
	import dm.game.components.InputController;
	import dm.game.components.Skin3D;
	import dm.game.conditions.ConditionChecker;
	import dm.game.managers.EntityManager;
	import dm.game.managers.EnvironmentStateManager;
	import dm.game.managers.EsManager;
	import dm.game.managers.MapManager;
	import dm.game.managers.MyManager;
	import dm.game.managers.UserManager;
	import dm.game.systems.CameraManager;
	import dm.game.windows.actions.ActionsWindow;
	import dm.game.windows.chat.Chat;
	import dm.game.windows.DmWindowManager;
	import dm.game.windows.menu.Menu;
	import dm.game.windows.minimap.Minimap;
	import flare.core.Pivot3D;
	import net.richardlord.ash.core.Entity;
	import ucc.ui.window.WindowsManager;
	import utils.AMFPHP;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class AvatarSpawnRoutine {
		
		private var _avatarSkin:Pivot3D;
		private var _currentAvatarSpawnPointIndex:int = 0;
		
		public function AvatarSpawnRoutine(avatarSkin:Pivot3D) {
			_avatarSkin = avatarSkin;
		}
		
		public function execute():void {
			var amfphp:AMFPHP = new AMFPHP(this.onLastLocation, this.onLastLocationNotFound);
			amfphp.xcall("dm.Avatar.getAvatarLastLocation", MyManager.instance.avatar.id);
		
		}
		
		/**
		 * On last location loaded
		 */
		private function onLastLocation(response:Object):void {
			if (response)
				if (response.room_id == EsManager.instance.roomData.id) {
					trace( "[dm.game.routines.AvatarSpawnRoutine.onLastLocation()] : spawn from last location" );
					this.spawnAvatar(response);
					return;
				}
			this.checkAvatarSpawnPoint(MapManager.instance.currentMap.avatarSpawnPoints[_currentAvatarSpawnPointIndex]);
		}
		
		/**
		 * On last location not found
		 */
		private function onLastLocationNotFound(response:Object = null):void {
			if ((MapManager.instance.currentMap.avatarSpawnPoints == undefined) || (MapManager.instance.currentMap.avatarSpawnPoints.length == 0)) {
				this.spawnAvatar();
			}
			this.checkAvatarSpawnPoint(MapManager.instance.currentMap.avatarSpawnPoints[_currentAvatarSpawnPointIndex]);
			// this.spawnAvatar();
		}
		
		private function checkAvatarSpawnPoint(avatarSpawnPointInfo:Object):void {
			if (avatarSpawnPointInfo.conditions.length > 0) {
				var conditions:Array = new Array();
				
				for each (var conditionInfo:Object in avatarSpawnPointInfo.conditions) {
					conditions.push(conditionInfo);
				}
				
				var conditionChecker:ConditionChecker = new ConditionChecker();
				conditionChecker.checkConditions(conditions, onAvatarSpawnPointConditionCheck);
			} else {
				// trace("dm.game.routines.AvatarSpawnRoutine.checkAvatarSpawnPoint() : Spawn point doesn't have any conditions.");
				spawnAvatar(MapManager.instance.currentMap.avatarSpawnPoints[_currentAvatarSpawnPointIndex]);
			}
		}
		
		private function onAvatarSpawnPointConditionCheck(response:Object):void {
			if (response == null) {
				trace("Bad condition data");
			}
			if (response == true) {
				spawnAvatar(MapManager.instance.currentMap.avatarSpawnPoints[_currentAvatarSpawnPointIndex]);
			} else {
				_currentAvatarSpawnPointIndex++;
				if (_currentAvatarSpawnPointIndex >= MapManager.instance.currentMap.avatarSpawnPoints.length) {
					trace("Not one of spawnpoints works for this avatar");
				}
				checkAvatarSpawnPoint(MapManager.instance.currentMap.avatarSpawnPoints[_currentAvatarSpawnPointIndex]);
			}
		}
		
		private function spawnAvatar(avatarSpawnPointInfo:Object = null):void {
			trace("Spawn point data: " + JSON.stringify(avatarSpawnPointInfo));
			
			var entity:Entity = new Entity();
			EntityManager.instance.addEntity(entity);
			entity.add(new Skin3D(_avatarSkin));
			
			var inputController:InputController = new InputController(_avatarSkin);			
			entity.add(inputController);
			
			if (avatarSpawnPointInfo != null) {
				inputController.avatarController.x = parseFloat( avatarSpawnPointInfo.x );
				inputController.avatarController.y = parseFloat( avatarSpawnPointInfo.y );
				inputController.avatarController.z = parseFloat( avatarSpawnPointInfo.z );
				
				if ( avatarSpawnPointInfo.rotationY ) {
					inputController.avatarController.turn(avatarSpawnPointInfo.rotationY);
				}
				
			}
			
			
			
			//entity.add(new AvatarLabel(MyManager.instance.avatar.name));
			CameraManager.instance.follow(_avatarSkin);
			
			MyManager.instance.myAvatarEntity = entity;
			MyManager.instance.skin = _avatarSkin;
			
			UserManager.instance.updatePositionVariable(_avatarSkin);
			
			DmWindowManager.instance.hidePreloader();
			
			DmWindowManager.instance.menu = WindowsManager.getInstance().createWindow(Menu) as Menu;
			
			DmWindowManager.instance.chat = WindowsManager.getInstance().createWindow(Chat) as Chat;
			DmWindowManager.instance.chat.visible = true;
			
			Minimap(WindowsManager.getInstance().createWindow(Minimap)).refreshQuestMarkers();
			
			WindowsManager.getInstance().createWindow(ActionsWindow);
			
			new EnvironmentStateManager();
			
		}
	
	}

}