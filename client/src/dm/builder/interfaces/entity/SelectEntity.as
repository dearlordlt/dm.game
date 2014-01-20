package dm.builder.interfaces.entity {
	
	import com.greensock.TweenLite;
	import dm.builder.interfaces.SearchList;
	import dm.game.components.Skin3D;
	import dm.game.managers.EntityManager;
	import dm.game.systems.CameraManager;
	import flare.core.Pivot3D;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import net.richardlord.ash.core.Entity;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SelectEntity extends SearchList {
		
		public function SelectEntity(parent:DisplayObjectContainer) {
			super(parent, "Select entity", EntityManager.instance.entities.concat());
			//items = EntityManager.instance.entities.concat();
			EntityManager.instance.entityAddedSignal.add(onEntityListUpdate);
			EntityManager.instance.entityRemovedSignal.add(onEntityListUpdate);
		}
		
		private function onEntityListUpdate(entity:Entity = null):void {
			items = EntityManager.instance.entities.concat();
			item_list.selectedIndex = item_list.items.length - 1;
		}
		
		override protected function onSelect(e:Event):void {
			if (item_list.selectedItem != null) {
				EntityManager.instance.currentEntity = Entity(item_list.selectedItem);
				onEntitySelected(Entity(item_list.selectedItem));
			}
		}
		
		private function onEntitySelected(entity:Entity):void {
			if (entity.has(Skin3D)) {
				var skin:Pivot3D = entity.get(Skin3D).skin as Pivot3D;
				TweenLite.to(CameraManager.instance.camera, 2, {x: skin.x, z: skin.z});
			}
		}
		
		override public function destroy():void {
			EntityManager.instance.entityAddedSignal.remove(onEntityListUpdate);
			EntityManager.instance.entityRemovedSignal.remove(onEntityListUpdate);
			super.destroy();
		}
	
	}

}