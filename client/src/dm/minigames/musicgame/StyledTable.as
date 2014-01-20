package dm.minigames.musicgame
{
	/**
	 * ...
	 * @author Darius Dauskurdis dariusdxd@gmail.com
	 */
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	import flash.display.MovieClip; 
	import flash.geom.Rectangle; 
	import flash.events.*;
	
	public class StyledTable extends Sprite {
		private var columnNumber:Number = 1;
		private var tableHeight:Number = 290;
		private var roundedCorners:Boolean = false;
		private var columnsInfo:Array = ["Demo header"];
		private var headerInfo:Object = {textColor:0xFFFFFF, backgroundColor:0x70706E,textHoverColor:0xFFFFFF, backgroundHoverColor:0xF05B22,borderColor:0x939392};
		private var row1Info:Object = {textColor:0x6D6F71, backgroundColor:0xD5D6D8,textHoverColor:0x6D6F71, backgroundHoverColor:0xE2E2E2,borderColor:0xDEDEE0};
		private var row2Info:Object = {textColor:0x6D6F71, backgroundColor:0xC6C6C6,textHoverColor:0x6D6F71, backgroundHoverColor:0xE2E2E2,borderColor:0xD2D2D2};
		private var rowsInfo:Array = new Array();
		private var headerHolder:Sprite;
		private var rowsHolder:Sprite;
		private var table:Sprite;
		private var headerFormatDefault:TextFormat = new TextFormat();
		private var headerFormatHover:TextFormat = new TextFormat();
		private var rowFormatDefault:TextFormat = new TextFormat();
		private var rowFormatHover:TextFormat = new TextFormat();
		private var columnsWidthInfo:Array = [200];
		private var table_data_holder:Sprite;
		private var table_header_mask:Sprite;
		private var table_rows_mask:Sprite;
		private var scroll_area:Sprite;
		private var scrollbar:Sprite;
		private var scroller:Sprite;
		private var follower:Sprite; //Naudojamas tam, kad kai peles mygtukas bus nebepaspaustas bet kurioje flasho vietoje, skrolas nebejudes
		private var rect:Rectangle;
		private var scrollerMinY:Number;
		private var contentMaxY:Number;
		private var padding:Number = 40;
		

		public function StyledTable() {
			table = new Sprite();
			this.addChild(table)
			table_data_holder = new Sprite();
			table.addChild(table_data_holder)
			headerHolder = new Sprite();
			table_data_holder.addChild(headerHolder);
			rowsHolder = new Sprite();
			table_data_holder.addChild(rowsHolder);
			
			table_header_mask = new Sprite();
			table_data_holder.addChild(table_header_mask);
			table_rows_mask = new Sprite();
			table_data_holder.addChild(table_rows_mask);
			
			headerHolder.mask = table_header_mask;
			rowsHolder.mask = table_rows_mask;
			
			
			scroll_area = new Sprite();
			table.addChild(scroll_area);
			scrollbar = new Sprite();
			scroll_area.addChild(scrollbar);
			scroller = new Sprite();
			scroll_area.addChild(scroller);
			scroller.buttonMode = true;
			scroller.addEventListener(MouseEvent.MOUSE_DOWN, dragIt);
			
			follower = new Sprite();
			follower.graphics.beginFill(0xFF0000);
			follower.graphics.drawRect(0,0,11,11);
			follower.graphics.endFill();
			this.addChild(follower);
			follower.visible = false;
			follower.alpha = 0;
			
			
			
			headerFormatDefault.font = "Arial";
			headerFormatDefault.size = 12;
			headerFormatDefault.color = 0xFFFFFF;
			headerFormatDefault.align = "left";
			headerFormatHover.font = "Arial";
			headerFormatHover.size = 12;
			headerFormatHover.color = 0xFFFFFF;
			headerFormatHover.align = "left";
			rowFormatDefault.font = "Arial";
			rowFormatDefault.size = 10;
			rowFormatDefault.color = 0x6D6F71;
			rowFormatDefault.align = "left";
			rowFormatHover.font = "Arial";
			rowFormatHover.size = 10;
			rowFormatHover.color = 0x6D6F71;
			rowFormatHover.align = "left";
			
			this.updateTable();
		}
		
		private function updateTable():void {
			this.clearHeaderHolder();
			this.clearRowsHolder();
			//--- Header update start ---
			var headerRowHolder:Sprite = new Sprite();
			headerRowHolder.name = "headerRowHolder";
			headerHolder.addChild(headerRowHolder);
			var headerRowDefault:Sprite = new Sprite();
			headerRowDefault.name = "headerRowDefault";
			headerRowHolder.addChild(headerRowDefault);
			var headerRowHover:Sprite = new Sprite();
			headerRowHover.name = "headerRowHover";
			headerRowHolder.addChild(headerRowHover);
			headerRowHolder.addEventListener(MouseEvent.ROLL_OVER,headerRowHolderRollOver);
			headerRowHolder.addEventListener(MouseEvent.ROLL_OUT,headerRowHolderRollOut);
			var num1:Number = 0;
			for each(var x:String in columnsInfo) {
				num1++;
				var cellHolder:Sprite = new Sprite();
				cellHolder.name = "cellHolder";
				if (headerRowDefault.width == 0) {
					cellHolder.x = headerRowDefault.width;
				}else {
					cellHolder.x = headerRowDefault.width-1;
				}
				headerRowDefault.addChild(cellHolder);
				var tfield:TextField = new TextField;
				//tfield.name = x;
				tfield.selectable = false;
				tfield.multiline = false;
				tfield.mouseEnabled = false;
				tfield.autoSize = "left";
				//tfield.border = true;
				//tfield.borderColor = 0xFF0000;
				tfield.defaultTextFormat = headerFormatDefault;
				var text_val:String = x as String;
				tfield.text = text_val.toUpperCase();
				cellHolder.addChild(tfield);
				cellHolder.graphics.clear();
				cellHolder.graphics.lineStyle(1, headerInfo.borderColor);
				var v1:Number = 100;
				if (columnsWidthInfo[num1 - 1]) {
					v1 = columnsWidthInfo[num1 - 1];
				}
				cellHolder.graphics.drawRect(0,0,v1,cellHolder.height);
				//tfield.x = cellHolder.width / 2 - tfield.width / 2;
				tfield.x = 5;
				
				
				var cellHolder2:Sprite = new Sprite();
				cellHolder2.name = "cellHolder";
				if (headerRowHover.width == 0) {
					cellHolder2.x = headerRowHover.width;
				}else {
					cellHolder2.x = headerRowHover.width-1;
				}
				headerRowHover.addChild(cellHolder2);
				var tfield2:TextField = new TextField;
				//tfield2.name = x;
				tfield2.selectable = false;
				tfield2.multiline = false;
				tfield2.mouseEnabled = false;
				tfield2.autoSize = "left";
				//tfield.border = true;
				//tfield.borderColor = 0xFF0000;
				tfield2.defaultTextFormat = headerFormatHover;
				tfield2.text = x.toUpperCase();
				cellHolder2.addChild(tfield2);
				cellHolder2.graphics.clear();
				cellHolder2.graphics.lineStyle(1, headerInfo.borderColor);
				var v2:Number = 100;
				if (columnsWidthInfo[num1 - 1]) {
					v2 = columnsWidthInfo[num1 - 1];
				}
				cellHolder2.graphics.drawRect(0, 0, v2, cellHolder2.height);
				//tfield2.x = cellHolder2.width / 2 - tfield2.width / 2;
				tfield2.x = 5;
			}
				headerRowDefault.graphics.clear();
				headerRowDefault.graphics.beginFill(headerInfo.backgroundColor);
				headerRowDefault.graphics.drawRect(0,0,headerRowDefault.width,headerRowDefault.height);
				headerRowDefault.graphics.endFill();
				headerRowHover.graphics.clear();
				headerRowHover.graphics.beginFill(headerInfo.backgroundHoverColor);
				headerRowHover.graphics.drawRect(0,0,headerRowHover.width,headerRowHover.height);
				headerRowHover.graphics.endFill();
				headerRowHover.visible = false;
			//--- Header update end ---
			//--- Rows update start ---	
			rowsHolder.y = headerRowHolder.height - 1;
			var row_num:Number = 0;
			var row_design_num:Number = 0;
			for (var y:String in rowsInfo) {
				row_num++;
				row_design_num++;
				var rowHolder:Sprite = new Sprite();
				rowHolder.name = "rowHolder_" + row_num;
				if (rowsHolder.height == 0) {
					rowHolder.y = rowsHolder.height;
				}else {
					rowHolder.y = rowsHolder.height-1;
				}
				rowsHolder.addChild(rowHolder);
				var rowDefault:Sprite = new Sprite();
				rowDefault.name = "rowDefault";
				rowHolder.addChild(rowDefault);
				var rowHover:Sprite = new Sprite();
				rowHover.name = "rowHover";
				rowHolder.addChild(rowHover);
				rowHolder.addEventListener(MouseEvent.ROLL_OVER,rowHolderRollOver);
				rowHolder.addEventListener(MouseEvent.ROLL_OUT,rowHolderRollOut);
				var num2:Number = 0;
				var max_row_height:Number = 0;
				for (var y2:String in rowsInfo[y]) {
					num2++;
					var cellHolder3:Sprite = new Sprite();
					cellHolder3.name = "cellHolder_"+num2;
					if (rowDefault.width == 0) {
						cellHolder3.x = rowDefault.width;
					}else {
						cellHolder3.x = rowDefault.width-1;
					}
					rowDefault.addChild(cellHolder3);
					
					if (rowsInfo[y][y2] is Sprite) {
						var sprite1:Sprite = rowsInfo[y][y2];
						cellHolder3.addChild(sprite1);
					}else if (rowsInfo[y][y2] is MovieClip) {
						var movieclip1:MovieClip = rowsInfo[y][y2];
						cellHolder3.addChild(movieclip1);
					}else {
						var tfield3:TextField = new TextField;
						tfield3.selectable = false;
						tfield3.multiline = false;
						tfield3.mouseEnabled = false;
						tfield3.autoSize = "left";
						tfield3.defaultTextFormat = rowFormatDefault;
						tfield3.text = rowsInfo[y][y2];
						//tfield3.border = true;
						//tfield3.borderColor = 0x0000FF;
						cellHolder3.addChild(tfield3);	
					}
					
					cellHolder3.graphics.clear();
					if (row_design_num == 1) {
						cellHolder3.graphics.lineStyle(1, row1Info.borderColor);
					}else {
						cellHolder3.graphics.lineStyle(1, row2Info.borderColor);	
					}
					var v3:Number = 100;
					if (columnsWidthInfo[num2 - 1]) {
						v3 = columnsWidthInfo[num2 - 1];
					}
					cellHolder3.graphics.drawRect(0, 0, v3, cellHolder3.height);
		
					
					//tfield3.x = v3 / 2 - tfield3.width / 2;
					tfield3.x = 5;
					var cellHolder4:Sprite = new Sprite();
					cellHolder4.name = "cellHolder_"+num2;
					if (rowHover.width == 0) {
						cellHolder4.x = rowHover.width;
					}else {
						cellHolder4.x = rowHover.width-1;
					}
					rowHover.addChild(cellHolder4);
					
					if (rowsInfo[y][y2] is Sprite) {
						var sprite2:Sprite = rowsInfo[y][y2]
						cellHolder4.addChild(sprite2);
					}else if(rowsInfo[y][y2] is MovieClip) {
						var movieclip2:MovieClip = rowsInfo[y][y2];
						cellHolder4.addChild(movieclip2);
					}else {
						var tfield4:TextField = new TextField;
						tfield4.selectable = false;
						tfield4.multiline = false;
						tfield4.mouseEnabled = false;
						tfield4.autoSize = "left";
						tfield4.defaultTextFormat = rowFormatHover;
						tfield4.text = rowsInfo[y][y2];
						cellHolder4.addChild(tfield4);
					}
					
					cellHolder4.graphics.clear();
					if (row_design_num == 1) {
						cellHolder4.graphics.lineStyle(1, row1Info.borderColor);
					}else {
						cellHolder4.graphics.lineStyle(1, row2Info.borderColor);
					}
					var v4:Number = 100;
					if (columnsWidthInfo[num2 - 1]) {
						v4 = columnsWidthInfo[num2 - 1];
					}
					cellHolder4.graphics.drawRect(0, 0, v4, cellHolder4.height);
					//tfield4.x = cellHolder4.width / 2 - tfield4.width / 2;
					tfield4.x = 5;
					
					
					if (rowsInfo[y][y2] is Sprite || rowsInfo[y][y2] is MovieClip) {
						rowHolder.addChild(rowsInfo[y][y2]);
						//rowsInfo[y][y2].x = cellHolder4.x + cellHolder4.width / 2 - rowsInfo[y][y2].width / 2;
						rowsInfo[y][y2].x = cellHolder4.x + 5;
						rowsInfo[y][y2].y = 5;
					}
					
					if (max_row_height <= cellHolder4.height) {
						max_row_height = cellHolder4.height;
					}
					
				}

				
					var h:Number = max_row_height;
					var w:Number;
					var n:Number = 0;
					
					for (var t:Number=0; t<num2; t++) {
						n++;
						var s1:Object = rowDefault.getChildByName("cellHolder_"+n);
						w = s1.width;
						s1.graphics.clear();
						s1.graphics.lineStyle(1, row1Info.borderColor);
						s1.graphics.drawRect(0, 0, w - 1, h);
						if(s1.numChildren>0){
							var s2:Object = s1.getChildAt(0);
							s2.y = s1.height / 2 - s2.height / 2;
						}
						
						var s3:Object = rowHover.getChildByName("cellHolder_"+n);
						s3.graphics.clear();
						s3.graphics.lineStyle(1, row1Info.borderColor);
						s3.graphics.drawRect(0, 0, w - 1, h);
						if(s3.numChildren>0){
							var s4:Object = s3.getChildAt(0);
							s4.y = s3.height / 2 - s4.height / 2;
						}
							
					}
				

				if (row_design_num == 1) {
					rowDefault.graphics.clear();
					rowDefault.graphics.beginFill(row1Info.backgroundColor);
					rowDefault.graphics.drawRect(0,0,rowDefault.width,rowDefault.height);
					rowDefault.graphics.endFill();
					rowHover.graphics.clear();
					rowHover.graphics.beginFill(row1Info.backgroundHoverColor);
					rowHover.graphics.drawRect(0,0,rowHover.width,rowHover.height);
					rowHover.graphics.endFill();
					rowHover.visible = false;
				}else {
					rowDefault.graphics.clear();
					rowDefault.graphics.beginFill(row2Info.backgroundColor);
					rowDefault.graphics.drawRect(0,0,rowDefault.width,rowDefault.height);
					rowDefault.graphics.endFill();
					rowHover.graphics.clear();
					rowHover.graphics.beginFill(row2Info.backgroundHoverColor);
					rowHover.graphics.drawRect(0,0,rowHover.width,rowHover.height);
					rowHover.graphics.endFill();
					rowHover.visible = false;
				}
				if (row_design_num == 2) {
					row_design_num = 0;
				}
			}
			//--- Rows update end ---	
			
			table_header_mask.x = headerHolder.x;
			table_header_mask.y = headerHolder.y;
			table_header_mask.graphics.clear();
			drawRoundRect(table_header_mask, headerHolder.width-1, headerHolder.height, 5, 5, 0, 0, 0, 0x00FF00, 0x00FF00, 1);
			
			
			table_rows_mask.x = rowsHolder.x;
			table_rows_mask.y = rowsHolder.y;
			table_rows_mask.graphics.clear();
			drawRoundRect(table_rows_mask, rowsHolder.width-1, tableHeight-headerHolder.height, 0, 0, 5, 5, 0, 0xFF0000, 0xFF0000, 1);
			
			
			
			/*scroll_area = new Sprite();
			table_data_holder.addChild(scroll_area);
			scrollbar = new Sprite();
			scroll_area.addChild(scrollbar);
			scroller = new Sprite();
			scroll_area.addChild(scroller);*/
			
			scroll_area.x = table_rows_mask.x + table_rows_mask.width + 5;
			scroll_area.y = table_rows_mask.y;
			scrollbar.graphics.clear();
			scrollbar.x = 3;
			scrollbar.graphics.lineStyle(1, 0xCDCECE);
			scrollbar.graphics.moveTo( 0, 0 );
			scrollbar.graphics.lineTo(0, tableHeight-headerHolder.height);
			scrollbar.graphics.moveTo( 2, 0 );
			scrollbar.graphics.lineTo(2, tableHeight - headerHolder.height);
			
			scroller.graphics.clear();
			scroller.graphics.beginFill(0xE2E2E2);
			scroller.graphics.drawRect(1, 0, 7, 2);
			scroller.graphics.beginFill(0x8B8B8D);
			scroller.graphics.drawRect(1, 2, 7, 1);
			scroller.graphics.beginFill(0xE2E2E2);
			scroller.graphics.drawRect(0, 3, 9, 2);
			scroller.graphics.beginFill(0x8B8B8D);
			scroller.graphics.drawRect(0, 5, 9, 1);
			scroller.graphics.beginFill(0xE2E2E2);
			scroller.graphics.drawRect(0, 6, 9, 2);
			scroller.graphics.beginFill(0x8B8B8D);
			scroller.graphics.drawRect(0, 8, 9, 1);
			scroller.graphics.beginFill(0xE2E2E2);
			scroller.graphics.drawRect(0, 9, 9, 2);
			scroller.graphics.beginFill(0x8B8B8D);
			scroller.graphics.drawRect(1, 11, 7, 1);
			scroller.graphics.beginFill(0xE2E2E2);
			scroller.graphics.drawRect(1, 12, 7, 2);
			scroller.graphics.endFill();
			scroller.x = -1;
			
			
			scrollerMinY = scroller.y;
			contentMaxY = rowsHolder.y;

			if (rowsHolder.height>(tableHeight - headerHolder.height)) {
				scroll_area.visible = true;
			}else {
				scroll_area.visible = false;
			}

		}
		
		private function dragIt(e:MouseEvent):void {
			rect = new Rectangle( -1, 0, 0, tableHeight - headerHolder.height - scroller.height);
			rect.x = -1;
			scroller.startDrag(false, rect);
			this.addEventListener(MouseEvent.MOUSE_UP, dropIt);
			scroller.addEventListener(Event.ENTER_FRAME, scrollIt);
			follower.visible = true;
			//this.setChildIndex(follower,this.numChildren - 1);
		}
		
		private function dropIt(e:MouseEvent):void {
			scroller.stopDrag();
			scroller.removeEventListener(Event.ENTER_FRAME, scrollIt);
			follower.visible = false;
		}
		
		private function scrollIt(e:Event):void {
			var scrollerRange:Number = rect.height-2;
			var contentRange:Number = rowsHolder.height - tableHeight-headerHolder.height + padding;
			var percentage:Number = (scroller.y - scrollerMinY) / scrollerRange;
			var targetY:Number = contentMaxY - percentage * contentRange;
			rowsHolder.y = targetY;
			follower.y = mouseY - follower.height / 2;
			follower.x = mouseX - follower.width / 2;
		}
		
		private function rowHolderRollOver(evt:MouseEvent):void {
			
			var obj1:Object = evt.target.getChildByName("rowDefault");
			var obj2:Object = evt.target.getChildByName("rowHover");
			obj1.visible = false;
			obj2.visible = true;
		}
		
		private function rowHolderRollOut(evt:MouseEvent):void {
			var obj1:Object = evt.target.getChildByName("rowDefault");
			var obj2:Object = evt.target.getChildByName("rowHover");
			obj1.visible = true;
			obj2.visible = false;
		}
		
		private function headerRowHolderRollOver(evt:MouseEvent):void {
			var obj1:Object = evt.target.getChildByName("headerRowDefault");
			var obj2:Object = evt.target.getChildByName("headerRowHover");
			obj1.visible = false;
			obj2.visible = true;
		}
		
		private function headerRowHolderRollOut(evt:MouseEvent):void {
			var obj1:Object = evt.target.getChildByName("headerRowDefault");
			var obj2:Object = evt.target.getChildByName("headerRowHover");
			obj1.visible = true;
			obj2.visible = false;
		}
		
		public function countRows():Number {
			return rowsInfo.length
		}
		
		public function clearRows():void {
			rowsInfo = [];
			this.updateTable();
		}
		
		private function clearHeaderHolder():void {
			while (headerHolder.numChildren > 0) {
				headerHolder.removeChildAt(0);
			}
		}
		
		private function clearRowsHolder():void {
			while (rowsHolder.numChildren > 0) {
				rowsHolder.removeChildAt(0);
			}
		}
		
		public function setTable(roundedCorners:Boolean = false):void {
			this.roundedCorners = roundedCorners;
		}
		
		public function tableHeader(textColor:Number,backgroundColor:Number,textHoverColor:Number,backgroundHoverColor:Number,borderColor:Number):void {
			this.headerInfo = {textColor:textColor, backgroundColor:backgroundColor,textHoverColor:textHoverColor, backgroundHoverColor:backgroundHoverColor,borderColor:borderColor};
			this.updateTable();
			var color1:String = textColor.toString(16);
			var color2:String = backgroundColor.toString(16);
			var color3:String = textHoverColor.toString(16);
			var color4:String = backgroundHoverColor.toString(16);
			var color5:String = borderColor.toString(16);
			//trace("Header design: "+"textColor:"+color1+", backgroundColor:"+color2+",textHoverColor:"+color3+", backgroundHoverColor:"+color4+", borderColor:"+color5);
		}
		
		public function columns(cols:Array):void {
			this.columnsInfo = cols;
			//trace(columnsInfo[0] as Array)
			var printText:String;
			printText = "Added columns: ";
			var num:Number = 0;
			for (var x:String in columnsInfo) {
				num++;
				if (num > 1) {
				printText += ",";
				}
				printText += x + ":" + columnsInfo[x];
			}
			this.columnNumber = num;
			this.updateTable();
			//trace(printText);
		}
		
		public function addRow(row:Array):void {
			this.rowsInfo.push(row as Array);
			this.updateTable();
			//trace("Added row: "+row);
		}
		
		public function columnsWidth(width_array:Array):void {
			this.columnsWidthInfo = width_array;
			this.updateTable();
		}
		
		public function row1(textColor:Number,backgroundColor:Number,textHoverColor:Number,backgroundHoverColor:Number,borderColor:Number):void {
			this.row1Info = {textColor:textColor, backgroundColor:backgroundColor,textHoverColor:textHoverColor, backgroundHoverColor:backgroundHoverColor,borderColor:borderColor};
			this.updateTable();
			var color1:String = textColor.toString(16);
			var color2:String = backgroundColor.toString(16);
			var color3:String = textHoverColor.toString(16);
			var color4:String = backgroundHoverColor.toString(16);
			var color5:String = borderColor.toString(16);
			//trace("Row 1 design: "+"textColor:"+color1+", backgroundColor:"+color2+",textHoverColor:"+color3+", backgroundHoverColor:"+color4+", borderColor:"+color5);
		}
		
		public function row2(textColor:Number,backgroundColor:Number,textHoverColor:Number,backgroundHoverColor:Number,borderColor:Number):void {
			this.row2Info = {textColor:textColor, backgroundColor:backgroundColor,textHoverColor:textHoverColor, backgroundHoverColor:backgroundHoverColor,borderColor:borderColor};
			this.updateTable();
			var color1:String = textColor.toString(16);
			var color2:String = backgroundColor.toString(16);
			var color3:String = textHoverColor.toString(16);
			var color4:String = backgroundHoverColor.toString(16);
			var color5:String = borderColor.toString(16);
			//trace("Row 2 design: "+"textColor:"+color1+", backgroundColor:"+color2+",textHoverColor:"+color3+", backgroundHoverColor:"+color4+", borderColor:"+color5);
		}
		
		private  function drawRoundRect(m_clip:Object, w:Number , h:Number, tl:Number, tr:Number, bl:Number, br:Number, thick:Number, borderColor:Number, bgColor:Number, trans:Number ):void {
			if (thick != 0) m_clip.graphics.lineStyle(thick, borderColor);
			m_clip.graphics.beginFill(bgColor, trans);
			m_clip.graphics.moveTo( 0, tl );
			m_clip.graphics.curveTo( 0, 0, tl, 0 );
			m_clip.graphics.lineTo(w - tr, 0);
			m_clip.graphics.curveTo( w, 0, w, tr );
			m_clip.graphics.lineTo(w, h - br);
			m_clip.graphics.curveTo( w, h, w - br, h );
			m_clip.graphics.lineTo(bl, h);
			m_clip.graphics.curveTo( 0, h, 0, h - bl );
			m_clip.graphics.endFill();
		}
		
	}

}