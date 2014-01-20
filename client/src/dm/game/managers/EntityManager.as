package dm.game.managers {
	
	import flash.utils.Dictionary;
	import net.richardlord.ash.core.Entity;
	import net.richardlord.ash.core.Game;
	import net.richardlord.ash.signals.Signal0;
	import net.richardlord.ash.signals.Signal1;
	import net.richardlord.ash.signals.Signal2;
	
	/**
	 * ...
	 * @author ...
	 */
	public class EntityManager {
		
		private static var _allowInstantiation:Boolean = false;
		private static var _instance:EntityManager;
		
		public var componentAddedSignal:Signal2;
		public var componentRemovedSignal:Signal2;
		public var entitySelectedSignal:Signal1;
		public var entityRemovedSignal:Signal0;
		public var entityAddedSignal:Signal1;
		
		public var game:Game;
		
		private var _entities:Array;
		private var _entityComponents:Dictionary;
		private var _entityProperties:Dictionary;
		
		private var _currentEntity:Entity;
		
		public function EntityManager() {
			if (!_allowInstantiation)
				throw(new Error("Use 'instance' property to get an instance"));
			
			_entities = new Array();
			_entityComponents = new Dictionary();
			_entityProperties = new Dictionary();
			
			componentAddedSignal = new Signal2(Entity, Class);
			componentRemovedSignal = new Signal2(Entity, Class);
			entitySelectedSignal = new Signal1(Entity);
			entityRemovedSignal = new Signal0();
			entityAddedSignal = new Signal1(Entity);
		}
		
		public static function get instance():EntityManager {
			if (!_instance) {
				_allowInstantiation = true;
				_instance = new EntityManager();
				_allowInstantiation = false;
			}
			return _instance;
		}
		
		public function addEntity(entity:Entity):void {
			//trace("EntityManager.addEntity()");
			game.addEntity(entity);
			_entities.push(entity);
			entity.componentAdded.add(onComponentAdd);
			entity.componentRemoved.add(onComponentRemove);
			_entityComponents[entity] = new Array();
			currentEntity = entity;
			entityAddedSignal.dispatch(entity);
		}
		
		private function onComponentAdd(entity:Entity, componentClass:Class):void {
			var entityComponentArray:Array = _entityComponents[entity] as Array;
			entityComponentArray.push(componentClass);
			componentAddedSignal.dispatch(entity, componentClass);
		}
		
		private function onComponentRemove(entity:Entity, componentClass:Class):void {
			var entityComponentArray:Array = _entityComponents[entity] as Array;
			entityComponentArray.splice(entityComponentArray.indexOf(componentClass), 1);
			entity.get(componentClass).destroy();
			componentRemovedSignal.dispatch(entity, componentClass);
		}
		
		public function removeEntity(entity:Entity):void {
			_entities.splice(_entities.indexOf(entity), 1);
			
			var entityComponents:Array = _entityComponents[entity].slice();
			for each (var componentClass:Class in entityComponents)
				entity.remove(componentClass);
			
			delete _entityComponents[entity];
			delete _entityProperties[entity];
			
			game.removeEntity(entity);
			
			if (_currentEntity == entity)
				_currentEntity = null;
			
			entity.componentAdded.remove(onComponentAdd);
			entity.componentRemoved.remove(onComponentRemove);
			
			entity = null;
			
			entityRemovedSignal.dispatch();
		}
		
		public function removeAllEntities():void {
			trace("EntityManager.removeAllEntities() | Entities length: " + entities.length);
			for each (var entity:Entity in _entities.concat())
				removeEntity(entity);
			trace("EntityManager.removeAllEntities() | Entities length: " + entities.length);
		}
		
		public function get entities():Array {
			return _entities;
		}
		
		public function get currentEntity():Entity {
			return _currentEntity;
		}
		
		public function set currentEntity(value:Entity):void {
			_currentEntity = value;
			entitySelectedSignal.dispatch(value);
		}
		
		public function get entityComponents():Dictionary {
			return _entityComponents;
		}
		
		public function get entityProperties():Dictionary {
			return _entityProperties;
		}
	
	}

}