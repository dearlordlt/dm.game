package dm.builder.interfaces.components 
{
	import dm.game.components.AltSkin;
	import dm.game.components.Audio;
	import dm.game.components.AvatarSpawnPoint;
	import dm.game.components.Interaction;
	import dm.game.components.Light;
	import dm.game.components.NPC;
	import dm.game.components.Skin3D;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author ...
	 */
	public class ComponentViewMap
	{
		private var _map:Dictionary;
		
		public function ComponentViewMap() 
		{
			_map = new Dictionary();
			_map[Skin3D] = Skin3DView;
			_map[AvatarSpawnPoint] = AvatarSpawnPointView;
			_map[NPC] = NPCView;
			_map[Interaction] = InteractionView;
			_map[Audio] = AudioView;
			_map[AltSkin] = AltSkinView;
			_map[Light] = LightView;
		}
		
		public function getView(componentClass:Class):Class {
			return _map[componentClass];
		}
		
	}

}