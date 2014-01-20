package dm.builder.interfaces.map {
	
	import com.bit101.components.PushButton;
	import dm.builder.interfaces.BuilderLabel;
	import dm.builder.interfaces.SearchListWithCategories;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import net.richardlord.ash.signals.Signal1;
	import utils.AMFPHP;
	
	/**
	 * ...
	 * @author
	 */
	public class SelectMap extends SearchListWithCategories {
		
		public var mapSelectedSignal:Signal1 = new Signal1(Object);
		
		public function SelectMap(parent:DisplayObjectContainer) {
			super(parent, _("Select map"), 5);
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function draw():void {
			super.draw();
			bodyHeight += 60
			
			var ok_btn:PushButton = new PushButton(_body, _width / 2, item_list.y + item_list.height + 15, _("OK"), onOkBtn);
			ok_btn.x -= ok_btn.width * 0.5;
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function initialize():void {
			this.loadData();
		}
		
		private function onOkBtn(e:MouseEvent):void {
			mapSelectedSignal.dispatch(item_list.selectedItem);
			destroy();
		}
		
		public function loadData():void {
			createDummy();
			var loading_lbl:BuilderLabel = new BuilderLabel(_dummy, 50, 50, _("Loading..."));
			
			var amfphp:AMFPHP = new AMFPHP(onMaps);
			amfphp.xcall("dm.Maps.getAllMaps");
			
			function onMaps(response:Object):void {
				items = response as Array;
				destroyDummy();
			}
		}
		
		override public function destroy():void {
			mapSelectedSignal.removeAll();
			super.destroy();
		}
	
	}

}