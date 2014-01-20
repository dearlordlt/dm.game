package dm.builder.interfaces.components {
	
	import com.bit101.components.PushButton;
	import dm.builder.interfaces.BuilderLabel;
	import dm.builder.interfaces.SearchListWithCategories;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import net.richardlord.ash.signals.Signal1;
	import utils.AMFPHP;
	
	/**
	 * Select skin3D
	 * @version $Id: SelectSkin3D.as 168 2013-06-19 09:19:14Z zenia.sorocan $
	 */
	public class SelectSkin3D extends SearchListWithCategories {
		
		private var _allSkinInfos:Array;
		
		public var skin3dSelectedSignal:Signal1 = new Signal1(Object);
		
		public function SelectSkin3D(parent:DisplayObjectContainer) {
			super(parent, "Select Skin3D", 6); // 6 - object type id of Skin3D in 'object_types' table
			
			bodyHeight += 60;

			
			var ok_btn:PushButton = new PushButton(_body, _width / 2, item_list.y + item_list.height + 15, "OK", onOkBtn);
			ok_btn.x -= ok_btn.width * 0.5;
			
			loadData();
		}		

		
		private function onOkBtn(e:MouseEvent):void {
			skin3dSelectedSignal.dispatch(item_list.selectedItem);
			destroy();
		}
		
		public function loadData():void {
			var amfphp:AMFPHP = new AMFPHP(onSkinInfo);
			amfphp.xcall("dm.Skin3D.getAllSkins");
			
			createDummy();
			var loading_lbl:BuilderLabel = new BuilderLabel(_dummy, 50, 50, "Loading...");
		}
		
		private function onSkinInfo(response:Object):void {
			items = response as Array;
			destroyDummy();		
		}
		
		override public function destroy():void {
			skin3dSelectedSignal.removeAll();
			
			super.destroy();
		}
	
	}

}