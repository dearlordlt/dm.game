package dm.builder.interfaces.tools.dialogeditor  
{
	/**
	 * ...
	 * @author Darius Dauskurdis dariusdxd@gmail.com
	 */
	
	import flash.display.Sprite;
	import flash.events.*;
	 
	public class RelationLine extends Sprite  
	{
		
		public var object1:Object;
		public var object2:Object;
		public var rline:Sprite;
		private var holder:*;
		public var snap_x:Number = 40;
		public var snap_y:Number = 40;
		public var _node_popup:Object;
		public var mini_preview:Object;
		public var which_node:Number;
		public var db:DataBase;
		
		public function RelationLine(node1:Object, node2:Object) {
			this.object1 = node1;
			this.object2 = node2;
			this.addEventListener(Event.ADDED, thisWasAdded);	
		}
		
		private function thisWasAdded(e:Event):void {
			this.removeEventListener(Event.ADDED, thisWasAdded);
			holder = this.parent;
			_node_popup = holder.parent.parent.getChildByName("NodePopup");
			mini_preview = holder.parent.parent.getChildByName("mini_preview");
			db = new DataBase(holder.parent.parent.gateway);
			rline = new Sprite();
			holder.addChild(rline);
			holder.setChildIndex(rline, 0);
			drawLineBetweenNodes();
			object1.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownObject1);
			object2.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownObject2);
			object1.addEventListener(MouseEvent.MOUSE_UP, onMouseUpObject1);
			object2.addEventListener(MouseEvent.MOUSE_UP, onMouseUpObject2);
			object1.addEventListener(MouseEvent.ROLL_OVER, onMouseRollOverObject1);
			object2.addEventListener(MouseEvent.ROLL_OVER, onMouseRollOverObject2);
			object1.addEventListener(MouseEvent.ROLL_OUT, onMouseRollOutObject1);
			object2.addEventListener(MouseEvent.ROLL_OUT, onMouseRollOutObject2);
		}
		
		public function onMouseRollOverObject1(event:MouseEvent):void {
			object1.activateNode();
			object2.activateNode();
			drawActiveLineBetweenNodes();
		}
		
		public function onMouseRollOverObject2(event:MouseEvent):void {
			object2.activateNode();
			drawLineBetweenNodes();
		}
		
		public function onMouseRollOutObject1(event:MouseEvent):void {
			object1.deactivateNode();
			object2.deactivateNode();
			drawLineBetweenNodes();
		}
		
		public function onMouseRollOutObject2(event:MouseEvent):void {
			object2.deactivateNode();
			drawLineBetweenNodes();
		}
		
		private function onMouseDownObject1(event:MouseEvent):void {
			which_node = 1;
			showNodePopup( event.currentTarget);
			if (event.currentTarget.info.type == "dialog") {
				mini_preview.hideMiniPreview();
			}
			holder.setChildIndex(object1, holder.numChildren-1);
            event.currentTarget.startDrag();
            holder.addEventListener(MouseEvent.MOUSE_MOVE, ActiveRelationLine);
		}
		
		
		private function showMinPrev(node:Object = null):void  {
			mini_preview.showMiniPreview(node);
		}
		
		private function showNodePopup(node:Object=null):void  {
			_node_popup.visible = true;
			if (which_node == 1) {
				_node_popup.x = holder.parent.width / 2 + holder.parent.x  + object1.x * holder.parent.scaleX + object1.width / 2 + 5;
				_node_popup.y = holder.parent.height / 2 + holder.parent.y + object1.y * holder.parent.scaleY + object1.height / 2 + 5;	
				if(node!=null){
					_node_popup.activateNodePopup(object1);
				}
			}else {
				_node_popup.x = holder.parent.width / 2 + holder.parent.x  + object2.x * holder.parent.scaleX + object2.width / 2 + 5;
				_node_popup.y = holder.parent.height / 2 + holder.parent.y + object2.y * holder.parent.scaleY + object2.height / 2 + 5;		
				if(node!=null){
					_node_popup.activateNodePopup(object2);
				}
			}
			
		}
		
		private function onMouseDownObject2(event:MouseEvent):void {
			which_node = 2;
			showNodePopup( event.currentTarget);
			if (event.currentTarget.info.type != "dialog") {
				showMinPrev( event.currentTarget);	
			}
            event.currentTarget.startDrag();
            holder.addEventListener(MouseEvent.MOUSE_MOVE, ActiveRelationLine);
		}
		
		private function onMouseUpObject1(event:MouseEvent):void {
			event.currentTarget.stopDrag();
			event.currentTarget.x = Math.round(event.currentTarget.x/snap_x) * snap_x;
			event.currentTarget.y = Math.round(event.currentTarget.y / snap_y) * snap_y;
			showNodePopup();
			drawLineBetweenNodes();
			holder.removeEventListener(MouseEvent.MOUSE_MOVE, ActiveRelationLine);
			var is_main:Boolean = false;
			if (event.currentTarget.info.type == "dialog") {
				is_main = true;
			}
			db.updateNodePosition(updateNodePositionResult,event.currentTarget.info.id,event.currentTarget.x,event.currentTarget.y,is_main);
		}
		
		private function onMouseUpObject2(event:MouseEvent):void {
			event.currentTarget.stopDrag();
			event.currentTarget.x = Math.round(event.currentTarget.x/snap_x) * snap_x;
			event.currentTarget.y = Math.round(event.currentTarget.y / snap_y) * snap_y;
			showNodePopup();
			drawLineBetweenNodes();
			holder.removeEventListener(MouseEvent.MOUSE_MOVE, ActiveRelationLine);
			var is_main:Boolean = false;
			if (event.currentTarget.info.type == "dialog") {
				is_main = true;
			}
			db.updateNodePosition(updateNodePositionResult,event.currentTarget.info.id,event.currentTarget.x,event.currentTarget.y,is_main);
		}
		
		public function updateNodePositionResult(r:Object): void {
			if (r == false) {
				trace("Error reading records. nr1");
			}else {
				//trace("Node position was saved");
			}
		}
		
		private function ActiveRelationLine(event:Event):void {
			showNodePopup();
			drawActiveLineBetweenNodes();
		}
		
		private function drawLineBetweenNodes():void {
			rline.graphics.clear();
			var arrow_coord:Object=getArrowCoord();
			rline.graphics.lineStyle(2, 0xCCCCCC, 100);
			rline.graphics.moveTo(object1.x, object1.y);
			rline.graphics.lineTo(object2.x, object2.y);
			rline.graphics.moveTo(arrow_coord.x1, arrow_coord.y1);
			rline.graphics.lineTo(arrow_coord.arrow_x, arrow_coord.arrow_y);
			rline.graphics.moveTo(arrow_coord.x2, arrow_coord.y2);
			rline.graphics.lineTo(arrow_coord.arrow_x,arrow_coord.arrow_y);
		}
		
		private function drawActiveLineBetweenNodes():void {
			rline.graphics.clear();
			var arrow_coord:Object=getArrowCoord();
			rline.graphics.lineStyle(2, 0xFF0000, 100);
			rline.graphics.moveTo(object1.x, object1.y);
			rline.graphics.lineTo(object2.x, object2.y);
			rline.graphics.moveTo(arrow_coord.x1, arrow_coord.y1);
			rline.graphics.lineTo(arrow_coord.arrow_x, arrow_coord.arrow_y);
			rline.graphics.moveTo(arrow_coord.x2, arrow_coord.y2);
			rline.graphics.lineTo(arrow_coord.arrow_x,arrow_coord.arrow_y);
		}
		
		private function getArrowCoord():Object {
			var arrowWidth:Number = 10;
			var distance_between_nodes:Number;
			distance_between_nodes = Math.sqrt(Math.pow((object1.x - object2.x), 2) + Math.pow((object1.y - object2.y), 2));
			var lambda:Number = (distance_between_nodes - object2.width / 2) / (object2.width / 2);
			var lambda2:Number = (distance_between_nodes - object1.width / 2) / (object1.width / 2);
			var arrow_x:Number = (object1.x + lambda * object2.x) / (1 + lambda);
			var arrow_y:Number = (object1.y + lambda * object2.y) / (1 + lambda);
			var arrow_x_2:Number = (object2.x + lambda2 * object1.x) / (1 + lambda2);
			var arrow_y_2:Number = (object2.y + lambda2 * object1.y) / (1 + lambda2);
			var xDist:Number = object1.x - arrow_x;
			var yDist:Number = object1.y - arrow_y;
			var xDist2:Number = object2.x - arrow_x_2;
			var yDist2:Number = object2.y - arrow_y_2;
			var arrRotation:Number = Math.atan(yDist/xDist);
			var arrRotation2:Number = Math.atan(yDist2/xDist2);
			if(xDist >= 0) arrRotation += Math.PI;
			if(xDist2 >= 0) arrRotation2 += Math.PI;
			var radRotation:Number = 30*Math.PI / 180;
			var rotationUp:Number = arrRotation + radRotation;
			var rotationDown:Number = arrRotation - radRotation;
			var radRotation2:Number = 30*Math.PI / 180;
			var rotationUp2:Number = arrRotation2 + radRotation2;
			var rotationDown2:Number = arrRotation2 - radRotation2;
			var x1:Number = Math.round(arrow_x - Math.cos(rotationUp) * arrowWidth);
			var y1:Number = Math.round(arrow_y - Math.sin(rotationUp) * arrowWidth);
			var x2:Number = Math.round(arrow_x - Math.cos(rotationDown) * arrowWidth);
			var y2:Number = Math.round(arrow_y - Math.sin(rotationDown) * arrowWidth);
			var x1_2:Number = Math.round(arrow_x_2 - Math.cos(rotationUp2) * arrowWidth);
			var y1_2:Number = Math.round(arrow_y_2 - Math.sin(rotationUp2) * arrowWidth);
			var x2_2:Number = Math.round(arrow_x_2 - Math.cos(rotationDown2) * arrowWidth);
			var y2_2:Number = Math.round(arrow_y_2 - Math.sin(rotationDown2) * arrowWidth);
			var result:Object = {"x1":x1,"y1":y1,"arrow_x":arrow_x,"arrow_y":arrow_y,"x2":x2,"y2":y2}
			return result;
		}
	}
}