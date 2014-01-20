package dm.game.systems.render {
	
	import flare.core.Pivot3D;
	
	/**
	 * ...
	 * @author zenia
	 */
	public interface SkinRecipient {
		function receive(skin:Pivot3D, skinInfo:Object):void;
	}
}