package dm.game.components 
{
	/**
	 * ...
	 * @author zenia
	 */
	public class AvatarSpawnPoint implements IComponent 
	{
		public var conditions:Array = new Array();
		public var x:Number;
		public var y:Number;
		public var z:Number;
		public var rotationY:Number;
		
		public function AvatarSpawnPoint() 
		{
			
		}
		
		public function get id():int {
			return 0;
		}
		
		public function get componentType():String {
			return "AvatarSpawnPoint";
		}
		
		public function destroy():void {

		}
		
	}

}