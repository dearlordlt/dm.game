package dm.minigames.artgame {
	/**
	 * ...
	 * @author Darius Dauskurdis dariusdxd@gmail.com
	 */
	
	//1 window Moderator window
	//2 window Player window
	//3 window Player starting window
	//4 window Score window
	//5 window Edit name window
	//6 window Riddle list window
	//7 window Edit answer window
	//8 window Add answer window 
	
	import dm.game.managers.MyManager;
	import flash.display.MovieClip;
	import flash.events.*;
	import fl.controls.Button;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	import fl.controls.List;
	import fl.controls.DataGrid;
	import fl.data.DataProvider;
	import flash.filters.GlowFilter;
	import fl.controls.ComboBox;
	import fl.controls.dataGridClasses.DataGridColumn;
	import fl.controls.RadioButton;
	import fl.controls.RadioButtonGroup;
	import fl.controls.listClasses.ICellRenderer;
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.net.FileReference;
	import flash.net.FileFilter;
	import fl.events.ListEvent;
	import flash.geom.*;
	import flash.net.URLRequestHeader;
	import utils.AMFPHP;
	
	public class art_game_environment extends MovieClip {
		
		public var main_parent:*;
		public var environment_type:String;
		public var max_window_width:Number = 700;
		public var max_window_height:Number = 400;
		public var window_padding:Number = 10;
		public var control_panel_width:Number = 300;
		public var art_game_main_holder:MovieClip;
		public var r_group:RadioButtonGroup = new RadioButtonGroup("group123");
		public var current_riddle_name:String = "";
		public var current_riddle_id:Number = -1;
		public var current_image_name:String = "";
		public var uploading_image_name:String = "";
		public var current_correct_answer_id:Number = -1;
		public var loader_moderator:Loader = new Loader();
		public var loader_player:Loader = new Loader();
		public var fileRef:FileReference;
		public var answers_array:Array = new Array();
		public var selected_answer_index:Number = -1;
		public var selected_answer_text:String = "";
		public var title_padding_hor:Number = 20;
		public var title_padding_ver:Number = 5;
		public var title_corner:Number = 10;
		public var cells_per_row:Number = 10;
		public var cells_per_col:Number = 10;
		public var step_number:Number;
		public var load_riddles_number:Number = 1;
		public var game_main_array:Array = new Array();
		public var max_step_points:Number = 100;
		public var current_step_points:Number = 0;
		public var player_total_points:Number = 0;
		public var all_cells_array:Array = new Array();
		public var left_cells_array:Array = new Array();
		public var high_scores_array:Array = new Array();
		public var message_1:String = "Jūsų pasirinkimas teisingas. Sveikiname!";
		public var message_2:String = "Jūs suklydote... Teisingas atsakymas :";
		public var message_3:String = "Jums baigėsi taškai... Teisingas atsakymas :";
		public var current_message:String = "";
		public var current_true_answer:String = "";
		public var current_true_answer_index:Number;
		public var player_selected_answer_index:Number;
		public var score_was_shared:Boolean = false;
		
		private const IMG_PATH:String = "http://vds000004.hosto.lt/dm/ArtGame/images/";
		
		public function art_game_environment(environment_type:String = "") {
			
			this.name = "artgame_" + getcode();
			this.environment_type = environment_type;

			if (environment_type != "") {
				this.addEventListener(Event.ADDED, this_was_added);
			}
		}
		
		private function this_was_added(e:Event):void {
			this.removeEventListener(Event.ADDED, this_was_added);
			
			main_parent = this.parent;
			art_game_main_holder = new MovieClip;
			this.addChild(art_game_main_holder);
			//var background:MovieClip = new MovieClip;
			//background.name = "main_background";
			//background.graphics.beginFill(0xFFFFFF);
			//background.graphics.drawRect(0, 0, max_window_width, max_window_height);
			//background.graphics.endFill();
			//art_game_main_holder.addChild(background);
			
			for (var i:uint = 1; i <= 8; i++) {
				var art_game_window:MovieClip = new MovieClip;
				art_game_main_holder.addChild(art_game_window);
				art_game_window.name = "art_game_window_" + i;
				art_game_window.visible = false;
					//art_game_window.scaleX = 0;
					//art_game_window.scaleY = 0;
				
			}
			
			if (environment_type == "backend") {
				create_window_1();
				/*create_window_5();
				   create_window_6();
				   create_window_7();
				 create_window_8();*/
				show_art_game_window(1);
			} else if (environment_type == "frontend") {
				//create_window_2();
				create_window_3();
				//create_window_4();
				show_art_game_window(3);
			}
		
		}
		
		private function show_art_game_window(window_number:Number, just_show:Number = 0):void {
			
			for (var i:uint = (art_game_main_holder.numChildren); i > 0; i--) {
				var obj:Object = art_game_main_holder.getChildAt(i - 1);
				if (obj.name == "art_game_window_" + window_number) {
					//update_art_game_window(window_number)
					obj.visible = true;
					//obj.scaleX = 1;
					//obj.scaleY = 1;
					if (window_number == 1) {
						if (just_show == 0) {
							update_main_moderator_window();
						}
					} else if (window_number == 2) {
						player_total_points = 0;
						activate_game();
					} else if (window_number == 3) {
						update_window_3()
					} else if (window_number == 4) {
						update_window_4();
					} else if (window_number == 5) {
						var name_edit_field:Object = get_object_by_name(obj, "name_edit_field");
						name_edit_field.text = current_riddle_name;
					} else if (window_number == 6) {
						var load_btn6:Object = get_object_by_name(obj, "load_btn");
						load_btn6.enabled = false;
						load_riddles_list();
					} else if (window_number == 7) {
						var edit_answer_field:Object = get_object_by_name(obj, "edit_answer_field");
						edit_answer_field.text = selected_answer_text;
					} else if (window_number == 8) {
						var add_answer_field:Object = get_object_by_name(obj, "add_answer_field");
						add_answer_field.text = "";
					}
				} else if (obj.name != "main_background") {
					obj.visible = false;
						//obj.scaleX = 0;
						//obj.scaleY = 0;
				}
			}
		}
		
		private function activate_game():void {
			var amfphp:AMFPHP = new AMFPHP(readResult10, onFault).xcall("dm.ArtGame.get_random_riddles", load_riddles_number);
		}
		
		public function readResult10(r:Array):void {
			if (r == false) {
				trace("Error reading records.");
			} else {
				game_main_array = [];
				game_main_array = r;
				step_number = 1;
				load_game_step();
			}
		}
		
		private function load_game_step():void {
			var index_val:Number = step_number - 1;
			var window:Object = get_object_by_name(art_game_main_holder, "art_game_window_2");
			var art_game_right_holder:Object = get_object_by_name(window, "art_game_right_holder");
			var select_player_answer_dropdown:Object = get_object_by_name(art_game_right_holder, "select_player_answer_dropdown");
			var art_game_left_holder:Object = get_object_by_name(window, "art_game_left_holder");
			var art_game_left_title_holder:Object = get_object_by_name(art_game_left_holder, "art_game_left_title_holder");
			var art_game_left_title:Object = get_object_by_name(art_game_left_title_holder, "art_game_left_title");
			var message_text_holder:Object = get_object_by_name(art_game_left_holder, "message_text_holder");
			var submit_btn:Object = get_object_by_name(art_game_right_holder, "submit_btn");
			var next_question_high_score_btn:Object = get_object_by_name(art_game_right_holder, "next_question_high_score_btn");
			var choose_answer_text:Object = get_object_by_name(art_game_right_holder, "choose_answer_text");
			var buy_clue_btn:Object = get_object_by_name(art_game_right_holder, "buy_clue_btn");
			
			submit_btn.visible = false;
			next_question_high_score_btn.visible = false;
			choose_answer_text.visible = true;
			select_player_answer_dropdown.visible = true;
			select_player_answer_dropdown.visible = true;
			buy_clue_btn.visible = true;
			
			select_player_answer_dropdown.dataProvider.removeAll();
			for (var i:uint = 0; i < game_main_array[index_val]['answers'].length; i++) {
				if (game_main_array[index_val]['answers'][i]['is_correct'] == 1) {
					current_true_answer = game_main_array[index_val]['answers'][i]['text'];
					current_true_answer_index = i;
				}
				select_player_answer_dropdown.addItem({label: game_main_array[index_val]['answers'][i]['text'], data: i});
			}
			
			message_text_holder.visible = false;
			
			current_step_points = max_step_points;
			
			art_game_left_title.text = game_main_array[index_val]['name'];
			
			all_cells_array = [];
			left_cells_array = [];
			for (var k:uint = 0; k < cells_per_row * cells_per_col; k++) {
				all_cells_array.push(k + 1);
				left_cells_array.push(k + 1);
			}
			
			if (game_main_array[index_val]['image'] != "") {
				load_image_to_game(game_main_array[index_val]['image']);
					//load_image_to_game('image_3.jpg');
			}
		
		}
		
		private function open_cell():void {
			if (left_cells_array.length > 0) {
				var rand_array_item_index:Number = Math.floor(Math.random() * (1 + left_cells_array.length - 1));
				var rand_array_item_value:Number = left_cells_array[rand_array_item_index];
				left_cells_array.splice(rand_array_item_index, 1);
				var window:Object = get_object_by_name(art_game_main_holder, "art_game_window_2");
				var art_game_left_holder:Object = get_object_by_name(window, "art_game_left_holder");
				var img_cells_holder:Object = get_object_by_name(art_game_left_holder, "img_cells_holder");
				var cell:Object = get_object_by_name(img_cells_holder, "cell_" + rand_array_item_value);
				cell.visible = false;
			}
		}
		
		public function onFault(fault:Object):void {
			var st:String = String(fault.description);
			trace(st);
		}
		
		private function load_riddles_list():void {
			var amfphp:AMFPHP = new AMFPHP(readResult1, onFault).xcall("dm.ArtGame.load_riddles_list");
		}
		
		public function readResult1(r:Object):void {
			if (r == false) {
				trace("Error reading records.");
			} else {
				var window:Object = get_object_by_name(art_game_main_holder, "art_game_window_6");
				var riddles_list:Object = get_object_by_name(window, "riddles_list");
				riddles_list.dataProvider.removeAll();
				for (var m:uint = 0; m < r.length; m++) {
					riddles_list.addItem({label: r[m]['name'], data: r[m]['id']});
				}
					//update_window_6();
			}
		
		}
		
		private function open_file_browser():void {
			fileRef = new FileReference();
			fileRef.addEventListener(Event.SELECT, uploadFile);
			fileRef.addEventListener(ProgressEvent.PROGRESS, fileUploadProgress);
			fileRef.addEventListener(Event.COMPLETE, fileUploadComplete);
			browseForFile();
		}
		
		private function browseForFile():void {
			var imagesFilter:FileFilter = new FileFilter("Images", "*.jpg;*.bmp;*.png");
			fileRef.browse([imagesFilter]);
		}
		
		public function uploadFile(e:Event):void {
			uploading_image_name = "image_" + current_riddle_id;
			fileRef.upload(new URLRequest("http://vds000004.hosto.lt/dm/ArtGame/upload_image.php?img_name=" + uploading_image_name), "as3File", false);
		}
		
		private function fileUploadProgress(e:ProgressEvent):void {
			trace((e.bytesLoaded / e.bytesTotal) * 100);
		}
		
		private function fileUploadComplete(e:Event):void {
			trace("upload complete");
			var image_name:String = "image_" + current_riddle_id + ".jpg";
			var params:Array = [current_riddle_id, image_name];
			
			var amfphp:AMFPHP = new AMFPHP(readResult9, onFault).xcall("dm.ArtGame.update_image", params);
		}
		
		public function readResult9(r:Object):void {
			if (r == false) {
				trace("Error reading records.");
			} else {
				show_art_game_window(1);
			}
		
		}
		
		private function update_art_game_window(window_number:Number):void {
		/*for (var i:uint = (main_parent.numChildren); i > 0; i--) {
		   var obj:Object = main_parent.getChildAt(i-1);
		   if (obj.name == "art_game_window_"+window_number ) {
		   obj.visible = true;
		   }else {
		   obj.visible = false;
		   }
		
		 }*/
		}
		
		private function do_action(action_num:Number):void {
			switch (action_num) {
				case 0: 
					//show_art_game_window(1);
					break;
				case 1: 
					add_new_riddle();
					break;
				case 2: 
					if (current_riddle_name != "") {
						clear_window("art_game_window_1");
						create_window_8();
						show_art_game_window(8)
					}
					break;
				case 3: 
					if (current_riddle_name != "" && selected_answer_index != -1) {
						remove_answer();
					}
					break;
				case 4: 
					if (current_riddle_name != "") {
						clear_window("art_game_window_1");
						create_window_5();
						show_art_game_window(5);
					}
					break;
				case 5: 
					if (current_riddle_name != "" && selected_answer_index != -1) {
						show_art_game_window(7)
					}
					break;
				case 6: 
					if (current_riddle_id != -1) {
						open_file_browser();
					}
					
					break;
				case 7: 
					clear_window("art_game_window_1");
					create_window_6();
					show_art_game_window(6);
					break;
				case 8: 
					//show_art_game_window(1);
					trace("ssss")
					break;
			}
		}
		
		private function create_window_1():void {
			var format:TextFormat = new TextFormat();
			format.font = "Arial";
			format.size = 14;
			format.color = 0x000000;
			format.align = "center";
			var window:Object = get_object_by_name(art_game_main_holder, "art_game_window_1");
			var resizer:MovieClip = new MovieClip;
			resizer.name = "resizer";
			window.addChild(resizer);
			resizer.graphics.beginFill(0xFF0000);
			resizer.graphics.drawRect(0, 0, 100, 100);
			resizer.graphics.endFill();
			resizer.visible = false;
			
			var background:MovieClip = new MovieClip;
			background.name = "background";
			window.addChild(background);
			/*var glow:GlowFilter = new GlowFilter();
			   glow.quality = 3;
			   glow.blurX = 5;
			   glow.blurY = 5;
			   glow.color=0xaaaaaa;
			 background.filters = [glow];*/
			
			var image_area:MovieClip = new MovieClip;
			image_area.name = "image_area";
			window.addChild(image_area);
			
			var navigation_area:MovieClip = new MovieClip;
			navigation_area.name = "navigation_area";
			window.addChild(navigation_area);
			
			var riddle_name_label:TextField = new TextField;
			riddle_name_label.name = "riddle_name_label";
			riddle_name_label.selectable = false;
			riddle_name_label.multiline = true;
			riddle_name_label.mouseEnabled = false;
			//riddle_name_label.border = true;
			//riddle_name_label.borderColor = 0xFF0000;
			
			riddle_name_label.height = 22;
			riddle_name_label.defaultTextFormat = format;
			riddle_name_label.text = current_riddle_name;
			navigation_area.addChild(riddle_name_label);
			riddle_name_label.width = control_panel_width;
			
			var answers_data_grid:DataGrid = new DataGrid();
			answers_data_grid.name = "answers_data_grid";
			navigation_area.addChild(answers_data_grid);
			
			/*scores_data_grid.addColumn("Nr");
			   scores_data_grid.addColumn("Name");
			 scores_data_grid.addColumn("Correct answer"); */
			
			var columns:Array = [];
			var gridcolumn:DataGridColumn = new DataGridColumn("col1");
			gridcolumn.headerText = "Nr ";
			columns.push(gridcolumn);
			gridcolumn = new DataGridColumn("col2");
			gridcolumn.headerText = "Answer";
			columns.push(gridcolumn);
			gridcolumn = new DataGridColumn("col3");
			gridcolumn.headerText = "Correct answer";
			gridcolumn.cellRenderer = RadioButtonCellRenderer;
			columns.push(gridcolumn);
			
			answers_data_grid.columns = columns;
			
			answers_data_grid.getColumnAt(0).width = 40;
			answers_data_grid.getColumnAt(2).width = 100;
			
			answers_data_grid.width = control_panel_width;
			//scores_data_grid.height = 140; 
			answers_data_grid.rowCount = 10;
			//scores_data_grid.rowCount = scores_data_grid.length;  */
			
			answers_data_grid.addEventListener(ListEvent.ITEM_CLICK, on_data_grid_click);
			
			var radio_btn:RadioButton = new RadioButton;
			
			var select_action_dropdown:ComboBox = new ComboBox;
			select_action_dropdown.name = "select_action_dropdown";
			navigation_area.addChild(select_action_dropdown);
			select_action_dropdown.addItem({label: "Select action", data: 0});
			select_action_dropdown.addItem({label: "New riddle", data: 1});
			select_action_dropdown.addItem({label: "Add answer", data: 2});
			select_action_dropdown.addItem({label: "Remove answer", data: 3});
			select_action_dropdown.addItem({label: "Edit ridle name", data: 4});
			select_action_dropdown.addItem({label: "Edit answer", data: 5});
			select_action_dropdown.addItem({label: "Add picture", data: 6});
			select_action_dropdown.addItem({label: "Load riddle", data: 7});
			//select_action_dropdown.addItem( { label:"Try game", data:8 } );
			select_action_dropdown.width = 150;
			var do_action_btn:Button = new Button;
			do_action_btn.label = "Do action";
			do_action_btn.name = "do_action_btn";
			navigation_area.addChild(do_action_btn);
			do_action_btn.addEventListener(MouseEvent.CLICK, do_action_btn_click);
			main_parent.parent.parent.change_window_title("Dailės žaidimo redagavimas");
			update_window_1();
		}
		
		private function on_data_grid_click(evt:ListEvent):void {
			var window:Object = get_object_by_name(art_game_main_holder, "art_game_window_1");
			var navigation_area:Object = get_object_by_name(window, "navigation_area");
			var answers_data_grid:Object = get_object_by_name(navigation_area, "answers_data_grid");
			selected_answer_index = evt.index;
			selected_answer_text = answers_array[selected_answer_index]['text'];
			if (evt.columnIndex == 2) {
				var is_correct_value:Boolean;
				var answers_dp:DataProvider = new DataProvider();
				for (var m:uint = 0; m < answers_array.length; m++) {
					if (evt.index == m) {
						is_correct_value = true;
						current_correct_answer_id = answers_array[m]['id'];
						answers_array[m]['is_correct'] = 1;
					} else {
						is_correct_value = false;
						answers_array[m]['is_correct'] = 0;
					}
					answers_dp.addItem({col1: m + 1 + ".", col2: answers_array[m]['text'], col3: is_correct_value});
				}
				answers_data_grid.dataProvider = answers_dp;
				select_correct_answer(selected_answer_index);
			}
		}
		
		private function select_correct_answer(sel_answ_index:Number):void {
			var window:Object = get_object_by_name(art_game_main_holder, "art_game_window_8");
			var add_answer_field:Object = get_object_by_name(window, "add_answer_field");
			var params:Array = [current_riddle_id, answers_array[selected_answer_index]['id']];
			
			var amfphp:AMFPHP = new AMFPHP(readResult6, onFault).xcall("dm.ArtGame.select_correct_answer", params);
		}
		
		public function readResult6(r:Object):void {
			if (r == false) {
				trace("Error reading records.");
			} else {
				trace("Correct answer was selected")
			}
		}
		
		private function do_action_btn_click(event:MouseEvent):void {
			var window:Object = get_object_by_name(art_game_main_holder, "art_game_window_1");
			var navigation_area:Object = get_object_by_name(window, "navigation_area");
			var select_action_dropdown:Object = get_object_by_name(navigation_area, "select_action_dropdown");
			var action_num:Number = select_action_dropdown.selectedItem.data;
			select_action_dropdown.selectedIndex = 0;
			do_action(action_num);
		}
		
		private function remove_answer():void {
			var window:Object = get_object_by_name(art_game_main_holder, "art_game_window_1");
			var navigation_area:Object = get_object_by_name(window, "navigation_area");
			var answers_data_grid:Object = get_object_by_name(navigation_area, "answers_data_grid");
			var id:Number = answers_array[selected_answer_index]['id'];
			if (answers_array[selected_answer_index]['is_correct'] != 1) {
				trace(answers_array[selected_answer_index]['text'])
				trace(answers_array[selected_answer_index]['is_correct'])
				answers_array.splice(selected_answer_index, 1);
				var is_correct_value:Boolean;
				var answers_dp:DataProvider = new DataProvider();
				for (var m:uint = 0; m < answers_array.length; m++) {
					if (answers_array[m]['is_correct'] == 1) {
						is_correct_value = true;
					} else {
						is_correct_value = false;
					}
					answers_dp.addItem({col1: m + 1 + ".", col2: answers_array[m]['text'], col3: is_correct_value});
				}
				answers_data_grid.dataProvider = answers_dp;
				
				var amfphp:AMFPHP = new AMFPHP(readResult7, onFault).xcall("dm.ArtGame.remove_answer", id);
			}
		}
		
		public function readResult7(r:Object):void {
			if (r == false) {
				trace("Error reading records.");
			} else {
				trace("Answer was removed")
			}
		}
		
		private function edit_answer(event:MouseEvent):void {
			var window:Object = get_object_by_name(art_game_main_holder, "art_game_window_1");
			var navigation_area:Object = get_object_by_name(window, "navigation_area");
			var answers_data_grid:Object = get_object_by_name(navigation_area, "answers_data_grid");
			var window2:Object = get_object_by_name(art_game_main_holder, "art_game_window_7");
			var edit_answer_field:Object = get_object_by_name(window2, "edit_answer_field");
			var answer_text:String = edit_answer_field.text;
			answers_array[selected_answer_index]['text'] = answer_text;
			var is_correct_value:Boolean;
			var answers_dp:DataProvider = new DataProvider();
			for (var m:uint = 0; m < answers_array.length; m++) {
				if (answers_array[m]['is_correct'] == 1) {
					is_correct_value = true;
				} else {
					is_correct_value = false;
				}
				answers_dp.addItem({col1: m + 1 + ".", col2: answers_array[m]['text'], col3: is_correct_value});
			}
			answers_data_grid.dataProvider = answers_dp;
			var params:Array = [answers_array[selected_answer_index]['id'], answer_text];
			
			var amfphp:AMFPHP = new AMFPHP(readResult8, onFault).xcall("dm.ArtGame.edit_answer", params);
		}
		
		public function readResult8(r:Object):void {
			if (r == false) {
				trace("Error reading records.");
			} else {
				trace("Answer was edited");
				show_art_game_window(1, 1);
			}
		}
		
		private function update_window_1():void {
			var window:Object = get_object_by_name(art_game_main_holder, "art_game_window_1");
			
			var resizer:Object = get_object_by_name(window, "resizer");
			var image_area:Object = get_object_by_name(window, "image_area");
			image_area.x = window_padding;
			image_area.y = window_padding;
			var navigation_area:Object = get_object_by_name(window, "navigation_area");
			navigation_area.x = image_area.x + image_area.width + window_padding;
			var riddle_name_label:Object = get_object_by_name(navigation_area, "riddle_name_label");
			riddle_name_label.y = window_padding;
			var answers_data_grid:Object = get_object_by_name(navigation_area, "answers_data_grid");
			answers_data_grid.y = riddle_name_label.y + riddle_name_label.height + 10;
			var do_action_btn:Object = get_object_by_name(navigation_area, "do_action_btn");
			do_action_btn.y = answers_data_grid.y + answers_data_grid.height + 10;
			do_action_btn.x = answers_data_grid.x + answers_data_grid.width - do_action_btn.width;
			
			var select_action_dropdown:Object = get_object_by_name(navigation_area, "select_action_dropdown");
			select_action_dropdown.y = do_action_btn.y;
			select_action_dropdown.x = do_action_btn.x - select_action_dropdown.width - 10;
			
			var background:Object = get_object_by_name(window, "background");
			//background.graphics.clear();
			//background.graphics.beginFill(0xFEFEFE);
			
			/*var bg_height:Number;
			   if (do_action_btn.y + do_action_btn.height >= image_area.height ) {
			   bg_height = do_action_btn.y + do_action_btn.height + window_padding;
			   }else {
			   bg_height = image_area.y + image_area.height + window_padding;
			 }*/
			
			trace(background.y)
			var bg_height:Number;
			background.graphics.clear();
			if (do_action_btn.y + do_action_btn.height >= image_area.height) {
				drawRoundRect(background, navigation_area.x + navigation_area.width + window_padding, do_action_btn.y + do_action_btn.height + window_padding, 5, 5, 5, 5, 0, 0xFFFFFF, 0xFFFFFF, 0.5);
			} else {
				drawRoundRect(background, navigation_area.x + navigation_area.width + window_padding, image_area.y + image_area.height + window_padding, 5, 5, 5, 5, 0, 0xFFFFFF, 0xFFFFFF, 0.5);
			}
			
			//background.graphics.drawRect(0, 0, navigation_area.x + navigation_area.width + window_padding, bg_height);
			//background.graphics.endFill();
			/*window.x = window.parent.width / 2 - background.width / 2;
			 window.y = window.parent.height / 2 - background.height / 2;*/ /*window.x = 10;
			 window.y = 10;*/
			
			resizer.width = background.width;
			resizer.height = background.height;
			main_parent.parent.parent.update_m_window();
		
		}
		
		private function create_window_2():void {
			var window:Object = get_object_by_name(art_game_main_holder, "art_game_window_2");
			
			var resizer:MovieClip = new MovieClip;
			resizer.name = "resizer";
			window.addChild(resizer);
			resizer.graphics.beginFill(0xFF0000);
			resizer.graphics.drawRect(0, 0, 1, 1);
			resizer.graphics.endFill();
			resizer.visible = false;
			
			var art_game_left_holder:MovieClip = new MovieClip;
			window.addChild(art_game_left_holder);
			art_game_left_holder.name = "art_game_left_holder";
			var art_game_right_holder:MovieClip = new MovieClip;
			window.addChild(art_game_right_holder);
			art_game_right_holder.name = "art_game_right_holder";
			var background_left:MovieClip = new MovieClip;
			background_left.name = "background_left";
			art_game_left_holder.addChild(background_left);
			var background_right:MovieClip = new MovieClip;
			background_right.name = "background_right";
			art_game_right_holder.addChild(background_right);
			var art_game_left_title_holder:MovieClip = new MovieClip;
			art_game_left_title_holder.name = "art_game_left_title_holder";
			art_game_left_holder.addChild(art_game_left_title_holder);
			var art_game_left_title_background:MovieClip = new MovieClip;
			art_game_left_title_holder.addChild(art_game_left_title_background);
			art_game_left_title_background.name = "art_game_left_title_background";
			var art_game_left_title:TextField = new TextField;
			art_game_left_title_holder.addChild(art_game_left_title);
			art_game_left_title.name = "art_game_left_title";
			
			var art_game_right_title_holder:MovieClip = new MovieClip;
			art_game_right_title_holder.name = "art_game_right_title_holder";
			art_game_right_holder.addChild(art_game_right_title_holder);
			var art_game_right_title_background:MovieClip = new MovieClip;
			art_game_right_title_holder.addChild(art_game_right_title_background);
			art_game_right_title_background.name = "art_game_right_title_background";
			var art_game_right_title:TextField = new TextField;
			art_game_right_title_holder.addChild(art_game_right_title);
			art_game_right_title.name = "art_game_right_title";
			
			var points_left_text:TextField = new TextField;
			art_game_right_holder.addChild(points_left_text);
			points_left_text.name = "points_left_text";
			
			var points_text:TextField = new TextField;
			art_game_right_holder.addChild(points_text);
			points_text.name = "points_text";
			
			var buy_clue_btn:Button = new Button;
			buy_clue_btn.label = "Buy a clue";
			buy_clue_btn.name = "buy_clue_btn";
			art_game_right_holder.addChild(buy_clue_btn);
			buy_clue_btn.addEventListener(MouseEvent.CLICK, buy_clue_btn_click);
			
			var choose_answer_text:TextField = new TextField;
			art_game_right_holder.addChild(choose_answer_text);
			choose_answer_text.name = "choose_answer_text";
			
			var select_player_answer_dropdown:ComboBox = new ComboBox;
			select_player_answer_dropdown.name = "select_player_answer_dropdown";
			art_game_right_holder.addChild(select_player_answer_dropdown);
			select_player_answer_dropdown.prompt = " ";
			//--------------NEW START ----------------//
			select_player_answer_dropdown.dropdownWidth = 250;
			select_player_answer_dropdown.width = 250;
			//--------------NEW END ----------------//
			select_player_answer_dropdown.addEventListener(Event.CHANGE, select_player_answer_dropdown_changed);
			
			var submit_btn:Button = new Button;
			submit_btn.label = "Submit";
			submit_btn.name = "submit_btn";
			art_game_right_holder.addChild(submit_btn);
			submit_btn.addEventListener(MouseEvent.CLICK, submit_btn_click);
			
			var next_question_high_score_btn:Button = new Button;
			next_question_high_score_btn.label = "Next question / high score";
			next_question_high_score_btn.name = "next_question_high_score_btn";
			art_game_right_holder.addChild(next_question_high_score_btn);
			next_question_high_score_btn.addEventListener(MouseEvent.CLICK, next_question_high_score_btn_click);
			
			var leave_btn:Button = new Button;
			leave_btn.label = "Leave";
			leave_btn.name = "leave_btn";
			art_game_right_holder.addChild(leave_btn);
			
			//XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
			
			var img_cells_holder:MovieClip = new MovieClip;
			img_cells_holder.name = "img_cells_holder";
			art_game_left_holder.addChild(img_cells_holder);
			var img_holder:MovieClip = new MovieClip;
			img_holder.name = "img_holder";
			img_cells_holder.addChild(img_holder);
			
			for (var n:uint = 1; n <= cells_per_row * cells_per_col; n++) {
				var cell:MovieClip = new MovieClip;
				cell.name = "cell_" + n;
				img_cells_holder.addChild(cell);
				cell.visible = false;
			}
			
			var img_cells_mask:MovieClip = new MovieClip;
			img_cells_mask.name = "img_cells_mask";
			art_game_left_holder.addChild(img_cells_mask);
			img_cells_holder.mask = img_cells_mask;
			
			var message_text_holder:MovieClip = new MovieClip;
			message_text_holder.name = "message_text_holder";
			art_game_left_holder.addChild(message_text_holder);
			var message_text_background:MovieClip = new MovieClip;
			message_text_holder.addChild(message_text_background);
			message_text_background.name = "message_text_background";
			var message_text:TextField = new TextField;
			message_text_holder.addChild(message_text);
			message_text.name = "message_text";
		
		}
		
		private function submit_btn_click(event:MouseEvent):void {
			if (player_selected_answer_index == current_true_answer_index) {
				step_result_window(1);
			} else {
				current_step_points = 1;
				step_result_window(2);
			}
		}
		
		private function buy_clue_btn_click(event:MouseEvent):void {
			if (left_cells_array.length > 1) {
				current_step_points--;
				open_cell();
				update_window_2();
			} else {
				current_step_points--;
				open_cell();
				update_window_2();
				step_result_window(3);
			}
		}
		
		private function next_question_high_score_btn_click(event:MouseEvent):void {
			if (step_number < load_riddles_number) {
				step_number++;
				player_total_points += current_step_points;
				load_game_step();
				update_window_2();
			} else {
				player_total_points += current_step_points;
				
				clear_window("art_game_window_2");
				create_window_4();
				show_art_game_window(4);
			}
		
		}
		
		private function select_player_answer_dropdown_changed(event:Event):void {
			var window:Object = get_object_by_name(art_game_main_holder, "art_game_window_2");
			var art_game_right_holder:Object = get_object_by_name(window, "art_game_right_holder");
			var submit_btn:Object = get_object_by_name(art_game_right_holder, "submit_btn");
			var select_player_answer_dropdown:Object = get_object_by_name(art_game_right_holder, "select_player_answer_dropdown");
			submit_btn.visible = true;
			player_selected_answer_index = select_player_answer_dropdown.selectedItem.data;
		}
		
		private function step_result_window(result_window_num:Number):void {
			var window:Object = get_object_by_name(art_game_main_holder, "art_game_window_2");
			var art_game_left_holder:Object = get_object_by_name(window, "art_game_left_holder");
			var art_game_right_holder:Object = get_object_by_name(window, "art_game_right_holder");
			var buy_clue_btn:Object = get_object_by_name(art_game_right_holder, "buy_clue_btn");
			var message_text_holder:Object = get_object_by_name(art_game_left_holder, "message_text_holder");
			var choose_answer_text:Object = get_object_by_name(art_game_right_holder, "choose_answer_text");
			var select_player_answer_dropdown:Object = get_object_by_name(art_game_right_holder, "select_player_answer_dropdown");
			var submit_btn:Object = get_object_by_name(art_game_right_holder, "submit_btn");
			var next_question_high_score_btn:Object = get_object_by_name(art_game_right_holder, "next_question_high_score_btn");
			
			switch (result_window_num) {
				case 1: 
					//Teisingas atsakymas
					current_message = message_1;
					break;
				case 2: 
					//Neteisingas atsakymas
					current_message = message_2 + " " + current_true_answer;
					break;
				case 3: 
					//Nebeliko tasku
					current_message = message_3 + " " + current_true_answer;
					break;
			}
			open_all_cells();
			buy_clue_btn.visible = false;
			message_text_holder.visible = true;
			choose_answer_text.visible = false;
			select_player_answer_dropdown.visible = false;
			submit_btn.visible = false;
			next_question_high_score_btn.visible = true;
			update_window_2();
		}
		
		private function open_all_cells():void {
			var window:Object = get_object_by_name(art_game_main_holder, "art_game_window_2");
			var art_game_left_holder:Object = get_object_by_name(window, "art_game_left_holder");
			var img_cells_holder:Object = get_object_by_name(art_game_left_holder, "img_cells_holder");
			for (var n:uint = 1; n <= cells_per_row * cells_per_col; n++) {
				var cell:Object = get_object_by_name(img_cells_holder, "cell_" + n);
				cell.visible = false;
			}
		
		}
		
		private function update_mask(area_width:Number, area_height:Number):void {
			var window:Object = get_object_by_name(art_game_main_holder, "art_game_window_2");
			var art_game_left_holder:Object = get_object_by_name(window, "art_game_left_holder");
			var img_cells_mask:Object = get_object_by_name(art_game_left_holder, "img_cells_mask");
			img_cells_mask.graphics.clear();
			drawRoundRect(img_cells_mask, area_width - 1, area_height - 1, 5, 5, 5, 5, 0, 0x000000, 0xF05A23, 1);
		}
		
		private function update_cells(area_width:Number, area_height:Number):void {
			var window:Object = get_object_by_name(art_game_main_holder, "art_game_window_2");
			var art_game_left_holder:Object = get_object_by_name(window, "art_game_left_holder");
			var img_cells_holder:Object = get_object_by_name(art_game_left_holder, "img_cells_holder");
			var cell_width:Number = area_width / cells_per_row;
			var cell_height:Number = area_height / cells_per_col;
			var row:Number = 1;
			var coll:Number = 0;
			for (var n:uint = 1; n <= cells_per_row * cells_per_col; n++) {
				coll++;
				var cell:Object = get_object_by_name(img_cells_holder, "cell_" + n);
				cell.graphics.clear();
				cell.graphics.lineStyle(1, 0x7A7979);
				cell.graphics.beginFill(0x5F5D5D);
				cell.graphics.drawRect(0, 0, cell_width, cell_height);
				cell.graphics.endFill();
				cell.x = (coll - 1) * cell_width - 1;
				cell.y = (row - 1) * cell_height - 1;
				cell.visible = true;
				if (coll == cells_per_row) {
					coll = 0;
					row++
				}
			}
		}
		
		private function update_window_2():void {
			var window:Object = get_object_by_name(art_game_main_holder, "art_game_window_2");
			window.visible = true;
			//window.scaleX = 1;
			//window.scaleY = 1;
			var art_game_left_holder:Object = get_object_by_name(window, "art_game_left_holder");
			var background_left:Object = get_object_by_name(art_game_left_holder, "background_left");
			var art_game_left_title_holder:Object = get_object_by_name(art_game_left_holder, "art_game_left_title_holder");
			var art_game_left_title_background:Object = get_object_by_name(art_game_left_title_holder, "art_game_left_title_background");
			var art_game_left_title:Object = get_object_by_name(art_game_left_title_holder, "art_game_left_title");
			var art_game_right_holder:Object = get_object_by_name(window, "art_game_right_holder");
			var background_right:Object = get_object_by_name(art_game_right_holder, "background_right");
			var art_game_right_title_holder:Object = get_object_by_name(art_game_right_holder, "art_game_right_title_holder");
			var art_game_right_title_background:Object = get_object_by_name(art_game_right_title_holder, "art_game_right_title_background");
			var art_game_right_title:Object = get_object_by_name(art_game_right_title_holder, "art_game_right_title");
			var img_cells_holder:Object = get_object_by_name(art_game_left_holder, "img_cells_holder");
			var img_cells_mask:Object = get_object_by_name(art_game_left_holder, "img_cells_mask");
			var points_left_text:Object = get_object_by_name(art_game_right_holder, "points_left_text");
			var points_text:Object = get_object_by_name(art_game_right_holder, "points_text");
			var buy_clue_btn:Object = get_object_by_name(art_game_right_holder, "buy_clue_btn");
			var choose_answer_text:Object = get_object_by_name(art_game_right_holder, "choose_answer_text");
			var select_player_answer_dropdown:Object = get_object_by_name(art_game_right_holder, "select_player_answer_dropdown");
			var submit_btn:Object = get_object_by_name(art_game_right_holder, "submit_btn");
			var next_question_high_score_btn:Object = get_object_by_name(art_game_right_holder, "next_question_high_score_btn");
			var leave_btn:Object = get_object_by_name(art_game_right_holder, "leave_btn");
			var resizer:Object = get_object_by_name(window, "resizer");
			var message_text_holder:Object = get_object_by_name(art_game_left_holder, "message_text_holder");
			var message_text_background:Object = get_object_by_name(message_text_holder, "message_text_background");
			var message_text:Object = get_object_by_name(message_text_holder, "message_text");
			
			art_game_left_title_holder.y = 0;
			art_game_left_title.x = title_padding_hor;
			//--------------NEW START ----------------//
			//update_area_title(art_game_left_title_holder, art_game_left_title_background, art_game_left_title, art_game_left_title.text, img_cells_mask.width);
			update_area_title(art_game_left_title_holder, art_game_left_title_background, art_game_left_title, "Galvosūkis " + step_number, img_cells_mask.width);
			//--------------NEW END ----------------//
			art_game_right_title_holder.y = 0;
			art_game_right_title.x = title_padding_hor;
			update_area_title(art_game_right_title_holder, art_game_right_title_background, art_game_right_title, "Actions", 200);
			img_cells_holder.x = window_padding;
			img_cells_holder.y = art_game_left_title_holder.y + art_game_left_title_holder.height + window_padding;
			img_cells_mask.x = window_padding;
			img_cells_mask.y = img_cells_holder.y;
			background_left.graphics.clear();
			drawRoundRect(background_left, img_cells_mask.width + 2 * window_padding, img_cells_mask.y + img_cells_mask.height + window_padding, 5, 5, 5, 5, 0, 0xFFFFFF, 0xFFFFFF, 0.5);
			art_game_left_title_holder.x = background_left.width / 2 - art_game_left_title_holder.width / 2;
			background_right.graphics.clear();
			//--------------NEW START ----------------//
			drawRoundRect(background_right, 270, img_cells_mask.y + img_cells_mask.height + window_padding, 5, 5, 5, 5, 0, 0xFFFFFF, 0xFFFFFF, 0.5);
			//--------------NEW END ----------------//
			art_game_right_title_holder.x = background_right.width / 2 - art_game_right_title_holder.width / 2;
			art_game_right_holder.x = art_game_left_holder.x + art_game_left_holder.width + window_padding;
			var t_format3:TextFormat = new TextFormat();
			t_format3.font = "Arial";
			t_format3.size = 14;
			t_format3.color = 0x5F5D5D;
			
			message_text.autoSize = "left";
			message_text.selectable = false;
			message_text.multiline = true;
			message_text.wordWrap = true;
			message_text.mouseEnabled = false;
			message_text.width = 200;
			message_text.defaultTextFormat = t_format3;
			message_text.text = current_message;
			message_text.x = window_padding;
			message_text.y = window_padding;
			message_text_background.graphics.clear();
			drawRoundRect(message_text_background, message_text.width + 2 * window_padding, message_text.height + 2 * window_padding, 5, 5, 5, 5, 0, 0xFFFFFF, 0xFFFFFF, 0.9);
			message_text_holder.x = img_cells_holder.x + img_cells_holder.width / 2 - message_text_holder.width / 2;
			message_text_holder.y = img_cells_holder.y + img_cells_holder.height / 2 - message_text_holder.height / 2;
			
			points_left_text.autoSize = "left";
			points_left_text.selectable = false;
			points_left_text.multiline = true;
			points_left_text.mouseEnabled = false;
			points_left_text.defaultTextFormat = t_format3;
			points_left_text.text = "Points left:";
			points_text.autoSize = "left";
			points_text.selectable = false;
			points_text.multiline = true;
			points_text.mouseEnabled = false;
			points_text.defaultTextFormat = t_format3;
			points_text.text = current_step_points + " / " + max_step_points;
			choose_answer_text.autoSize = "left";
			choose_answer_text.selectable = false;
			choose_answer_text.multiline = true;
			choose_answer_text.mouseEnabled = false;
			choose_answer_text.defaultTextFormat = t_format3;
			choose_answer_text.text = "Choose answer:";
			leave_btn.x = art_game_right_holder.width / 2 - leave_btn.width / 2;
			leave_btn.y = background_right.height - window_padding - leave_btn.height;
			next_question_high_score_btn.width = 150;
			next_question_high_score_btn.x = art_game_right_holder.width / 2 - next_question_high_score_btn.width / 2;
			next_question_high_score_btn.y = leave_btn.y - window_padding - next_question_high_score_btn.height;
			select_player_answer_dropdown.x = art_game_right_holder.width / 2 - select_player_answer_dropdown.width / 2;
			select_player_answer_dropdown.y = art_game_right_holder.height / 2 - select_player_answer_dropdown.height / 2;
			submit_btn.x = art_game_right_holder.width / 2 - submit_btn.width / 2;
			submit_btn.y = select_player_answer_dropdown.y + select_player_answer_dropdown.height + window_padding;
			choose_answer_text.x = art_game_right_holder.width / 2 - choose_answer_text.width / 2;
			choose_answer_text.y = select_player_answer_dropdown.y - choose_answer_text.height;
			points_left_text.x = art_game_right_holder.width / 2 - points_left_text.width / 2;
			points_left_text.y = img_cells_holder.y;
			points_text.x = art_game_right_holder.width / 2 - points_text.width / 2;
			points_text.y = points_left_text.y + points_left_text.height;
			buy_clue_btn.x = art_game_right_holder.width / 2 - buy_clue_btn.width / 2;
			buy_clue_btn.y = points_text.y + points_text.height;
			
			resizer.width = art_game_right_holder.x + background_right.width;
			resizer.height = background_right.height;
			
			main_parent.parent.parent.update_m_window();
		}
		
		private function update_area_title(holder:Object, holder_background:Object, textfield_obj:Object, title_val:String, max_width:Number):void {
			var t_format:TextFormat = new TextFormat();
			t_format.font = "Arial";
			t_format.size = 14;
			t_format.color = 0xFFFFFF;
			textfield_obj.autoSize = "left";
			textfield_obj.selectable = true;
			textfield_obj.multiline = true;
			textfield_obj.mouseEnabled = false;
			textfield_obj.defaultTextFormat = t_format;
			textfield_obj.text = title_val.toUpperCase();
			textfield_obj.y = title_padding_ver;
			holder_background.graphics.clear();
			if (textfield_obj.width > max_width) {
				textfield_obj.wordWrap = true;
				textfield_obj.width = max_width;
			}
			drawRoundRect(holder_background, textfield_obj.width + title_padding_hor * 2, textfield_obj.height + title_padding_ver * 2, 0, 0, title_corner, title_corner, 0, 0x000000, 0xB2B3B1, 1);
			draw_title_shadow(holder_background, 0x919190, 0xB2B3B1, 1, 1);
		
		}
		
		private function load_image_to_game(image_name:String):void {
			var img_url:String = IMG_PATH + image_name;
			var url:URLRequest = new URLRequest(img_url);
			loader_player.load(url);
			loader_player.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			loader_player.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			loader_player.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadProgress_image_player);
			loader_player.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete_image_player);
		}
		
		private function loadProgress_image_player(event:ProgressEvent):void {
			var percentLoaded:Number = Math.round((event.bytesLoaded / event.bytesTotal) * 100);
			trace("Loading: " + percentLoaded + "%");
		}
		
		private function loadComplete_image_player(event:Event):void {
			loader_player.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loadProgress_image_moderator);
			loader_player.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadComplete_image_moderator);
			trace("Complete");
			var window:Object = get_object_by_name(art_game_main_holder, "art_game_window_2");
			var art_game_left_holder:Object = get_object_by_name(window, "art_game_left_holder");
			var img_cells_holder:Object = get_object_by_name(art_game_left_holder, "img_cells_holder");
			var img_holder:Object = get_object_by_name(img_cells_holder, "img_holder");
			var l_width:Number = loader_player.content.width;
			var l_height:Number = loader_player.content.height;
			var scale_val:Number;
			if (l_width >= l_height) {
				scale_val = (max_window_width - control_panel_width) / l_width;
				loader_player.scaleX = scale_val;
				loader_player.scaleY = scale_val;
			} else {
				scale_val = max_window_height / l_height;
				loader_player.scaleX = scale_val;
				loader_player.scaleY = scale_val;
			}
			
			update_mask(l_width, l_height);
			update_cells(l_width, l_height);
			
			while (img_holder.numChildren > 0) {
				img_holder.removeChildAt(0);
			}
			img_holder.addChild(loader_player);
			update_window_2();
			open_cell();
			main_parent.parent.parent.change_window_title("Dailės žaidimas");
		}
		
		private function create_window_3():void {
			var format:TextFormat = new TextFormat();
			format.font = "Arial";
			format.size = 14;
			format.color = 0x000000;
			
			var window:Object = get_object_by_name(art_game_main_holder, "art_game_window_3");
			var resizer:MovieClip = new MovieClip;
			resizer.name = "resizer";
			window.addChild(resizer);
			resizer.graphics.beginFill(0xFF0000);
			resizer.graphics.drawRect(0, 0, 1, 1);
			resizer.graphics.endFill();
			resizer.visible = false;
			
			var background:MovieClip = new MovieClip;
			background.name = "background";
			window.addChild(background);
			
			var begin_btn:Button = new Button;
			begin_btn.label = "Begin";
			begin_btn.name = "begin_btn";
			window.addChild(begin_btn);
			begin_btn.addEventListener(MouseEvent.CLICK, begin_btn_click);
			
			/*var exit_btn:Button = new Button;
			   exit_btn.label = "Exit";
			   exit_btn.name = "exit_btn";
			 window.addChild(exit_btn);*/ /*var high_score_btn:Button = new Button;
			   high_score_btn.label = "High score";
			   high_score_btn.name = "high_score_btn";
			 window.addChild(high_score_btn);*/
			
			var select_riddle_label:TextField = new TextField;
			select_riddle_label.name = "select_riddle_label";
			select_riddle_label.selectable = false;
			select_riddle_label.multiline = true;
			select_riddle_label.wordWrap = true;
			select_riddle_label.autoSize = "left";
			select_riddle_label.mouseEnabled = false;
			select_riddle_label.width = 200;
			select_riddle_label.defaultTextFormat = format;
			select_riddle_label.text = "Select how many riddle you want to solve";
			window.addChild(select_riddle_label);
			
			var select_riddle_dropdown:ComboBox = new ComboBox;
			select_riddle_dropdown.name = "select_riddle_dropdown";
			window.addChild(select_riddle_dropdown);
			select_riddle_dropdown.addItem({label: "1 Riddle", data: 1});
			select_riddle_dropdown.addItem({label: "3 Riddles", data: 3});
			select_riddle_dropdown.addItem({label: "5 Riddles", data: 5});
			select_riddle_dropdown.addItem({label: "7 Riddles", data: 7});
			select_riddle_dropdown.addItem({label: "10 Riddles", data: 10});
			select_riddle_dropdown.width = 200;
			select_riddle_dropdown.dropdownWidth = 200;
			select_riddle_dropdown.addEventListener(Event.CHANGE, select_riddle_dropdown_selected);
			main_parent.parent.parent.change_window_title("Dailės žaidimas");
		
			//update_window_3();
		}
		
		private function update_window_3():void {
			
			var window:Object = get_object_by_name(art_game_main_holder, "art_game_window_3");
			var resizer:Object = get_object_by_name(window, "resizer");
			var select_riddle_label:Object = get_object_by_name(window, "select_riddle_label");
			select_riddle_label.x = window_padding;
			select_riddle_label.y = window_padding;
			var select_riddle_dropdown:Object = get_object_by_name(window, "select_riddle_dropdown");
			select_riddle_dropdown.x = select_riddle_label.x;
			select_riddle_dropdown.y = select_riddle_label.y + select_riddle_label.height + 10;
			var begin_btn:Object = get_object_by_name(window, "begin_btn");
			begin_btn.x = select_riddle_dropdown.x + select_riddle_dropdown.width / 2 - begin_btn.width / 2;
			begin_btn.y = select_riddle_dropdown.y + select_riddle_dropdown.height + window_padding;
			/*var high_score_btn:Object = get_object_by_name(window, "high_score_btn");
			   high_score_btn.x = select_riddle_dropdown.x;
			   high_score_btn.y = select_riddle_dropdown.y + select_riddle_dropdown.height + 10;
			   var exit_btn:Object = get_object_by_name(window, "exit_btn");
			   exit_btn.x = select_riddle_label.x + select_riddle_label.width - begin_btn.width;
			 exit_btn.y = high_score_btn.y;*/
			var background:Object = get_object_by_name(window, "background");
			
			//background.graphics.beginFill(0xFEFEFE);
			//background.graphics.drawRect(0, 0, begin_btn.x + begin_btn.width + window_padding, begin_btn.y + begin_btn.height + window_padding);
			//background.graphics.endFill();
			
			background.graphics.clear();
			drawRoundRect(background, select_riddle_dropdown.x + select_riddle_dropdown.width + window_padding, begin_btn.y + begin_btn.height + window_padding, 5, 5, 5, 5, 0, 0xFFFFFF, 0xFFFFFF, 0.5);
			
			//window.x = window.parent.width / 2 - background.width / 2;
			//window.y = window.parent.height / 2 - background.height / 2;
			
			resizer.width = background.width;
			resizer.height = background.height;
			
			main_parent.parent.parent.update_m_window();
		}
		
		public function select_riddle_dropdown_selected(event:Event):void {
			//--------------NEW START ----------------//
			/*var window:Object = get_object_by_name(art_game_main_holder, "art_game_window_3");
			   var select_riddle_dropdown:Object = get_object_by_name(window, "select_riddle_dropdown");
			 load_riddles_number = select_riddle_dropdown.selectedItem.data;*/
			//--------------NEW END ----------------//
			trace(load_riddles_number)
		}
		
		private function begin_btn_click(event:MouseEvent):void {
			//--------------NEW START ----------------//
			var window:Object = get_object_by_name(art_game_main_holder, "art_game_window_3");
			var select_riddle_dropdown:Object = get_object_by_name(window, "select_riddle_dropdown");
			load_riddles_number = select_riddle_dropdown.selectedItem.data;
			//--------------NEW END ----------------//
			create_window_2();
			show_art_game_window(2);
			clear_window("art_game_window_3");
		}
		
		private function create_window_4():void {
			var window:Object = get_object_by_name(art_game_main_holder, "art_game_window_4");
			var resizer:MovieClip = new MovieClip;
			resizer.name = "resizer";
			window.addChild(resizer);
			resizer.graphics.beginFill(0xFF0000);
			resizer.graphics.drawRect(0, 0, 1, 1);
			resizer.graphics.endFill();
			resizer.visible = false;
			
			var format:TextFormat = new TextFormat();
			format.font = "Arial";
			format.size = 14;
			format.color = 0x000000;
			var format2:TextFormat = new TextFormat();
			format2.font = "Arial";
			format2.size = 24;
			format2.color = 0x000000;
			
			var art_game_top_holder:MovieClip = new MovieClip;
			window.addChild(art_game_top_holder);
			art_game_top_holder.name = "art_game_top_holder";
			
			var background_top:MovieClip = new MovieClip;
			background_top.name = "background_top";
			art_game_top_holder.addChild(background_top);
			
			var art_game_top_title_holder:MovieClip = new MovieClip;
			art_game_top_title_holder.name = "art_game_top_title_holder";
			art_game_top_holder.addChild(art_game_top_title_holder);
			
			var art_game_top_title_background:MovieClip = new MovieClip;
			art_game_top_title_holder.addChild(art_game_top_title_background);
			art_game_top_title_background.name = "art_game_top_title_background";
			
			var art_game_top_title:TextField = new TextField;
			art_game_top_title_holder.addChild(art_game_top_title);
			art_game_top_title.name = "art_game_top_title";
			
			var art_game_bottom_holder:MovieClip = new MovieClip;
			window.addChild(art_game_bottom_holder);
			art_game_bottom_holder.name = "art_game_bottom_holder";
			
			var background_bottom:MovieClip = new MovieClip;
			background_bottom.name = "background_bottom";
			art_game_bottom_holder.addChild(background_bottom);
			
			var art_game_bottom_title_holder:MovieClip = new MovieClip;
			art_game_bottom_title_holder.name = "art_game_bottom_title_holder";
			art_game_bottom_holder.addChild(art_game_bottom_title_holder);
			
			var art_game_bottom_title_background:MovieClip = new MovieClip;
			art_game_bottom_title_holder.addChild(art_game_bottom_title_background);
			art_game_bottom_title_background.name = "art_game_bottom_title_background";
			
			var art_game_bottom_title:TextField = new TextField;
			art_game_bottom_title_holder.addChild(art_game_bottom_title);
			art_game_bottom_title.name = "art_game_bottom_title";
			
			var score_label:TextField = new TextField;
			score_label.name = "score_label";
			score_label.selectable = true;
			score_label.multiline = false;
			score_label.mouseEnabled = false;
			score_label.width = 50;
			score_label.height = 26;
			score_label.autoSize = "left";
			score_label.defaultTextFormat = format2;
			art_game_top_holder.addChild(score_label);
			
			var play_again_btn:Button = new Button;
			play_again_btn.label = "Play again";
			play_again_btn.name = "play_again_btn";
			art_game_top_holder.addChild(play_again_btn);
			play_again_btn.addEventListener(MouseEvent.CLICK, play_again_btn_click);
			
			var scores_dp:DataProvider = new DataProvider();
			//scores_dp.addItem( { Name:"Jonas Jonaitis", Score:"100" } ); 
			//scores_dp.addItem( { Name:"Petras Petraitis", Score:"90" } ); 
			var scores_data_grid:DataGrid = new DataGrid();
			scores_data_grid.name = "scores_data_grid";
			scores_data_grid.addColumn("Name");
			scores_data_grid.addColumn("Score");
			scores_data_grid.dataProvider = scores_dp;
			scores_data_grid.getColumnAt(1).width = 70;
			scores_data_grid.width = 400;
			//scores_data_grid.height = 140; 
			scores_data_grid.rowCount = 10;
			//scores_data_grid.rowCount = scores_data_grid.length;  
			art_game_bottom_holder.addChild(scores_data_grid);
			
			var share_score_btn:Button = new Button;
			share_score_btn.label = "Share score";
			share_score_btn.name = "share_score_btn";
			art_game_bottom_holder.addChild(share_score_btn);
			share_score_btn.addEventListener(MouseEvent.CLICK, share_score_btn_click);
			
			main_parent.parent.parent.change_window_title("Dailės žaidimas");
			update_high_scores_list();
			//update_window_4();
		}
		
		private function update_window_4():void {
			var window:Object = get_object_by_name(art_game_main_holder, "art_game_window_4");
			var resizer:Object = get_object_by_name(window, "resizer");
			var art_game_top_holder:Object = get_object_by_name(window, "art_game_top_holder");
			var art_game_bottom_holder:Object = get_object_by_name(window, "art_game_bottom_holder");
			var art_game_top_title_holder:Object = get_object_by_name(art_game_top_holder, "art_game_top_title_holder");
			var art_game_bottom_title_holder:Object = get_object_by_name(art_game_bottom_holder, "art_game_bottom_title_holder");
			var art_game_top_title_background:Object = get_object_by_name(art_game_top_title_holder, "art_game_top_title_background");
			var art_game_bottom_title_background:Object = get_object_by_name(art_game_bottom_title_holder, "art_game_bottom_title_background");
			var art_game_top_title:Object = get_object_by_name(art_game_top_title_holder, "art_game_top_title");
			var art_game_bottom_title:Object = get_object_by_name(art_game_bottom_title_holder, "art_game_bottom_title");
			var score_label:Object = get_object_by_name(art_game_top_holder, "score_label");
			var play_again_btn:Object = get_object_by_name(art_game_top_holder, "play_again_btn");
			var background_top:Object = get_object_by_name(art_game_top_holder, "background_top");
			var background_bottom:Object = get_object_by_name(art_game_bottom_holder, "background_bottom");
			var scores_data_grid:Object = get_object_by_name(art_game_bottom_holder, "scores_data_grid");
			var share_score_btn:Object = get_object_by_name(art_game_bottom_holder, "share_score_btn");
			
			art_game_top_title.text = "Your score";
			art_game_top_title.y = 0;
			art_game_top_title.x = title_padding_hor;
			update_area_title(art_game_top_title_holder, art_game_top_title_background, art_game_top_title, art_game_top_title.text, 200);
			score_label.text = player_total_points;
			score_label.y = art_game_top_title.y + art_game_top_title.height + window_padding;
			play_again_btn.y = score_label.y + score_label.height + window_padding;
			drawRoundRect(background_top, scores_data_grid.x + scores_data_grid.width + 2 * window_padding, play_again_btn.y + play_again_btn.height + window_padding, 5, 5, 5, 5, 0, 0xFFFFFF, 0xFFFFFF, 0.5);
			art_game_top_title_holder.x = background_top.width / 2 - art_game_top_title_holder.width / 2;
			score_label.x = background_top.width / 2 - score_label.width / 2;
			play_again_btn.x = background_top.width / 2 - play_again_btn.width / 2;
			art_game_bottom_holder.y = background_top.y + background_top.height + window_padding;
			art_game_bottom_title.text = "High score";
			art_game_bottom_title.y = 0;
			art_game_bottom_title.x = title_padding_hor;
			update_area_title(art_game_bottom_title_holder, art_game_bottom_title_background, art_game_bottom_title, art_game_bottom_title.text, 200);
			scores_data_grid.x = window_padding;
			scores_data_grid.y = art_game_bottom_title.y + art_game_bottom_title.height + window_padding;
			share_score_btn.y = scores_data_grid.y + scores_data_grid.height + window_padding;
			drawRoundRect(background_bottom, scores_data_grid.x + scores_data_grid.width + window_padding, share_score_btn.y + share_score_btn.height + window_padding, 5, 5, 5, 5, 0, 0xFFFFFF, 0xFFFFFF, 0.5);
			art_game_bottom_title_holder.x = background_bottom.width / 2 - art_game_top_title_holder.width / 2;
			share_score_btn.x = background_bottom.width / 2 - share_score_btn.width / 2;
			resizer.width = background_bottom.width;
			resizer.height = art_game_bottom_holder.y + background_bottom.height;
			main_parent.parent.parent.update_m_window();
		}
		
		public function update_high_scores_list():void {
			var amfphp:AMFPHP = new AMFPHP(readResult11, onFault).xcall("dm.ArtGame.get_all_high_scores");
		}
		
		public function readResult11(r:Array):void {
			if (r == false) {
				trace("Error reading records.");
			} else {
				var window:Object = get_object_by_name(art_game_main_holder, "art_game_window_4");
				var art_game_bottom_holder:Object = get_object_by_name(window, "art_game_bottom_holder");
				var scores_data_grid:Object = get_object_by_name(art_game_bottom_holder, "scores_data_grid");
				var share_score_btn:Object = get_object_by_name(art_game_bottom_holder, "share_score_btn");
				high_scores_array = [];
				high_scores_array = r;
				scores_data_grid.dataProvider.removeAll();
				for (var i:uint = 0; i < high_scores_array.length; i++) {
					scores_data_grid.addItem({Name: high_scores_array[i][1], Score: high_scores_array[i][2]});
				}
				
				if ((player_total_points > high_scores_array[high_scores_array.length - 1][2]) && (score_was_shared == false)) {
					share_score_btn.visible = true;
				} else {
					share_score_btn.visible = false;
				}
				
			}
		}
		
		private function share_score_btn_click(event:MouseEvent):void {
			event.target.visible = false;
			score_was_shared = true;
			var params:Array = [MyManager.instance.avatar.name, player_total_points];
			
			var amfphp:AMFPHP = new AMFPHP(readResult12, onFault).xcall("dm.ArtGame.share_score", params);
		}
		
		public function readResult12(r:Object):void {
			if (r == false) {
				trace("Error reading records.");
			} else {
				update_high_scores_list();
			}
		}
		
		private function play_again_btn_click(event:MouseEvent):void {
			clear_window("art_game_window_4");
			create_window_3();
			show_art_game_window(3);
		}
		
		private function create_window_5():void {
			var format:TextFormat = new TextFormat();
			format.font = "Arial";
			format.size = 14;
			format.color = 0x000000;
			var window:Object = get_object_by_name(art_game_main_holder, "art_game_window_5");
			
			var resizer:MovieClip = new MovieClip;
			resizer.name = "resizer";
			window.addChild(resizer);
			resizer.graphics.beginFill(0xFF0000);
			resizer.graphics.drawRect(0, 0, 1, 1);
			resizer.graphics.endFill();
			resizer.visible = false;
			
			var background:MovieClip = new MovieClip;
			background.name = "background";
			window.addChild(background);
			var ok_btn:Button = new Button;
			ok_btn.label = "Ok";
			ok_btn.name = "ok_btn";
			window.addChild(ok_btn);
			ok_btn.addEventListener(MouseEvent.CLICK, update_riddle_name);
			var cancel_btn:Button = new Button;
			cancel_btn.label = "Cancel";
			cancel_btn.name = "cancel_btn";
			window.addChild(cancel_btn);
			cancel_btn.addEventListener(MouseEvent.CLICK, cancel_window);
			var name_edit_field:TextField = new TextField;
			name_edit_field.name = "name_edit_field";
			//name_edit_field.autoSize = "left";
			name_edit_field.type = "input";
			name_edit_field.selectable = true;
			name_edit_field.multiline = false;
			name_edit_field.mouseEnabled = true;
			name_edit_field.border = true;
			name_edit_field.borderColor = 0xcccccc;
			name_edit_field.width = 230;
			name_edit_field.height = 22;
			name_edit_field.defaultTextFormat = format;
			name_edit_field.text = "Name edit";
			window.addChild(name_edit_field);
			update_window_5();
		}
		
		private function update_window_5():void {
			var window:Object = get_object_by_name(art_game_main_holder, "art_game_window_5");
			var resizer:Object = get_object_by_name(window, "resizer");
			var name_edit_field:Object = get_object_by_name(window, "name_edit_field");
			name_edit_field.x = window_padding;
			name_edit_field.y = window_padding;
			var ok_btn:Object = get_object_by_name(window, "ok_btn");
			ok_btn.x = name_edit_field.x;
			ok_btn.y = name_edit_field.y + name_edit_field.height + 10;
			var cancel_btn:Object = get_object_by_name(window, "cancel_btn");
			cancel_btn.x = name_edit_field.x + name_edit_field.width - cancel_btn.width;
			cancel_btn.y = ok_btn.y;
			var background:Object = get_object_by_name(window, "background");
			background.graphics.clear();
			drawRoundRect(background, name_edit_field.x + name_edit_field.width + window_padding, cancel_btn.y + cancel_btn.height + window_padding, 5, 5, 5, 5, 0, 0xFFFFFF, 0xFFFFFF, 0.5);
			resizer.width = background.width;
			resizer.height = background.height;
			main_parent.parent.parent.update_m_window();
		}
		
		private function create_window_6():void {
			var format:TextFormat = new TextFormat();
			format.font = "Arial";
			format.size = 14;
			format.color = 0x000000;
			var window:Object = get_object_by_name(art_game_main_holder, "art_game_window_6");
			
			var resizer:MovieClip = new MovieClip;
			resizer.name = "resizer";
			window.addChild(resizer);
			resizer.graphics.beginFill(0xFF0000);
			resizer.graphics.drawRect(0, 0, 1, 1);
			resizer.graphics.endFill();
			resizer.visible = false;
			
			var background:MovieClip = new MovieClip;
			background.name = "background";
			window.addChild(background);
			var load_btn:Button = new Button;
			load_btn.label = "Load";
			load_btn.name = "load_btn";
			window.addChild(load_btn);
			load_btn.addEventListener(MouseEvent.CLICK, load_riddle);
			var cancel_btn:Button = new Button;
			cancel_btn.label = "Cancel";
			cancel_btn.name = "cancel_btn";
			window.addChild(cancel_btn);
			cancel_btn.addEventListener(MouseEvent.CLICK, cancel_window);
			var riddle_name_label:TextField = new TextField;
			riddle_name_label.name = "riddle_name_label";
			riddle_name_label.selectable = false;
			riddle_name_label.multiline = false;
			riddle_name_label.mouseEnabled = true;
			riddle_name_label.border = false;
			riddle_name_label.width = 230;
			riddle_name_label.height = 22;
			riddle_name_label.defaultTextFormat = format;
			riddle_name_label.text = "Riddle name";
			window.addChild(riddle_name_label);
			var riddles_list:List = new List;
			riddles_list.name = "riddles_list";
			riddles_list.setSize(300, 160);
			window.addChild(riddles_list);
			riddles_list.addEventListener(Event.CHANGE, riddles_list_item_selected);
			
			update_window_6();
		}
		
		private function update_window_6():void {
			var window:Object = get_object_by_name(art_game_main_holder, "art_game_window_6");
			var resizer:Object = get_object_by_name(window, "resizer");
			var riddle_name_label:Object = get_object_by_name(window, "riddle_name_label");
			riddle_name_label.x = window_padding;
			riddle_name_label.y = window_padding;
			var riddles_list:Object = get_object_by_name(window, "riddles_list");
			riddles_list.x = riddle_name_label.x;
			riddles_list.y = riddle_name_label.y + riddle_name_label.height + 10;
			var load_btn:Object = get_object_by_name(window, "load_btn");
			load_btn.x = riddles_list.x;
			load_btn.y = riddles_list.y + riddles_list.height + 10;
			var cancel_btn:Object = get_object_by_name(window, "cancel_btn");
			cancel_btn.x = riddles_list.x + riddles_list.width - cancel_btn.width;
			cancel_btn.y = load_btn.y;
			var background:Object = get_object_by_name(window, "background");
			//background.graphics.clear();
			//background.graphics.beginFill(0xFEFEFE);
			//background.graphics.drawRect(0, 0, riddles_list.x + riddles_list.width + window_padding, cancel_btn.y + cancel_btn.height + window_padding);
			//background.graphics.endFill();
			//window.x = window.parent.width / 2 - background.width / 2;
			//window.y = window.parent.height / 2 - background.height / 2;
			
			background.graphics.clear();
			drawRoundRect(background, riddles_list.x + riddles_list.width + window_padding, cancel_btn.y + cancel_btn.height + window_padding, 5, 5, 5, 5, 0, 0xFFFFFF, 0xFFFFFF, 0.5);
			resizer.width = background.width;
			resizer.height = background.height;
			main_parent.parent.parent.update_m_window();
		
		}
		
		private function create_window_7():void {
			var format:TextFormat = new TextFormat();
			format.font = "Arial";
			format.size = 14;
			format.color = 0x000000;
			var window:Object = get_object_by_name(art_game_main_holder, "art_game_window_7");
			var background:MovieClip = new MovieClip;
			background.name = "background";
			window.addChild(background);
			var glow:GlowFilter = new GlowFilter();
			glow.quality = 3;
			glow.blurX = 5;
			glow.blurY = 5;
			glow.color = 0xaaaaaa;
			background.filters = [glow];
			var ok_btn:Button = new Button;
			ok_btn.label = "Ok";
			ok_btn.name = "ok_btn";
			window.addChild(ok_btn);
			ok_btn.addEventListener(MouseEvent.CLICK, edit_answer);
			var cancel_btn:Button = new Button;
			cancel_btn.label = "Cancel";
			cancel_btn.name = "cancel_btn";
			window.addChild(cancel_btn);
			cancel_btn.addEventListener(MouseEvent.CLICK, cancel_window);
			var edit_answer_field:TextField = new TextField;
			edit_answer_field.name = "edit_answer_field";
			//name_edit_field.autoSize = "left";
			edit_answer_field.type = "input";
			edit_answer_field.selectable = true;
			edit_answer_field.multiline = false;
			edit_answer_field.mouseEnabled = true;
			edit_answer_field.border = true;
			edit_answer_field.borderColor = 0xcccccc;
			edit_answer_field.width = 230;
			edit_answer_field.height = 22;
			edit_answer_field.defaultTextFormat = format;
			edit_answer_field.text = "";
			window.addChild(edit_answer_field);
			update_window_7();
		}
		
		private function update_window_7():void {
			var window:Object = get_object_by_name(art_game_main_holder, "art_game_window_7");
			var edit_answer_field:Object = get_object_by_name(window, "edit_answer_field");
			edit_answer_field.x = window_padding;
			edit_answer_field.y = window_padding;
			var ok_btn:Object = get_object_by_name(window, "ok_btn");
			ok_btn.x = edit_answer_field.x;
			ok_btn.y = edit_answer_field.y + edit_answer_field.height + 10;
			var cancel_btn:Object = get_object_by_name(window, "cancel_btn");
			cancel_btn.x = edit_answer_field.x + edit_answer_field.width - cancel_btn.width;
			cancel_btn.y = ok_btn.y;
			var background:Object = get_object_by_name(window, "background");
			background.graphics.clear();
			background.graphics.beginFill(0xFEFEFE);
			background.graphics.drawRect(0, 0, edit_answer_field.x + edit_answer_field.width + window_padding, cancel_btn.y + cancel_btn.height + window_padding);
			background.graphics.endFill();
			window.x = window.parent.width / 2 - background.width / 2;
			window.y = window.parent.height / 2 - background.height / 2;
		}
		
		private function create_window_8():void {
			var format:TextFormat = new TextFormat();
			format.font = "Arial";
			format.size = 14;
			format.color = 0x000000;
			var window:Object = get_object_by_name(art_game_main_holder, "art_game_window_8");
			
			var resizer:MovieClip = new MovieClip;
			resizer.name = "resizer";
			window.addChild(resizer);
			resizer.graphics.beginFill(0xFF0000);
			resizer.graphics.drawRect(0, 0, 1, 1);
			resizer.graphics.endFill();
			resizer.visible = false;
			
			var background:MovieClip = new MovieClip;
			background.name = "background";
			window.addChild(background);
			/*var glow:GlowFilter = new GlowFilter();
			   glow.quality = 3;
			   glow.blurX = 5;
			   glow.blurY = 5;
			   glow.color=0xaaaaaa;
			 background.filters = [glow];*/
			var ok_btn:Button = new Button;
			ok_btn.label = "Ok";
			ok_btn.name = "ok_btn";
			window.addChild(ok_btn);
			ok_btn.addEventListener(MouseEvent.CLICK, add_answer);
			var cancel_btn:Button = new Button;
			cancel_btn.label = "Cancel";
			cancel_btn.name = "cancel_btn";
			window.addChild(cancel_btn);
			cancel_btn.addEventListener(MouseEvent.CLICK, cancel_window);
			var add_answer_field:TextField = new TextField;
			add_answer_field.name = "add_answer_field";
			//name_edit_field.autoSize = "left";
			add_answer_field.type = "input";
			add_answer_field.selectable = true;
			add_answer_field.multiline = false;
			add_answer_field.mouseEnabled = true;
			add_answer_field.border = true;
			add_answer_field.borderColor = 0xcccccc;
			add_answer_field.width = 230;
			add_answer_field.height = 22;
			add_answer_field.defaultTextFormat = format;
			add_answer_field.text = "";
			window.addChild(add_answer_field);
			update_window_8();
		}
		
		private function update_window_8():void {
			var window:Object = get_object_by_name(art_game_main_holder, "art_game_window_8");
			var resizer:Object = get_object_by_name(window, "resizer");
			var add_answer_field:Object = get_object_by_name(window, "add_answer_field");
			add_answer_field.x = window_padding;
			add_answer_field.y = window_padding;
			var ok_btn:Object = get_object_by_name(window, "ok_btn");
			ok_btn.x = add_answer_field.x;
			ok_btn.y = add_answer_field.y + add_answer_field.height + 10;
			var cancel_btn:Object = get_object_by_name(window, "cancel_btn");
			cancel_btn.x = add_answer_field.x + add_answer_field.width - cancel_btn.width;
			cancel_btn.y = ok_btn.y;
			var background:Object = get_object_by_name(window, "background");
			background.graphics.clear();
			drawRoundRect(background, add_answer_field.x + add_answer_field.width + window_padding, cancel_btn.y + cancel_btn.height + window_padding, 5, 5, 5, 5, 0, 0xFFFFFF, 0xFFFFFF, 0.5);
			resizer.width = background.width;
			resizer.height = background.height;
			main_parent.parent.parent.update_m_window();
		}
		
		public function get_object_by_name(holder:Object, object_name:String):Object {
			var obj:DisplayObject = holder.getChildByName(object_name);
			var obj_index:Number = holder.getChildIndex(obj);
			var return_obj:Object = holder.getChildAt(obj_index);
			return return_obj;
		}
		
		private function getcode():String {
			var d:Date = new Date();
			var string_val:String = d.getFullYear() + "" + d.getMonth() + "" + d.getDay() + "" + d.getHours() + "" + d.getMinutes() + "" + d.getSeconds();
			return string_val;
		}
		
		private function add_new_riddle():void {
			var amfphp:AMFPHP = new AMFPHP(readResult3, onFault).xcall("dm.ArtGame.insert_riddle");
		}
		
		public function readResult3(r:Object):void {
			if (r == false) {
				trace("Error reading records.");
			} else {
				var window:Object = get_object_by_name(art_game_main_holder, "art_game_window_1");
				var image_area:Object = get_object_by_name(window, "image_area");
				var navigation_area:Object = get_object_by_name(window, "navigation_area");
				var riddle_name_label:Object = get_object_by_name(navigation_area, "riddle_name_label");
				var answers_data_grid:Object = get_object_by_name(navigation_area, "answers_data_grid");
				riddle_name_label.text = r['name'];
				current_riddle_id = r['id'];
				current_riddle_name = r['name'];
				var answers_dp:DataProvider = new DataProvider();
				answers_array = [];
				answers_array = r['answers'];
				for (var m:uint = 0; m < r['answers'].length; m++) {
					var is_correct_value:Boolean;
					if (r['answers'][m]['is_correct'] == 1) {
						is_correct_value = true;
						current_correct_answer_id = r['answers'][m]['id'];
					} else {
						is_correct_value = false;
					}
					
					answers_dp.addItem({col1: m + 1 + ".", col2: r['answers'][m]['text'], col3: is_correct_value});
					
				}
				answers_data_grid.dataProvider = answers_dp;
				
				while (image_area.numChildren > 0) {
					image_area.removeChildAt(image_area.numChildren - 1);
				}
				
				current_image_name = r['image'];
				
				if (r['image'] != "") {
					var img_url:String = IMG_PATH + r['image'];
					var url:URLRequest = new URLRequest(img_url);
					//loader_moderator = new Loader();
					loader_moderator.load(url);
					loader_moderator.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
					loader_moderator.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
					loader_moderator.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadProgress_image_moderator);
					loader_moderator.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete_image_moderator);
				}
				
				update_window_1();
			}
		
		}
		
		private function errorHandler(event:ErrorEvent):void {
			trace("errorHandler: " + event);
		}
		
		private function add_answer(event:MouseEvent):void {
			var window:Object = get_object_by_name(art_game_main_holder, "art_game_window_8");
			var add_answer_field:Object = get_object_by_name(window, "add_answer_field");
			var params:Array = [current_riddle_id, add_answer_field.text];
			
			var amfphp:AMFPHP = new AMFPHP(readResult5, onFault).xcall("dm.ArtGame.add_answer", params);
		}
		
		public function readResult5(r:Object):void {
			if (r == false) {
				trace("Error reading records.");
			} else {
				trace("Answer was added")
				clear_window("art_game_window_8");
				create_window_1();
				show_art_game_window(1);
			}
		}
		
		private function load_riddle(event:MouseEvent):void {
			var window:Object = get_object_by_name(art_game_main_holder, "art_game_window_6");
			var riddles_list:Object = get_object_by_name(window, "riddles_list");
			current_riddle_name = riddles_list.selectedItem.label;
			current_riddle_id = riddles_list.selectedItem.data;
			clear_window("art_game_window_6");
			create_window_1();
			show_art_game_window(1);
		}
		
		private function cancel_window(event:MouseEvent):void {
			clear_window("art_game_window_5");
			clear_window("art_game_window_6");
			clear_window("art_game_window_8");
			current_riddle_name = "";
			create_window_1();
			show_art_game_window(1, 1);
		}
		
		public function riddles_list_item_selected(event:Event):void {
			var window:Object = get_object_by_name(art_game_main_holder, "art_game_window_6");
			var load_btn:Object = get_object_by_name(window, "load_btn");
			load_btn.enabled = true;
		}
		
		private function update_riddle_name(event:MouseEvent):void {
			var window:Object = get_object_by_name(art_game_main_holder, "art_game_window_5");
			var name_edit_field:Object = get_object_by_name(window, "name_edit_field");
			current_riddle_name = name_edit_field.text;
			var params:Array = [current_riddle_id, current_riddle_name, 0];
			
			var amfphp:AMFPHP = new AMFPHP(readResult4, onFault).xcall("dm.ArtGame.update_riddle_name", params);
		}
		
		public function readResult4(r:Object):void {
			if (r == false) {
				trace("Error reading records.");
			} else {
				trace("name saved");
				clear_window("art_game_window_5");
				create_window_1();
				show_art_game_window(1, 1);
			}
		
		}
		
		private function update_main_moderator_window():void {
			if (current_riddle_id != -1) {
				var amfphp:AMFPHP = new AMFPHP(readResult2, onFault).xcall("dm.ArtGame.get_all_riddle_info", current_riddle_id);
			}
		}
		
		public function readResult2(r:Object):void {
			if (r == false) {
				trace("Error reading records.");
			} else {
				var window:Object = get_object_by_name(art_game_main_holder, "art_game_window_1");
				var image_area:Object = get_object_by_name(window, "image_area");
				var navigation_area:Object = get_object_by_name(window, "navigation_area");
				var riddle_name_label:Object = get_object_by_name(navigation_area, "riddle_name_label");
				var answers_data_grid:Object = get_object_by_name(navigation_area, "answers_data_grid");
				riddle_name_label.text = r['name'];
				var answers_dp:DataProvider = new DataProvider();
				answers_array = [];
				answers_array = r['answers'];
				for (var m:uint = 0; m < r['answers'].length; m++) {
					var is_correct_value:Boolean;
					if (r['answers'][m]['is_correct'] == 1) {
						is_correct_value = true;
						current_correct_answer_id = r['answers'][m]['id'];
					} else {
						is_correct_value = false;
					}
					
					answers_dp.addItem({col1: m + 1 + ".", col2: r['answers'][m]['text'], col3: is_correct_value});
					
				}
				answers_data_grid.dataProvider = answers_dp;
				
				while (image_area.numChildren > 0) {
					image_area.removeChildAt(image_area.numChildren - 1);
				}
				current_image_name = r['image'];
				
				if (r['image'] != "") {
					var img_url:String = IMG_PATH + r['image'];
					var url:URLRequest = new URLRequest(img_url);
					//loader_moderator = new Loader();
					loader_moderator.load(url);
					loader_moderator.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
					loader_moderator.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
					loader_moderator.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadProgress_image_moderator);
					loader_moderator.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete_image_moderator);
				}
				selected_answer_index = -1;
				
				update_window_1();
				
			}
		
		}
		
		private function loadProgress_image_moderator(event:ProgressEvent):void {
			var percentLoaded:Number = Math.round((event.bytesLoaded / event.bytesTotal) * 100);
			trace("Loading: " + percentLoaded + "%");
		}
		
		private function loadComplete_image_moderator(event:Event):void {
			loader_moderator.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loadProgress_image_moderator);
			loader_moderator.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadComplete_image_moderator);
			trace("Complete");
			var window:Object = get_object_by_name(art_game_main_holder, "art_game_window_1");
			var image_area:Object = get_object_by_name(window, "image_area");
			var l_width:Number = loader_moderator.content.width;
			var l_height:Number = loader_moderator.content.height;
			var scale_val:Number;
			if (l_width >= l_height) {
				scale_val = (max_window_width - control_panel_width) / l_width;
				loader_moderator.scaleX = scale_val;
				loader_moderator.scaleY = scale_val;
			} else {
				scale_val = max_window_height / l_height;
				loader_moderator.scaleX = scale_val;
				loader_moderator.scaleY = scale_val;
			}
			image_area.addChild(loader_moderator);
			update_window_1();
		}
		
		private function drawRoundRect(m_clip:Object, w:Number, h:Number, tl:Number, tr:Number, bl:Number, br:Number, thick:Number, borderColor:Number, bgColor:Number, trans:Number):void {
			if (thick != 0)
				m_clip.graphics.lineStyle(thick, borderColor);
			m_clip.graphics.beginFill(bgColor, trans);
			m_clip.graphics.moveTo(0, tl);
			m_clip.graphics.curveTo(0, 0, tl, 0);
			m_clip.graphics.lineTo(w - tr, 0);
			m_clip.graphics.curveTo(w, 0, w, tr);
			m_clip.graphics.lineTo(w, h - br);
			m_clip.graphics.curveTo(w, h, w - br, h);
			m_clip.graphics.lineTo(bl, h);
			m_clip.graphics.curveTo(0, h, 0, h - bl);
			m_clip.graphics.endFill();
		}
		
		private function draw_title_shadow(obj:Object, color1:Number, color2:Number, alpha1:Number, alpha2:Number):void {
			var fillType:String = "linear";
			var colors:Array = [color1, color2];
			var alphas:Array = [alpha1, alpha2];
			var ratios:Array = [0, 255];
			var matr:Matrix = new Matrix();
			matr.createGradientBox(obj.width, 6, Math.PI / 2, 3, 0);
			obj.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr);
			obj.graphics.moveTo(0, 0);
			obj.graphics.lineTo(obj.width, 0);
			obj.graphics.lineTo(obj.width, 6);
			obj.graphics.lineTo(0, 6);
			obj.graphics.endFill();
		}
		
		private function print_childs(obj:Object):void {
			trace(obj.name);
			if (obj is MovieClip && obj.numChildren > 0) {
				for (var i:uint = 0; i < obj.numChildren; i++) {
					var obj2:Object = obj.getChildAt(i);
					print_childs(obj2);
				}
			}
		}
		
		private function clear_window(window_name:String):void {
			for (var i:uint = 0; i < (art_game_main_holder.numChildren); i++) {
				var obj:Object = art_game_main_holder.getChildAt(i);
				if (window_name == obj.name) {
					while (obj.numChildren > 0) {
						obj.removeChildAt(0);
					}
				}
			}
		}
	
	}

}