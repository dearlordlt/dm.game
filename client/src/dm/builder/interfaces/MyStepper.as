package dm.builder.interfaces {
	import com.bit101.components.PushButton;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import net.richardlord.ash.signals.Signal1;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class MyStepper extends Sprite {
		
		private var _value:int = 0;
		private var _minimum:int = 0;
		private var _maximum:int = 5;
		
		public var changeSignal:Signal1 = new Signal1(MyStepper);
		
		public function MyStepper(parent:DisplayObjectContainer, xPos:Number, yPos:Number) {
			parent.addChild(this);
			
			x = xPos;
			y = yPos;
			
			var prev_btn:PushButton = new PushButton(this, 0, 0, "<", onPrevBtn);
			prev_btn.width = 20;
			
			var next_btn:PushButton = new PushButton(this, prev_btn.x + prev_btn.width + 5, prev_btn.y, ">", onNextBtn);
			next_btn.width = 20;
			
		}
		
		private function onPrevBtn(e:MouseEvent):void {
			_value--;
			if (_value < _minimum)
				_value = _maximum;
			changeSignal.dispatch(this);
		}
		
		private function onNextBtn(e:MouseEvent):void {
			_value++;
			if (_value > _maximum)
				_value = _minimum;
			changeSignal.dispatch(this);
		}
		
		public function get value():int {
			return _value;
		}
		
		public function set value(value:int):void {
			_value = value;
			if (_value > _maximum)
				_value = _maximum;
			if (_value < _minimum)
				_value = _minimum;
		}
		
		public function get minimum():int {
			return _minimum;
		}
		
		public function set minimum(value:int):void {
			_minimum = value;
			if (_value < _minimum)
				_value = _minimum;
		}
		
		public function get maximum():int {
			return _maximum;
		}
		
		public function set maximum(value:int):void {
			_maximum = value;
			if (_value > _maximum)
				_value = _maximum;
		}
	
	}

}