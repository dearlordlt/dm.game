package dm.builder.interfaces.components {
	
	import com.bit101.components.PushButton;
	import dm.builder.interfaces.SearchListWithCategories;
	import dm.game.components.AltSkin;
	import dm.game.managers.EntityManager;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import utils.AMFPHP;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class SelectAltSkin extends SearchListWithCategories {
		
		public function SelectAltSkin(parent:DisplayObjectContainer) {
			super(parent, "Select altering skin", 7);
			
			bodyHeight += 50;
			
			var ok_btn:PushButton = new PushButton(_body, _width / 2, item_list.y + item_list.height + 10, "OK", onOkBtn);
			ok_btn.x -= ok_btn.width * 0.5;
			
			new AMFPHP(onAltSkins).xcall("dm.AltSkin.getAllAltskins");
			function onAltSkins(response:Object):void {
				items = response as Array;
			}
		}
		
		private function onOkBtn(e:MouseEvent):void {
			var amfphp:AMFPHP = new AMFPHP(onAltSkin);
			amfphp.xcall("dm.AltSkin.getAltskinById", item_list.selectedItem.id);
		}
		
		private function onAltSkin(response:Object):void {
			EntityManager.instance.currentEntity.add(new AltSkin(response));
			destroy();
		}
	
	}

}