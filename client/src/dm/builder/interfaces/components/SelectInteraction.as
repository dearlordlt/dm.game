package dm.builder.interfaces.components 
{
	import com.bit101.components.PushButton;
	import dm.builder.interfaces.SearchListWithCategories;
	import dm.game.components.Interaction;
	import dm.game.managers.EntityManager;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import utils.AMFPHP;
	/**
	 * ...
	 * @author zenia
	 */
	public class SelectInteraction extends SearchListWithCategories {
		
		public function SelectInteraction(parent:DisplayObjectContainer) {
			super(parent, "Select interaction", 4);
			
			bodyHeight += 50;
			
			var ok_btn:PushButton = new PushButton(_body, _width / 2, item_list.y + item_list.height + 15, "OK", onOkBtn);
			ok_btn.x -= ok_btn.width * 0.5;
			
			var amfphp:AMFPHP = new AMFPHP(onInteractions);
			amfphp.xcall("dm.Interaction.getAllInteractions");
			function onInteractions(response:Object):void {
				items = response as Array;				
			}
		}
		
		private function onOkBtn(e:MouseEvent):void {
			var amfphp:AMFPHP = new AMFPHP(onInteraction);
			amfphp.xcall("dm.Interaction.getInteractionById", item_list.selectedItem.id);
		}
		
		private function onInteraction(response:Object):void {
			EntityManager.instance.currentEntity.add(new Interaction(response));
			destroy();
		}
	
	}

}