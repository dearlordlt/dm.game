package dm.builder.interfaces.entity 
{
	import com.bit101.components.PushButton;
	import dm.builder.interfaces.BuilderLabel;
	import dm.builder.interfaces.SearchList;
	import dm.game.managers.EntityCreator;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import utils.AMFPHP;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class Presets extends SearchList
	{
		
		public function Presets(parent:DisplayObjectContainer) {
			super(parent, "Presets");
			
			bodyHeight += 30
			
			var add_btn:PushButton = new PushButton(_body, _width / 2, item_list.y + item_list.height + 15, "Add to map", onAddBtn);
			add_btn.x -= add_btn.width * 0.5;
			
			loadData();
		}
		
		private function onAddBtn(e:MouseEvent):void {
			EntityCreator.instance.createEntityFromData(item_list.selectedItem).id = 0;;
		}

		
		public function loadData():void {
			createDummy();
			var loading_lbl:BuilderLabel = new BuilderLabel(_dummy, 50, 50, "Loading...");
			
			var amfphp:AMFPHP = new AMFPHP(onPresets);
			amfphp.xcall("dm.Entity.getPresets");
			
			function onPresets(response:Object):void {
				items = response as Array;
				destroyDummy();			
			}
		}
	}

}