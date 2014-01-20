package dm.game.components {
	
	import flare.core.Pivot3D;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class Interaction implements IComponent {
		
		private var _id:int;
		public var label:String;
		public var conditions:Array;
		public var functions:Array;
		public var available:Boolean = false;
		public var iconPlane:Pivot3D;
		
		public function Interaction(data:Object = null) {
			if (data != null) {
				_id = data.id;
				label = data.label;
				conditions = data.conditions;
				functions = data.functions;
			}
		}
		
		public function get id():int {
			return _id;
		}
		
		public function get componentType():String {
			return "Interaction";
		}
		
		public function destroy():void {
			if (iconPlane != null)
				iconPlane.parent.removeChild(iconPlane);
		}
	}

}