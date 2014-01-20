package dm.builder.interfaces.tools.looteditor {
	import com.bit101.components.PushButton;
	import dm.builder.interfaces.SearchList;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import net.richardlord.ash.signals.Signal1;
	import utils.AMFPHP;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class DialogList extends SearchList {
		
		public var dialogSelectedSignal:Signal1 = new Signal1(Object);
		
		public function DialogList(parent:DisplayObjectContainer) {
			super(parent, "Dialog list");
			
			bodyHeight += 40;
			
			var add_btn:PushButton = new PushButton(_body, _width * 0.5, item_list.y + item_list.height + 20, "Add", onAddBtn);
			add_btn.x -= add_btn.width * 0.5;
			
			var amfphp:AMFPHP = new AMFPHP(onDialogs, null, true);
			amfphp.xcall("dm.Dialog.getAllDialogs");
		}
		
		private function onAddBtn(e:MouseEvent):void {
			dialogSelectedSignal.dispatch(item_list.selectedItem);
		}
		
		private function onDialogs(response:Object):void {
			items = response as Array;
		}
		
		override public function destroy():void {
			dialogSelectedSignal.removeAll();
			super.destroy();
		}
	
	}

}