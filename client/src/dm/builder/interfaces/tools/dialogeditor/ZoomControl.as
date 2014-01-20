package dm.builder.interfaces.tools.dialogeditor  
{
	/**
	 * ...
	 * @author Darius Dauskurdis dariusdxd@gmail.com
	 */
	
	import flash.display.Sprite;
	import flash.events.*; 
	 
	public class ZoomControl extends Sprite  
	{
		public var zoom_object:Object;
		public var zoom_m:zoomMinus;
		public var zoom_p:zoomPlus;
		private var holder:*;
		public var _node_popup:Sprite;
		
		public function ZoomControl(zoom_object:Object) {
			this.zoom_object = zoom_object;
			this.addEventListener(Event.ADDED, thisWasAdded);	
		}
		
		private function thisWasAdded(e:Event):void {
			this.removeEventListener(Event.ADDED, thisWasAdded);
			holder = this.parent;
			_node_popup = holder.getChildByName("NodePopup");
			zoom_m = new zoomMinus;
			this.addChild(zoom_m);
			zoom_m.addEventListener(MouseEvent.CLICK, zoomMinusClick);
			zoom_p = new zoomPlus;
			this.addChild(zoom_p);
			zoom_p.addEventListener(MouseEvent.CLICK, zoomPlusClick);
			zoom_p.x = zoom_m.x + zoom_m.width + 10;
		}
	
		private function zoomMinusClick(event:MouseEvent):void {
			_node_popup.visible = false;
			var current_scale_x:Number = zoom_object.scaleX;
			var current_scale_y:Number = zoom_object.scaleY;
			if (current_scale_x >= 0.7) {
				zoom_object.scaleX = current_scale_x - 0.1;
				zoom_object.scaleY = current_scale_y - 0.1;
				zoom_object.parent.MoveGridToCenter();
			}
		}
		
		private function zoomPlusClick(event:MouseEvent):void {
			_node_popup.visible = false;
			var current_scale_x:Number = zoom_object.scaleX;
			var current_scale_y:Number = zoom_object.scaleY;
			if (current_scale_x <= 1.5) {
				zoom_object.scaleX = current_scale_x + 0.1;
				zoom_object.scaleY = current_scale_y + 0.1;
				zoom_object.parent.MoveGridToCenter();
			}
		}
		
		
	}
}