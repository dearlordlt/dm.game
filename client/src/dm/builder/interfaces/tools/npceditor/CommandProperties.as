package dm.builder.interfaces.tools.npceditor {
	
	import com.bit101.components.ComboBox;
	import com.bit101.components.InputText;
	import com.bit101.components.List;
	import com.bit101.components.PushButton;
	import dm.game.systems.render.Animation;
	import dm.builder.interfaces.BuilderLabel;
	import dm.builder.interfaces.BuilderWindow;
	import dm.builder.interfaces.WindowManager;
	import dm.game.managers.AnimationManager;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import net.richardlord.ash.signals.Signal1;
	import utils.AMFPHP;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class CommandProperties extends BuilderWindow {
		
		public var commandAddedSignal:Signal1 = new Signal1(Object);
		
		private const PLAY_ANIMATION:String = "playAnimation";
		private const GO_TO:String = "goTo";
		
		private var command_cb:ComboBox;
		private var param_list:List;
		private var paramValue_ti:InputText;
		private var numbersOnly:RegExp = /^(-)?[0-9]*$/;
		private var positiveNumbersOnly:RegExp = /^[0-9]*$/;
		private var paramValue_cb:ComboBox;
		
		public function CommandProperties(parent:DisplayObjectContainer, initialData:Object = null) {
			super(parent, "Command properties", 210, 150);
			
			if (initialData) {
				command_cb.addItem(initialData);
				command_cb.selectedIndex = 0;
				command_cb.enabled = false;
				return;
			}
			
			var amfphp:AMFPHP = new AMFPHP(onCommands);
			amfphp.xcall("dm.NPC.getAllCommandLabels");
		}
		
		private function onCommands(response:Object):void {
			command_cb.items = response as Array;
			command_cb.selectedIndex = 0;
		}
		
		override protected function createGUI():void {
			var command_lbl:BuilderLabel = new BuilderLabel(_body, 10, 10, "Command: ");
			command_cb = new ComboBox(_body, command_lbl.x + command_lbl.textWidth + 5, command_lbl.y);
			command_cb.addEventListener(Event.SELECT, onCommandSelect);
			var params_lbl:BuilderLabel = new BuilderLabel(_body, command_lbl.x, command_lbl.y + 30, "Params: ");
			params_lbl.width = _width - 10;
			param_list = new List(_body, params_lbl.x, params_lbl.y + 20);
			param_list.addEventListener(Event.SELECT, onParamSelect);
			param_list.height -= 50;
			
			// for text input params
			var paramValue_lbl:BuilderLabel = new BuilderLabel(_body, param_list.x + param_list.width + 10, params_lbl.y, "Param value:");
			paramValue_ti = new InputText(_body, paramValue_lbl.x, paramValue_lbl.y + 20, "", onParamValueChange);
			paramValue_ti.width -= 20;
			
			// for selectable params
			paramValue_cb = new ComboBox(_body, paramValue_lbl.x, paramValue_lbl.y + 20);
			paramValue_cb.addEventListener(Event.SELECT, onParamValueSelect);
			paramValue_cb.width -= 20;
			paramValue_cb.visible = false;
			
			var save_btn:PushButton = new PushButton(_body, _width * 0.5, param_list.y + param_list.height + 10, "Save", onSaveBtn);
			save_btn.x -= save_btn.width * 0.5;
		}
		
		private function onSaveBtn(e:MouseEvent):void {
			for each (var param:Object in command_cb.selectedItem.params) {
				if (param.value == undefined || param.value == "") {
					WindowManager.instance.dispatchMessage("Enter values for all parameters.");
					return;
				}
				
				switch (param.label) {
					case "x": 
					case "y": 
					case "z": 
						if (!numbersOnly.test(param.value)) {
							WindowManager.instance.dispatchMessage("'" + param.label + "' must be integer.");
							return;
						}
						break;
					case "duration": 
						if (!positiveNumbersOnly.test(param.value)) {
							WindowManager.instance.dispatchMessage("'" + param.label + "' must be positive integer.");
							return;
						}
						break;
				}
			}
			commandAddedSignal.dispatch(command_cb.selectedItem);
			commandAddedSignal.removeAll();
			destroy();
		}
		
		private function onCommandSelect(e:Event):void {
			param_list.items = command_cb.selectedItem.params as Array;
			param_list.selectedIndex = 0;
		}
		
		private function onParamValueChange(e:Event):void {
			param_list.selectedItem.value = paramValue_ti.text;
		}
		
		private function onParamValueSelect(e:Event):void {
			param_list.selectedItem.value = paramValue_cb.selectedItem;
		}
		
		private function onParamSelect(e:Event):void {
			if (command_cb.selectedItem.label == PLAY_ANIMATION) {
				paramValue_ti.visible = false;
				paramValue_cb.visible = true;
				paramValue_cb.items = getUniqueAnimations();				
				if (param_list.selectedItem.value)
					paramValue_cb.selectedIndex = paramValue_cb.items.indexOf(param_list.selectedItem.value);
				else
					paramValue_cb.selectedIndex = 0;
			}
			
			if (command_cb.selectedItem.label == "goTo") {
				paramValue_ti.visible = true;
				paramValue_cb.visible = false;
				paramValue_ti.text = param_list.selectedItem.value;
			}
			
			if (command_cb.selectedItem.label == "wait") {
				paramValue_ti.visible = true;
				paramValue_cb.visible = false;
				paramValue_ti.text = param_list.selectedItem.value;
			}
		}
		
		private function getUniqueAnimations():Array {
			var animations:Array = new Array();
			for each (var animation:Animation in AnimationManager.instance.animations)
				if (animations.indexOf(animation.label) < 0)
					animations.push(animation.label);
			trace(animations);
			return animations;
		}
	
	}

}