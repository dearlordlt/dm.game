package dm.builder.interfaces.components {
	import com.bit101.components.PushButton;
	import dm.builder.interfaces.SearchListWithCategories;
	import dm.game.components.NPC;
	import dm.game.managers.EntityManager;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import utils.AMFPHP;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class SelectNPC extends SearchListWithCategories {
		
		public function SelectNPC(parent:DisplayObjectContainer) {
			super(parent, "Select NPC", 1);
			
			bodyHeight += 50;
			
			var ok_btn:PushButton = new PushButton(_body, _width / 2, item_list.y + item_list.height + 15, "OK", onOkBtn);
			ok_btn.x -= ok_btn.width * 0.5;
			
			var amfphp:AMFPHP = new AMFPHP(onNpcs);
			amfphp.xcall("dm.NPC.getAllNpcs");
			function onNpcs(response:Object):void {
				items = response as Array;				
			}
		}
		
		private function onOkBtn(e:MouseEvent):void {
			var amfphp:AMFPHP = new AMFPHP(onNpc);
			amfphp.xcall("dm.NPC.getNpcById", item_list.selectedItem.id);
		}
		
		private function onNpc(response:Object):void {
			EntityManager.instance.currentEntity.add(new NPC(response));
			destroy();
		}
	
	}

}