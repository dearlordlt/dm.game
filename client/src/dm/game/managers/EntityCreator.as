package dm.game.managers {
	
	import dm.game.components.AltSkin;
	import dm.game.components.Skin3D;
	import dm.game.Main;
	import dm.game.managers.EntityManager;
	import dm.game.systems.AltSkinManager;
	import dm.game.systems.render.SkinFactory;
	import dm.game.systems.render.SkinRecipient;
	import flare.core.Pivot3D;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	import net.richardlord.ash.core.Entity;
	import net.richardlord.ash.signals.Signal1;
	import ucc.logging.Logger;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class EntityCreator implements SkinRecipient {
		
		public var entityCreatedSignal:Signal1 = new Signal1(Entity);
		
		/** SKIN_3D */
		private const SKIN3D:String = "Skin3D";
		private const ALTSKIN:String = "AltSkin";
		
		private static var _allowInstantiation:Boolean = false;
		
		private static var _instance:EntityCreator;
		
		/** Skin to entity data */
		private var skinDataToEntityData:Dictionary = new Dictionary();
		
		public function EntityCreator() {
			if (!_allowInstantiation)
				throw(new Error("Use 'instance' property to get an instance"));
		}
		
		public static function get instance():EntityCreator {
			if (!_instance) {
				_allowInstantiation = true;
				_instance = new EntityCreator();
				_allowInstantiation = false;
			}
			return _instance;
		}
		
		/**
		 * Create entity from info
		 */
		public function createEntityFromData(entityData:Object):Entity {
			var component:Object;
			
			var entity:Entity = new Entity();
			entityData.entity = entity;
			
			EntityManager.instance.entityProperties[entity] = entityData;
			
			entity.id = entityData.id;
			entity.label = entityData.label;
			EntityManager.instance.addEntity(entity);
			
			for each (component in entityData.components) {
				if (component.component_type == ALTSKIN) {
					if (Main.getInstance().getBuilderMode())
						entity.add(new AltSkin(component.data));
					AltSkinManager.instance.getSkin(entityData, skinDataToEntityData, this);
					return entity;
				}
				
				if (component.component_type == SKIN3D) {
					component.data.enabled = true;
					skinDataToEntityData[component.data] = entityData;
					SkinFactory.createSkin(component.data, this);
					return entity;
				}
			}
			
			for each (component in entityData.components) {
				switch (component.component_type) {
					case ALTSKIN:
						break;
					case SKIN3D: 
						break;
					default: 
						var componentClass:Class = getDefinitionByName("dm.game.components." + component.component_type) as Class;
						entity.add(new componentClass(component.data));
						break;
				}
			}
			return entity;
		}
		
		public function receive(skin:Pivot3D, skinData:Object):void {
			//trace("EntityCreator: Skin received | " + skinInfo.label);
			var time:int = getTimer();
			var entityData:Object = skinDataToEntityData[skinData];
			
			if (entityData != null) {
				var entity:Entity = entityData.entity as Entity;
				skin.setPosition(entityData.x, entityData.y, entityData.z);
				skin.setRotation(entityData.rotationX, entityData.rotationY, entityData.rotationZ);
				delete skinDataToEntityData[skinData];
				entity.add(new Skin3D(skin, skinData.enabled));
				for each (var component:Object in entityData.components) {
					switch (component.component_type) {
						case ALTSKIN:
							break;
						case SKIN3D: 
							break;
						default: 
							var componentClass:Class = getDefinitionByName("dm.game.components." + component.component_type) as Class;
							entity.add(new componentClass(component.data));
							break;
					}
				}
				
				entityCreatedSignal.dispatch(entity);
			} else {
				Logger.log("dm.game.managers.EntityCreator.receive() : EntityInfo not found for skin : " + JSON.stringify(skinData, null, 4), Logger.LEVEL_ERROR);
			}
		}
	
	}

}