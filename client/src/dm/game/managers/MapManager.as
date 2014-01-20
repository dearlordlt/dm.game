package dm.game.managers {
	
	import dm.builder.interfaces.map.World3D;
	import dm.builder.interfaces.WindowManager;
	import dm.game.components.AvatarSpawnPoint;
	import dm.game.components.IComponent;
	import dm.game.components.MapObject;
	import dm.game.components.Skin3D;
	import dm.game.managers.EntityManager;
	import dm.game.managers.MyManager;
	import flare.core.Pivot3D;
	import flare.primitives.SkyBox;
	import net.richardlord.ash.core.Entity;
	import net.richardlord.ash.signals.Signal0;
	import ucc.util.Delegate;
	import utils.AMFPHP;
	
	/**
	 * Map manager
	 * @version $Id: MapManager.as 200 2013-08-01 12:52:12Z zenia.sorocan $
	 */
	public class MapManager {
		
		public var currentMap:Object = {label: "NewMap", id: 0, width: 100, height: 100}; // default value
		
		private var _avatarSpawnPoints:Array = new Array();
		
		public var mapLoadedSignal:Signal0 = new Signal0();
		
		public var world:World3D;
		
		/** Skin3D */
		public static const SKIN3D:String = "Skin3D";
		public static const ALTSKIN:String = "AltSkin";
		
		private var _skybox:SkyBox;
		
		private var _objectsToLoad:int = 0;
		
		private var _objectsLoaded:int = 0;
		
		private var _mapLoaded:Boolean = true;
		
		private static var _allowInstantiation:Boolean = false;
		
		private static var _instance:MapManager;
		
		public static function get instance():MapManager {
			if (!_instance) {
				_allowInstantiation = true;
				_instance = new MapManager();
				_allowInstantiation = false;
			}
			return _instance;
		}
		
		public function createNewMap(name:String, width:int, height:int, categoryId:int, skyboxInfo:Object = null, clearEntities:Boolean = true):void {
			if (clearEntities) {
				var entities:Array = EntityManager.instance.entities.concat();
				for each (var entity:Entity in entities)
					EntityManager.instance.removeEntity(entity);
			}
			
			currentMap = {id: 0, label: name, width: width, height: height, category_id: categoryId};
			world.setWorldDimensions(width, height);
			
			if (skyboxInfo != null)
				skybox = skyboxInfo;
		
			// TODO: uncomment if it's needed
			// world.redrawLines();
		}
		
		public function createAvatarSpawnPoint(avatarSpawnPointInfo:Object = null):void {
			var entity:Entity = new Entity();
			entity.label = "spawnpoint";
			EntityManager.instance.addEntity(entity);
			entity.add(new AvatarSpawnPoint());
			entity.add(new MapObject());
			var skin:Pivot3D = world.scene.addChildFromFile("assets/misc/spawnPoint.f3d");
			skin.userData = {label: "Spawn point"};
			world.scene.addChild(skin);
			entity.add(new Skin3D(skin, false));
			
			if (avatarSpawnPointInfo == null) {
				AvatarSpawnPoint(entity.get(AvatarSpawnPoint)).rotationY = 0;
				
				skin.x = world.scene.camera.x;
				skin.y = 5;
				skin.z = world.scene.camera.z;
				skin.setRotation(0, -90, 0);
			} else {
				for each (var conditionInfo:Object in avatarSpawnPointInfo.conditions)
					AvatarSpawnPoint(entity.get(AvatarSpawnPoint)).conditions.push(conditionInfo);
				
				AvatarSpawnPoint(entity.get(AvatarSpawnPoint)).rotationY = avatarSpawnPointInfo.rotationY;
				
				skin.x = avatarSpawnPointInfo.x;
				skin.y = avatarSpawnPointInfo.y;
				skin.z = avatarSpawnPointInfo.z;
				skin.setRotation(0, avatarSpawnPointInfo.rotationY - 90, 0);
			}
		}
		
		public function loadMap(mapId:int):void {
			trace("MapManager.loadMap() | mapId: " + mapId);
			_mapLoaded = false;
			
			this._objectsLoaded = 0;
			var amfphp:AMFPHP = new AMFPHP(this.onMapDataLoaded, Delegate.createWithCallArgsIgnore(this.onMapDataLoadFail, mapId));
			amfphp.xcall("dm.Maps.getMapById", mapId);
		
		}
		
		public function onMapDataLoaded(response:Object):void {
			_objectsToLoad = 0;
			
			trace("dm.game.managers.MapManager.onMapDataLoaded() : ");
			
			// TODO: udaliat' tol'ko te entity, kotoryje prinadlezhat etoj mape (sm. currentMap.mapInfo), a ne vse podriad
			EntityManager.instance.removeAllEntities();
			
			currentMap = {label: response.label, mapInfo: response, id: response.id, width: response.width, height: response.height, avatarSpawnPoints: response.avatarSpawnPoints, category_id: response.category_id};
			
			skybox = response.skybox;
			
			world.setWorldDimensions(response.width, response.height);
			
			var entityData:Object;
			
			trace("MapManager.onMap() | entities: " + response.entities.length);
			
			for each (entityData in response.entities)
				for each (var componentInfo:Object in entityData.components)
					if (componentInfo.component_type == SKIN3D || componentInfo.component_type == ALTSKIN)
						_objectsToLoad++;
			
			if (_objectsToLoad == 0) {				
				_mapLoaded = true;
				mapLoadedSignal.dispatch();
			}
			
			// if buildermode			
			if (!EsManager.instance.es.engine.connected)
				for each (var avatarSpawnPointInfo:Object in response.avatarSpawnPoints)
					createAvatarSpawnPoint(avatarSpawnPointInfo);
			
			EntityCreator.instance.entityCreatedSignal.add(onObjectLoaded);
			
			for each (entityData in response.entities)
				EntityCreator.instance.createEntityFromData(entityData);
		}
		
		private function onObjectLoaded(entity:Entity):void {
			_objectsLoaded++;
			entity.add(new MapObject());
			
			trace("MapManager: Loaded " + _objectsLoaded + " / " + _objectsToLoad + " objects (" + entity.label + ")");
			if (_objectsLoaded == _objectsToLoad) {				
				_mapLoaded = true;
				mapLoadedSignal.dispatch();
			}
		}
		
		public function saveMapAs(label:String, categoryId:int):void {
			var skin:Pivot3D;
			var map:Object = currentMap;
			map.label = label;
			if (categoryId != 0)
				map.category_id = categoryId;
			map.avatarSpawnPoints = new Array();
			var entityInfos:Array = new Array();
			
			for each (var entity:Entity in EntityManager.instance.entities) {
				if (entity.has(MapObject)) {
					if (entity.has(AvatarSpawnPoint)) {
						var avatarSpawnPoint:AvatarSpawnPoint = entity.get(AvatarSpawnPoint) as AvatarSpawnPoint;
						skin = Skin3D(entity.get(Skin3D)).skin;
						avatarSpawnPoint.x = skin.x;
						avatarSpawnPoint.y = skin.y;
						avatarSpawnPoint.z = skin.z;
						map.avatarSpawnPoints.push(avatarSpawnPoint);
						continue;
					}
					
					var entityInfo:Object = {id: entity.id, label: entity.label};
					
					if (entity.has(Skin3D)) {
						skin = Skin3D(entity.get(Skin3D)).skin;
						entityInfo.x = skin.x;
						entityInfo.y = skin.y;
						entityInfo.z = skin.z;
						entityInfo.rotationX = skin.getRotation().x;
						entityInfo.rotationY = skin.getRotation().y;
						entityInfo.rotationZ = skin.getRotation().z;
					}
					var components:Array = new Array();
					
					for each (var componentClass:Class in EntityManager.instance.entityComponents[entity]) {
						var component:IComponent = entity.get(componentClass);
						
						if (component.id != 0)
							components.push({id: component.id, type: component.componentType});
					}
					
					entityInfo.components = components;
					entityInfos.push(entityInfo);
				}
			}
			map.entities = entityInfos;
			
			var amfphp:AMFPHP = new AMFPHP(this.onMapSave, this.onMapSaveFail);
			amfphp.xcall("dm.Maps.saveMap", map, MyManager.instance.id);
		
		}
		
		/**
		 * On map save
		 */
		protected function onMapSave(response:Object):void {
			trace("[dm.game.managers.MapManager.onMapSave] response : " + JSON.stringify(response, null, 4));
			WindowManager.instance.dispatchMessage("Map successfully saved");
			trace("[ucc.data.service.AmfPhpClient.processCallQueue] remoteMethodCall.params : " + JSON.stringify(response, null, 4));
		}
		
		/**
		 *	On map data load fail
		 */
		protected function onMapDataLoadFail(mapId:int):void {
			trace("[dm.game.managers.MapManager.onMapDataLoadFail] mapId : " + mapId);
		}
		
		/**
		 *	On map save fail
		 */
		protected function onMapSaveFail():void {
		
		}
		
		public function set skybox(skyboxInfo:Object):void {
			try {
				world.scene.removeChild(_skybox);
			} catch (error:Error) {
			}
			_skybox = new SkyBox(skyboxInfo.path, skyboxInfo.type, world.scene);
			world.scene.addChild(_skybox);
			currentMap.skybox_id = skyboxInfo.id;
			//trace(currentMap.skybox_id);
		}
		
		public function get mapLoaded():Boolean {
			return _mapLoaded;
		}
	
	}

}