package dm.builder.interfaces.tools.dialogeditor  
{
	/**
	 * ...
	 * @author Darius Dauskurdis dariusdxd@gmail.com
	 */
	
	import dm.builder.interfaces.FunctionsAndConditions;
	import fl.controls.List;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class NodeEditor extends Sprite 
	{
		public var db:DataBase;
		public var current_dialog_id:Number;
		public var current_user_id:Number;
		public var current_user_username:String;
		public var current_user_is_admin:String;
		public var bg_holder:Sprite;
		public var opacity_value:Number = 0.5;
		public var bgcolor:Number = 0xFFFFFF;
		public var node_editor_bg_holder:Sprite;
		public var node_editor_holder:Sprite;
		public var node_editor_bg_holder2:Sprite;
		public var node_editor_bg_holder2b:Sprite;
		public var node_editor_holder2:Sprite;
		public var node_editor_holder2b:Sprite;
		public var node_editor_bg_holder3:Sprite;
		public var node_editor_holder3:Sprite;
		public var is_active:Boolean=true;
		private var holder:*;
		public var dialogs_control:Object;
		public var current_node:Object = new Object;
		public var close_btn_1:CloseBtn;
		public var close_btn_2:CloseBtn;
		public var close_btn_2b:CloseBtn;
		public var close_btn_3:CloseBtn;
		public var add_btn:Btn;
		public var cancel_btn_1:Btn;
		public var cancel_btn_2:Btn;
		public var cancel_btn_2b:Btn;
		public var cancel_btn_3:Btn;
		public var save_btn:Btn;
		public var save_btnb:Btn;
		public var delete_btn:Btn;
		public var delete_node_text:String = "Do you really want to delete this phrase?";
		public var delete_dialog_text:String = "Do you really want to delete this dialog and its phrases?";
		public var subject_label_text:String = "Subject:"; 
		public var subject_input_field:TextField;
		public var subject_label:TextField;
		public var delete_label:TextField;
		public var tabs_control:TabsControl;
		public var tabs_controlb:TabsControl;
		public var cnt1:Sprite;
		public var cnt2:Sprite;
		public var cnt3:Sprite;
		public var cnt1b:Sprite;
		public var cnt2b:Sprite;
		public var cnt3b:Sprite;
		public var id_f:TextField;
		public var id_fb:TextField;
		public var title_f:TextField;
		public var topic_f:TextField;
		public var subject_f:TextField;
		public var priority_f:TextField;
		public var phrase_f:TextField;
		public var created_date_f:TextField;
		public var created_by_f:TextField;
		public var last_modified_date_f:TextField;
		public var last_modified_by_f:TextField;
		public var created_date_fb:TextField;
		public var created_by_fb:TextField;
		public var last_modified_date_fb:TextField;
		public var last_modified_by_fb:TextField;
		public var users_array:Array = new Array();
		public var users_list_holder:Sprite;
		public var users_list_holder_mask:Sprite;
		public var user_list_item_width:Number = 315;
		public var user_list_item_height:Number = 30;
		public var slider:Slidebar;
		public var slider2:Slidebar;
		public var copy_dialog_nodes_area:Sprite;
		public var dialogs_list_to_copy_holder:Sprite;
		public var dialogs_list_to_copy:Sprite;
		public var dialogs_list_to_copy_mask:Sprite;
		public var dialogs_list_item_width:Number = 312;
		public var dialogs_list_item_height:Number = 16;
		public var copy_from_id:Number = -1;
		private var func_and_cond:FunctionsAndConditions;
		
		public function NodeEditor() {
			this.addEventListener(Event.ADDED, thisWasAdded);		
		}
		
		private function thisWasAdded(e:Event):void {
			this.removeEventListener(Event.ADDED, thisWasAdded);
			holder = this.parent;
			dialogs_control = holder.getChildByName("DialogsControl");
			db = new DataBase(holder.gateway);
			current_user_id = holder.current_user_id;
			current_user_username = holder.current_user_username;
			current_user_is_admin = holder.current_user_is_admin;
			bg_holder = new Sprite();
			bg_holder.graphics.beginFill(bgcolor);
			bg_holder.graphics.drawRect(0,0,1,1);
			bg_holder.graphics.endFill();
			bg_holder.alpha = opacity_value;
			this.addChild(bg_holder);
			node_editor_holder = new Sprite();
			this.addChild(node_editor_holder);
			node_editor_bg_holder = new Sprite();
			node_editor_holder.addChild(node_editor_bg_holder);
			drawRoundRect(node_editor_bg_holder, 500, 200, 20, 20, 20, 20, 0, 0x000000, 0xFFFFFF, 1);
			var popup_title_1:Sprite = new Sprite();
			node_editor_holder.addChild(popup_title_1);
			popupTitle(popup_title_1, "Add child node", 16, 0x5A7582);
			popup_title_1.x = 20;
			popup_title_1.y = 15;
			subject_label = addLabel(subject_label_text, 0x5A7582);
			node_editor_holder.addChild(subject_label);
			subject_label.x = 20;
			subject_label.y = 70;
			subject_input_field = addInputField("subject_input_field_1", "(unknown)", 379, 20);
			node_editor_holder.addChild(subject_input_field);
			subject_input_field.x = 100;
			subject_input_field.y = 70;
			cancel_btn_1 = new Btn("Cancel",150,30,15,0xFFFFFF,true,0xA7582,1,0,0xFF0000,1,0xFFFFFF,0x89AFC2,0x00FF00,10);
			node_editor_holder.addChild(cancel_btn_1);
			cancel_btn_1.x = 80;
			cancel_btn_1.y = node_editor_holder.height - 20 - cancel_btn_1.height;
			cancel_btn_1.addEventListener(MouseEvent.CLICK, onClickCloseBtn);
			add_btn = new Btn("Add",150,30,15,0xFFFFFF,true,0xA7582,1,0,0xFF0000,1,0xFFFFFF,0x89AFC2,0x00FF00,10);
			node_editor_holder.addChild(add_btn);
			add_btn.x = cancel_btn_1.x + 180;
			add_btn.y = node_editor_holder.height - 20 - add_btn.height;
			add_btn.addEventListener(MouseEvent.CLICK, onClickAddBtn);
			close_btn_1 = new CloseBtn();
			node_editor_holder.addChild(close_btn_1);
			close_btn_1.x = node_editor_bg_holder.width - close_btn_1.width - 10;
			close_btn_1.y = close_btn_1.height + 5;
			close_btn_1.addEventListener(MouseEvent.CLICK, onClickCloseBtn);
			node_editor_holder.visible = false;
			//---------------------------------------------------------------
			node_editor_holder2 = new Sprite();
			this.addChild(node_editor_holder2);
			node_editor_bg_holder2 = new Sprite();
			node_editor_holder2.addChild(node_editor_bg_holder2);
			drawRoundRect(node_editor_bg_holder2, 500, 600, 20, 20, 20, 20, 0, 0x000000, 0xFFFFFF, 1);
			var popup_title_2:Sprite = new Sprite();
			node_editor_holder2.addChild(popup_title_2);
			popupTitle(popup_title_2, "Edit node", 16, 0x5A7582);
			popup_title_2.x = 20;
			popup_title_2.y = 15;
			tabs_control = new TabsControl;
			node_editor_holder2.addChild(tabs_control);
			tabs_control.x = 20;
			tabs_control.y = 70;
			
			var options_icon:OptionsIcon = new OptionsIcon;
			var users_icon:UsersIcon = new UsersIcon;
			var info_icon:InfoIcon = new InfoIcon;
			cnt1 = new Sprite();
			var id_label:TextField = addLabel("ID:", 0x5A7582);
			cnt1.addChild(id_label);
			id_label.visible = false;
			id_f = addInputField("id_f"," ",200,20,"static");
			cnt1.addChild(id_f);
			id_f.visible = false;
			id_f.y = id_label.y + id_label.height + 5;
			var title_label:TextField = addLabel("TITLE:", 0x5A7582);
			cnt1.addChild(title_label);
			//title_label.y = id_f.y + id_f.height + 20;
			title_label.y = 0;
			title_f = addInputField("title_f"," ",330,20,"input");
			cnt1.addChild(title_f);
			title_f.y = title_label.y + title_label.height + 5;
			var topic_label:TextField = addLabel("TOPIC:", 0x5A7582);
			cnt1.addChild(topic_label);
			topic_label.y = title_f.y + title_f.height + 20;
			topic_f = addInputField("topic_f"," ",330,20,"input");
			cnt1.addChild(topic_f);
			topic_f.y = topic_label.y + topic_label.height + 5;
			
			copy_dialog_nodes_area = new Sprite();
			copy_dialog_nodes_area.y = topic_f.y + topic_f.height + 20;
			cnt1.addChild(copy_dialog_nodes_area);
			copy_dialog_nodes_area.visible = false;
			var copy_phrases_label:TextField = addLabel("COPY PHRASES FROM:", 0x5A7582);
			copy_dialog_nodes_area.addChild(copy_phrases_label);
			copy_phrases_label.y = 0;

			dialogs_list_to_copy_holder = new Sprite;
			dialogs_list_to_copy_holder.y = copy_phrases_label.y + copy_phrases_label.height + 5;
			
			dialogs_list_to_copy = new Sprite;
			dialogs_list_to_copy_holder.addChild(dialogs_list_to_copy);
			
			copy_dialog_nodes_area.addChild(dialogs_list_to_copy_holder);
			dialogs_list_to_copy_mask = new Sprite;
			dialogs_list_to_copy_holder.addChild(dialogs_list_to_copy_mask);
			dialogs_list_to_copy_mask.graphics.beginFill(0xFF0000);
			dialogs_list_to_copy_mask.graphics.drawRect(0, 0, 1, 1);
			dialogs_list_to_copy_mask.graphics.endFill();
			//dialogs_list_to_copy_holder.mask = dialogs_list_to_copy_mask;
			dialogs_list_to_copy_mask.width = dialogs_list_item_width;
			dialogs_list_to_copy_mask.height = 270;
			dialogs_list_to_copy_mask.x = 0;
			dialogs_list_to_copy_mask.y = 0;
			
			
			cnt2 = new Sprite();
			var users_list_label:TextField = addLabel("EDITORS LIST:", 0x5A7582);
			cnt2.addChild(users_list_label);
			users_list_holder = new Sprite;
			cnt2.addChild(users_list_holder);
			users_list_holder.name="users_list_holder";
			users_list_holder.y = users_list_label.y + users_list_label.height + 5;
			users_list_holder_mask = new Sprite;
			users_list_holder_mask.graphics.beginFill(0xFF0000,0.5);
			users_list_holder_mask.graphics.drawRect(0, 0, 1, 1);
			users_list_holder_mask.graphics.endFill();
			users_list_holder.mask = users_list_holder_mask;
			users_list_holder_mask.x = 0;
			users_list_holder_mask.y = 25;
			users_list_holder_mask.width = user_list_item_width+1;
			users_list_holder_mask.height = 391;
			cnt2.addChild(users_list_holder_mask);
			//------------------------------------------------------
			cnt3 = new Sprite();
			var created_date_label:TextField = addLabel("CREATED DATE:", 0x5A7582);
			cnt3.addChild(created_date_label);
			created_date_f = addInputField("created_date_f"," ",200,20,"static");
			cnt3.addChild(created_date_f);
			created_date_f.y = created_date_label.y + created_date_label.height + 5;
			
			var created_by_label:TextField = addLabel("CREATED BY:", 0x5A7582);
			cnt3.addChild(created_by_label);
			created_by_label.y = created_date_f.y + created_date_f.height + 20;
			created_by_f = addInputField("created_by_f"," ",200,20,"static");
			cnt3.addChild(created_by_f);
			created_by_f.y = created_by_label.y + created_by_label.height + 5;
			
			var last_modified_date_label:TextField = addLabel("LAST MODIFIED DATE:", 0x5A7582);
			cnt3.addChild(last_modified_date_label);
			last_modified_date_label.y = created_by_f.y + created_by_f.height + 20;
			last_modified_date_f = addInputField("last_modified_date_f"," ",200,20,"static");
			cnt3.addChild(last_modified_date_f);
			last_modified_date_f.y = last_modified_date_label.y + last_modified_date_label.height + 5;
			
			var last_modified_by_label:TextField = addLabel("LAST MODIFIED BY:", 0x5A7582);
			cnt3.addChild(last_modified_by_label);
			last_modified_by_label.y = last_modified_date_f.y + last_modified_date_f.height + 20;
			last_modified_by_f = addInputField("last_modified_by_f"," ",200,20,"static");
			cnt3.addChild(last_modified_by_f);
			last_modified_by_f.y = last_modified_by_label.y + last_modified_by_label.height + 5;
			
			tabs_control.addTab(options_icon,cnt1);
			tabs_control.addTab(users_icon,cnt2);
			tabs_control.addTab(info_icon,cnt3);

			cancel_btn_2 = new Btn("Cancel",150,30,15,0xFFFFFF,true,0xA7582,1,0,0xFF0000,1,0xFFFFFF,0x89AFC2,0x00FF00,10);
			node_editor_holder2.addChild(cancel_btn_2);
			cancel_btn_2.x = 80;
			cancel_btn_2.y = node_editor_holder2.height - 20 - cancel_btn_2.height;
			cancel_btn_2.addEventListener(MouseEvent.CLICK, onClickCloseBtn);
			save_btn = new Btn("Save",150,30,15,0xFFFFFF,true,0xA7582,1,0,0xFF0000,1,0xFFFFFF,0x89AFC2,0x00FF00,10);
			node_editor_holder2.addChild(save_btn);
			save_btn.x = cancel_btn_2.x + 180;
			save_btn.y = node_editor_holder2.height - 20 - save_btn.height;
			save_btn.addEventListener(MouseEvent.CLICK, onClickSaveBtn);
			close_btn_2 = new CloseBtn();
			node_editor_holder2.addChild(close_btn_2);
			close_btn_2.x = node_editor_bg_holder2.width - close_btn_2.width - 10;
			close_btn_2.y = close_btn_2.height + 5;
			close_btn_2.addEventListener(MouseEvent.CLICK, onClickCloseBtn);
			node_editor_holder2.visible = false;
			//--------------------------------------------------
			node_editor_holder2b = new Sprite();
			this.addChild(node_editor_holder2b);
			node_editor_bg_holder2b = new Sprite();
			node_editor_holder2b.addChild(node_editor_bg_holder2b);
			drawRoundRect(node_editor_bg_holder2b, 500, 600, 20, 20, 20, 20, 0, 0x000000, 0xFFFFFF, 1);
			var popup_title_2b:Sprite = new Sprite();
			node_editor_holder2b.addChild(popup_title_2b);
			popupTitle(popup_title_2b, "Edit node", 16, 0x5A7582);
			popup_title_2b.x = 20;
			popup_title_2b.y = 15;
			tabs_controlb = new TabsControl;
			node_editor_holder2b.addChild(tabs_controlb);
			tabs_controlb.x = 20;
			tabs_controlb.y = 70;
			
			cnt1b = new Sprite();
			var id_labelb:TextField = addLabel("ID:", 0x5A7582);
			cnt1b.addChild(id_labelb);
			id_fb = addInputField("id_fb","152745",200,20,"static");
			cnt1b.addChild(id_fb);
			id_fb.y = id_labelb.y + id_labelb.height + 5;
			
			var subject_label:TextField = addLabel("SUBJECT:", 0x5A7582);
			cnt1b.addChild(subject_label);
			subject_label.y = id_fb.y + id_fb.height + 20;
			subject_f = addInputField("subject_f","ddddddd",330,20,"input");
			cnt1b.addChild(subject_f);
			subject_f.y = subject_label.y + subject_label.height + 5;
			
			var priority_label:TextField = addLabel("PRIORITY:", 0x5A7582);
			cnt1b.addChild(priority_label);
			priority_label.y = subject_f.y + subject_f.height + 20;
			priority_f = addInputField("priority_f","ffff",330,20,"input");
			cnt1b.addChild(priority_f);
			priority_f.y = priority_label.y + priority_label.height + 5;
			
			var phrase_label:TextField = addLabel("PHRASE:", 0x5A7582);
			cnt1b.addChild(phrase_label);
			phrase_label.y = priority_f.y + priority_f.height + 20;
			phrase_f = addInputField("phrase_f","ffff",330,190,"input");
			cnt1b.addChild(phrase_f);
			phrase_f.y = phrase_label.y + phrase_label.height + 5;

			cnt2b = new Sprite();
			func_and_cond = new FunctionsAndConditions(cnt2b, new Point(0, 0));
			func_and_cond.movable = false;
			func_and_cond.hideButtons();
			
			cnt3b = new Sprite();
			var created_date_labelb:TextField = addLabel("CREATED DATE:", 0x5A7582);
			cnt3b.addChild(created_date_labelb);
			created_date_fb = addInputField("created_date_fb"," ",200,20,"static");
			cnt3b.addChild(created_date_fb);
			created_date_fb.y = created_date_labelb.y + created_date_labelb.height + 5;
			
			var created_by_labelb:TextField = addLabel("CREATED BY:", 0x5A7582);
			cnt3b.addChild(created_by_labelb);
			created_by_labelb.y = created_date_fb.y + created_date_fb.height + 20;
			created_by_fb = addInputField("created_by_fb"," ",200,20,"static");
			cnt3b.addChild(created_by_fb);
			created_by_fb.y = created_by_labelb.y + created_by_labelb.height + 5;
			
			var last_modified_date_labelb:TextField = addLabel("LAST MODIFIED DATE:", 0x5A7582);
			cnt3b.addChild(last_modified_date_labelb);
			last_modified_date_labelb.y = created_by_fb.y + created_by_fb.height + 20;
			last_modified_date_fb = addInputField("last_modified_date_fb"," ",200,20,"static");
			cnt3b.addChild(last_modified_date_fb);
			last_modified_date_fb.y = last_modified_date_labelb.y + last_modified_date_labelb.height + 5;
			
			var last_modified_by_labelb:TextField = addLabel("LAST MODIFIED BY:", 0x5A7582);
			cnt3b.addChild(last_modified_by_labelb);
			last_modified_by_labelb.y = last_modified_date_fb.y + last_modified_date_fb.height + 20;
			last_modified_by_fb = addInputField("last_modified_by_fb"," ",200,20,"static");
			cnt3b.addChild(last_modified_by_fb);
			last_modified_by_fb.y = last_modified_by_labelb.y + last_modified_by_labelb.height + 5;
			
			var options_icon2:OptionsIcon = new OptionsIcon;
			var functions_icon:FunctionsIcon = new FunctionsIcon;
			var conditions_icon:ConditionsIcon = new ConditionsIcon;
			var info_icon2:InfoIcon = new InfoIcon;
			tabs_controlb.addTab(options_icon2,cnt1b);
			tabs_controlb.addTab(functions_icon,cnt2b);
			tabs_controlb.addTab(info_icon2,cnt3b);

			
			cancel_btn_2b = new Btn("Cancel",150,30,15,0xFFFFFF,true,0xA7582,1,0,0xFF0000,1,0xFFFFFF,0x89AFC2,0x00FF00,10);
			node_editor_holder2b.addChild(cancel_btn_2b);
			cancel_btn_2b.x = 80;
			cancel_btn_2b.y = node_editor_holder2.height - 20 - cancel_btn_2b.height;
			cancel_btn_2b.addEventListener(MouseEvent.CLICK, onClickCloseBtn);
			save_btnb = new Btn("Save",150,30,15,0xFFFFFF,true,0xA7582,1,0,0xFF0000,1,0xFFFFFF,0x89AFC2,0x00FF00,10);
			node_editor_holder2b.addChild(save_btnb);
			save_btnb.x = cancel_btn_2b.x + 180;
			save_btnb.y = node_editor_holder2b.height - 20 - save_btnb.height;
			save_btnb.addEventListener(MouseEvent.CLICK, onClickSaveBtn);
			close_btn_2b = new CloseBtn();
			node_editor_holder2b.addChild(close_btn_2b);
			close_btn_2b.x = node_editor_bg_holder2b.width - close_btn_2b.width - 10;
			close_btn_2b.y = close_btn_2b.height + 5;
			close_btn_2b.addEventListener(MouseEvent.CLICK, onClickCloseBtn);
			node_editor_holder2b.visible = false;
			//--------------------------------------------------
			node_editor_holder3 = new Sprite();
			this.addChild(node_editor_holder3);
			node_editor_bg_holder3 = new Sprite();
			node_editor_holder3.addChild(node_editor_bg_holder3);
			drawRoundRect(node_editor_bg_holder3, 500, 200, 20, 20, 20, 20, 0, 0x000000, 0xFFFFFF, 1);
			var popup_title_3:Sprite = new Sprite();
			node_editor_holder3.addChild(popup_title_3);
			popupTitle(popup_title_3, "Delete node", 16, 0x5A7582);
			popup_title_3.x = 20;
			popup_title_3.y = 15;
			delete_label = addLabel("", 0x5A7582);
			node_editor_holder3.addChild(delete_label);
			delete_label.x = 20;
			delete_label.y = 70;
			
			
			cancel_btn_3 = new Btn("Cancel",150,30,15,0xFFFFFF,true,0xA7582,1,0,0xFF0000,1,0xFFFFFF,0x89AFC2,0x00FF00,10);
			node_editor_holder3.addChild(cancel_btn_3);
			cancel_btn_3.x = 80;
			cancel_btn_3.y = node_editor_holder3.height - 20 - cancel_btn_3.height;
			cancel_btn_3.addEventListener(MouseEvent.CLICK, onClickCloseBtn);
			
			delete_btn = new Btn("Delete",150,30,15,0xFFFFFF,true,0xA7582,1,0,0xFF0000,1,0xFFFFFF,0x89AFC2,0x00FF00,10);
			node_editor_holder3.addChild(delete_btn);
			delete_btn.x = cancel_btn_3.x + 180;
			delete_btn.y = node_editor_holder3.height - 20 - delete_btn.height;
			delete_btn.addEventListener(MouseEvent.CLICK, onClickDeleteBtn);
			
			
			close_btn_3 = new CloseBtn();
			node_editor_holder3.addChild(close_btn_3);
			close_btn_3.x = node_editor_bg_holder3.width - close_btn_3.width - 10;
			close_btn_3.y = close_btn_3.height + 5;
			close_btn_3.addEventListener(MouseEvent.CLICK, onClickCloseBtn);
			node_editor_holder3.visible = false;
			this.visible = false;
		}
		
		private function addInputField(input_name:String,input_text:String,input_text_width:Number=200,input_text_height:Number=30,type:String="input"):TextField{
			var t_format:TextFormat = new TextFormat();
			t_format.font="Arial";
			t_format.size = 14;
			t_format.color = 0x5A7582;
			if(type=="input"){
				t_format.leftMargin = 5;
				t_format.rightMargin = 5;
			}
			var textBox:TextField = new TextField()
			textBox.name = input_name;
			textBox.width = input_text_width;
			textBox.height = input_text_height;
			if(type=="input"){
				textBox.type = "input";
				textBox.background = true;
				textBox.border = true;
				textBox.borderColor = 0x5A7582;
			}
			textBox.multiline = true;
			textBox.wordWrap = true;
			textBox.defaultTextFormat = t_format;
			textBox.setTextFormat(t_format);
			textBox.text = input_text;
			return textBox;
		}
		
		private function addLabel(label_text:String = "", label_text_color:Number = 0x00FF00):TextField {
			var obj_txt:TextField = new TextField(); 
			var format1:TextFormat = new TextFormat();
			format1.font="Arial";
			format1.size = 14;
			format1.color = label_text_color;
			format1.bold = true;
			obj_txt.autoSize = "left";
			obj_txt.text = label_text;  
			obj_txt.name = "text_field";
			obj_txt.defaultTextFormat = format1;
			obj_txt.setTextFormat(format1);
			obj_txt.selectable = false;  
			obj_txt.mouseEnabled = false;
			return obj_txt;
		}
		
		private function addList(f_name:String,list_width:Number=200,list_height:Number=30):List {
			var aList:List = new List(); 
			aList.name = f_name;
			var width_val:Number = list_width;
			var height_val:Number = list_height;
			aList.setSize(width_val, height_val); 
			return aList; 
		}
		
		private  function popupTitle(spr:Sprite, item_text:String = "unknown", text_size:Number = 16, text_color:Number = 0x00FF00):void {
			var obj_txt:TextField = new TextField(); 
			spr.addChild(obj_txt);
			var format1:TextFormat = new TextFormat();
			format1.font="Arial";
			format1.size = text_size;
			format1.color = text_color;
			format1.bold = true;
			obj_txt.autoSize = "left";
			obj_txt.text = item_text;  
			obj_txt.name = "text_field";
			obj_txt.setTextFormat(format1); 
			obj_txt.x = spr.width/2-obj_txt.width/2;
			obj_txt.y = spr.height/2-obj_txt.height/2;
			obj_txt.selectable = false;  
			obj_txt.mouseEnabled = false;
			spr.graphics.lineStyle(1, 0x5A7582);
			spr.graphics.moveTo(0, obj_txt.y + obj_txt.height + 10);
			spr.graphics.lineTo(460, obj_txt.y + obj_txt.height + 10);
		}
		
		
		private function onClickSaveBtn(event:MouseEvent):void{
			this.visible = false;
			if (current_node.info.type == "dialog") {
				var num:Number = 0;
				var users_ids:String = "";
				for(var i:int=0; i<users_array.length; i++){	

					if (users_array[i] == 1) {
						num++;
						if (num > 1) {
							users_ids += ",";
						}
						users_ids += i;
					}
				}
				var params:Object = {"dialog_id":current_node.info.id, "dialog_title":title_f.text, "last_modified_by":current_user_id, "editors":users_ids, "topic":topic_f.text, "copy_from_id":copy_from_id };
				db.updateDialogInfo(updateDialogInfoResult, params);
			}else {
				var params2:Object = {"id":current_node.info.id,"subject":subject_f.text, "priority":priority_f.text, "phrase":phrase_f.text,"last_modified_by":current_user_id,"f_ids":func_and_cond.getFunctionIds(),"c_ids": func_and_cond.getConditionIds()};
				db.updatePhraseInfo(updatePhraseInfoResult, params2);
			}
		}
		
		public function updatePhraseInfoResult(r:Object): void {
			if (r == false) {
				trace("Error reading records. Nr12");
			}else {
				holder.loadDialogNodes(current_dialog_id);
				dialogs_control.refreshDialogList();
			}
		}
		
		public function updateDialogInfoResult(r:Object): void {
			if (r == false) {
				trace("Error reading records. Nr7");
			}else {
				holder.loadDialogNodes(current_dialog_id);
				dialogs_control.refreshDialogList();
			}
		}
		
		private function onClickDeleteBtn(event:MouseEvent):void{
			this.visible = false;
			var params:Object = { "id":current_node.info.id, "type":current_node.info.type };
			db.deleteNodeFromDatabase(deleteNodeFromDatabaseResult,params);
		}
		
		public function deleteNodeFromDatabaseResult(r:Object): void {
			if (r == false) {
				trace("Error reading records. Nr8");
			}else {
				if (current_node.info.type == "dialog") {
					holder.loadDialogNodes(-1);
				}else {
					holder.loadDialogNodes(current_node.info.dialog_id);
				}
				dialogs_control.refreshDialogList();
			}
		}
		
		private function onClickAddBtn(event:MouseEvent):void{
			this.visible = false;
			var x_val:Number = current_node.x + 40;
			var y_val:Number = current_node.y + 40;
			var xy:String = x_val + "_" + y_val;
			
			var par_id:Number;
			if (current_node.info.type == "dialog") {
				par_id = 0;
			}else {
				par_id = current_node.info.id;
			}
			var params:Object = {"dialog_id":current_node.info.dialog_id, "parent_id":par_id, "subject":subject_input_field.text, "x_y":xy, "author":current_user_id}
			db.addNodeToDatabase(addNodeResult,params);
		}
		
		public function addNodeResult(r:Object): void {
			if (r == false) {
				trace("Error reading records. Nr9");
			}else {
				holder.loadDialogNodes(current_node.info.dialog_id);
				dialogs_control.refreshDialogList();
			}
		}
		
		private function onClickCloseBtn(event:MouseEvent):void{
			this.visible = false;
			is_active = false;
			node_editor_holder.visible = false;
			node_editor_holder2.visible = false;
			node_editor_holder3.visible = false;
		}
		
		public function ShowNodeEditor(node:Object, action:String):void {
			current_dialog_id = holder.current_dialog_id;
			is_active = true;
			this.current_node = node;
			node_editor_holder.visible = false;
			node_editor_holder2.visible = false;
			node_editor_holder2b.visible = false;
			node_editor_holder3.visible = false;
			if ( action == "add") {
				subject_input_field.text = "";
				node_editor_holder.visible = true;
			}else if (action == "edit") {
				if (current_node.info.type == "dialog") {
						
					copy_from_id = -1;
					copy_dialog_nodes_area.visible = false;
					id_f.text = current_node.info.id;
					title_f.text = current_node.info.name;
					topic_f.text = current_node.info.topic;
					created_date_f.text = current_node.info.created_date;
					created_by_f.text = current_node.info.created_by.username;
					last_modified_date_f.text = current_node.info.last_modified_date;
					last_modified_by_f.text = current_node.info.last_modified_by.username;
					
					var tempArray:Array = current_node.info.editors_ids.split(",");
					users_array = [ ];
					for (var index:String in tempArray) {
						users_array[tempArray[index]] = 1;
					}
					db.getAllUsers(getAllUsersResult);	
				}else {
					id_fb.text = current_node.info.id;
					subject_f.text = current_node.info.subject;
					priority_f.text = current_node.info.priority;
					phrase_f.text =unescape(current_node.info.text);
					created_date_fb.text = current_node.info.created_date;
					created_by_fb.text = current_node.info.created_by.username;
					last_modified_date_fb.text = current_node.info.last_modified_date;
					last_modified_by_fb.text = current_node.info.last_modified_by.username;
					func_and_cond.setFunctions(current_node.info.functions);
					func_and_cond.setConditions(current_node.info.conditions);
					tabs_controlb.activateTab(1);
					node_editor_holder2b.visible = true;
				}
			}else if (action == "delete") {
				if (current_node.info.type == "dialog") {
					delete_label.text = delete_dialog_text;
				}else {
					delete_label.text  = delete_node_text;
				}
				node_editor_holder3.visible = true;
			}
			this.visible = true;
		}
		
		
		public function getAllUsersResult(r:Object): void {
			if (r == false) {
				trace("Error reading records. Nr10");
			}else {
				while (users_list_holder.numChildren > 0) {
					users_list_holder.removeChildAt(0);
				}
				//if (current_node.info.created_by.id == current_user_id || current_user_is_admin == "Y") {
					var num:Number = -1;
					for (var index:String in r) {	
						//if(r[index].isadmin != "Y" && r[index].id != current_user_id){
							num++;
							var y_val:Number = num * user_list_item_height;
							var x_val:Number = 0;
							var is_active:Boolean = false;
							createUsersListItem(users_list_holder, "menu_" + r[index].id, r[index].username, x_val, y_val, user_list_item_width, user_list_item_height, false, is_active); 
							if (users_array[r[index].id] == 1) {
								checkItem("menu_" + r[index].id);
							}
						//}
					}
				//}
				var obj:Object = dialogs_list_to_copy_holder.getChildByName("slider");
				if (obj==null) {
					slider = new Slidebar(users_list_holder_mask,users_list_holder);
					cnt2.addChild(slider);
					slider.name = "slider";
				}
				slider.updateSliderbar();
				if (current_node.info.haschilds == true) {
					tabs_control.activateTab(1);
					node_editor_holder2.visible = true;
				}else {
					db.getAllDialogsToCopy(createDialogListItemsToCopy);	
				}
			}
		}
		
		private function createDialogListItemsToCopy(r:Object): void {
			if (r == false) {
				trace("Error reading records. Nr11");
			}else {				
				while (dialogs_list_to_copy.numChildren > 0) {
					dialogs_list_to_copy.removeChildAt(0);
				}
				
				var num2:Number = -1;
				for (var index:String in r) {
					if (current_node.info.id!=r[index].id) {
						num2++;
						var y_val:Number = num2 * dialogs_list_item_height;
						var x_val:Number = 0;
						createDialogListItemToCopy(dialogs_list_to_copy, "menu_" + r[index].id, r[index].name+" ("+r[index].count+")", x_val, y_val, dialogs_list_item_width, dialogs_list_item_height,r[index].created_by_username); 	
					}
				}

				var obj:Object = dialogs_list_to_copy_holder.getChildByName("slider2");
				if (obj==null) {
					slider2 = new Slidebar(dialogs_list_to_copy_mask,dialogs_list_to_copy);
					dialogs_list_to_copy_holder.addChild(slider2);
					slider2.name = "slider2";
				}
				
				slider2.updateSliderbar();
				copy_dialog_nodes_area.visible = true;
				tabs_control.activateTab(1);
				node_editor_holder2.visible = true;
			}
		}

		private function createDialogListItemToCopy(items_holder:Sprite, menu_item_name:String, menu_text:String, x_position:Number, y_position:Number, width_val:Number, height_val:Number,created_by:String=""): void {
			var item_mc2:Sprite = new Sprite();
			items_holder.addChild(item_mc2);
			item_mc2.buttonMode = true;
			item_mc2.name = menu_item_name;
			item_mc2.x = x_position;
			item_mc2.y = y_position;
			var mc_default:Sprite = new Sprite();
			item_mc2.addChild(mc_default);
			mc_default.name = "mc_default";
			mc_default.graphics.lineStyle(1,0x5A7582);
			mc_default.graphics.drawRect(0,0,width_val,height_val);
			mc_default.mouseEnabled = false;
			var mc_hover:Sprite = new Sprite();
			item_mc2.addChild(mc_hover);
			mc_hover.name = "mc_hover";
			mc_hover.graphics.lineStyle(1,0x5A7582);
			mc_hover.graphics.beginFill(0xffffff);
			mc_hover.graphics.drawRect(0,0,width_val,height_val);
			mc_hover.graphics.endFill();
			mc_hover.mouseEnabled = false;
			mc_hover.visible = false;
			mc_hover.alpha = 0.5;
			var mc_active:Sprite = new Sprite();
			item_mc2.addChild(mc_active);
			mc_active.name = "mc_activeb";
			mc_active.graphics.beginFill(0xc5e7d0);
			mc_active.graphics.drawRect(1,1,width_val-1,height_val-1);
			mc_active.graphics.endFill();
			mc_active.mouseEnabled = false;
			mc_active.alpha = 1;
			mc_active.visible = false;
			var menu_txt:TextField = new TextField(); 
			item_mc2.addChild(menu_txt);
			var format1:TextFormat = new TextFormat();
			format1.font="Arial";
			format1.size = 10;
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
			/*var menu_txt2:TextField = new TextField(); 
			item_mc.addChild(menu_txt2);
			var format2:TextFormat = new TextFormat();
			format2.font="Arial";
			format2.size = 8;
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
			menu_txt2.mouseEnabled = false;*/
			item_mc2.addEventListener(MouseEvent.CLICK, itemMcClick2);
		}
		
		private function itemMcClick2(event:MouseEvent):void {
			var obj:Object = dialogs_list_to_copy.getChildByName(event.target.name);
			var obj_name_array:Array = obj.name.split("_");
			var mc_active:Object = obj.getChildByName("mc_activeb");
			if (mc_active.visible == false ) {
				uncheckItems2();
				mc_active.visible = true;
				copy_from_id = obj_name_array[1];
			}else {
				mc_active.visible = false;
				copy_from_id = -1;
			}
		}
		
		public function uncheckItems2():void{
			for (var k:uint = 0; k < dialogs_list_to_copy.numChildren; k++) {
				var obj:Object = dialogs_list_to_copy.getChildAt(k);
				var obj_name_array:Array = obj.name.split("_");
				if (obj_name_array[0] == "menu") {
					var active_obj:Sprite = obj.getChildByName("mc_activeb");
					active_obj.visible = false;
				}
			}
		}
		
		
		private function createUsersListItem(items_holder:Sprite, menu_item_name:String, menu_text:String, x_position:Number, y_position:Number, width_val:Number, height_val:Number, is_active:Boolean = false, is_locked:Boolean = false): void {
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
			format1.size = 16;
			format1.bold = true;
			format1.color = 0x5A7582;
			menu_txt.text = menu_text;  
			menu_txt.name = "menu_txt";
			menu_txt.setTextFormat(format1);
			menu_txt.width = width_val-40;
			menu_txt.height = height_val - 5; 
			menu_txt.border = false;
			menu_txt.x = 40;
			menu_txt.y = 3;
			menu_txt.selectable = false;  
			menu_txt.mouseEnabled = false;
			
			
			var active_user_icon:ActiveUserIcon = new ActiveUserIcon;
			active_user_icon.name = "active_user_icon";
			item_mc.addChild(active_user_icon);
			active_user_icon.mouseEnabled = false;
			active_user_icon.x = item_mc.x + 20 ;
			active_user_icon.y = user_list_item_height / 2 + 1;
			active_user_icon.visible = false;
			if(is_active==true){
				active_user_icon.visible = true;
			}
			var user_icon:UserIcon = new UserIcon;
			user_icon.name = "user_icon";
			item_mc.addChild(user_icon);
			user_icon.mouseEnabled = false;
			user_icon.x = item_mc.x + 20;
			user_icon.y = user_list_item_height / 2 + 1;
			if(is_active==true){
				user_icon.visible = false;
			}
			item_mc.addEventListener(MouseEvent.CLICK, itemMcClick);

		}
		
		private function itemMcClick(event:MouseEvent):void {
			checkItem(event.target.name);
		}
		
		
		public function checkItem(item_name:String):void {
			var obj:Object = users_list_holder.getChildByName(item_name);
			var user_icon:Object = obj.getChildByName("user_icon");
			var active_user_icon:Object = obj.getChildByName("active_user_icon");
			var mc_active:Object = obj.getChildByName("mc_active");
			var name_array:Array=item_name.split("_")
			if (user_icon.visible == false ) {
				user_icon.visible = true;
				active_user_icon.visible = false; 
				mc_active.visible = false;
				users_array[name_array[1]] = 0;
			}else {
				user_icon.visible = false;
				active_user_icon.visible = true; 
				mc_active.visible = true;
				users_array[name_array[1]] = 1;
			}
		}
		
		public function updateNodeEditorPosition(w:Number = 1920, h:Number = 1080):void {
			bg_holder.width = w;
			bg_holder.height = h;
			node_editor_holder.x = bg_holder.width / 2 - node_editor_holder.width / 2;
			node_editor_holder.y = bg_holder.height / 2 - node_editor_holder.height / 2;
			node_editor_holder2.x = bg_holder.width / 2 - node_editor_holder2.width / 2;
			node_editor_holder2.y = bg_holder.height / 2 - 600 / 2;
			node_editor_holder2b.x = bg_holder.width / 2 - node_editor_holder2b.width / 2;
			node_editor_holder2b.y = bg_holder.height / 2 - node_editor_holder2b.height / 2;
			node_editor_holder3.x = bg_holder.width / 2 - node_editor_holder3.width / 2;
			node_editor_holder3.y = bg_holder.height / 2 - node_editor_holder3.height / 2;
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
		
	}

}