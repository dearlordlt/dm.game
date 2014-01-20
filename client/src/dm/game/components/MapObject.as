package dm.game.components 
{
	/**
	 * ...
	 * @author zenia
	 */
	public class MapObject implements IComponent 
	{
		
		public function MapObject() 
		{
			
		}
		
		public function get id():int {
			return 0;
		}
		
		public function get componentType():String {
			return "MapObject";
		}
		
		public function destroy():void {

		}
		
	}

}