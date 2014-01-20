package dm.game.systems {
	
	import dm.game.components.AltSkin;
	import dm.game.components.Skin3D;
	import dm.game.conditions.ConditionChecker;
	import dm.game.Main;
	import dm.game.managers.EntityManager;
	import dm.game.managers.EsManager;
	import dm.game.systems.render.SkinFactory;
	import dm.game.systems.render.SkinRecipient;
	import flare.core.Pivot3D;
	import flash.utils.Dictionary;
	import net.richardlord.ash.core.Entity;
	import utils.AMFPHP;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class AltSkinManager implements SkinRecipient {
		
		private static var _allowInstantiation:Boolean = false;
		private static var _instance:AltSkinManager;
		
		private const ALTSKIN:String = "AltSkin";
		
		// for altskin rechecks
		private var _entityData:Array = new Array();
		private var _skinDataToEntityData:Dictionary = new Dictionary();
		
		public function AltSkinManager() {
			if (!_allowInstantiation)
				throw(new Error("Use 'instance' property to get an instance"));
		}
		
		public static function get instance():AltSkinManager {
			if (!_instance) {
				_allowInstantiation = true;
				_instance = new AltSkinManager();
				_allowInstantiation = false;
			}
			return _instance;
		}
		
		public function getSkin(entityData:Object, skinDataToEntityData:Dictionary, skinRecipient:SkinRecipient):void {
			var amfphp:AMFPHP;
			var defaultSkinId:int;
			
			// saving entity data for rechecks
			if (_entityData.indexOf(entityData) == -1)
				_entityData.push(entityData);
			
			var altSkinData:Object;
			for each (var component:Object in entityData.components)
				if (component.component_type == ALTSKIN)
					altSkinData = component.data
			
			// getting default skin out of skin array
			for each (var skinData:Object in altSkinData.skins3d)
				if (skinData.is_default) {
					defaultSkinId = skinData.id;
					break;
				}
			
			if (Main.getInstance().getBuilderMode()) {
				amfphp = new AMFPHP(onSkinData).xcall("dm.Skin3D.getSkinById", defaultSkinId);
				return;
			}
			
			
			var conditionChecker:ConditionChecker = new ConditionChecker();
			
			// changing avatar id for skin checks when visiting other player homes
			if (String(EsManager.instance.roomData.label).split('@')[0] == EsManager.HOME_ROOM_NAME)
				conditionChecker.avatarId = int(String(EsManager.instance.room.name).split('@')[1]);
			trace("AltSkinManager: Checking conditions for " + conditionChecker.avatarId);
			
			var currentSkinIndex:int = 0;
			
			if (altSkinData.skins3d[currentSkinIndex].id == defaultSkinId)
				currentSkinIndex++;
			
			if (altSkinData.skins3d[currentSkinIndex].conditions)
				conditionChecker.checkConditions(altSkinData.skins3d[currentSkinIndex].conditions, onConditionCheck);
			else
				amfphp = new AMFPHP(onSkinData).xcall("dm.Skin3D.getSkinById", altSkinData.skins3d[currentSkinIndex].id); // if skin has no conditions, then it passes check
			
			function onConditionCheck(result:Boolean):void {
				//trace("AltSkinManager.onConditionCheck()");
				if (result) {
					amfphp = new AMFPHP(onSkinData).xcall("dm.Skin3D.getSkinById", altSkinData.skins3d[currentSkinIndex].id);
				} else {
					if (currentSkinIndex < altSkinData.skins3d.length - 1) {
						currentSkinIndex++;
						conditionChecker.checkConditions(altSkinData.skins3d[currentSkinIndex].conditions, onConditionCheck);
					} else
						amfphp = new AMFPHP(onSkinData).xcall("dm.Skin3D.getSkinById", defaultSkinId);
				}
			
			}
			
			function onSkinData(result:Object):void {
				//trace("AltSkinManager.onSkinData()");
				result.enabled = false;
				skinDataToEntityData[result] = entityData;
				SkinFactory.createSkin(result, skinRecipient);
			}
		}
		
		public function recheckAltSkinConditions():void {
			for each (var entityData:Object in _entityData)
				getSkin(entityData, _skinDataToEntityData, this);
		}
		
		public function receive(skin:Pivot3D, skinData:Object):void {
			var entityData:Object = _skinDataToEntityData[skinData];
			if (entityData != null) {
				var entity:Entity = entityData.entity as Entity;
				skin.setPosition(entityData.x, entityData.y, entityData.z);
				skin.setRotation(entityData.rotationX, entityData.rotationY, entityData.rotationZ);
				delete _skinDataToEntityData[skinData];
				entity.add(new Skin3D(skin));
			}
		}
	}

}