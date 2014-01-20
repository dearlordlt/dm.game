package dm.builder.interfaces.tools.npceditor {
	
	import com.bit101.components.ComboBox;
	import com.bit101.components.InputText;
	import com.bit101.components.List;
	import com.bit101.components.PushButton;
	import dm.builder.interfaces.BuilderLabel;
	import dm.builder.interfaces.BuilderWindow;
	import dm.builder.interfaces.WindowManager;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import net.richardlord.ash.signals.Signal1;
	import utils.AMFPHP;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class NewCommand extends BuilderWindow {
		
		public var commandAddedSignal:Signal1 = new Signal1(Object);
		
		private var command_cb:ComboBox;
		private var param_list:List;
		private var paramValue_ti:InputText;
		
		public function NewCommand(parent:DisplayObjectContainer) {
			super(parent, "New command", 210, 150);
			
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
			
			var paramValue_lbl:BuilderLabel = new BuilderLabel(_body, param_list.x + param_list.width + 10, params_lbl.y, "Param value:");
			paramValue_ti = new InputText(_body, paramValue_lbl.x, paramValue_lbl.y + 20, "", onParamChange);
			paramValue_ti.width -= 20;
			
			var add_btn:PushButton = new PushButton(_body, _width * 0.5, param_list.y + param_list.height + 10, "Add", onAddBtn);
			add_btn.x -= add_btn.width * 0.5;
		}
		
		private function onAddBtn(e:MouseEvent):void {
			for each (var param:Object in command_cb.selectedItem.params)
				if (param.value == undefined || param.value == "") {
					WindowManager.instance.dispatchMessage("Enter values for all parameters.");
					return;
				}
			commandAddedSignal.dispatch(command_cb.selectedItem);
			commandAddedSignal.removeAll();
			destroy();
		}

		private function onCommandSelect(e:Event):void {
			param_list.items = command_cb.selectedItem.params as Array;
			param_list.selectedIndex = 0;
		}
		
		private function onParamChange(e:Event):void {
			param_list.selectedItem.value = paramValue_ti.text;
		}
		
		private function onParamSelect(e:Event):void {
			paramValue_ti.text = param_list.selectedItem.value;
		}
	
	}

}