package dm.builder.interfaces.tools.dialogeditor 
{
	/**
	 * ...
	 * @author Darius Dauskurdis dariusdxd@gmail.com
	 */
	
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.events.*;
	import flash.geom.*;
	import flash.display.Shape;
	import flash.display.GradientType; 
	import flash.geom.Matrix;

	public class MainGrid extends Sprite
	{
		private var root_holder:*;
		private var root_holder_is_stage:Boolean;
		private var holder:*;
		private var numOfColumns:Number = 100;
		private var numOfRows:Number = 100; 
		private var cellHeight:Number = 40;
		private var cellWidth:Number = 40;
		private var grid_area_click_x:Number;
		private var grid_area_click_y:Number;
		private var grid_area_x:Number;
		private var grid_area_y:Number;
		public var grid_area_is_clicked:Boolean = false;
		public var _node_popup:Sprite;
		public var mini_preview:Object;
		
		public function MainGrid() {
			this.addEventListener(Event.ADDED, thisWasAdded);
		}
		
		private function thisWasAdded(e:Event):void {
			this.removeEventListener(Event.ADDED, thisWasAdded);
			holder = this.parent;
			root_holder = holder.root_holder;
			root_holder_is_stage=holder.root_holder_is_stage
			var grid_holder:Sprite = new Sprite();
			grid_holder.name = "grid_holder";
			this.addChild(grid_holder);
			grid_holder.addEventListener(MouseEvent.MOUSE_DOWN, on_MouseDown_grid);
			grid_holder.addEventListener(MouseEvent.MOUSE_UP, on_MouseUp_grid);
			drawGrid(numOfColumns, numOfRows, cellHeight, cellWidth, grid_holder);
			var nodes_holder:Sprite = new Sprite();
			nodes_holder.x = grid_holder.width / 2;
			nodes_holder.y = grid_holder.height / 2;
			this.addChild(nodes_holder);
			nodes_holder.name = "nodes_holder";
		}	
		
		private function on_MouseDown_grid(event:MouseEvent):void {
			_node_popup = holder.getChildByName("NodePopup");
			_node_popup.visible = false;
			mini_preview = holder.getChildByName("mini_preview");	
			mini_preview.hideMiniPreview();
			
			
			
			grid_area_click_x = holder.mouseX;
			grid_area_click_y = holder.mouseY;
			grid_area_x = this.x;
			grid_area_y = this.y;
			grid_area_is_clicked = true;
			event.target.addEventListener(Event.ENTER_FRAME, onGridAreaClick);
		}
		 
		private function on_MouseUp_grid(event:MouseEvent):void{
		   grid_area_is_clicked = false;
		   event.target.removeEventListener(Event.ENTER_FRAME, onGridAreaClick);
		}
		
		private function onGridAreaClick(event:Event):void {
			if (grid_area_is_clicked == true) {
				var dis_x:Number =  grid_area_click_x - grid_area_x;
				var dis_y:Number =  grid_area_click_y - grid_area_y;
				this.x = holder.mouseX - dis_x;
				this.y = holder.mouseY - dis_y;
				this.x = (this.x > 0 ? 0 : this.x);
				this.y = (this.y > 0 ? 0 : this.y);
				this.x = (this.x < holder.size.width - this.width ? holder.size.width - this.width : this.x);
				this.y = (this.y < holder.size.height - this.height ? holder.size.height - this.height : this.y);
			}
		}
		
		private function drawGrid(numColumns:Number, numRows:Number, cellHeight:Number, cellWidth:Number, grid:Sprite):void {
			var fillType:String = GradientType.LINEAR;
			//var colors:Array = [0x5A7582, 0x102F39];
			var colors:Array = [0x5A7582, 0x5A7582];
			var alphas:Array = [1, 1];
			var ratios:Array = [0, 255];
			var matrix:Matrix = new Matrix();
			var gradWidth:Number = numColumns*cellWidth;
			var gradHeight:Number = numRows*cellHeight;
			var gradRotation:Number = 90 / 180 * Math.PI; // rotation expressed in radians
			var gradOffsetX:Number = 0;
			var gradOffsetY:Number = 0;
			matrix.createGradientBox(gradWidth, gradHeight, gradRotation, gradOffsetX, gradOffsetY);
			var spreadMethod:String = "reflect";
			grid.graphics.beginGradientFill(fillType, colors, alphas, ratios, matrix, spreadMethod);  
			grid.graphics.drawRect(0, 0, numColumns*cellWidth, numRows*cellHeight);
			grid.graphics.endFill();
			//grid.graphics.lineStyle(1, 0x768F98);
			grid.graphics.lineStyle(1, 0x5A7F8F);
			// we drop in the " + 1 " so that it will cap the right and bottom sides.
			for (var col:Number = 0; col < numColumns + 1; col++){
				for (var row:Number = 0; row < numRows + 1; row++){
					/*grid.graphics.moveTo(col * cellWidth, 0);
					grid.graphics.lineTo(col * cellWidth, cellHeight * numRows);
					grid.graphics.moveTo(0, row * cellHeight);
					grid.graphics.lineTo(cellWidth * numColumns, row * cellHeight);*/
				}
			}
		}
	}
}