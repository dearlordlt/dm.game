package dm.game.characterbuilder {
	
	import com.bit101.components.ColorChooser;
	import com.bit101.components.ComboBox;
	import com.bit101.components.HSlider;
	import com.bit101.components.InputText;
	import com.bit101.components.NumericStepper;
	import com.bit101.components.PushButton;
	import dm.builder.interfaces.BuilderLabel;
	import dm.builder.interfaces.BuilderWindow;
	import dm.builder.interfaces.map.World3D;
	import dm.builder.interfaces.MyStepper;
	import dm.builder.interfaces.WindowManager;
	import dm.game.managers.MyManager;
	import flare.core.Mesh3D;
	import flare.core.Pivot3D;
	import flare.loaders.Flare3DLoader;
	import flare.utils.Pivot3DUtils;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import utils.AMFPHP;
	import utils.Utils;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class CharacterParts extends BuilderWindow {
		
		private var _world:World3D;
		
		private var _partNames:Array = ["accessories", "hair", "head", "top", "bottom", "shoes"];
		
		private var _currentAnimations:Array;
		
		private var _elementInfos:Array;
		private var _textureInfos:Array;
		
		public var partsLoaded:int;
		public var partsToLoad:int;
		
		private var _accessoriesInfos:Array = new Array();
		private var _hairInfos:Array = new Array();
		private var _headInfos:Array = new Array();
		private var _topInfos:Array = new Array();
		private var _bottomInfos:Array = new Array();
		private var _shoesInfos:Array = new Array();
		
		private var _accessoriesTextureInfos:Array = new Array();
		private var _hairTextureInfos:Array = new Array();
		private var _headTextureInfos:Array = new Array();
		private var _topTextureInfos:Array = new Array();
		private var _bottomTextureInfos:Array = new Array();
		private var _shoesTextureInfos:Array = new Array();
		
		private var name_ti:InputText;
		public var type_cb:ComboBox;
		public var bodyColor_cc:ColorChooser;
		private var animation_cb:ComboBox;
		
		private var accessories_stpr:MyStepper;
		private var hair_stpr:MyStepper;
		private var head_stpr:MyStepper;
		private var top_stpr:MyStepper;
		private var bottom_stpr:MyStepper;
		private var shoes_stpr:MyStepper;
		
		private var accessoriesTexture_stpr:MyStepper;
		private var hairTexture_stpr:MyStepper;
		private var headTexture_stpr:MyStepper;
		private var topTexture_stpr:MyStepper;
		private var bottomTexture_stpr:MyStepper;
		private var shoesTexture_stpr:MyStepper;
		
		public function CharacterParts(parent:DisplayObjectContainer) {
			super(parent, "", 215, 350);
			_world = CharacterBuilder(parent).world;
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			preloadData();
		}
		
		private function onMouseDown(e:MouseEvent):void {
			e.stopImmediatePropagation();
		}
		
		private function preloadData():void {
			var amfphp:AMFPHP = new AMFPHP(onCharacterTypes);
			amfphp.xcall("dm.Builder.getCharacterTypes", MyManager.instance.id);
		}
		
		private function onCharacterTypes(response:Object):void {
			type_cb.items = response as Array;
			type_cb.selectedIndex = 0;
			
			var amfphp:AMFPHP = new AMFPHP(onElements);
			amfphp.xcall("dm.Skin3D.getAllCharacters");
		}
		
		private function onElements(response:Object):void {
			_elementInfos = response as Array;
			
			var amfphp:AMFPHP = new AMFPHP(onTextures);
			amfphp.xcall("dm.Skin3D.getAllCharacterTextures");
			
			updatePartInfoArray();
		}
		
		private function onTextures(response:Array):void {
			_textureInfos = response as Array;
			
			for each (var textureInfo:Object in _textureInfos)
				expandTextureInfo(textureInfo);
			
			updateTextureInfoArray();
			
			type_cb.addEventListener(Event.SELECT, onTypeChange);
			
			fullUpdate();
		}
		
		private function updatePartInfoArray():void {
			partsToLoad = 0;
			
			var partInfos:Array;
			var partName:String;
			
			for each (partName in _partNames) {
				partInfos = this['_' + partName + "Infos"];
				partInfos.splice(0);
			}
			
			for each (var partInfo:Object in _elementInfos)
				for each (partName in _partNames)
					if ((partInfo.label.indexOf(partName) > -1) && (partInfo.subtype == type_cb.selectedItem.label)) {
						partInfos = this['_' + partName + "Infos"];
						partInfos.push(partInfo);
					}
			
			for each (partName in _partNames) {
				partInfos = this['_' + partName + "Infos"];
				
				if (partInfos.length > 0)
					partsToLoad++;
				
				this[partName + "_stpr"].minimum = 0;
				this[partName + "_stpr"].maximum = partInfos.length - 1;
			}
		}
		
		private function updateTextureInfoArray():void {
			var textureInfos:Array;
			var partName:String;
			
			for each (partName in _partNames) {
				textureInfos = this['_' + partName + "TextureInfos"];
				textureInfos.splice(0);
			}
			
			for each (var textureInfo:Object in _textureInfos)
				for each (partName in _partNames)
					if ((textureInfo.label.indexOf(type_cb.selectedItem.label) > -1) && (textureInfo.part_name == partName) && (textureInfo.part_variation == this[partName + "_stpr"].value + 1)) {
						textureInfos = this['_' + partName + "TextureInfos"];
						textureInfos.push(textureInfo);
					}
			
			for each (partName in _partNames) {
				textureInfos = this['_' + partName + "TextureInfos"];
				this[partName + "Texture_stpr"].minimum = 0;
				this[partName + "Texture_stpr"].maximum = (textureInfos.length / 3) - 1;
			}
		}
		
		private function fullUpdate():void {
			partsLoaded = 0;
			
			for each (var partName:String in _partNames) {
				var partInfos:Array = this['_' + partName + "Infos"];
				var partInfo:Object = partInfos[this[partName + "_stpr"].value];
				
				var textureInfos:Array = this['_' + partName + "TextureInfos"];
				var textureSet:Object = getTextureSetByTextureVariation(textureInfos, this[partName + "Texture_stpr"].value + 1);
				
				CharacterBuilder(parent).update(partName, partInfo, textureSet);
			}
		}
		
		private function onBodyColorChange(e:Event):void {
			fullUpdate();
			trace(bodyColor_cc.value);
		}
		
		private function catipaliseFirstLetter(string:String):String {
			return string.substring(0, 1).toUpperCase() + string.substr(1, string.length - 1);
		}
		
		override protected function createGUI():void {
			var longestTextWidth:Number = 90; // booo! magic number here :E
			
			var name_lbl:BuilderLabel = new BuilderLabel(_body, 10, 10, "Avatar name: ");
			name_lbl.width = longestTextWidth;
			name_lbl.textAlign = "right";
			name_ti = new InputText(_body, name_lbl.x + name_lbl.width + 5, name_lbl.y + 2);
			
			var type_lbl:BuilderLabel = new BuilderLabel(_body, name_lbl.x, name_ti.y + 30, "Character type: ");
			type_lbl.width = longestTextWidth;
			type_lbl.textAlign = "right";
			type_cb = new ComboBox(_body, type_lbl.x + type_lbl.width + 5, type_lbl.y);
			//type_cb.addEventListener(Event.SELECT, onTypeChange);
			
			var bodyColor_lbl:BuilderLabel = new BuilderLabel(_body, name_lbl.x, type_cb.y + 30, "Body color: ");
			bodyColor_lbl.width = longestTextWidth;
			bodyColor_lbl.textAlign = "right";
			bodyColor_cc = new ColorChooser(_body, bodyColor_lbl.x + bodyColor_lbl.width + 5, bodyColor_lbl.y, 0x000000, onBodyColorChange);
			bodyColor_cc.usePopup = true;
			
			var labelY:Number = type_cb.y + 60;
			
			for each (var partName:String in _partNames) {
				var lbl:BuilderLabel = new BuilderLabel(_body, name_lbl.x, labelY, catipaliseFirstLetter(partName) + ": ");
				lbl.width = longestTextWidth;
				lbl.textAlign = "right";
				
				this[partName + "_stpr"] = new MyStepper(_body, lbl.x + lbl.width + 5, lbl.y);
				this[partName + "_stpr"].changeSignal.add(onPartStepper);
				this[partName + "_stpr"].name = partName;
				
				this[partName + "Texture_stpr"] = new MyStepper(_body, lbl.x + 150, lbl.y + 5);
				MyStepper(this[partName + "Texture_stpr"]).scaleX = 0.7;
				MyStepper(this[partName + "Texture_stpr"]).scaleY = 0.7;
				this[partName + "Texture_stpr"].changeSignal.add(onTextureStepper);
				this[partName + "Texture_stpr"].name = partName;
				
				labelY += 30;
			}
			
			var animation_lbl:BuilderLabel = new BuilderLabel(_body, name_lbl.x, 290, "Animation: ");
			animation_lbl.width = longestTextWidth;
			animation_lbl.textAlign = "right";
			animation_cb = new ComboBox(_body, animation_lbl.x + animation_lbl.width, animation_lbl.y);
			
			var save_btn:PushButton = new PushButton(_body, _width * 0.5, 320, "Save", onSaveBtn);
			save_btn.x -= save_btn.width * 0.5;
		}
		
		private function onTypeChange(e:Event):void {
			//trace("onTypeChange");
			
			CharacterBuilder(parent).character.removeEventListener(Pivot3D.ENTER_FRAME_EVENT, onSkinEnterFrame);
			CharacterBuilder(parent).world.scene.removeChild(CharacterBuilder(parent).character);
			CharacterBuilder(parent).character = new Pivot3D("character");
			CharacterBuilder(parent).world.scene.addChild(CharacterBuilder(parent).character);
			
			updatePartInfoArray();
			updateTextureInfoArray();
			fullUpdate();
		}
		
		private function onPartStepper(stepper:MyStepper):void {
			updateTextureInfoArray();
			fullUpdate();
		}
		
		private function onTextureStepper(stepper:MyStepper):void {
			fullUpdate();
		}
		
		private function getTextureSetByTextureVariation(textureInfos:Array, texture_variation:int):Object {
			var textureSet:Object = {};
			for each (var textureInfo:Object in textureInfos)
				if (textureInfo.texture_variation == texture_variation)
					textureSet[textureInfo.type] = textureInfo;
			return textureSet;
		}
		
		public function expandTextureInfo(textureInfo:Object):void {
			var label:String = textureInfo.label.replace(".png", "");
			var splitLabel:Array = label.split("_");
			textureInfo.part_name = splitLabel[2];
			textureInfo.part_variation = splitLabel[3];
			textureInfo.texture_variation = splitLabel[4];
		}
		
		private function getElementInfoByLabel(label:String):Object {
			for each (var element:Object in _elementInfos)
				if (element.label == label)
					return element;
			return null;
		}
		
		public function loadAnimations():void {
			animation_cb.removeEventListener(Event.CHANGE, onAnimationChange);
			
			var amfphp:AMFPHP = new AMFPHP(onAnimations);
			amfphp.xcall("dm.Skin3D.getAnimationsByCharacterType", type_cb.selectedItem.id);
		}
		
		private function onAnimations(response:Object):void {
			_currentAnimations = response as Array;
			animation_cb.items = _currentAnimations;
			animation_cb.selectedIndex = 0;
			animation_cb.addEventListener(Event.SELECT, onAnimationChange);
			
			var animationInfo:Object = getElementInfoByLabel(type_cb.selectedItem.label + "_animation");
			if (animationInfo != null) {
				var animation:Flare3DLoader = CharacterBuilder(parent).world.getModel(animationInfo) as Flare3DLoader;
				if (animation.bytesLoaded > 0) {
					Pivot3DUtils.appendAnimation(CharacterBuilder(parent).character, animation);
					playAnimation(CharacterBuilder(parent).character, animation_cb.selectedItem.label);
					trace("Animation loaded");
				} else {
					animation.addEventListener(Event.COMPLETE, onAnimationLoad);
				}
			} else
				trace("Animation not found");
		}
		
		private function onAnimationLoad(e:Event):void {
			trace("onAnimationLoad()");
			e.currentTarget.removeEventListener(Event.COMPLETE, onAnimationLoad);
			Pivot3DUtils.appendAnimation(CharacterBuilder(parent).character, e.currentTarget as Pivot3D);
			playAnimation(CharacterBuilder(parent).character, animation_cb.selectedItem.label);
		}
		
		private function onAnimationChange(e:Event):void {
			playAnimation(CharacterBuilder(parent).character, animation_cb.selectedItem.label);
		}
		
		private var _curAnimation:Object;
		
		public function playAnimation(skin:Pivot3D, animationLabel:String):void {
			trace("playAnimation(): " + animationLabel);
			skin.frameSpeed = 0.4;
			
			Utils.clearNonMesh(skin);
			
			_curAnimation = getAnimationByLabel(animationLabel);
			if (_curAnimation != null) {
				skin.removeEventListener(Pivot3D.ENTER_FRAME_EVENT, onSkinEnterFrame);
				skin.addEventListener(Pivot3D.ENTER_FRAME_EVENT, onSkinEnterFrame);
				skin.gotoAndPlay(int(_curAnimation.start_frame), 20);
			} else
				trace("Animation not found");
		}
		
		private function onSkinEnterFrame(e:Event):void {
			var skin:Pivot3D = e.currentTarget as Pivot3D;
			if (Math.floor(skin.children[0].children[0].currentFrame) == int(_curAnimation.end_frame))
				skin.gotoAndPlay(int(_curAnimation.start_frame));
		}
		
		private function getAnimationByLabel(label:String):Object {
			for each (var animation:Object in _currentAnimations)
				if (animation.label == label)
					return animation;
			return null;
		}
		
		private function onSaveBtn(e:MouseEvent):void {
			if (name_ti.text == "") {
				WindowManager.instance.dispatchMessage(_("Enter avatar name"));
				return;
			}
			
			var skin3d:Object = {label: name_ti.text, type: 3, subtype: type_cb.selectedItem.id};
			
			var elements:Array = new Array();
			for each (var part:Pivot3D in CharacterBuilder(parent).character.children) {
				var partInfo:Object = CharacterBuilder(parent).partsToPartInfos[part];
				var element:Object = {id: partInfo.id, x: 0, y: 0, z: 0};
				
				var textures:Array = new Array();
				for each (var textureInfo:Object in CharacterBuilder(parent).partsToTextureSets[part])
					textures.push({id: textureInfo.id, part_name: part.name});
				
				element.textures = textures;
				element.color = bodyColor_cc.value;
				
				elements.push(element);
			}
			
			var animationInfo:Object = getElementInfoByLabel(type_cb.selectedItem.label + "_animation");
			elements.push({id: animationInfo.id, x: 0, y: 0, z: 0});
			
			skin3d.elements = elements;
			
			var amfphp:AMFPHP = new AMFPHP(onSkinSave);
			amfphp.xcall("dm.Avatar.saveAvatar", MyManager.instance.id, name_ti.text, skin3d, type_cb.selectedItem.id);
			
			function onSkinSave(response:Object):void {
				trace(response);
				if (response.type != "error") {
					CharacterBuilder(parent).avatarSavedSignal.dispatch(response);
				} else {
					WindowManager.instance.dispatchMessage(_(response.message));
				}
			}
		}
	
	}

}