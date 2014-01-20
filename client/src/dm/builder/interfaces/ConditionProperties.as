package dm.builder.interfaces {
	
	import com.bit101.components.ComboBox;
	import com.bit101.components.InputText;
	import com.bit101.components.List;
	import com.bit101.components.PushButton;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import net.richardlord.ash.signals.Signal1;
	import utils.AMFPHP;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class ConditionProperties extends BuilderWindow {
		
		private var param_list:List;
		private var paramName_ti:InputText;
		private var paramValue_ti:InputText;
		private var condition_cb:ComboBox;
		
		public var conditionSavedSignal:Signal1 = new Signal1(Object);
		
		public function ConditionProperties(parent:DisplayObjectContainer = null, initialData:Object = null) {
			super(parent, "New condition", 210, 150);
			
			if (initialData) {
				condition_cb.addItem(initialData);
				condition_cb.selectedIndex = 0;
				condition_cb.enabled = false;
				return;
			}
			
			var amfphp:AMFPHP = new AMFPHP(onConditions);
			amfphp.xcall("dm.Conditions.getAllConditionLabels");
		}
		
		private function onConditions(response:Object):void {
			condition_cb.items = response as Array;
			condition_cb.selectedIndex = 0;
		}
		
		override protected function createGUI():void {
			var condition_lbl:BuilderLabel = new BuilderLabel(_body, 10, 10, "Condition: ");
			condition_cb = new ComboBox(_body, condition_lbl.x + condition_lbl.textWidth + 5, condition_lbl.y);
			condition_cb.addEventListener(Event.SELECT, onConditionSelect);
			var params_lbl:BuilderLabel = new BuilderLabel(_body, condition_lbl.x, condition_lbl.y + 30, "Params: ");
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
			for each (var param:Object in condition_cb.selectedItem.params)
				if (param.value == undefined || param.value == "") {
					trace("Enter values for all parameters");
					return;
				}
			var amfphp:AMFPHP = new AMFPHP(onConditionSave);
			amfphp.xcall("dm.Conditions.saveCondition", condition_cb.selectedItem);
		}
		
		private function onConditionSave(response:Object):void {
			trace("Condition saved");
			conditionSavedSignal.dispatch(response);
			conditionSavedSignal.removeAll();
			destroy();
		}
		
		private function onConditionSelect(e:Event):void {
			param_list.items = condition_cb.selectedItem.params as Array;
			if (param_list.items.length)
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