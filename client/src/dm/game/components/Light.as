package dm.game.components 
{
	import dm.game.Main;
	import flare.core.Light3D;
	/**
	 * ...
	 * @author zenia
	 */
	public class Light implements IComponent 
	{
		private var _light3d:Light3D;		
		
		public function Light(type:int = Light3D.POINT, color:uint = 0xFFFFFF, radius:Number = 100) 
		{
			_light3d = new Light3D("", type);
			_light3d.setParams(color, radius);
			Main.getInstance().getWorld3D().scene.addChild(_light3d);
		}
		
		public function get id():int {
			return 0;
		}
		
		public function get componentType():String {
			return "Light";
		}
		
		public function get light3d():Light3D 
		{
			return _light3d;
		}
		
		public function destroy():void {

		}
	}

}