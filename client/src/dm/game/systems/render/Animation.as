package dm.game.systems.render {
	import flare.core.Pivot3D;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author
	 */
	public class Animation {
		private var _label:String;
		private var _startFrame:int;
		private var _endFrame:int;
		private var _loop:Boolean;
		private var _type:int;
		
		public function Animation(label:String, type:int, startFrame:int, endFrame:int, loop:Boolean = false) {
			_label = label;
			_type = type;
			_startFrame = startFrame;
			_endFrame = endFrame;
			_loop = loop;
		}
		
		public function get label():String {
			return _label;
		}
		
		public function get startFrame():int {
			return _startFrame;
		}
		
		public function get endFrame():int {
			return _endFrame;
		}
		
		public function get loop():Boolean {
			return _loop;
		}
		
		public function get type():int {
			return _type;
		}
	
	}

}