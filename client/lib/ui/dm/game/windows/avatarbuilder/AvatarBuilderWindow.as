package dm.game.windows.avatarbuilder {
	
	import dm.builder.interfaces.map.World3D;
	import dm.game.characterbuilder.CharacterBuilder;
	import dm.game.Main;
	import dm.game.windows.DmWindow;
	import dm.game.windows.ui.stepper.SimpleStepper;
	import fl.controls.Button;
	import fl.controls.ColorPicker;
	import fl.controls.ComboBox;
	import fl.controls.Label;
	import fl.controls.TextInput;
	import fl.data.DataProvider;
	import fl.events.ColorPickerEvent;
	import flash.geom.Point;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Dictionary;
	import net.richardlord.ash.signals.Signal1;
	import org.as3commons.lang.builder.ToStringBuilder;
	
// import com.bit101.components.ColorChooser;
// import com.bit101.components.ComboBox;
// import com.bit101.components.HSlider;
// import com.bit101.components.InputText;
// import com.bit101.components.NumericStepper;
// import com.bit101.components.PushButton;
	
// import dm.builder.interfaces.BuilderLabel;
// import dm.builder.interfaces.BuilderWindow;
	import dm.builder.interfaces.map.World3D;
	
	import dm.game.windows.ui.stepper.SimpleStepper;
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
	 * Avatar character builder
	 *
	 * @version $Id: AvatarBuilderWindow.as 203 2013-08-15 06:12:04Z zenia.sorocan $
	 */
	public class AvatarBuilderWindow extends DmWindow {
		
		/** Label width */
		private static const LABEL_WIDTH:Number = 155;
		
		/** label x */
		private static const LABEL_X:Number = 15;
		
		/** Controls X */
		private static const CONTROLS_X:Number = LABEL_WIDTH + LABEL_X + 12;
		
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
		
		/** Name text input */
		public var nameTextInputDO:TextInput;
		
		/** Type combo box */
		public var typeComboBoxDO:ComboBox;
		
		/** Body color picker */
		public var bodyColorPickerDO:ColorPicker;
		
		/** Save button */
		public var saveButtonDO:Button;
		
		/** Animation combo box */
		public var animationComboBoxDO:ComboBox;
		
		/** Intro text label */
		public var introTextLabelDO:Label;
		
		private var accessories_stpr:SimpleStepper;
		private var hair_stpr:SimpleStepper;
		private var head_stpr:SimpleStepper;
		private var top_stpr:SimpleStepper;
		private var bottom_stpr:SimpleStepper;
		private var shoes_stpr:SimpleStepper;
		
		private var accessoriesTexture_stpr:SimpleStepper;
		private var hairTexture_stpr:SimpleStepper;
		private var headTexture_stpr:SimpleStepper;
		private var topTexture_stpr:SimpleStepper;
		private var bottomTexture_stpr:SimpleStepper;
		private var shoesTexture_stpr:SimpleStepper;
		
		/**
		 * Class constructor
		 */
		public function AvatarBuilderWindow(parent:CharacterBuilder) {
			super(parent, _("Character builder"));
			this._world = CharacterBuilder(parent).world;
			this.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function initialize():void {
			
			this.saveButtonDO.addEventListener(MouseEvent.CLICK, this.onSaveBtn);
			
			//type_cb.addEventListener(Event.SELECT, onTypeChange);
			
			this.bodyColorPickerDO.addEventListener(ColorPickerEvent.CHANGE, this.onBodyColorChange);
			
			var labelY:Number = this.animationComboBoxDO.y + 31; // typeComboBoxDO.y + 60;
			
			var labelDO:Label;
			var partStepper:SimpleStepper;
			var textureStepper:SimpleStepper;
			
			for each (var partName:String in this._partNames) {
				
				// label
				labelDO = new Label();
				this.addChild(labelDO);
				labelDO.x = LABEL_X;
				labelDO.y = labelY;
				labelDO.width = LABEL_WIDTH;
				labelDO.autoSize = TextFieldAutoSize.RIGHT;
				labelDO.text = _(catipaliseFirstLetter(partName));
				
				// part stepper
				partStepper = new SimpleStepper();
				partStepper.x = CONTROLS_X;
				partStepper.y = labelY;
				
				this.addChild(partStepper);
				
				partStepper.changeSignal.add(this.onPartStepper);
				partStepper.name = partName;
				this[partName + "_stpr"] = partStepper;
				
				// texture stepper
				textureStepper = new SimpleStepper(); // _body, labelDO.x + 150, labelDO.y + 5 );
				this.addChild(textureStepper);
				textureStepper.x = CONTROLS_X + 65;
				textureStepper.y = labelY + 5;
				
				textureStepper.scaleX = textureStepper.scaleY = 0.7;
				textureStepper.changeSignal.add(this.onTextureStepper);
				textureStepper.name = partName;
				this[partName + "Texture_stpr"] = textureStepper;
				
				labelY += 32;
			}
			
			// correct save button position
			
			this.saveButtonDO.y = labelY;
			
			this.introTextLabelDO.y = labelY + 32;
			
			var specLocation:String = "";
			
			if (Main.getInstance().getCurrentRoomName() == "vdk") {
				specLocation = "VDK"
			}
			
			this.introTextLabelDO.text
				
				= "Sveiki prisijungę prie " + specLocation + " simuliacinio žaidimo! " + "\n" +
				
				"Susimodeliuokite personažą kuriuo žaisite ir spauskite <Išsaugoti>. " + "\n" +
				
				"Personažas žaidime valdomas WASD mygtukų pagalba:" + "\n" +
				
				"W - į priekį" + "\n" +
				
				"A - į kairę" + "\n" +
				
				"S - į dešinę" + "\n" +
				
				"D - atgal" + "\n" +
				
				"Susikūrę ir išsaugoję personažą pateksite į žaidimą. " + "\n" +
				
				"Tolimesnes instrukcijas gausite artimiausio pastato priimamajame. " + "\n" +
				
				"Sėkmės!";
			
			this.redraw();
			
			// start data loading
			this.preloadData();
		
		}
		
		/**
		 * Prevent 3d worl from moving
		 */
		private function onMouseDown(e:MouseEvent):void {
			e.stopImmediatePropagation();
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function getInitialPosition():Point {
			return new Point(this.stage.stageWidth - this.width - 10, 20);
		}
		
		private function preloadData():void {
			new AMFPHP(onCharacterTypes).xcall("dm.Builder.getCharacterTypes", MyManager.instance.id);
		}
		
		private function onCharacterTypes(response:Object):void {
			typeComboBoxDO.dataProvider = new DataProvider(response as Array);
			typeComboBoxDO.selectedIndex = 0;
			
			new AMFPHP(onElements).xcall("dm.Skin3D.getAllCharacters");
		}
		
		private function onElements(response:Object):void {
			_elementInfos = response as Array;
			
			new AMFPHP(onTextures).xcall("dm.Skin3D.getAllCharacterTextures");
			
			updatePartInfoArray();
		}
		
		private function onTextures(response:Array):void {
			_textureInfos = response as Array;
			
			for each (var textureInfo:Object in _textureInfos)
				expandTextureInfo(textureInfo);
			
			updateTextureInfoArray();
			
			typeComboBoxDO.addEventListener(Event.CHANGE, this.onTypeChange);
			
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
					if ((partInfo.label.indexOf(partName) > -1) && (partInfo.subtype == typeComboBoxDO.selectedItem.label)) {
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
					if ((textureInfo.label.indexOf(typeComboBoxDO.selectedItem.label) > -1) && (textureInfo.part_name == partName) && (textureInfo.part_variation == this[partName + "_stpr"].value + 1)) {
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
		}
		
		private function catipaliseFirstLetter(string:String):String {
			return string.substring(0, 1).toUpperCase() + string.substr(1, string.length - 1);
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
		
		private function onPartStepper(stepper:SimpleStepper):void {
			updateTextureInfoArray();
			fullUpdate();
		}
		
		private function onTextureStepper(stepper:SimpleStepper):void {
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
			animationComboBoxDO.removeEventListener(Event.CHANGE, onAnimationChange);
			
			var amfphp:AMFPHP = new AMFPHP(onAnimations);
			amfphp.xcall("dm.Skin3D.getAnimationsByCharacterType", typeComboBoxDO.selectedItem.id);
		}
		
		private function onAnimations(response:Object):void {
			_currentAnimations = response as Array;
			animationComboBoxDO.dataProvider = new DataProvider(_currentAnimations);
			animationComboBoxDO.selectedIndex = 0;
			animationComboBoxDO.addEventListener(Event.SELECT, onAnimationChange);
			
			var animationInfo:Object = getElementInfoByLabel(typeComboBoxDO.selectedItem.label + "_animation");
			if (animationInfo != null) {
				var animation:Flare3DLoader = CharacterBuilder(parent).world.getModel(animationInfo) as Flare3DLoader;
				if (animation.bytesLoaded > 0) {
					Pivot3DUtils.appendAnimation(CharacterBuilder(parent).character, animation);
					playAnimation(CharacterBuilder(parent).character, animationComboBoxDO.selectedItem.label);
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
			playAnimation(CharacterBuilder(parent).character, animationComboBoxDO.selectedItem.label);
		}
		
		private function onAnimationChange(e:Event):void {
			playAnimation(CharacterBuilder(parent).character, animationComboBoxDO.selectedItem.label);
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
			if (nameTextInputDO.text == "") {
				WindowManager.instance.dispatchMessage(_("Enter avatar name"));
				return;
			}
			
			var skin3d:Object = {label: nameTextInputDO.text, type: 3, subtype: typeComboBoxDO.selectedItem.id};
			
			var elements:Array = new Array();
			for each (var part:Pivot3D in CharacterBuilder(parent).character.children) {
				var partInfo:Object = CharacterBuilder(parent).partsToPartInfos[part];
				var element:Object = {id: partInfo.id, x: 0, y: 0, z: 0};
				
				var textures:Array = new Array();
				for each (var textureInfo:Object in CharacterBuilder(parent).partsToTextureSets[part])
					textures.push({id: textureInfo.id, part_name: part.name});
				
				element.textures = textures;
				element.color = bodyColorPickerDO.selectedColor;
				
				elements.push(element);
			}
			
			var animationInfo:Object = getElementInfoByLabel(typeComboBoxDO.selectedItem.label + "_animation");
			elements.push({id: animationInfo.id, x: 0, y: 0, z: 0});
			
			skin3d.elements = elements;
			
			var amfphp:AMFPHP = new AMFPHP(onSkinSave);
			amfphp.xcall("dm.Avatar.saveAvatar", MyManager.instance.id, nameTextInputDO.text, skin3d, typeComboBoxDO.selectedItem.id);
			
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