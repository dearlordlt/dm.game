package dm.game.systems.render {
	
	import flare.basic.Scene3D;
	import flare.core.Pivot3D;
	import flare.core.Texture3D;
	import flare.loaders.Flare3DLoader;
	import flare.materials.filters.AlphaMaskFilter;
	import flare.materials.filters.ColorFilter;
	import flare.materials.filters.NormalMapFilter;
	import flare.materials.filters.SpecularMapFilter;
	import flare.materials.filters.TextureFilter;
	import flare.materials.Shader3D;
	import flare.system.ILibraryExternalItem;
	import flare.utils.Pivot3DUtils;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class SkinLoader {
		
		/** DIFF */
		public static const DIFF:String = "diff";
		
		/** NML */
		public static const NML:String = "nml";
		
		/** SPM */
		public static const SPM:String = "spm";
		
		/** COLOR */
		public static const COLOR:String = "color";
		
		private var _scene:Scene3D;
		
		private var _skinInfo:Object;
		
		private var _recipient:SkinRecipient;
		
		private var _textureInfoToBitmap:Dictionary = new Dictionary();
		
		private var _elementsToLoad:int = 0;
		
		private var _elementsLoaded:int = 0;
		
		public function SkinLoader(scene:Scene3D, skinInfo:Object, recipient:SkinRecipient) {
			_scene = scene;
			_skinInfo = skinInfo;
			_recipient = recipient;
			
			_elementsToLoad = skinInfo.elements.length;
			
			for each (var elementInfo:Object in _skinInfo.elements) {
				var element:Flare3DLoader = _scene.library.getItem(elementInfo.label) as Flare3DLoader;
				
				if (element == null) {
					//trace("SkinLoader: '" + elementInfo.label + "' - element is not in library. Starting to load.");
					element = new Flare3DLoader(elementInfo.path);
					element.addEventListener(Event.COMPLETE, onElementLoaded);
					var externalLibItem:ILibraryExternalItem = _scene.library.push(element);
					_scene.library.addItem(elementInfo.label, externalLibItem);
				} else {
					if ((element.bytesLoaded == 0) || (element.bytesLoaded > 0 && element.bytesLoaded < element.bytesTotal)) {
						//trace("SkinLoader: '" + elementInfo.label + "' - element is in libarary. Still loading.");						
						Flare3DLoader(_scene.library.getItem(elementInfo.label)).addEventListener(Event.COMPLETE, onElementLoaded);
					} else if (element.bytesLoaded == element.bytesTotal) {
						//trace("SkinLoader: '" + elementInfo.label + "' - this element is already loaded.");
						_elementsLoaded++;
					} else
						throw new Error("dm.game.systems.render.SkinLoader.SkinLoader() : Some really weird loading error");
				}
			}
			
			if (_elementsLoaded == _elementsToLoad) {
				onAllElementsLoaded();
					//trace("SkinLoader: Elements already loaded");
			}
		}
		
		private function onElementLoaded(e:Event):void {
			//trace("SkinLoader.onElementLoaded(): " + Flare3DLoader(e.currentTarget).name);
			e.currentTarget.removeEventListener(Event.COMPLETE, onElementLoaded);
			_elementsLoaded++;
			
			if (_elementsLoaded == _elementsToLoad) {
				onAllElementsLoaded();
			}
		}
		
		private function onAllElementsLoaded():void {
			//trace("SkinLoader.onElementsLoad(): All elements of '" + _skinInfo.label + "' loaded. Adding to scene.");
			var skin:Pivot3D = new Pivot3D(_skinInfo.label);
			
			for each (var elementInfo:Object in _skinInfo.elements) {
				var element:Pivot3D = Pivot3D(_scene.library.getItem(elementInfo.label)).clone();
				
				element.userData = elementInfo.label;
				
				if (elementInfo.label.indexOf("animation") < 0) {
					skin.addChild(element);
					element.setPosition(elementInfo.x, elementInfo.y, elementInfo.z);
					var shader:Shader3D = new Shader3D("material", [], true, Shader3D.VERTEX_SKIN);
					
					for each (var textureInfo:Object in elementInfo.textures) {
						switch (textureInfo.type) {
							//var cf:ColorFilter = new ColorFilter(characterParts.bodyColor_cc.value);
							case DIFF: 
								var tf:TextureFilter = new TextureFilter(getTexture(textureInfo));
								shader.filters.push(tf);
								break;
							case NML: 
								var nmf:NormalMapFilter = new NormalMapFilter(getTexture(textureInfo));
								shader.filters.push(nmf);
								break;
							case SPM: 
								var smf:SpecularMapFilter = new SpecularMapFilter(getTexture(textureInfo));
								shader.filters.push(smf);
								break;
							case COLOR: 
								var cf:ColorFilter = new ColorFilter(textureInfo.path);
								shader.filters.splice(0, 0, cf);
								break;
						}
						
							//if (textureInfo.subtype == "transparent")
							//shader.filters.push(new AlphaMaskFilter());
					}
					
					if (shader.filters.length > 0)
						element.setMaterial(shader);
					
				} else {
					Pivot3DUtils.appendAnimation(skin, element);
				}
			}
			
			skin.userData = _skinInfo;
			
			_scene.addChild(skin);
			//skin.play();
			_recipient.receive(skin, _skinInfo);
		
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
	}
}