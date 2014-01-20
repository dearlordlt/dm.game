package dm.builder.interfaces.map {
	
	import dm.game.persistance.SettingsManager;
	import flare.basic.Scene3D;
	import flare.core.Camera3D;
	import flare.core.Lines3D;
	import flare.core.Pivot3D;
	import flare.core.Texture3D;
	import flare.loaders.Flare3DLoader;
	import flare.loaders.Flare3DLoader1;
	import flare.materials.filters.ColorFilter;
	import flare.materials.filters.SpecularMapFilter;
	import flare.materials.filters.TextureFilter;
	import flare.materials.Shader3D;
	import flare.physics.core.PhysicsPlane;
	import flare.physics.core.RigidBody;
	import flare.primitives.Plane;
	import flare.system.ILibraryExternalItem;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author
	 */
	public class World3D extends Sprite {
		
		private const SCENE_ANTIALIAS:int = 2;
		private const PIXELS_IN_METER:int = 100;
		
		public static const SCENE_FRAMERATE:int = 60;
		
		protected var _scene:Scene3D;
		
		private var _worldWidth:int = 1000;
		private var _worldHeight:int = 1000;
		
		private var _lines:Lines3D = new Lines3D("lines");
		private var _floor:Plane;
		
		public function World3D(parent:DisplayObjectContainer, viewPortWidth:Number = 0, viewPortHeight:Number = 0, viewPortXPos:Number = 0, viewPortYPos:Number = 0) {
			
			parent.addChild(this);
			
			_scene = new Scene3D(this);
			
			// TODO: load external user setting here or externalize it
			
			if (viewPortWidth != 0 && viewPortHeight != 0) {
				_scene.setViewport(viewPortXPos, viewPortYPos, viewPortWidth, viewPortHeight, SCENE_ANTIALIAS);
			}
			
			// TODO: load video settings from SettingsManager
			// _scene.antialias = SCENE_ANTIALIAS;
			// _scene.frameRate = SCENE_FRAMERATE;
			
			// TODO: default values should be taken from somewhere else
			_scene.antialias = SettingsManager.getInstance().getStore().getKeyValue( "antialiasing", SCENE_ANTIALIAS, true );
			_scene.frameRate = SettingsManager.getInstance().getStore().getKeyValue( "framerate", SCENE_FRAMERATE, true );
			
			_scene.autoResize = true;
			_scene.camera = new Camera3D();
			
			// For f3d v1			
			_scene.registerClass(Flare3DLoader1);
			_scene.registerClass(SpecularMapFilter);
			
			recreateFloor();
			
			_scene.addEventListener(Scene3D.COMPLETE_EVENT, onSceneComplete);
		}
		
		private function recreateFloor():void {
			// Floor	
			try {
				_scene.removeChild(_floor);
			} catch (error:Error) {
			}
			
			var floorMaterial:Shader3D = new Shader3D( "floorShader" );
			var cf:ColorFilter = new ColorFilter(0xCCCCCC, 0.5);
			floorMaterial.filters = [cf];
			
			_floor = new Plane("floor", _worldWidth * PIXELS_IN_METER, _worldHeight * PIXELS_IN_METER, 1, floorMaterial, "+xz");
			_floor.visible = false;
			_floor.x += _floor.width / 2;
			_floor.z += _floor.height / 2;
			_scene.addChild(_floor);
			
			// Shader3D( _floor.getMaterialByName( "floorShader" ) ).filters.
			
			var floorPhys:RigidBody = new PhysicsPlane();
			floorPhys.movable = false;
			floorPhys.friction = 0;
			floorPhys.restitution = 0;
			_floor.addComponent(floorPhys);
			
			//redrawLines();
		}
		
		public function getModel(modelInfo:Object):Pivot3D {
			var model:Pivot3D = _scene.library.getItem(modelInfo.label) as Pivot3D;
			return (model) ? model : loadModel(modelInfo);
		}
		
		public function getTexture(textureInfo:Object):Texture3D {
			var texture3d:Texture3D = _scene.library.getItem(textureInfo.label) as Texture3D;
			return (texture3d) ? texture3d : loadTexture(textureInfo);
		}
		
		private function loadModel(modelInfo:Object):Flare3DLoader {
			var model:Flare3DLoader = new Flare3DLoader(modelInfo.path);
			model.name = modelInfo.label;
			var modelLibItem:ILibraryExternalItem = _scene.library.push(model);
			_scene.library.addItem(modelInfo.label, modelLibItem);
			return model;
		}
		
		private function loadTexture(textureInfo:Object):Texture3D {
			
			// TODO: check what parameter optimizeForRenderToTexture means in constructor
			// Answer: http://www.flare3d.com/thread/1337-faster-way-to-upload-textures-to-gpu-
			var texture3d:Texture3D = new Texture3D(textureInfo.path);
			texture3d.name = textureInfo.label;
			var textureLibItem:ILibraryExternalItem = _scene.library.push(texture3d);
			_scene.library.addItem(textureInfo.label, textureLibItem);
			return texture3d;
		}
		
		public function loadModels(models:Array):void {
			for each (var model:Object in models) {
				var modelLoader:Flare3DLoader = new Flare3DLoader(model.path);
				var modelLibItem:ILibraryExternalItem = _scene.library.push(modelLoader);
				_scene.library.addItem(model.label, modelLibItem);
			}
		}
		
		public function loadTextures(textures:Array):void {
			for each (var texture:Object in textures) {
				var texture3d:Texture3D = new Texture3D(texture.path);
				var textureLibItem:ILibraryExternalItem = _scene.library.push(texture3d);
				_scene.library.addItem(texture.label, textureLibItem);
			}
		}
		
		protected function onSceneComplete(e:Event):void {
			trace("World3D.onSceneComplete()");
			//_scene.removeEventListener(Scene3D.COMPLETE_EVENT, onSceneComplete);
		}
		
		public function redrawLines():void {
			var lineScale:Number = 50;
			_lines.clear();
			_scene.addChild(_lines);
			_lines.lineStyle(5, 0xFF0000);
			for (var i:int = 0; i < _worldWidth * PIXELS_IN_METER; i += lineScale * PIXELS_IN_METER) {
				for (var j:int = 0; j < _worldHeight * PIXELS_IN_METER; j += lineScale * PIXELS_IN_METER) {
					_lines.moveTo(i, 5, 0);
					_lines.lineTo(i, 5, _worldHeight * PIXELS_IN_METER);
					_lines.moveTo(i, 5, j);
					_lines.lineTo(i, 5, _worldWidth * PIXELS_IN_METER);
				}
			}
			
			// TODO: remove
			/*for (var i:int = 0; i < worldWidth * PIXELS_IN_METER; i += 200 * PIXELS_IN_METER) {
			   _lines.moveTo(i, 5, 0);
			   _lines.lineTo(i, 5, worldWidth * PIXELS_IN_METER);
			   _lines.moveTo(0, 5, i);
			   _lines.lineTo(worldWidth * PIXELS_IN_METER, 5, i);
			 }*/
		}
		
		public function get scene():Scene3D {
			return _scene;
		}
		
		public function destroy():void {
			parent.removeChild(this);
			_scene.dispose();
		}
		
		public function get worldWidthInPixels():Number {
			return _worldWidth * PIXELS_IN_METER;
		}
		
		public function setWorldDimensions(worldWidth:int, worldHeight:int):void {
			_worldWidth = worldWidth;
			_worldHeight = worldHeight;
			recreateFloor();
		}
	
	}

}