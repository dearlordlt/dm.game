package dm.game.managers {
	
	import com.electrotank.electroserver5.api.EsObject;
	import com.electrotank.electroserver5.api.UpdateUserVariableRequest;
	import com.electrotank.electroserver5.api.UserUpdateAction;
	import com.electrotank.electroserver5.api.UserUpdateEvent;
	import com.electrotank.electroserver5.api.UserVariable;
	import com.electrotank.electroserver5.api.UserVariableUpdateEvent;
	import com.electrotank.electroserver5.user.User;
	import dm.game.components.AvatarLabel;
	import dm.game.components.Skin3D;
	import dm.game.routines.RefreshAvatarSkinRoutine;
	import dm.game.systems.render.SkinFactory;
	import dm.game.systems.render.SkinRecipient;
	import flare.core.Pivot3D;
	import flash.utils.Dictionary;
	import net.richardlord.ash.core.Entity;
	import net.richardlord.ash.signals.Signal0;
	import net.richardlord.ash.signals.Signal1;
	import ucc.logging.Logger;
	import utils.AMFPHP;
	import utils.Utils;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class UserManager implements SkinRecipient {
		
		private static var _instance:UserManager;
		private static var _usingGetInstance:Boolean = false;
		
		private var _skinsToLoad:int = 0;
		private var _skinsLoaded:int = 0;
		
		public var skinsLoadedSignal:Signal0 = new Signal0();
		public var userJoinedSignal:Signal1 = new Signal1(String);
		public var userLeftSignal:Signal1 = new Signal1(String);
		public var userAvatarCreatedSignal:Signal1 = new Signal1(String);
		
		private var _usersToEntities:Dictionary = new Dictionary();
		private var _skinInfoToEntity:Dictionary = new Dictionary();
		
		public function UserManager() {
			if (!_usingGetInstance)
				throw new Error("Please use 'instance' property.");
			
			setupListeners();
		}
		
		public static function get instance():UserManager {
			if (_instance == null) {
				_usingGetInstance = true;
				_instance = new UserManager();
				_usingGetInstance = false;
			}
			return _instance;
		}
		
		private function setupListeners():void {
			EsManager.instance.userUpdateSignal.add(onUserUpdate);
			EsManager.instance.userVariableUpdateSignal.add(onUserVariableUpdate);
		}
		
		public function removeAllAvatars():void {
			for each (var entity:Entity in _usersToEntities)
				EntityManager.instance.removeEntity(entity);
			Utils.clearDictionary(_usersToEntities);
		}
		
		public function updatePositionVariable(skin:Pivot3D):void {
			if (EsManager.instance.es.engine.connected) {
				var uuvr:UpdateUserVariableRequest = new UpdateUserVariableRequest();
				uuvr.name = "position";
				var position:EsObject = new EsObject();
				position.setNumber("x", skin.x);
				position.setNumber("y", skin.y);
				position.setNumber("z", skin.z);
				position.setNumber("rotationX", skin.getRotation().x);
				position.setNumber("rotationY", skin.getRotation().y);
				position.setNumber("rotationZ", skin.getRotation().z);
				uuvr.value = position;
				EsManager.instance.es.engine.send(uuvr);
			}
		}
		
		public function broadcastAvatarSkinRefresh():void {
			if (EsManager.instance.es.engine.connected) {
				var uuvr:UpdateUserVariableRequest = new UpdateUserVariableRequest();
				uuvr.name = "skin";
				uuvr.value = new EsObject();
				EsManager.instance.es.engine.send(uuvr);
			}
		}
		
		public function createUserAvatars():void {
			_skinsToLoad = EsManager.instance.room.users.length - 1; // minus me
			if (_skinsToLoad == 0) {
				skinsLoadedSignal.dispatch();
				skinsLoadedSignal.removeAll();
				return;
			}
			_skinsLoaded = 0;
			for each (var user:User in EsManager.instance.room.users)
				if (user.userName != MyManager.instance.username)
					createAvatar(user);
		}
		
		private function onUserUpdate(e:UserUpdateEvent):void {
			switch (e.action) {
				case UserUpdateAction.AddUser: 
					trace("UserManager: User connected: " + e.userName);
					createAvatar(e);
					userJoinedSignal.dispatch(e.userName);
					break;
				case UserUpdateAction.DeleteUser: 
					trace("UserManager: User left: " + e.userName);
					userLeftSignal.dispatch(e.userName);
					var userEntity:Entity = _usersToEntities[e.userName];
					EntityManager.instance.removeEntity(userEntity);
					delete _usersToEntities[e.userName];
					break;
			}
		}
		
		private function onUserVariableUpdate(e:UserVariableUpdateEvent):void {
			if (e.userName != MyManager.instance.username) {
				
				var entity:Entity = _usersToEntities[e.userName];
				if (entity == null)
					return;
				
				var skin:Pivot3D;
				
				switch (e.variable.name) {
					case "position": 
						var position:EsObject = e.variable.value;
						if (entity.has(Skin3D)) {
							skin = Skin3D(entity.get(Skin3D)).skin;
							skin.setPosition(position.getNumber("x"), position.getNumber("y"), position.getNumber("z"), 1);
							skin.setRotation(position.getNumber("rotationX"), position.getNumber("rotationY"), position.getNumber("rotationZ"));
						}
						break;
					
					case "animation": 
						var animation:EsObject = e.variable.value;
						if (entity.has(Skin3D)) {
							skin = Skin3D(entity.get(Skin3D)).skin;
							AnimationManager.instance.playAnimation(skin, animation.getString("animation"));
						}
						break;
					
					case "skin":
						trace("UserManager: Refresh skin for " + e.userName);
						new RefreshAvatarSkinRoutine(_usersToEntities[e.userName]).execute();
						break;
				}
			}
		}
		
		private function createAvatar(user:Object):void { // both UserVariableUpdateEvent and User work here
			var entity:Entity = new Entity();
			entity.label = user.userName;
			EntityManager.instance.addEntity(entity);
			_usersToEntities[user.userName] = entity;
			
			var avatar:EsObject;
			for each (var uv:UserVariable in user.userVariables)
				if (uv.name == "avatar") {
					avatar = uv.value;
					break;
				}
			
			var amfphp:AMFPHP = new AMFPHP(onSkinInfo, onSkinInfoNotFound);
			amfphp.xcall("dm.Skin3D.getSkinById", avatar.getInteger("skin3dId"));
			
			function onSkinInfo(response:Object):void {
				_skinInfoToEntity[response] = entity;
				SkinFactory.createSkin(response, _instance);
			}
			
			function onSkinInfoNotFound(response:Object):void {
				Logger.log("dm.game.managers.UserManager.createAvatar() : skin info not found skin3dId" + avatar.getNumber("skin3dId"), Logger.LEVEL_ERROR);
			}
		
		}
		
		public function receive(skin:Pivot3D, skinInfo:Object):void {
			var entity:Entity = _skinInfoToEntity[skinInfo];
			delete _skinInfoToEntity[skinInfo];
			entity.add(new Skin3D(skin));
			
			// checking if user is from same school
			var userSchoolId:int = EsManager.instance.es.managerHelper.userManager.userByName(entity.label).userVariableByName("avatar").value.getInteger("schoolId");
			var labelColor:uint = (MyManager.instance.school.id == userSchoolId) ? 0x00FF00 : 0xFFFFFF;
			
			entity.add(new AvatarLabel(entity.label, labelColor));
			
			try {
				var position:EsObject = EsManager.instance.es.managerHelper.userManager.userByName(entity.label).userVariableByName("position").value;
				skin.setPosition(position.getNumber("x"), position.getNumber("y"), position.getNumber("z"), 1);
				skin.setRotation(position.getNumber("rotationX"), position.getNumber("rotationY"), position.getNumber("rotationZ"));
			} catch (e:Error) {
				trace("UserManager: Can't get user position");
			}
			
			userAvatarCreatedSignal.dispatch(entity.label);
			
			_skinsLoaded++;
			trace("UserManager: Initial user avatars loading: " + _skinsLoaded + " / " + _skinsToLoad);
			if (_skinsLoaded == _skinsToLoad) {
				skinsLoadedSignal.dispatch();
				skinsLoadedSignal.removeAll();
			}
		}
		
		public function get usersToEntities():Dictionary {
			return _usersToEntities;
		}
	
	}

}