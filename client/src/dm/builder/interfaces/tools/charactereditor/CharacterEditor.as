package dm.builder.interfaces.tools.charactereditor {
	import com.bit101.components.ComboBox;
	import com.bit101.components.InputText;
	import com.bit101.components.PushButton;
	import dm.builder.Builder;
	import dm.builder.interfaces.BuilderLabel;
	import dm.builder.interfaces.BuilderWindow;
	import dm.builder.interfaces.WindowManager;
	import flare.core.Pivot3D;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import utils.AMFPHP;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class CharacterEditor extends BuilderWindow {
		
		private var _world:CharacterEditorWorld;
		
		private const VIEWPORT_WIDTH:Number = 300;
		
		private var _currentType:String;
		private var type_cb:ComboBox;
		private var name_ti:InputText;
		private var _elementInfos:Array;
		
		private var _partNames:Array = ["accessories", "hair", "head", "top", "bottom", "shoes"];
		
		private var _curAccessories:int = 1;
		private var _curHair:int = 1;
		private var _curHead:int = 1;
		private var _curTop:int = 1;
		private var _curBottom:int = 1;
		private var _curShoes:int = 1;
		
		public function CharacterEditor(parent:DisplayObjectContainer) {
			super(parent, "Character builder", 550, 500);
			movable = false;
			
			redrawBody();
			
			preloadData();
		}
		
		private function preloadData():void {
			createDummy();
			var loading_lbl:BuilderLabel = new BuilderLabel(_dummy, 50, 50, "Loading...");
			
			var amfphp:AMFPHP = new AMFPHP(onElements);
			amfphp.xcall("dm.Skin3D.getAllCharacters");
			
			function onElements(response:Object):void {
				_world.scene.library.addEventListener(Event.COMPLETE, onModelsLoad);
				_world.loadModels(response as Array);
				
				_elementInfos = response as Array;
				
				for each (var element:Object in response)
					if (type_cb.items.indexOf(element.subtype) < 0)
						type_cb.addItem(element.subtype);
				type_cb.selectedIndex = 0;
				_currentType = String(type_cb.selectedItem);
			}
			
			function onModelsLoad(e:Event):void {
				_world.scene.library.removeEventListener(Event.COMPLETE, onModelsLoad);
				destroyDummy();
			}
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
			_world = new CharacterEditorWorld(_body, VIEWPORT_WIDTH, bodyHeight, x, y + HEADER_HEIGTH + 2);
			
			var name_lbl:BuilderLabel = new BuilderLabel(_body, 310, 10, "Preset name: ");
			name_ti = new InputText(_body, name_lbl.x + name_lbl.textWidth + 5, name_lbl.y);
			
			var type_lbl:BuilderLabel = new BuilderLabel(_body, name_lbl.x, name_ti.y + 30, "Character type: ");
			type_cb = new ComboBox(_body, type_lbl.x + type_lbl.textWidth + 5, type_lbl.y);
			type_cb.addEventListener(Event.SELECT, onTypeChange);
			
			
			var labelY:Number = type_cb.y + 40;
			var longestTextWidth:Number = 72; // booo! magic number here :E
			for each (var part:String in _partNames) {
				var lbl:BuilderLabel = new BuilderLabel(_body, name_lbl.x, labelY, catipaliseFirstLetter(part) + ": ");
				lbl.width = longestTextWidth;
				lbl.textAlign = "right";
				
				var prev_btn:PushButton = new PushButton(_body, lbl.x + lbl.width + 5, lbl.y, "<", onPrevBtn);
				prev_btn.width = 20;
				prev_btn.name = part;
				
				var next_btn:PushButton = new PushButton(_body, prev_btn.x + prev_btn.width + 5, lbl.y, ">", onNextBtn);
				next_btn.width = 20;
				next_btn.name = part;
				
				labelY += 30;
			}
			
			var save_btn:PushButton = new PushButton(_body, name_lbl.x, 300, "Save", onSaveBtn);
		}
		
		private function onNextBtn(e:MouseEvent):void {
			var part:String = e.currentTarget.name;
			this["_cur" + catipaliseFirstLetter(part)]++;
			var partName:String = type_cb.selectedItem + "_" + part + "_" + this["_cur" + catipaliseFirstLetter(part)];
			if (_world.scene.library.getItem(partName) == null)
				this["_cur" + catipaliseFirstLetter(part)]--;
			_world.update(currentParts);
		}
		
		private function onPrevBtn(e:MouseEvent):void {
			var part:String = e.currentTarget.name;
			this["_cur" + catipaliseFirstLetter(part)]--;
			var partName:String = type_cb.selectedItem + "_" + part + "_" + this["_cur" + catipaliseFirstLetter(part)];
			if (_world.scene.library.getItem(partName) == null)
				this["_cur" + catipaliseFirstLetter(part)]++;
			_world.update(currentParts);
		}
		
		private function onTypeChange(e:Event):void {
			_currentType = String(type_cb.selectedItem);
			_world.update(currentParts);
		}
		
		private function onSaveBtn(e:MouseEvent):void {
			var skin:Object = new Object();
			skin.label = name_ti.text;
			skin.type = 3;
			var elements:Array = new Array();
			
			/* add elements */
			for each (var partName:String in currentParts)
				elements.push( { id: getElementIdByLabel(partName), x: 0, y: 0, z: 0 } );
				
			trace(elements);
			
			skin.elements = elements;
			
			var amfphp:AMFPHP = new AMFPHP(onSkinSave);
			amfphp.xcall("dm.Skin3D.saveSkin", skin);
			function onSkinSave(response:Object):void {
				WindowManager.instance.dispatchMessage("Objektas sekmingai issaugotas.");
				destroy();
			}
		}
		
		private function getElementIdByLabel(label:String):int {
			for each (var element:Object in _elementInfos)
				if (element.label == label)
					return element.id;
			return 0;
		}
		
		private function catipaliseFirstLetter(string:String):String {
			return string.substring(0, 1).toUpperCase() + string.substr(1, string.length-1);
		}
		
		private function get currentParts():Array {
			var parts:Array = new Array();
			for each (var partName:String in _partNames) {
				parts.push(type_cb.selectedItem + "_" + partName + "_" + this["_cur" + catipaliseFirstLetter(partName)]);
			}
			return parts;
		}
		
		override public function destroy():void {
			super.destroy();
			_world.scene.dispose();
		}
	
	}
}