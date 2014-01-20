package dm.game.components {
	import flare.core.Pivot3D;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class AltSkin implements IComponent {
		
		private var _data:Object;
		private var _currentSkin:Pivot3D;
		
		public function AltSkin(data:Object = null) {
			_data = data;
		}
		
		public function get id():int {
			return _data.id;
		}
		
		public function get componentType():String {
			return "AltSkin";
		}
		
		public function get data():Object {
			return _data;
		}
		
		public function get currentSkin():Pivot3D {
			return _currentSkin;
		}
		
		public function destroy():void {
		
		}
	
	}

}