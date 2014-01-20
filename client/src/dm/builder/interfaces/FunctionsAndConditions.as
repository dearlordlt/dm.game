package dm.builder.interfaces {
	
	import com.bit101.components.InputText;
	import com.bit101.components.List;
	import com.bit101.components.PushButton;
	import dm.builder.interfaces.BuilderLabel;
	import dm.builder.interfaces.BuilderWindow;
	// import dm.builder.interfaces.NewCondition;
	// import dm.builder.interfaces.NewFunction;
	import dm.builder.interfaces.WindowManager;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import utils.AMFPHP;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class FunctionsAndConditions extends BuilderWindow {
		
		private var condition_list:List;
		private var function_list:List;
		private var label_ti:InputText
		
		private var removeCondition_btn:PushButton;
		private var editCondition_btn:PushButton;
		
		private var removeFunction_btn:PushButton;
		private var editFunction_btn:PushButton;
		
		private var _initialPosition:Point;
		
		public function FunctionsAndConditions(parent:DisplayObjectContainer, initialPosition:Point) {
			_initialPosition = initialPosition;
			super(parent, "Functions and conditions");
			bodyHeight += 30;
		}
		
		override protected function createGUI():void {
			
			var conditions_lbl:BuilderLabel = new BuilderLabel(_body, 10, 10, "Conditions: ");
			conditions_lbl.width = _width - 10;
			condition_list = new List(_body, conditions_lbl.x, conditions_lbl.y + 20);
			condition_list.height -= 20;
			condition_list.addEventListener(Event.SELECT, onConditionSelect);
			
			var addCondition_btn:PushButton = new PushButton(_body, condition_list.x + condition_list.width + 10, condition_list.y, "Add", onAddConditionBtn);
			addCondition_btn.width -= 20;
			removeCondition_btn = new PushButton(_body, addCondition_btn.x, addCondition_btn.y + 30, "Remove", onRemoveConditionBtn);
			removeCondition_btn.width = addCondition_btn.width;
			removeCondition_btn.enabled = false;
			editCondition_btn = new PushButton(_body, removeCondition_btn.x, removeCondition_btn.y + 30, "Edit", onEditConditionBtn);
			editCondition_btn.width = removeCondition_btn.width;
			editCondition_btn.enabled = false;
			
			var functions_lbl:BuilderLabel = new BuilderLabel(_body, condition_list.x, condition_list.y + condition_list.height + 10, "Functions: ");
			functions_lbl.width = _width - 10;
			function_list = new List(_body, functions_lbl.x, functions_lbl.y + 20);
			function_list.removeItemAt(0);
			function_list.addEventListener(Event.SELECT, onFunctionSelect);
			
			var addFunction_btn:PushButton = new PushButton(_body, function_list.x + function_list.width + 10, function_list.y, "Add", onAddFunctionBtn);
			function_list.height = condition_list.height;
			addFunction_btn.width -= 20;
			removeFunction_btn = new PushButton(_body, addFunction_btn.x, addFunction_btn.y + 30, "Remove", onRemoveFunctionBtn);
			removeFunction_btn.width = addFunction_btn.width;
			removeFunction_btn.enabled = false;
			editFunction_btn = new PushButton(_body, removeFunction_btn.x, removeFunction_btn.y + 30, "Edit", onEditFunctionBtn);
			editFunction_btn.width = removeFunction_btn.width;
			editFunction_btn.enabled = false;
		}
		
		private function onConditionSelect(e:Event):void {
			if (condition_list.selectedItem) {
				removeCondition_btn.enabled = true;
				editCondition_btn.enabled = true;
			}
		}
		
		private function onAddConditionBtn(e:MouseEvent):void {
			var newCondition:ConditionProperties = new ConditionProperties(parent);
			newCondition.conditionSavedSignal.add(onConditionSaved);
		}
		
		private function onRemoveConditionBtn(e:MouseEvent):void {
			condition_list.removeItemAt(condition_list.selectedIndex);
		}
		
		private function onEditConditionBtn(e:MouseEvent):void {
			var newCondition:ConditionProperties = new ConditionProperties(parent, condition_list.selectedItem);
			newCondition.conditionSavedSignal.add(onConditionSaved);
		}
		
		private function onConditionSaved(condition:Object):void {
			for each (var currentCondition:Object in condition_list.items)
				if (currentCondition.id == condition.id) {
					condition_list.removeItem(currentCondition);
					break;
				}
			condition_list.addItem(condition);
		}
		
		private function onFunctionSelect(e:Event):void {
			if (function_list.selectedItem) {
				removeFunction_btn.enabled = true;
				editFunction_btn.enabled = true;
			}
		}
		
		private function onAddFunctionBtn(e:MouseEvent):void {
			var newFunction:FunctionProperties = new FunctionProperties(parent);
			newFunction.functionSavedSignal.add(onFunctionSaved);
		}
		
		private function onRemoveFunctionBtn(e:MouseEvent):void {
			function_list.removeItemAt(function_list.selectedIndex);
		}
		
		private function onEditFunctionBtn(e:MouseEvent):void {
			var newFunction:FunctionProperties = new FunctionProperties(parent, function_list.selectedItem);
			newFunction.functionSavedSignal.add(onFunctionSaved);
		}
		
		private function onFunctionSaved(func:Object):void {
			for each (var currentFunction:Object in function_list.items)
				if (currentFunction.id == func.id) {
					function_list.removeItem(currentFunction);
					break;
				}
			function_list.addItem(func);
		}
		
		public function getFunctionIds():Array {
			var functionIds:Array = [];
			for each (var item:Object in function_list.items)
				functionIds.push(item.id);
			return functionIds;
		}
		
		public function getConditionIds():Array {
			var conditionIds:Array = [];
			for each (var item:Object in condition_list.items)
				conditionIds.push(item.id);
			return conditionIds;
		}
		
		public function setFunctions(functions:Array):void {
			function_list.items = functions;
		}
		
		public function setConditions(conditions:Array):void {
			condition_list.items = conditions;;
		}
		
		public function clearLists():void {
			condition_list.removeAll();
			function_list.removeAll();
		}
		
		override public function getInitialPosition():Point {
			return _initialPosition;
		}
	
	}

}