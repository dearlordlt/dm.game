package dm.game.components {
	
	import flare.core.Mesh3D;
	import flare.core.Pivot3D;
	
	/**
	 * Skin 3D
	 * @version $Id: Skin3D.as 200 2013-08-01 12:52:12Z zenia.sorocan $
	 */
	public class Skin3D implements IComponent {
		
		private var _skin:Pivot3D;
		
		private var _enabled:Boolean;
		
		public function Skin3D(skin:Pivot3D = null, enabled:Boolean = true) {
			_skin = skin;
			_enabled = enabled;
		}
		
		public function destroy():void {
			//trace("Skin3D.destroy()");
			if (_skin != null) {
				_skin.parent.removeChild(_skin);
			}
		}
		
		public function get skin():Pivot3D {
			return _skin;
		}
		
		public function set skin(value:Pivot3D):void {
			_skin = value;
		}
		
		public function get id():int {
			return (_enabled) ? _skin.userData.id : 0;
		}
		
		public function get componentType():String {
			return "Skin3D";
		}
		
		public function get enabled():Boolean {
			return _enabled;
		}
	
	}
}