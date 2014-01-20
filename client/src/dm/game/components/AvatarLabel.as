package dm.game.components {
	import dm.game.components.IComponent;
	import flare.primitives.Plane;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class AvatarLabel implements IComponent {
		
		public var label:String;
		public var color:uint;
		public var namePlane:Plane;
		
		public function AvatarLabel(label:String, color:uint = 0xFFFFFF) {
			this.label = label;
			this.color = color;
		}
		
		public function get id():int {
			return 0;
		}
		
		public function get componentType():String {
			return "AvatarLabel";
		}
		
		public function destroy():void {
			if (namePlane != null) {
				namePlane.parent.removeChild(namePlane);
				namePlane = null;
			}
		}
	
	}

}