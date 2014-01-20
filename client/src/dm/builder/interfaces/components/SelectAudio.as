package dm.builder.interfaces.components 
{
	import com.bit101.components.PushButton;
	import dm.builder.interfaces.SearchListWithCategories;
	import dm.game.components.Audio;
	import dm.game.managers.EntityManager;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import utils.AMFPHP;
	/**
	 * ...
	 * @author zenia
	 */
	public class SelectAudio extends SearchListWithCategories {
		
		public function SelectAudio(parent:DisplayObjectContainer) {
			super(parent, "Select audio", 8);
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function initialize (  ) : void {
			var amfphp:AMFPHP = new AMFPHP(onAudios);
			amfphp.xcall("dm.Audio.getAllAudios");
			function onAudios(response:Object):void {
				items = response as Array;				
			}
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function draw (  ) : void {
			super.draw();
			
			bodyHeight += 50;
			
			var ok_btn:PushButton = new PushButton(_body, _width / 2, item_list.y + item_list.height + 10, "OK", onOkBtn);
			ok_btn.x -= ok_btn.width * 0.5;			
		}
		
		private function onOkBtn(e:MouseEvent):void {
			EntityManager.instance.currentEntity.add(new Audio(item_list.selectedItem));
			destroy();
		}
		

	}

}