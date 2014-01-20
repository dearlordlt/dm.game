package dm.builder.interfaces.tools.dialogeditor  
{
	/**
	 * ...
	 * @author Darius Dauskurdis dariusdxd@gmail.com
	 */
	
	import flash.display.Sprite;
	import flash.events.*; 
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	
	public class NodeText extends Sprite
	{
		
		public var node:Object;
		private var holder:*;
		public var t_format:TextFormat;
		public var txt:TextField;
		public var _timer:Timer = new Timer(10, 1);
		
		public function NodeText(node:Object) {
			this.node = node;
			this.addEventListener(Event.ADDED, thisWasAdded);
		}
		
		private function thisWasAdded(e:Event):void {
			this.removeEventListener(Event.ADDED, thisWasAdded);
			holder = this.parent;
			_timer.addEventListener(TimerEvent.TIMER, runOnce);
			_timer.stop();
			txt = new TextField(); 
			t_format = new TextFormat();
			t_format.font = "Arial";
			t_format.size = 12;
			t_format.color = 0xFFFFFF;
			txt.defaultTextFormat = t_format;
			txt.selectable = false;
			txt.autoSize = "left";
			txt.text = node.info.subject!=""?node.info.subject:"(unknown)";
			this.addChild(txt);
			holder.setChildIndex(this, holder.numChildren - 1);
			updateNodeTextPosition();
			node.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownNode);
			node.addEventListener(MouseEvent.MOUSE_UP, onMouseUpNode);
		}
		
		public function updateNodeTextPosition():void {
			this.x = node.x - this.width / 2;
			this.y = node.y + node.height / 2 + 2;
		}
		
		private function onMouseDownNode(event:MouseEvent):void {
            holder.addEventListener(MouseEvent.MOUSE_MOVE, ActiveNode);
		}
		
		private function onMouseUpNode(event:MouseEvent):void {
			holder.removeEventListener(MouseEvent.MOUSE_MOVE, ActiveNode);
			_timer.start();
		}
		
		private function ActiveNode(event:Event):void {
			updateNodeTextPosition();
		}
		
		private function runOnce(event:TimerEvent):void {
			updateNodeTextPosition();
		}
		
	}

}