package dm.builder.interfaces {
	import com.bit101.components.ComboBox;
	import com.bit101.components.InputText;
	import com.bit101.components.List;
	import com.bit101.components.PushButton;
	import dm.builder.interfaces.BuilderWindow;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import net.richardlord.ash.signals.Signal1;
	import utils.AMFPHP;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class FunctionProperties extends BuilderWindow {
		
		private var param_list:List;
		private var paramName_ti:InputText;
		private var paramValue_ti:InputText;
		private var function_cb:ComboBox;
		
		public var functionSavedSignal:Signal1 = new Signal1(Function);
		
		public function FunctionProperties(parent:DisplayObjectContainer, initialData:Object = null) {
			super(parent, "Function properties", 210, 150);
			
			if (initialData) {
				function_cb.addItem(initialData);
				function_cb.selectedIndex = 0;
				function_cb.enabled = false;
				return;
			}
			
			var amfphp:AMFPHP = new AMFPHP(onFunctions);
			amfphp.xcall("dm.Functions.getAllFunctionLabels");
		}
		
		private function onFunctions(response:Object):void {
			function_cb.items = response as Array;
			function_cb.selectedIndex = 0;
		}
		
		override protected function createGUI():void {
			var function_lbl:BuilderLabel = new BuilderLabel(_body, 10, 10, "Function: ");
			function_cb = new ComboBox(_body, function_lbl.x + function_lbl.textWidth + 5, function_lbl.y);
			function_cb.addEventListener(Event.SELECT, onFunctionSelect);
			var params_lbl:BuilderLabel = new BuilderLabel(_body, function_lbl.x, function_lbl.y + 30, "Params: ");
			params_lbl.width = _width - 10;
			param_list = new List(_body, params_lbl.x, params_lbl.y + 20);
			param_list.addEventListener(Event.SELECT, onParamSelect);
			param_list.height -= 50;
			
			var paramValue_lbl:BuilderLabel = new BuilderLabel(_body, param_list.x + param_list.width + 10, params_lbl.y, "Param value:");
			paramValue_ti = new InputText(_body, paramValue_lbl.x, paramValue_lbl.y + 20, "", onParamChange);
			paramValue_ti.width -= 20;
			
			var save_btn:PushButton = new PushButton(_body, _width * 0.5, param_list.y + param_list.height + 10, "Save", onSaveBtn);
			save_btn.x -= save_btn.width * 0.5;
		}
		
		private function onSaveBtn(e:MouseEvent):void {
			for each (var param:Object in function_cb.selectedItem.params)
				if (param.value == undefined || param.value == "") {
					trace("Enter values for all parameters");
					return;
				}
			var amfphp:AMFPHP = new AMFPHP(onFunctionSave);
			amfphp.xcall("dm.Functions.saveFunction", function_cb.selectedItem);
			trace("Saving function: " + JSON.stringify(function_cb.selectedItem));
		}
		
		private function onFunctionSave(response:Object):void {
			trace("Function saved: " + JSON.stringify(response));
			functionSavedSignal.dispatch(response);
			functionSavedSignal.removeAll();
			destroy();
		}
		
		private function onFunctionSelect(e:Event):void {
			param_list.items = function_cb.selectedItem.params as Array;
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