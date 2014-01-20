package dm.builder.interfaces.tools.solidobjecteditor {
	
	import com.bit101.components.ComboBox;
	import com.bit101.components.InputText;
	import com.bit101.components.PushButton;
	import dm.builder.interfaces.BuilderLabel;
	import dm.builder.interfaces.BuilderWindow;
	import dm.builder.interfaces.tools.texturemanager.TextureManager;
	import dm.builder.interfaces.tools.texturemanager.TextureProperties;
	import dm.builder.interfaces.WindowManager;
	import flare.core.Mesh3D;
	import flare.core.Pivot3D;
	import flare.materials.filters.TextureFilter;
	import flare.materials.Shader3D;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import utils.AMFPHP;
	import utils.Utils;
	
	/**
	 * ...
	 * @author
	 */
	public class SolidObjectEditor extends BuilderWindow {
		
		private const VIEWPORT_WIDTH:Number = 300;
		
		private var _world:SolidObjectEditorWorld;
		private var _textureManager:TextureManager
		
		private var _currentObject:Pivot3D;
		public var currentObjectInfo:Object;
		
		private var part_cb:ComboBox;
		private var label_ti:InputText;
		
		public function SolidObjectEditor(parent:DisplayObjectContainer) {
			movable = this.isDraggable();
			super(parent, "Solid object editor", 500, 500);
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function draw (  ) : void {
			super.draw();
			redrawBody();
		}
		
		
		/**
		 *	@inheritDoc
		 */
		public override function initialize (  ) : void {
			createDummy();
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function isDraggable (  ) : Boolean {
			return false;
		}
		
		private function redrawBody():void {
			_body.graphics.clear();
			_body.graphics.lineStyle(1, 0xCCCCCC);
			_body.graphics.drawRect(0, 0, _width, bodyHeight);
			
			_body.graphics.beginFill(0x464646);
			_body.graphics.drawRect(VIEWPORT_WIDTH, 0, _width - VIEWPORT_WIDTH, bodyHeight);
			_body.graphics.endFill();
		}
		
		override protected function createGUI():void {
			_world = new SolidObjectEditorWorld(_body, VIEWPORT_WIDTH, bodyHeight, x, y + HEADER_HEIGTH + 2);
			//_world.redrawLines();
			
			var label_lbl:BuilderLabel = new BuilderLabel(_body, VIEWPORT_WIDTH + 10, 10, "Label: ");
			label_ti = new InputText(_body, label_lbl.x + label_lbl.textWidth + 5, label_lbl.y);
			
			var textures_lbl:BuilderLabel = new BuilderLabel(_body, label_lbl.x, label_lbl.y + 30, "Textures: ");
			var selectPart_lbl:BuilderLabel = new BuilderLabel(_body, textures_lbl.x, textures_lbl.y + 20, "Object parts: ");
			part_cb = new ComboBox(_body, selectPart_lbl.x, selectPart_lbl.y + 20);
			var selectTexture_btn:PushButton = new PushButton(_body, part_cb.x + part_cb.width + 10, part_cb.y, "Set texture", onSetTextureBtn);
			selectTexture_btn.width = 70;
			
			var textureProps_btn:PushButton = new PushButton(_body, selectPart_lbl.x, part_cb.y + 30, "Texture properties", onTexturePropsBtn);
			
			var save_btn:PushButton = new PushButton(_body, selectPart_lbl.x, part_cb.y + 100, "Save", onSaveBtn);
		}
		
		private function onTexturePropsBtn(e:MouseEvent):void {
			new TextureProperties(parent, _currentObject.children[0].getChildByName(part_cb.selectedItem.label));
		}
		
		private function onSaveBtn(e:MouseEvent):void {
			if (label_ti.text == "") {
				WindowManager.instance.dispatchMessage("Enter object label.");
				return;
			}
			
			var skin:Object = new Object();
			skin.label = label_ti.text;
			skin.type = 2;
			var elements:Array = new Array();
			for each (var element:Object in currentObjectInfo.elements) {
				var elementToSave:Object = {id: element.id, x: element.x, y: element.y, z: element.z};
				var textures:Array = new Array();
				for each (var part:Object in part_cb.items)
					if (part.hasOwnProperty("textureInfo"))
						textures.push({id: part.textureInfo.id, part_name: part.part.name});
				elementToSave.textures = textures;
				elements.push(elementToSave);
			}
			skin.elements = elements;
			
			var amfphp:AMFPHP = new AMFPHP(onSkinSave);
			amfphp.xcall("dm.Skin3D.saveSkin", skin);
			function onSkinSave(response:Object):void {
				trace(response);
				WindowManager.instance.dispatchMessage("Objektas sekmingai issaugotas.");
				destroy();
			}
		}
		
		private function onSetTextureBtn(e:MouseEvent):void {
			_textureManager = new TextureManager(parent, false);
			_textureManager.textureSelectedSignal.add(onTextureSelected);
		}
		
		private function onTextureSelected(textureInfo:Object, textureFilter:TextureFilter):void {
			//_textureManager.destroy();
			
			part_cb.selectedItem.textureInfo = textureInfo;
			trace(part_cb.selectedItem.textureInfo);
			
			var material:Shader3D = new Shader3D("texture");
			material.filters = [textureFilter];
			
			part_cb.selectedItem.part.setMaterial(material);
		}
		
		override protected function createDummy():void {
			super.createDummy();
			var selectSolidObject:SelectSolidObject = new SelectSolidObject(_dummy);
			selectSolidObject.hideButtons();
			selectSolidObject.movable = false;
			selectSolidObject.x = _width * 0.5 - selectSolidObject.width * 0.5;
			selectSolidObject.y = _width * 0.5 - selectSolidObject.height * 0.5;
		}
		
		public function set currentObject(value:Pivot3D):void {
			_currentObject = value;
			
			fillPartList(_currentObject);

			//part_cb.items = currentObjectInfo.elements[0].parts;
			part_cb.selectedIndex = 0;
			_world.scene.addChild(value);
			destroyDummy();
		}
		
		private function fillPartList(pivot3d:Pivot3D):void {			
			for each (var child:Pivot3D in pivot3d.children) {
				if (child is Mesh3D) {
					var label:String = (child.name.indexOf(":") > -1) ? child.name.split(":")[1] : child.name;
					part_cb.addItem( { label: label, part: child } );
				}
				else if (child.children.length > 0)
					fillPartList(child);
			}
		}
		
		public function get world():SolidObjectEditorWorld {
			return _world;
		}
		
		override public function destroy():void {
			_world.destroy();
			super.destroy();
		}
	}

}