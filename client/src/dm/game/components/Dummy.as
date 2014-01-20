package dm.game.components 
{
	/**
	 * ...
	 * @author zenia
	 */
	public class Dummy implements IComponent 
	{
		
		public function Dummy() 
		{
			
		}
		
		public function get id():int {
			return 0;
		}
		
		public function get componentType():String {
			return "Dummy";
		}
		
		public function destroy():void {
			
		}
		
	}

}