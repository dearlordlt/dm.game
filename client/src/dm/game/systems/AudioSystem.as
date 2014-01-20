package dm.game.systems {
	
	import com.greensock.loading.LoaderStatus;
	import dm.game.components.Audio;
	import dm.game.components.NPC;
	import dm.game.components.Skin3D;
	import dm.game.managers.EntityManager;
	import dm.game.managers.MyManager;
	import dm.game.nodes.AudioNode;
	import flare.core.Pivot3D;
	import net.richardlord.ash.core.Entity;
	import net.richardlord.ash.core.Game;
	import net.richardlord.ash.core.NodeList;
	import net.richardlord.ash.core.System;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class AudioSystem extends System {
		
		private var _audioNodes:NodeList;
		
		public function AudioSystem() {
			init();
		}
		
		private function init():void {
			EntityManager.instance.componentAddedSignal.add(onComponentAdded);
		}
		
		private function onComponentAdded(entity:Entity, componentClass:Class):void {
			if (componentClass == Audio) {
				var audio:Audio = Audio(entity.get(Audio));
				if (audio.id != 0)
					audio.sound.load();
			}
		}
		
		override public function addToGame(game:Game):void {
			_audioNodes = game.getNodeList(AudioNode);
		}
		
		override public function update(time:Number):void {
			for (var audioNode:AudioNode = _audioNodes.head; audioNode; audioNode = audioNode.next) {
				if (audioNode.skin3d.skin != null && audioNode.audio.sound != null) {
					if (audioNode.audio.sound.status != LoaderStatus.COMPLETED)
						continue;
					
					var skin:Pivot3D = audioNode.skin3d.skin;
					var audio:Audio = audioNode.audio;
					if (MyManager.instance.skin != null) {
						var distance:Number = Math.sqrt(Math.pow(skin.x - MyManager.instance.skin.x, 2) + Math.pow(skin.y - MyManager.instance.skin.y, 2) + Math.pow(skin.z - MyManager.instance.skin.z, 2));
						//trace(distance + " / " + audio.distance);
						if (distance < audio.distance) {
							if (audio.sound.soundPaused) {
								audio.sound.volume = 1;
								audio.sound.playSound();
								trace("Play sound");
							}
						} else if (!audio.sound.soundPaused) {
							audio.sound.pauseSound();
							trace("Pause sound");
						}
					}
				}
			}
		}
	
	}

}