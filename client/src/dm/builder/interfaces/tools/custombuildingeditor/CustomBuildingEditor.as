package dm.builder.interfaces.tools.custombuildingeditor {
	
	import com.bit101.components.ComboBox;
	import com.bit101.components.InputText;
	import com.bit101.components.NumericStepper;
	import com.bit101.components.PushButton;
	import dm.builder.interfaces.BuilderLabel;
	import dm.builder.interfaces.BuilderWindow;
	import dm.builder.interfaces.WindowManager;
	import flare.core.Pivot3D;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import utils.AMFPHP;
	
	/**
	 * ...
	 * @author
	 */
	public class CustomBuildingEditor extends BuilderWindow {
		
		private var _world:CustomBuildingEditorWorld;
		
		private const VIEWPORT_WIDTH:Number = 300;
		
		private var _currentType:String;
		private var type_cb:ComboBox;
		private var floors_stepper:NumericStepper;
		private var name_ti:InputText;
		
		private var _elementInfos:Array;
		
		public function CustomBuildingEditor(parent:DisplayObjectContainer) {
			super(parent, _("Building builder"), 550, 500);
			movable = false;
			
			redrawBody();
			
			preloadData();
		}
		
		private function preloadData():void {
			var dummy:Sprite = new Sprite();
			_body.addChild(dummy);
			dummy.graphics.beginFill(0x464646);
			dummy.graphics.drawRect(1, 1, 548, 498);
			var loading_lbl:BuilderLabel = new BuilderLabel(dummy, 50, 50, _("Loading..."));
			
			var amfphp:AMFPHP = new AMFPHP(onElements);
			amfphp.xcall("dm.Skin3D.getAllCustomBuildings");
			
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
				_body.removeChild(dummy);
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
			_world = new CustomBuildingEditorWorld(_body, VIEWPORT_WIDTH, bodyHeight, x, y + HEADER_HEIGTH + 2);
			
			var name_lbl:BuilderLabel = new BuilderLabel(_body, 310, 10, __("#{Preset name}: "));
			name_ti = new InputText(_body, name_lbl.x + name_lbl.textWidth + 5, name_lbl.y);
			
			var type_lbl:BuilderLabel = new BuilderLabel(_body, name_lbl.x, name_ti.y + 30, __("#{Building type}: "));
			type_cb = new ComboBox(_body, type_lbl.x + type_lbl.textWidth + 5, type_lbl.y);
			type_cb.addEventListener(Event.SELECT, onTypeChange);
			
			var floors_lbl:BuilderLabel = new BuilderLabel(_body, name_lbl.x, type_cb.y + 30, __("#{Floors}: "));
			floors_stepper = new NumericStepper(_body, floors_lbl.x + floors_lbl.textWidth + 5, floors_lbl.y, onFloorStepper);
			floors_stepper.minimum = 1;
			floors_stepper.maximum = 164;
			
			var save_btn:PushButton = new PushButton(_body, name_lbl.x, 100, _("Save"), onSaveBtn);
		
			//var load_btn:PushButton = new PushButton(_body, floors_lbl.x, floors_lbl.y + 30, "Load", onLoadBtn);
		}
		
		private function onTypeChange(e:Event):void {
			_currentType = String(type_cb.selectedItem);
			_world.update(_currentType, floors_stepper.value);
		}
		
		/*
		   private function onLoadBtn(e:MouseEvent):void {
		   var amfphp:AMFPHP = new AMFPHP(onBuilding);
		   amfphp.xcall("dm.Skin3D.getSkinById", 1);
		   }
		
		   private function onBuilding(response:Object):void {
		   trace(response.label);
		   _world.loadBuilding(response);
		   }
		 */
		
		private function onFloorStepper(e:Event):void {
			_world.update(_currentType, floors_stepper.value);
		}
		
		private function onSaveBtn(e:MouseEvent):void {
			var skin:Object = new Object();
			skin.label = name_ti.text;
			skin.type = 1;
			var elements:Array = new Array();
			for each (var floor:Pivot3D in _world.building.children) {
				var element:Object = {id: getElementIdByLabel(floor.name), x: floor.x, y: floor.y, z: floor.z};
				element.textures = [];
				elements.push(element);
			}
			skin.elements = elements;
			
			var amfphp:AMFPHP = new AMFPHP(onSkinSave);
			amfphp.xcall("dm.Skin3D.saveSkin", skin);
			function onSkinSave(response:Object):void {
				WindowManager.instance.dispatchMessage(_("Object successfuly saved."));
				destroy();
			}
		}
		
		private function getElementIdByLabel(label:String):int {
			for each (var element:Object in _elementInfos)
				if (element.label == label)
					return element.id;
			return 0;
		}
		
		override public function destroy():void {
			super.destroy();
			_world.scene.dispose();
		}
	
	}
}