package dm.game.characterbuilder {
	
	import dm.builder.interfaces.map.World3D;
	import dm.game.windows.avatarbuilder.AvatarBuilderWindow;
	import flare.basic.Scene3D;
	import flare.core.Camera3D;
	import flare.core.Pivot3D;
	import flare.loaders.Flare3DLoader;
	import flare.materials.filters.ColorFilter;
	import flare.materials.filters.NormalMapFilter;
	import flare.materials.filters.SpecularMapFilter;
	import flare.materials.filters.TextureFilter;
	import flare.materials.Shader3D;
	import flare.primitives.SkyBox;
	import flare.system.Input3D;
	import flare.utils.Vector3DUtils;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	import net.richardlord.ash.signals.Signal1;
	import utils.Utils;
	
	/**
	 * Caharacter builder
	 * @version $Id: CharacterBuilder.as 203 2013-08-15 06:12:04Z zenia.sorocan $
	 */
	public class CharacterBuilder extends Sprite {
		
		private var _world:World3D;
		public var character:Pivot3D;
		
		private var characterParts:AvatarBuilderWindow;
		
		public var avatarSavedSignal:Signal1 = new Signal1(Object);
		
		public var partNamesToParts:Dictionary = new Dictionary();
		public var partsToPartInfos:Dictionary = new Dictionary();
		public var partsToTextureSets:Dictionary = new Dictionary();
		
		/**
		 * Class constructor
		 */
		public function CharacterBuilder() {
			
			if (stage)
				init(null);
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		
		}
		
		/**
		 * Initializes this instance.
		 */
		private function init(e:Event):void {
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_world = new World3D(this);
			
			character = new Pivot3D("character");
			_world.scene.addChild(character);
			
			_world.scene.camera.y = 100;
			_world.scene.camera.z = -220;
			
			var sky:SkyBox = new SkyBox("assets/skyboxes/sb1.jpg", SkyBox.HORIZONTAL_CROSS, _world.scene);
			_world.scene.addChild(sky);
			
			_world.scene.addEventListener(Scene3D.UPDATE_EVENT, onSceneUpdate);
			
			this.characterParts = new AvatarBuilderWindow(this);
			// characterParts.x = stage.stageWidth - characterParts.width - 5;
			// characterParts.y = 20;
		}
		
		public function update(partName:String, partInfo:Object, textureSet:Object):void {
			character.stop();
			var part:Pivot3D = partNamesToParts[partName];
			try {
				if (partInfo.label != part.name) {
					delete partsToPartInfos[part];
					character.removeChild(part);
					part = null;
				} else {
					// eta proverka na sluchaj, kogda u predydushego skina ne bylo etoj chasti, bez nee programa dumaet chto chast' uzhe est'
					if (character.getChildByName(part.name) == null)
						part = null;
					onModelLoad(null);
				}
			} catch (error:Error) {
			}
			
			if (part == null) {
				part = _world.getModel(partInfo) as Pivot3D;
				if (Flare3DLoader(part).bytesLoaded == 0)
					part.addEventListener(Event.COMPLETE, onModelLoad);
				else
					onModelLoad(null);
				character.addChild(part);
				partNamesToParts[partName] = part;
				partsToPartInfos[part] = partInfo;
			}
			
			partsToTextureSets[part] = textureSet;
			
			function onModelLoad(e:Event):void {
				part.removeEventListener(Event.COMPLETE, onModelLoad);
				trace(partName);
				applyTextures(part, textureSet);
				characterParts.partsLoaded++;
				//trace(part.name + "loaded (" + characterParts.partsLoaded + " / " + characterParts.partsToLoad + ")");
				if (characterParts.partsLoaded == characterParts.partsToLoad) {
					trace("All parts loaded");
					characterParts.loadAnimations();
					synchronizeAnimation(character);
				}
			}
		}
		
		private function applyTextures(part:Pivot3D, textureSet:Object):void {
			
			try {
				trace(textureSet.diff.label);
				
				var cf:ColorFilter = new ColorFilter(characterParts.bodyColorPickerDO.selectedColor);
				var tf:TextureFilter = new TextureFilter(_world.getTexture(textureSet.diff), 0, BlendMode.NORMAL);
				var nmf:NormalMapFilter = new NormalMapFilter(_world.getTexture(textureSet.nml));
				var smf:SpecularMapFilter = new SpecularMapFilter(_world.getTexture(textureSet.spm));
				
				var shader:Shader3D = part.getMaterialByName("material") as Shader3D;
				if (shader == null) {
					shader = new Shader3D("material", [cf, tf, nmf, smf], true, Shader3D.VERTEX_SKIN);
					part.setMaterial(shader);
				} else
					shader.filters = [cf, tf, nmf, smf];
			} catch (error:Error) {
				trace("CharacterBuilder.applyTextures(): Something wrong with textures");
			}
		}
		
		public function get world():World3D {
			return _world;
		}
		
		public function compareTextureSets(textureSet1:Object, textureSet2:Object):Boolean {
			return (textureSet1.diff.label == textureSet2.diff.label);
		}
		
		private var out:Vector3D = new Vector3D();
		
		private function onSceneUpdate(e:Event):void {
			// simple orbit camera.
			var camera:Camera3D = _world.scene.camera;
			if (Input3D.mouseDown) {
				if (Input3D.keyDown(Input3D.SPACE)) {
					camera.translateX(-Input3D.mouseXSpeed * camera.getPosition().length / 300);
					camera.translateY(Input3D.mouseYSpeed * camera.getPosition().length / 300);
				} else {
					camera.rotateY(Input3D.mouseXSpeed, false, Vector3DUtils.ZERO);
					camera.rotateX(Input3D.mouseYSpeed, true, Vector3DUtils.ZERO);
				}
			}
			
			if (Input3D.delta != 0)
				camera.translateZ(camera.getPosition(false, out).length * Input3D.delta / 20);
		}
		
		private function synchronizeAnimation(skin:Pivot3D):void {
			var frame:int = 0;
			var child:Pivot3D;
			var inner_child:Pivot3D;
			for each (child in skin.children)
				for each (inner_child in child.children)
					if (inner_child.currentFrame > frame)
						frame = inner_child.currentFrame;
			for each (child in skin.children)
				for each (inner_child in child.children)
					inner_child.currentFrame = frame;
			character.play();
		}
		
		public function destroy():void {
			Utils.clearDictionary(partNamesToParts);
			Utils.clearDictionary(partsToPartInfos);
			Utils.clearDictionary(partsToTextureSets);
			
			_world.destroy();
			parent.removeChild(this);
		}
	
	}

}