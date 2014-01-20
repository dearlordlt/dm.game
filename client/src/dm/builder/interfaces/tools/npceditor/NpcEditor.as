package dm.builder.interfaces.tools.npceditor {
	
	import com.bit101.components.PushButton;
	import dm.builder.interfaces.SearchListWithCategories;
	import dm.game.managers.MyManager;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import utils.AMFPHP;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class NpcEditor extends SearchListWithCategories {
		
		private var _npcProperties:NpcProperties;
		
		public function NpcEditor(parent:DisplayObjectContainer) {
			_width = 400;
			super(parent, "NPC editor", 1);
			bodyHeight += 50;
			
			refreshNpcList();
			
			_npcProperties = new NpcProperties(this);
			_npcProperties.hideButtons();
			_npcProperties.movable = false;
			_npcProperties.x = item_list.x + item_list.width + 15;
			_npcProperties.y = search_ti.y + 25;
			_npcProperties.npcSavedSignal.add(refreshNpcList);
			
			categoriesLoadedSignal.add(onCategoriesLoaded);
			
			item_list.addEventListener(Event.SELECT, onNpcSelect);
			
			var add_btn:PushButton = new PushButton(_body, item_list.x, item_list.y + item_list.height + 5, "Add", onAddBtn);
		}
		
		private function onCategoriesLoaded(response:Object):void {
			_npcProperties.category_cb.items = categoryFilter_cb.items;
			_npcProperties.category_cb.selectedIndex = 0;
		}
		
		private function refreshNpcList():void {
			var amfphp:AMFPHP = new AMFPHP(onNpcs).xcall("dm.NPC.getUserNpcs", MyManager.instance.id);
			function onNpcs(response:Object):void {
				items = response as Array;
				//item_list.selectedIndex = 0;
			}
		}
		
		private function onNpc(response:Object):void {
			_npcProperties.data = response;
		}
		
		private function onAddBtn(e:MouseEvent):void {
			item_list.addItemAt( { label: "NewNPC", category_id: categoryFilter_cb.selectedItem.id }, 0);
			item_list.selectedIndex = 0;
		}
		
		private function onNpcSelect(e:Event):void {
			if (item_list.selectedItem.id != undefined) {
				var amfphp:AMFPHP = new AMFPHP(onNpc).xcall("dm.NPC.getNpcById", item_list.selectedItem.id);
			} else {
				_npcProperties.clearData();
			}
		}
		
		override public function destroy():void {
			_npcProperties.npcSavedSignal.removeAll();
			_npcProperties.destroy();
			super.destroy();
		}
	
	}

}