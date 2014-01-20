package dm.game.systems {
	
	import dm.builder.interfaces.map.World3D;
	import dm.game.components.Skin3D;
	import dm.game.managers.EntityManager;
	import dm.game.nodes.RenderNode;
	import flare.core.IComponent;
	import flare.core.Mesh3D;
	import flare.core.Pivot3D;
	import flare.physics.core.PhysicsMesh;
	import flare.physics.core.PhysicsSystemManager;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import net.richardlord.ash.core.Entity;
	import net.richardlord.ash.core.Game;
	import net.richardlord.ash.core.NodeList;
	import net.richardlord.ash.core.System;
	
	/**
	 * Render and physics system
	 * @version $Id: RenderAndPhysicsSystem.as 190 2013-07-25 05:49:15Z zenia.sorocan $
	 */
	public class RenderAndPhysicsSystem extends System {
		
		public static const SCENE_FRAMERATE:int = 60;
		
		/** COLLISION_OBJECT */
		public static const COLLISION_OBJECT:String = "collisionObject";
		
		/** Is initialized? */
		private var initialized:Boolean = true;
		
		/** World */
		private var world:World3D;
		
		/** Render nodes */
		private var renderNodes:NodeList;
		
		/** Physics */
		private var physics:PhysicsSystemManager;
		
		/**
		 * Class constructor
		 */
		public function RenderAndPhysicsSystem(world:World3D) {
			//_rootContainer = rootContainer;
			world = world;
			init();
		}
		
		private function init():void {
			physics = PhysicsSystemManager.getInstance();
			physics.gravity = new Vector3D(0, -981, 0);
			EntityManager.instance.componentAddedSignal.add(onComponentAdded);
			EntityManager.instance.componentRemovedSignal.add(onComponentRemoved);
		}
		
		private function onComponentRemoved(entity:Entity, componentClass:Class):void {
			if (componentClass == Skin3D) {
				var skin:Pivot3D = Skin3D(entity.get(Skin3D)).skin;
				
				if (skin != null) {
					var collisionObject:Pivot3D = skin.getChildByName(COLLISION_OBJECT);
					
					if (collisionObject != null)
						for each (var component:IComponent in collisionObject.components)
							if (component is PhysicsMesh) {
								collisionObject.removeComponent(component);
								physics.removeBody(component as PhysicsMesh);
							}
				}
			}
		}
		
		/**
		 * On component added
		 */
		private function onComponentAdded(entity:Entity, componentClass:Class):void {
			if (componentClass == Skin3D) {
				var skin:Pivot3D = Skin3D(entity.get(Skin3D)).skin;
				
				if (skin != null) {
					var collisionObject:Pivot3D = skin.getChildByName(COLLISION_OBJECT);
					
					if (collisionObject != null) {
						//trace("RenderAndPhysicsSystem.onComponentAdded(): Skin3D.skin has collisionObject");
						collisionObject.visible = false;
						//trace("RenderAndPhysicsSystem.onComponentAdded() | Adding collision to: " + skin.userData.label);
						refreshCollision(collisionObject);
						skin.addEventListener(Pivot3D.UPDATE_TRANSFORM_EVENT, onSkinTransform);
					}
				}
			}
		}
		
		/**
		 * On skin transform
		 */
		private function onSkinTransform(e:Event):void {
			//trace("RenderAndPhysicsSystem.onSkinTransform()");
			var skin:Pivot3D = e.currentTarget as Pivot3D;
			var collisionObject:Mesh3D = skin.getChildByName(COLLISION_OBJECT) as Mesh3D;
			refreshCollision(collisionObject);
		}
		
		override public function removeFromGame(game:Game):void {
		
		}
		
		override public function addToGame(game:Game):void {
			renderNodes = game.getNodeList(RenderNode);
		}
		
		override public function update(time:Number):void {
			if (initialized) {
				physics.step();
			}
		}
		
		private function refreshCollision(collisionObject:Pivot3D):void {
			for each (var component:IComponent in collisionObject.components)
				if (component is PhysicsMesh) {
					collisionObject.removeComponent(component);
					physics.removeBody(component as PhysicsMesh);
				}
			var collision:PhysicsMesh = new PhysicsMesh(collisionObject);
			collision.movable = false;
			collisionObject.addComponent(collision);
		}
	
	}
}