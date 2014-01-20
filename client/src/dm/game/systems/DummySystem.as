package dm.game.systems {
	
	import dm.game.components.Dummy;
	import dm.game.components.Skin3D;
	import dm.game.managers.EntityManager;
	import dm.game.nodes.DummyNode;
	import flare.core.Pivot3D;
	import net.richardlord.ash.core.Entity;
	import net.richardlord.ash.core.Game;
	import net.richardlord.ash.core.NodeList;
	import net.richardlord.ash.core.System;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class DummySystem extends System {
		
		private var _dummyNodes:NodeList;
		
		public function DummySystem() {
			init();
		}
		
		private function init():void {
			EntityManager.instance.componentAddedSignal.add(onComponentAdded);
		}
		
		private function onComponentAdded(entity:Entity, componentClass:Class):void {
			if (componentClass == Dummy) {
				var dummy:Dummy = Dummy(entity.get(Dummy));
				//var skin:Pivot3D = Skin3D(entity.get(Skin3D)).skin;

			}
		}
		
		override public function addToGame(game:Game):void {
			_dummyNodes = game.getNodeList(DummyNode);
		}
		
		override public function update(time:Number):void {
			for (var dummyNode:DummyNode = _dummyNodes.head; dummyNode; dummyNode = dummyNode.next) {
				if (dummyNode.skin3d.skin != null) {
					
				}
			}
		}
	
	}

}