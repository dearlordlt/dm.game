package dm.game.components {
	
	/**
	 * ...
	 * @author zenia
	 */
	public class NPC implements IComponent {
		
		private var _id:int = 0;
		public var label:String;
		public var commands:Array = new Array();
		
		public function NPC(data:Object = null) {
			if (data != null) {
				_id = data.id;
				label = data.label;
				commands = data.commands;
			}
		}
		
		public function get id():int {
			return _id;
		}
		
		public function get componentType():String {
			return "NPC";
		}
		
		public function destroy():void {
		
		}
	
	}

}