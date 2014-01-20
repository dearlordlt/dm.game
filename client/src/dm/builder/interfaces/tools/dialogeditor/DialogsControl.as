package dm.builder.interfaces.tools.dialogeditor  
{
	/**
	 * ...
	 * @author Darius Dauskurdis dariusdxd@gmail.com
	 */
	
	import flash.display.Sprite;
	import flash.events.*; 
	import flash.display.Shape; 
	import flash.text.TextField;
    import flash.text.TextFieldType;
    import flash.text.TextFormat;
	import flash.utils.Timer;
	
	public class DialogsControl extends Sprite 
	{
		private var holder:*;
		public var db:DataBase;
		public var dialogs_control_area:Sprite = new Sprite();
		public var dialogs_control_top:Sprite = new Sprite();
		public var dialogs_control_middle:Sprite = new Sprite();
		public var dialogs_control_bottom:Sprite = new Sprite();
		public var dialogs_control_top_background:Sprite = new Sprite();
		public var dialogs_control_middle_background:Sprite = new Sprite();
		public var dialogs_control_bottom_background:Sprite = new Sprite();
		public var dialogs_control_mask:Sprite = new Sprite();
		public var dialogs_control_width:Number = 300;
		public var margin:Number = 20;
		public var padding_top:Number = 20;
		public var padding_bottom:Number = 20;
		public var min_height:Number = 600;
		public var dialogs_list_holder:Sprite;
		public var menu_item_width:Number = 240;
		public var menu_item_height:Number = 30;
		public var dialogs_list_holder_mask:Sprite = new Sprite();
		public var slider:Slidebar;
		public var shIcon:showHideIcon = new showHideIcon;
		public var filter_holder:Sprite;
		public var filter_bg:Sprite;
		public var selected_item_name:String = "";
		public var filter_name_input:TextField;
		public var filter_author_input:TextField;
		public var filter_topic_input:TextField;
		public var refresh_filter_timer:Timer = new Timer(500);
		public var new_dialog_name_input:TextField;
		public var add_dialog_btn:Btn;
		
		public function DialogsControl() {
			this.addEventListener(Event.ADDED, thisWasAdded);
		}
		
		private function thisWasAdded(e:Event):void {
			this.removeEventListener(Event.ADDED, thisWasAdded);
			holder = this.parent;
			db = new DataBase(holder.gateway);
			this.y = margin;
			this.addChild(dialogs_control_area);
			this.addChild(dialogs_control_mask);
			dialogs_control_area.mask = dialogs_control_mask;
			dialogs_control_area.addChild(dialogs_control_top);
			dialogs_control_area.addChild(dialogs_control_middle);
			dialogs_control_area.addChild(dialogs_control_bottom);
			dialogs_control_top.addChild(dialogs_control_top_background);
			dialogs_control_middle.addChild(dialogs_control_middle_background);
			dialogs_control_bottom.addChild(dialogs_control_bottom_background);
			dialogs_control_top_background.addEventListener(MouseEvent.CLICK, onMouseClickDialogsControl);
			dialogs_control_middle_background.addEventListener(MouseEvent.CLICK, onMouseClickDialogsControl);
			dialogs_control_bottom_background.addEventListener(MouseEvent.CLICK, onMouseClickDialogsControl);
			shIcon.addEventListener(MouseEvent.CLICK, onMouseClickDialogsControl);
			drawTop();
			drawMiddle();
			drawBottom();
			
			filter_holder = new Sprite;
			filter_bg = new Sprite;
			filter_holder.addChild(filter_bg);
			dialogs_control_middle.addChild(filter_holder);
			filter_holder.x = 15;
			filter_holder.y = dialogs_list_holder_mask.y + dialogs_list_holder_mask.height + 20;
			drawRoundRect(filter_bg, dialogs_control_width - 40, 150, 10, 10, 10, 10, 0, 0x000000, 0x89AFC2, 1);
			filter_bg.graphics.lineStyle(1,0x5A7582)
			filter_bg.graphics.moveTo(10, 35);
			filter_bg.graphics.lineTo(filter_bg.width-20, 35);
			
			
			var filter_label:TextField = addLabel("FILTER", 0x5A7582);
			filter_holder.addChild(filter_label);
			filter_label.x = 10;
			filter_label.y = 10;
			
			var filter_name_label:TextField = addLabel("Title", 0x5A7582);
			filter_holder.addChild(filter_name_label);
			filter_name_label.x = filter_label.x;
			filter_name_label.y = filter_label.y + filter_label.height + 20;
			filter_name_input = addInputField("filter_name_input", "", 150, 20);
			filter_holder.addChild(filter_name_input);
			filter_name_input.x = filter_bg.width - filter_name_input.width - 20;
			filter_name_input.y = filter_name_label.y;
			filter_name_input.addEventListener(KeyboardEvent.KEY_UP, filteInputKeyUp);
			
			var filter_author_label:TextField = addLabel("Author", 0x5A7582);
			filter_holder.addChild(filter_author_label);
			filter_author_label.x = filter_name_label.x;
			filter_author_label.y = filter_name_input.y + filter_name_input.height + 10;
			filter_author_input = addInputField("filter_author_input", "", 150, 20);
			filter_holder.addChild(filter_author_input);
			filter_author_input.x = filter_name_input.x;
			filter_author_input.y = filter_author_label.y;
			filter_author_input.addEventListener(KeyboardEvent.KEY_UP, filteInputKeyUp);
			
			var filter_topic_label:TextField = addLabel("Topic", 0x5A7582);
			filter_holder.addChild(filter_topic_label);
			filter_topic_label.x = filter_author_label.x;
			filter_topic_label.y = filter_author_input.y + filter_name_input.height + 10;
			filter_topic_input = addInputField("filter_author_input", "", 150, 20);
			filter_holder.addChild(filter_topic_input);
			filter_topic_input.x = filter_author_input.x;
			filter_topic_input.y = filter_topic_label.y;
			filter_topic_input.addEventListener(KeyboardEvent.KEY_UP, filteInputKeyUp);
			
			
			add_dialog_btn = new Btn("+ Add dialog",100,25,13,0xFFFFFF,true,0xA7582,1,0,0xFF0000,1,0xFFFFFF,0x89AFC2,0x00FF00,10);
			dialogs_control_middle.addChild(add_dialog_btn);
			add_dialog_btn.x = 20;
			add_dialog_btn.y = 0;
			add_dialog_btn.addEventListener(MouseEvent.CLICK, addDialogBtnClick);
			
			new_dialog_name_input = addInputField("new_dialog_name_input", "", 150, 20);
			new_dialog_name_input.maxChars = 25;
			dialogs_control_middle.addChild(new_dialog_name_input);
			new_dialog_name_input.x = 130;
			new_dialog_name_input.y = 0;
			
			
			drawMask();
			updateDialogsControlSize();
			updateMask();
			//showHideDialogsControl();

			dialogs_list_holder = new Sprite;
			dialogs_control_middle.addChild(dialogs_list_holder);
			dialogs_list_holder.x = 20;
			dialogs_control_middle.addChild(shIcon);

			dialogs_list_holder_mask.graphics.beginFill(0xFF0000);
			dialogs_list_holder_mask.graphics.drawRect(0, 0, 1, 1);
			dialogs_list_holder_mask.graphics.endFill();
			dialogs_list_holder.mask = dialogs_list_holder_mask;
			dialogs_list_holder_mask.width = menu_item_width + 1;
			dialogs_list_holder_mask.x = dialogs_list_holder.x;
			dialogs_control_middle.addChild(dialogs_list_holder_mask);
			db.getAllDialogs(createDialogListItems);
			
			updateDialogsListMask();	
		}
		
		
		private function filteInputKeyUp(event:KeyboardEvent):void {
          	refresh_filter_timer.stop();
			refresh_filter_timer.removeEventListener(TimerEvent.TIMER, refreshFilter);
			refresh_filter_timer.addEventListener(TimerEvent.TIMER, refreshFilter);
			refresh_filter_timer.start();
        }
		
		private function refreshFilter(evt:TimerEvent):void {
			refresh_filter_timer.stop();
			refresh_filter_timer.removeEventListener(TimerEvent.TIMER, refreshFilter);
            refreshDialogList();
		}
		
		private  function drawRoundRect(spr:Sprite, w:Number , h:Number, tl:Number, tr:Number, bl:Number, br:Number, thick:Number, borderColor:Number, bgColor:Number, trans:Number ):void {
			if (thick != 0) spr.graphics.lineStyle(thick, borderColor);
			spr.graphics.beginFill(bgColor, trans);
			spr.graphics.moveTo( 0, tl );
			spr.graphics.curveTo( 0, 0, tl, 0 );
			spr.graphics.lineTo(w - tr, 0);
			spr.graphics.curveTo( w, 0, w, tr );
			spr.graphics.lineTo(w, h - br);
			spr.graphics.curveTo( w, h, w - br, h );
			spr.graphics.lineTo(bl, h);
			spr.graphics.curveTo( 0, h, 0, h - bl );
			spr.graphics.endFill();
		}
		
		private function updateDialogsListMask():void {
			dialogs_list_holder_mask.height =  dialogs_control_middle_background.height - 210;
			filter_holder.x = 20;
			filter_holder.y = dialogs_list_holder_mask.y + dialogs_list_holder_mask.height + 20;
			add_dialog_btn.y = filter_holder.y + filter_holder.height + 15;
			new_dialog_name_input.y = filter_holder.y + filter_holder.height + 18;
			
		}
		
		public function createDialogListItems(r:Object): void {
			if (r == false) {
				trace("Error reading records. Nr5");
			}else {
				for (var index:String in r) {
					var y_val:Number = int(index) * menu_item_height;
					var x_val:Number = 0;
					var is_locked:Boolean = true;
					var ids_array:Array = r[index].editors_ids.split(",")
					trace(ids_array);

					if (r[index].created_by==holder.current_user_id || holder.current_user_is_admin =="Y" || valueIsInArray(holder.current_user_id, ids_array)) {
						is_locked = false;
					}
					createDialogListItem(dialogs_list_holder, "menu_" + r[index].id, r[index].name+" ("+r[index].count+")", x_val, y_val, menu_item_width, menu_item_height,false,is_locked,r[index].created_by_username); 	
				}
				slider = new Slidebar(dialogs_list_holder_mask,dialogs_list_holder);
				dialogs_control_middle.addChild(slider);
			}
		}
		
		
		private function valueIsInArray(value:Object, arr:Array):Boolean {
			for (var i:uint=0; i < arr.length; i++) {
				if (arr[i]==value) {
					return true;
				}
			}
			return false;
		}
		
		public function refreshDialogList(): void {
			var params:Object = {"name":filter_name_input.text,"created_by":filter_author_input.text,"topic":filter_topic_input.text}
			db.filterAllDialogs(filterAllDialogsResult,params);
		}
		
		public function filterAllDialogsResult(r:Object): void {
			if (r == false) {
				trace("Error reading records. Nr6");
			}else {
				while (dialogs_list_holder.numChildren > 0) {
					dialogs_list_holder.removeChildAt(0);
				}
				for (var index:String in r) {
					var y_val:Number = int(index) * menu_item_height;
					var x_val:Number = 0;
					var is_active:Boolean = false;
					if (("menu_" + r[index].id)==selected_item_name) {
						is_active = true;	
					}
					var is_locked:Boolean = true;
					if (r[index].created_by==holder.current_user_id || holder.current_user_is_admin =="Y" ) {
						is_locked = false;
					}
					createDialogListItem(dialogs_list_holder, "menu_" + r[index].id, r[index].name+" ("+r[index].count+")", x_val, y_val, menu_item_width, menu_item_height,is_active,is_locked,r[index].created_by_username); 	
				}
				if (slider) {
					slider.updateSliderbar();
				}
			}
		}
		
		
		
		private function createDialogListItem(items_holder:Sprite, menu_item_name:String, menu_text:String, x_position:Number, y_position:Number, width_val:Number, height_val:Number, is_active:Boolean = false, is_locked:Boolean = false,created_by:String=""): void {
			var item_mc:Sprite = new Sprite();
			items_holder.addChild(item_mc);
			item_mc.buttonMode = true;
			item_mc.name = menu_item_name;
			item_mc.x = x_position;
			item_mc.y = y_position;
			var mc_default:Sprite = new Sprite();
			item_mc.addChild(mc_default);
			mc_default.name = "mc_default";
			mc_default.graphics.lineStyle(1,0x5A7582);
			mc_default.graphics.drawRect(0,0,width_val,height_val);
			mc_default.mouseEnabled = false;
			var mc_hover:Sprite = new Sprite();
			item_mc.addChild(mc_hover);
			mc_hover.name = "mc_hover";
			mc_hover.graphics.lineStyle(1,0x5A7582);
			mc_hover.graphics.beginFill(0xffffff);
			mc_hover.graphics.drawRect(0,0,width_val,height_val);
			mc_hover.graphics.endFill();
			mc_hover.mouseEnabled = false;
			mc_hover.visible = false;
			mc_hover.alpha = 0.5;
			var mc_active:Sprite = new Sprite();
			item_mc.addChild(mc_active);
			mc_active.name = "mc_active";
			mc_active.graphics.beginFill(0xc5e7d0);
			mc_active.graphics.drawRect(1,1,width_val-1,height_val-1);
			mc_active.graphics.endFill();
			mc_active.mouseEnabled = false;
			if (is_active == true) {
				mc_active.visible = true;
			}else {
				mc_active.visible = false;
			}
			mc_active.alpha = 1;
			var menu_txt:TextField = new TextField(); 
			item_mc.addChild(menu_txt);
			var format1:TextFormat = new TextFormat();
			format1.font="Arial";
			format1.size = 12;
			format1.bold = true;
			format1.color = 0x5A7582;
			menu_txt.text = menu_text;  
			menu_txt.name = "menu_txt";
			menu_txt.setTextFormat(format1);
			menu_txt.width = width_val-5;
			menu_txt.height = height_val; 
			menu_txt.x = 5;
			menu_txt.selectable = false;  
			menu_txt.mouseEnabled = false;
			
			
			var menu_txt2:TextField = new TextField(); 
			item_mc.addChild(menu_txt2);
			var format2:TextFormat = new TextFormat();
			format2.font="Arial";
			format2.size = 9;
			format2.bold = false;
			format2.color = 0x5A7582;
			if (created_by == "" || created_by ==null) {
				menu_txt2.text ="created by unknown";  	
			}else {
				menu_txt2.text = "created by "+created_by ; 
			}
			
			menu_txt2.name = "menu_txt";
			menu_txt2.setTextFormat(format2);
			menu_txt2.width = width_val-5;
			menu_txt2.height = 15; 
			menu_txt2.x = 5;
			menu_txt2.y = 14;
			menu_txt2.selectable = false;  
			menu_txt2.mouseEnabled = false;
			
			
			
			
			
			if(is_locked==true){
				var lock_icon:LockIcon = new LockIcon;
				lock_icon.name = "lock_"+menu_item_name;
				items_holder.addChild(lock_icon);
				lock_icon.mouseEnabled = false;
				lock_icon.x = item_mc.x + item_mc.width - lock_icon.width;
				lock_icon.y = item_mc.y + item_mc.height - lock_icon.height + 2;
			}else {
				item_mc.addEventListener(MouseEvent.CLICK, itemMcClick);
			}
			item_mc.addEventListener(MouseEvent.ROLL_OVER, itemMcRollOver);
			item_mc.addEventListener(MouseEvent.ROLL_OUT, itemMcRollOut);
		}
		
		public function checkItem(item_name:String):void {
			var obj:Object = dialogs_list_holder.getChildByName(item_name);
			var active_obj:Sprite = obj.getChildByName("mc_active");
			active_obj.visible = true;
			selected_item_name = item_name;
		}
		
		public function uncheckItems():void{
			for (var k:uint = 0; k < dialogs_list_holder.numChildren; k++) {
				var obj:Object = dialogs_list_holder.getChildAt(k);
				var obj_name_array:Array = obj.name.split("_");
				if (obj_name_array[0] == "menu") {
					var active_obj:Sprite = obj.getChildByName("mc_active");
					active_obj.visible = false;
				}
			}
		}
		

		private function addDialogBtnClick(event:MouseEvent):void{
			addDialog();
		}
		
		public function addDialog():void {
			var params:Object = {"name":new_dialog_name_input.text, "created_by":holder.current_user_id, "last_modified_by":holder.current_user_id };
			db.addDialog(addDialogResult, params);
		}
		
		public function addDialogResult(r:Object): void {
			if (r == false) {
				trace("Error reading records. Nr4");
			}else {
				refreshDialogList();
			}
			
		}
		
		private function itemMcRollOver(event:MouseEvent):void{
			var hover_obj:Sprite = event.target.getChildByName("mc_hover");
			hover_obj.visible = true;
		}
		
		private function itemMcRollOut(event:MouseEvent):void{
			var hover_obj:Sprite = event.target.getChildByName("mc_hover");
			hover_obj.visible = false;
		}
		
		private function itemMcClick(event:MouseEvent):void {
			uncheckItems();
			checkItem(event.target.name);
			var obj_name_array:Array = event.target.name.split("_");
			holder.current_dialog_id = obj_name_array[1];
			holder.loadDialogNodes(obj_name_array[1]);
		}
		
		private function onMouseClickDialogsControl(event:Event):void  {
			showHideDialogsControl();
		}
		
		private function showHideDialogsControl():void  {
			if (dialogs_control_middle.x==0) {
				dialogs_control_top.x = -dialogs_control_middle.width + 20;
				dialogs_control_middle.x = -dialogs_control_middle.width + 20;
				dialogs_control_bottom.x = -dialogs_control_middle.width + 20;
				dialogs_control_mask.width = 20;
			}else {
				dialogs_control_top.x = 0;
				dialogs_control_middle.x = 0;
				dialogs_control_bottom.x = 0;
				dialogs_control_mask.width = dialogs_control_width;
			}
		}
		
		private function drawMask():void {
			var rectangle:Shape = new Shape; // initializing the variable named rectangle
			rectangle.graphics.beginFill(0xFFFFFF); // choosing the colour for the fill, here it is red
			rectangle.graphics.drawRect(0, 0, dialogs_control_width,dialogs_control_bottom.y+dialogs_control_bottom.height); // (x spacing, y spacing, width, height)
			rectangle.graphics.endFill(); // not always needed but I like to put it in to end the fill
			dialogs_control_mask.addChild(rectangle); // adds the rectangle to the stage
		}
		
		private function updateMask():void {
			dialogs_control_mask.height = dialogs_control_bottom.y + dialogs_control_bottom.height;
		}
		
		private function drawTop():void {
			drawRoundRect(dialogs_control_top_background, dialogs_control_width, padding_top, 0, 20, 0, 0, 0, 0x000000, 0xFFFFFF, 0.9);
		}
		
		private function drawMiddle():void {
			var rectangle:Shape = new Shape;
			rectangle.graphics.beginFill(0xFFFFFF,0.9);
			rectangle.graphics.drawRect(0, 0, dialogs_control_width,holder.size.height-2*margin-padding_top-padding_bottom);
			rectangle.graphics.endFill();
			dialogs_control_middle_background.addChild(rectangle);
		}
		
		private function drawBottom():void {
			drawRoundRect(dialogs_control_bottom_background, dialogs_control_width, padding_bottom, 0, 0, 0, 20, 0, 0x000000, 0xFFFFFF, 0.9);
		}
		
		public function updateDialogsControlSize():void {
			dialogs_control_middle.y = dialogs_control_top.height;
			var current_height:Number;
			var min_current_height:Number;
			current_height = holder.size.height - 2 * margin - padding_top - padding_bottom;
			min_current_height = min_height - 2 * margin - padding_top - padding_bottom;
			dialogs_control_middle_background.height = (current_height < min_current_height ? min_current_height : current_height);
			dialogs_control_bottom.y = dialogs_control_middle.y + dialogs_control_middle_background.height;
			shIcon.x = dialogs_control_width - shIcon.width + 3;
			shIcon.y = dialogs_control_middle_background.height / 2 - shIcon.height / 2;
			updateMask();
			updateDialogsListMask();
			if (slider) {
				slider.updateSliderbar();
			}
		}
		
		private function addInputField(input_name:String,input_text:String,input_text_width:Number=200,input_text_height:Number=30):TextField{
			var t_format:TextFormat = new TextFormat();
			t_format.font="Arial";
			t_format.size = 14;
			t_format.color = 0x5A7582;
			t_format.leftMargin = 5;
			t_format.rightMargin = 5;
			var textBox:TextField = new TextField()
			textBox.name = input_name;
			textBox.width = input_text_width;
			textBox.height = input_text_height;
			textBox.border = true;
			textBox.borderColor = 0x5A7582;
			textBox.type = "input";
			textBox.defaultTextFormat = t_format;
			textBox.setTextFormat(t_format);
			textBox.text = input_text;
			textBox.background = true;
			return textBox;
		}
		
		private function addLabel(label_text:String = "", label_text_color:Number = 0x00FF00):TextField {
			var obj_txt:TextField = new TextField(); 
			var format1:TextFormat = new TextFormat();
			format1.font="Arial";
			format1.size = 14;
			format1.color = label_text_color;
			format1.bold = true;
			//obj_txt.autoSize = "left";
			obj_txt.text = label_text;  
			obj_txt.name = "text_field";
			obj_txt.defaultTextFormat = format1;
			obj_txt.setTextFormat(format1);
			obj_txt.selectable = false;  
			obj_txt.mouseEnabled = false;
			obj_txt.autoSize = "left";
			return obj_txt;
		}
		
		
	}
}