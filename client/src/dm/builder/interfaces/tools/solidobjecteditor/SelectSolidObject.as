package dm.builder.interfaces.tools.solidobjecteditor {
	
	import com.bit101.components.PushButton;
	import dm.builder.interfaces.SearchList;
	import dm.builder.interfaces.WindowManager;
	import dm.game.systems.render.SkinFactory;
	import dm.game.systems.render.SkinRecipient;
	import flare.core.Pivot3D;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import utils.AMFPHP;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SelectSolidObject extends SearchList implements SkinRecipient {
		
		private var _solidObjectEditor:SolidObjectEditor;
		
		public function SelectSolidObject(parent:DisplayObjectContainer) {
			super(parent, "Select solid object");
			
			_solidObjectEditor = WindowManager.instance.getWindowById("SolidObjectEditor") as SolidObjectEditor;
			
			bodyHeight += 20;
			var ok_btn:PushButton = new PushButton(_body, _width * 0.5, item_list.y + item_list.height + 10, "OK", onOkBtn);
			ok_btn.x -= ok_btn.width * 0.5;
			
			loadSolidObjectInfos();
		}
		
		private function onOkBtn(e:MouseEvent):void {
			SkinFactory.createSkin(item_list.selectedItem, this, _solidObjectEditor.world.scene);
			_solidObjectEditor.currentObjectInfo = item_list.selectedItem;
			destroy();
		}
		
		public function receive(skin:Pivot3D, skinInfo:Object):void {
			_solidObjectEditor.currentObject = skin;
		}
		
		private function loadSolidObjectInfos():void {
			var amfphp:AMFPHP = new AMFPHP(onInfos);
			amfphp.xcall("dm.Skin3D.getAllSolidObjects");
			function onInfos(response:Object):void {
				items = response as Array;
			}
		}
	
	}

}