package dm.game.components 
{
	
	/**
	 * ...
	 * @author zenia
	 */
	public interface IComponent
	{
		function get id():int;
		function get componentType():String;
		function destroy():void;
	}
	
}