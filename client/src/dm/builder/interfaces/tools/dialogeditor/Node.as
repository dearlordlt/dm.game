package dm.builder.interfaces.tools.dialogeditor
{
	/**
	 * ...
	 * @author Darius Dauskurdis dariusdxd@gmail.com
	 */
	
	import flash.display.Sprite;
	import flash.events.*;
	import flash.display.Shape;
	  
	public class Node extends Sprite 
	{
		private var holder:*;
		public var _node:Sprite
		public var size:Sprite
		public var node_click_x:Number;
		public var node_click_y:Number;
		public var node_x:Number;
		public var node_y:Number;
		public var node_is_clicked:Boolean = false;
		//public var snap_x:Number = 40;
		//public var snap_y:Number = 40;
		public var info:Object;
		//public var _node_popup:Sprite
		
		public function Node(info:Object) {
			this.info = info;
			this.addEventListener(Event.ADDED, thisWasAdded);
		}
		
		private function thisWasAdded(e:Event):void {
			this.removeEventListener(Event.ADDED, thisWasAdded);
			holder = this.parent;
			size = holder.parent.parent.size;
			//_node_popup = holder.parent.parent.getChildByName("NodePopup");
			_node = new Sprite();
			if (info.type == "dialog" || info.parent_id == 0) {
				if (info.haschilds) {
					var ball_holder1:green_ball_40x40 = new green_ball_40x40;
					ball_holder1.name = 'ball_holder';
					_node.addChild(ball_holder1);
				}else {
					var ball_holder2:green_ball_20x20 = new green_ball_20x20;
					ball_holder2.name = 'ball_holder';
					_node.addChild(ball_holder2);
				}
			}else{
				if (info.haschilds) {
					var ball_holder3:black_ball_40x40 = new black_ball_40x40;
					ball_holder3.name = 'ball_holder';
					_node.addChild(ball_holder3);
				}else {
					var ball_holder4:black_ball_20x20 = new black_ball_20x20;
					ball_holder4.name = 'ball_holder';
					_node.addChild(ball_holder4);
				}
			}
			
			if (info.haschilds) {
				var ball_holder5:red_ball_40x40 = new red_ball_40x40;
				ball_holder5.name = 'active_ball';
				_node.addChild(ball_holder5);
				ball_holder5.visible = false;
			}else {
				var ball_holder6:red_ball_20x20 = new red_ball_20x20;
				ball_holder6.name = 'active_ball';
				_node.addChild(ball_holder6);
				ball_holder6.visible = false;
			}
			

			this.addChild(_node);
			var xy_array:Array = info.x_y.split("_");
			this.x = info.x_y == "" || xy_array[0]>2000 ? 0 : xy_array[0];
			this.y = info.x_y == ""|| xy_array[1]>2000 ? 0 : xy_array[1];
			
			//this.x = Math.round(this.x/snap_x) * snap_x;
			//this.y = Math.round(this.y/snap_y) * snap_y;
			/*this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);	
			holder.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);	
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);	*/
		}
	
		public function activateNode():void {
			var r_ball:Object = _node.getChildByName("active_ball");
			r_ball.visible = true;
		}
		
		public function deactivateNode():void {
			var r_ball:Object = _node.getChildByName("active_ball");
			r_ball.visible = false;
		}
		
		private function onMouseDown(event:MouseEvent):void {
			/*node_click_x = holder.mouseX;
			node_click_y = holder.mouseY;
			node_x = this.x;
			node_y = this.y;*/
			node_is_clicked = true;
			
			
			//size
			//trace(this.parent.width)
			
			//_node_popup.x = this.x;
			//_node_popup.y = this.y;
			//_node.addEventListener(Event.ENTER_FRAME, ActiveNode);
		//	trace("hhh")
			_node.startDrag();
			_node.mouseEnabled = false;
			//addEventListener(MouseEvent.MOUSE_MOVE, ActiveNode);
		}
		
		private function onMouseUp(event:MouseEvent):void{
			node_is_clicked = false;
			//_node.removeEventListener(Event.ENTER_FRAME, ActiveNode);
		}
		
		private function ActiveNode(event:Event):void {
			if (node_is_clicked == true) {
				/*var dis_x:Number =  node_click_x - node_x;
				var dis_y:Number =  node_click_y - node_y;
				this.x = holder.mouseX - dis_x;
				this.y = holder.mouseY - dis_y;
				this.x = Math.round(this.x/snap_x) * snap_x;
				this.y = Math.round(this.y / snap_y) * snap_y;*/
				
				//this.x = (this.x > 0 ? 0 : this.x);
				//this.y = (this.y > 0 ? 0 : this.y);
				//this.x = (this.x < root_holder.stageWidth - this.width ? root_holder.stageWidth - this.width : this.x);
				//this.y = (this.y < root_holder.stageHeight - this.height ? root_holder.stageHeight - this.height : this.y);
			}
		}
	}
}