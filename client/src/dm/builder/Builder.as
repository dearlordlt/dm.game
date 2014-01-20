package dm.builder {
	
	import dm.builder.interfaces.components.ComponentHolder;
	import dm.builder.interfaces.entity.EntityMenu;
	import dm.builder.interfaces.map.MapMenu;
	import dm.builder.interfaces.tools.ToolMenu;
	import dm.game.components.AltSkin;
	import dm.game.components.Light;
	import dm.game.components.MapObject;
	import dm.game.components.Skin3D;
	import dm.game.components.TransformEnabled;
	import dm.game.Main;
	import dm.game.managers.EntityManager;
	import dm.game.systems.CameraManager;
	import dm.game.systems.InputSystem;
	import dm.game.systems.render.SkinRecipient;
	import dm.game.systems.TransformSystem;
	import flare.basic.Scene3D;
	import flare.core.Pivot3D;
	import flare.system.Input3D;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import net.richardlord.ash.core.Entity;
	import utils.Utils;
	
	/**
	 * Main builder class
	 * @version $Id: Builder.as 200 2013-08-01 12:52:12Z zenia.sorocan $
	 */
	public class Builder extends Sprite {
		
		/** Map editing permissions */
		protected var permissions:Object;
		
		private var _holder:ComponentHolder;
		private var _tryMapper:Entity;
		private var _transformSystem:TransformSystem;
		
		private var _scene:Scene3D;
		
		/**
		 * Class constructor
		 */
		public function Builder(parent:DisplayObjectContainer, permissions:Object):void {
			
			/** this.permissions */
			this.permissions = permissions;
			
			parent.addChild(this);
			
			if (stage) {
				init();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		/**
		 * Init
		 */
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point			
			
			//Input3D.enableEventPhase = true;
			
			var layer2d:Sprite = new Sprite();
			addChild(layer2d);
			_transformSystem = new TransformSystem(layer2d);
			EntityManager.instance.game.addSystem(_transformSystem, 1);
			
			_holder = new ComponentHolder(this);
			
			// hiding or displaying menus based on privileges
			var mapMenu:MapMenu = new MapMenu(this, this.permissions.map);
			var entityMenu:EntityMenu = new EntityMenu(this, this.permissions.entity);
			entityMenu.x = 202;
			var toolMenu:ToolMenu = new ToolMenu(this, this.permissions.tools);
			toolMenu.x = 404;
			
			setupCamera();
			
			_scene = Main.getInstance().getWorld3D().scene;
			_scene.addEventListener(Scene3D.UPDATE_EVENT, onSceneUpdate);
			
			EntityManager.instance.componentAddedSignal.add(onComponentAdd);
			EntityManager.instance.componentRemovedSignal.add(onComponentRemove);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseDown);
			
			for each (var entity:Entity in EntityManager.instance.entities) {
				if (entity.has(Skin3D) && !entity.has(TransformEnabled))
					if (Skin3D(entity.get(Skin3D)).skin != null)
						entity.add(new TransformEnabled(Skin3D(entity.get(Skin3D)).skin));
			}
		}
		
		private function setupCamera():void {
			CameraManager.instance.idle();
			
			//CameraManager.instance.camera.x = _world.worldWidthInPixels / 2;
			
			CameraManager.instance.camera.y = 5000;
			//CameraManager.instance.camera.z = _world.worldWidthInPixels / 2;
			
			CameraManager.instance.camera.x = 0;
			CameraManager.instance.camera.z = 0;
			
			CameraManager.instance.camera.setRotation(90, 0, 0);
			CameraManager.instance.camera.far = 100000;
		}
		
		private function onMouseDown(e:MouseEvent):void {
			e.stopImmediatePropagation();
		}
		
		private function onComponentAdd(entity:Entity, componentClass:Class):void {
			if (componentClass == Skin3D)
				if (Skin3D(entity.get(Skin3D)).skin != null)
					entity.add(new TransformEnabled(Skin3D(entity.get(Skin3D)).skin));
			
			if (componentClass == Light)
				if (Light(entity.get(Light)).light3d != null)
					entity.add(new TransformEnabled(Light(entity.get(Light)).light3d));
		}
		
		private function onComponentRemove(entity:Entity, componentClass:Class):void {
			if (componentClass == Skin3D)
				entity.remove(TransformEnabled);
		}
		
		private function onSceneUpdate(e:Event):void {
			var cameraSpeed:Number = 20;
			
			if (InputSystem.inputEnabled) {
				
				if (Input3D.mouseDown) {
					CameraManager.instance.camera.x -= Input3D.mouseXSpeed * 100;
					CameraManager.instance.camera.z += Input3D.mouseYSpeed * 100;
				}
				
				CameraManager.instance.camera.y += 100 * Input3D.delta;
				
				// move object to mouse position
				
				if (Input3D.keyDown(Input3D.SHIFT) && Input3D.keyHit(Input3D.V))
					try {
						var camPos:Vector3D = CameraManager.instance.camera.getPosition(false);
						var camDir:Vector3D = CameraManager.instance.camera.getPointDir(Input3D.mouseX, Input3D.mouseY);
						var pos:Vector3D = Utils.rayPlane(new Vector3D(0, 1, 0), new Vector3D(), camPos, camDir);
						
						Skin3D(EntityManager.instance.currentEntity.get(Skin3D)).skin.setPosition(pos.x, 0, pos.z);
					} catch (e:Error) {
						trace(e.message);
					}
				
				if (Input3D.keyDown(Input3D.SHIFT) && Input3D.keyHit(Input3D.C)) {
					var camPos1:Vector3D = CameraManager.instance.camera.getPosition(false);
					var camDir1:Vector3D = CameraManager.instance.camera.getPointDir(Input3D.mouseX, Input3D.mouseY);
					var pos1:Vector3D = Utils.rayPlane(new Vector3D(0, 1, 0), new Vector3D(), camPos1, camDir1);
					
					var entityToClone:Entity = EntityManager.instance.currentEntity;
					
					var entityClone:Entity = new Entity();
					entityClone.id = 0;
					entityClone.label = entityToClone.label;
					
					EntityManager.instance.addEntity(entityClone);
					entityClone.add(new MapObject());
					
					if (entityToClone.has(AltSkin)) {
						var altskinData:Object = AltSkin(entityToClone.get(AltSkin)).data;
						entityClone.add(new AltSkin(altskinData));
					}
					
					if (entityToClone.has(Skin3D)) {
						var skinClone:Pivot3D = Skin3D(entityToClone.get(Skin3D)).skin.clone();
						_scene.addChild(skinClone);
						skinClone.setPosition(pos1.x, 0, pos1.z);
						entityClone.add(new Skin3D(skinClone));
					}
				}
			}
		}
		
		public function destroy():void {
			
			_scene.removeEventListener(Scene3D.UPDATE_EVENT, onSceneUpdate);
			EntityManager.instance.componentAddedSignal.remove(onComponentAdd);
			EntityManager.instance.componentRemovedSignal.remove(onComponentRemove);
			
			for each (var entity:Entity in EntityManager.instance.entities)
				if (entity.has(TransformEnabled))
					entity.remove(TransformEnabled);
			EntityManager.instance.game.removeSystem(_transformSystem);
			
			_holder.destroy();
			
			parent.removeChild(this);
		}
	
	}

}