package dm.game.components {
	import flare.core.Pivot3D;
	import flash.display.Sprite;
	
	public class TransformEnabled implements IComponent {
		
		private var _transformObject:Pivot3D;
		public var btns:Sprite;
		
		public function TransformEnabled(transformObject:Pivot3D) {
			_transformObject = transformObject;
		}
		
		public function get id():int {
			return 0;
		}
		
		public function get componentType():String {
			return "TransformEnabled";
		}
		
		public function get transformObject():Pivot3D {
			return _transformObject;
		}
		
		public function destroy():void {
		
		}
	
	}
}