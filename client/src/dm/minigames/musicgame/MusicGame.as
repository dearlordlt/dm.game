package dm.minigames.musicgame {


import dm.game.managers.MyManager;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.filters.GlowFilter;
import flash.events.MouseEvent;
import flash.geom.*;
import fl.controls.ComboBox;
import flash.net.Responder;
import fl.video.FLVPlayback;
import fl.controls.Button;
// import mx.core.FlexTextField;
import sound_button;
import SeekBar;
import fl.video.MetadataEvent;
import flash.display.Loader;
import flash.events.ProgressEvent;
import flash.events.IOErrorEvent;
import fl.video.*;
import flash.media.Sound
import flash.media.SoundChannel;
import fl.controls.Label;
import flash.net.URLRequest;
import flash.media.SoundMixer;
import flash.media.SoundTransform;
import utils.AMFPHP;

/**
 * Music mini game
 * @author Darius Dauskurdis dariusdxd@gmail.com
 * @version $Id$
 */
public class MusicGame extends Sprite {
	
	public var main_parent : *;
	
	public var m_window_holder : Sprite;
	
	public var m_window_background : Sprite;
	
	public var m_window_content_holder : Sprite;
	
	public var m_window_title : TextField;
	
	public var m_window_title_holder : Sprite;
	
	public var m_window_title_background : Sprite;
	
	public var close_btn : close_circle;
	
	public var m_window_cover : Sprite;
	
	public var close_circle_rad : Number = 6;
	
	public var m_window_padding : Number = 10;
	
	public var window_width : Number = 300;
	
	public var t_format : TextFormat;
	
	public var title_padding_hor : Number = 20;
	
	public var title_padding_ver : Number = 5;
	
	public var title_corner : Number = 10;
	
	public var window_part_1 : Sprite;
	
	public var window_part_2 : Sprite;
	
	public var window_part_3 : Sprite;
	
	public var max_block_width : Number = 800;
	
	public var tab_1 : Sprite;
	
	public var tab_2 : Sprite;
	
	private const FILE_PATH : String = "http://vds000004.hosto.lt/dm/MusicGame";
	
	public var user_id : Number = 1;
	
	public var styled_table_obj_1 : StyledTable;
	
	public var styled_table_obj_2 : StyledTable;
	
	public var select_song_dropdown : ComboBox;
	
	public var flvPlayer : FLVPlayback;
	
	public var play_btn : Button;
	
	public var pause_btn : Button;
	
	public var play_game_btn : Button;
	
	public var friend_play_game_btn : Button;
	
	public var submit_level_btn : Button;
	
	public var submit_result_btn : Button;
	
	public var cancel_result_btn : Button;
	
	public var result_popup_score : TextField;
	
	public var sound_activate_btn : sound_button;
	
	public var new_video : Boolean = false;
	
	public var current_video_file : String;
	
	public var main_state : Number = 1; //1-Play video, 2-Test Yourself, 3-Challange Your friend;
	
	public var select_level_popup : Sprite;
	
	public var select_level_popup_stars_holder : Sprite;
	
	public var result_popup : Sprite;
	
	public var current_level : Number = 1;
	
	public var playing_level : Number = 1;
	
	public var main_stars_holder : Sprite;
	
	public var points_history_text : TextField;
	
	public var current_points_text : TextField;
	
	public var points_splitter : Sprite;
	
	private var sound_rect : Rectangle;
	
	public var game_sliding_area : Sprite;
	
	public var game_sliding_mask_area : Sprite;
	
	public var game_sliding_target_line : Sprite;
	
	public var game_time_sliding_area : Sprite;
	
	public var current_video_press_nodes : Array = new Array();
	
	public var current_video_duration : Number;
	
	public var game_is_playing : Boolean = false;
	
	public var need_press_key : Boolean = false;
	
	public var good_press : Boolean = false;
	
	public var next_press_node_time : Number;
	
	public var user_current_score : Number = 0;
	
	public var next_press_node_index : Number = 0;
	
	public var speed : Number = 100;
	
	public var current_position_x : Number;
	
	public var node_position_x : Number;
	
	public var score_animation_area : Sprite;
	
	public var soundArray : Array = new Array();
	
	public var was_pressed : Boolean = false;
	
	public var end_node : Boolean = false;
	
	public var game_area : Sprite;
	
	public var lines_area : Sprite;
	
	public var triple_sum : Number = 0;
	
	public var triple_num : Number;
	
	public var user_sounds_string_array : Array;
	
	public var user_created_string_array : Array = [];
	
	public var user_created_string : String;
	
	public var sound_channel : SoundChannel = new SoundChannel;
	
	public var rule_level_1_right_press : Number = 1;
	
	public var rule_level_2_right_press : Number = 2;
	
	public var rule_level_3_right_press : Number = 3;
	
	public var rule_level_1_wrong_press : Number = 3;
	
	public var rule_level_2_wrong_press : Number = 2;
	
	public var rule_level_3_wrong_press : Number = 1;
	
	public var rule_level_1_miss_press : Number = 6;
	
	public var rule_level_2_miss_press : Number = 4;
	
	public var rule_level_3_miss_press : Number = 2;
	
	public var rule_level_1_triple : Number = 3;
	
	public var rule_level_2_triple : Number = 3;
	
	public var rule_level_3_triple : Number = 3;
	
	public var current_video_id : Number;
	
	public var current_video_title : String;
	
	public var seekbar_obj : SeekBar;
	
	public var seeker_cover : Sprite;
	
	public var video_area : Sprite;
	
	public var sound_navigation : Sprite;
	
	public var sound_level : Number;
	
	public var sound_scroller : Sprite;
	
	//NEW START 2012-10-09
	public var wrong_soundArray : Array = new Array();
	
	public var wrong_sounds_number : Number = 3;
	
	public var current_sound_number : Number = 1;
	
	//NEW END 2012-10-09
	
	/**
	 * Class constructor
	 */
	public function MusicGame() {
		this.addEventListener( Event.ADDED_TO_STAGE, this.init );
	}
	
	public function destroy ( event : Event = null ) : void {
		
		this.parent.removeChild( this );
		this.flvPlayer.stop();
		
	}
	
	/**
	 * Init
	 */
	public function init ( event : Event = null ) : void {
		this.removeEventListener( Event.ADDED_TO_STAGE, this.init );
		main_parent = this.parent;
		m_window_holder = new Sprite;
		this.addChild( m_window_holder );
		m_window_background = new Sprite;
		m_window_holder.addChild( m_window_background );
		m_window_background.addEventListener( MouseEvent.MOUSE_DOWN, m_window_background_mouseDown )
		m_window_background.addEventListener( MouseEvent.MOUSE_UP, m_window_background_mouseUp );
		
		var glow : GlowFilter = new GlowFilter();
		glow.quality = 3;
		glow.blurX = 5;
		glow.blurY = 5;
		glow.color = 0xaaaaaa;
		m_window_background.filters = [ glow ];
		
		close_btn = new close_circle;
		m_window_holder.addChild( close_btn );
		m_window_title_holder = new Sprite;
		m_window_holder.addChild( m_window_title_holder );
		m_window_title_holder.mouseEnabled = false;
		m_window_title_holder.mouseChildren = false;
		close_btn.addEventListener(MouseEvent.CLICK, close_btn_click);
		m_window_content_holder = new Sprite;
		m_window_holder.addChild( m_window_content_holder );
		
		m_window_title_background = new Sprite;
		m_window_title_holder.addChild( m_window_title_background );
		m_window_title = new TextField;
		m_window_title_holder.addChild( m_window_title );
		
		window_part_1 = new Sprite;
		window_part_1.name = "window_part_1";
		m_window_content_holder.addChild( window_part_1 );
		var window_part_1_background : Sprite = new Sprite;
		window_part_1_background.name = "window_part_1_background";
		window_part_1.addChild( window_part_1_background );
		drawRoundRect( window_part_1_background, ( max_block_width - m_window_padding ) / 2, 340, 5, 5, 5, 5, 0, 0xFFFFFF, 0xFFFFFF, 0.9 );
		
		window_part_2 = new Sprite;
		window_part_2.name = "window_part_2";
		m_window_content_holder.addChild( window_part_2 );
		var window_part_2_background : Sprite = new Sprite;
		window_part_2_background.name = "window_part_2_background";
		window_part_2.addChild( window_part_2_background );
		drawRoundRect( window_part_2_background, 450, 340, 5, 5, 5, 5, 0, 0xFFFFFF, 0xFFFFFF, 0.9 );
		window_part_2.x = window_part_1.x + window_part_1.width + m_window_padding;
		
		window_part_3 = new Sprite;
		window_part_3.name = "window_part_3";
		m_window_content_holder.addChild( window_part_3 );
		var window_part_3_background : Sprite = new Sprite;
		window_part_3_background.name = "window_part_3_background";
		window_part_3.addChild( window_part_3_background );
		drawRoundRect( window_part_3_background, window_part_2.x + window_part_2.width, 250, 5, 5, 5, 5, 0, 0xFFFFFF, 0xFFFFFF, 0.9 );
		window_part_3.x = window_part_3.x;
		window_part_3.y = window_part_1.y + window_part_1.height + m_window_padding;
		
		select_song_dropdown = new ComboBox;
		select_song_dropdown.name = "select_song_dropdown";
		window_part_1.addChild( select_song_dropdown );
		select_song_dropdown.prompt = "Select music";
		select_song_dropdown.width = 200;
		select_song_dropdown.addEventListener( Event.CHANGE, list_song_selected );
		
		change_window_title( "MUZIKOS ŽAIDIMAS" );
		
		var video_block_title : Sprite = new Sprite;
		video_block_title.name = "video_block_title";
		window_part_1.addChild( video_block_title );
		add_tab_title( video_block_title, "Sprendimai", "static" );
		video_block_title.x = window_part_1.width / 2 - video_block_title.width / 2;
		select_song_dropdown.x = window_part_1.width / 2 - select_song_dropdown.width / 2;
		select_song_dropdown.y = video_block_title.y + video_block_title.height + 10;
		
		main_stars_holder = new Sprite;
		window_part_1.addChild( main_stars_holder );
		main_stars_holder.x = window_part_1.width / 2 - main_stars_holder.width / 2;
		main_stars_holder.y = video_block_title.y + video_block_title.height + 40;
		
		var stars : Sprite = star_generator( 3, 0, 2, true );
		main_stars_holder.addChild( stars );
		
		main_stars_holder.x = window_part_1.width / 2 - main_stars_holder.width / 2;
		main_stars_holder.y = video_block_title.y + video_block_title.height + 40;
		
		video_area = new Sprite;
		window_part_1.addChild( video_area );
		drawRoundRect( video_area, 370, 210, 3, 3, 3, 3, 0, 0xD5D6D7, 0xD5D6D7, 1 );
		video_area.y = video_block_title.y + video_block_title.height + 60;
		video_area.x = window_part_1.width / 2 - video_area.width / 2;
		
		var flvPlayer_background : Sprite = new Sprite;
		flvPlayer_background.graphics.lineStyle( 1, 0x000000 );
		flvPlayer_background.graphics.beginFill( 0x000000 );
		flvPlayer_background.graphics.drawRect( 0, 0, 360, 180 );
		flvPlayer_background.graphics.endFill();
		video_area.addChild( flvPlayer_background );
		flvPlayer_background.x = 5;
		flvPlayer_background.y = 5;
		
		flvPlayer = new FLVPlayback();
		video_area.addChild( flvPlayer );
		//flvPlayer.autoPlay = true;
		flvPlayer.volume = 0.5;
		flvPlayer.width = 360;
		flvPlayer.height = 180;
		flvPlayer.y = 5;
		//flvPlayer.source = "../../Video/video_1.flv";
		flvPlayer.addEventListener( MetadataEvent.CUE_POINT, cp_listener );
		flvPlayer.addEventListener( Event.ENTER_FRAME, onvideoplaying );
		flvPlayer.addEventListener( VideoEvent.READY, onflvPlayer_READY );
		flvPlayer.addEventListener( VideoEvent.COMPLETE, onflvPlayer_COMPLETE );
		flvPlayer.addEventListener( ProgressEvent.PROGRESS, loadingAdvanced );
		flvPlayer.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
		seekbar_obj = new SeekBar;
		video_area.addChild( seekbar_obj );
		seekbar_obj.y = flvPlayer_background.y + flvPlayer_background.height + 10;
		seekbar_obj.x = 34;
		flvPlayer.seekBar = seekbar_obj;
		
		seeker_cover = new Sprite;
		seeker_cover.graphics.beginFill( 0x00FF00, 0 );
		seeker_cover.graphics.drawRect( 0, 0, 332, 8 );
		window_part_1.addChild( seeker_cover );
		seeker_cover.y = 284;
		seeker_cover.x = 45;
		seeker_cover.visible = false;
		
		sound_navigation = new Sprite;
		sound_navigation.visible = false;
		window_part_1.addChild( sound_navigation );
		var sound_navigation_background : Sprite = new Sprite;
		drawRoundRect( sound_navigation_background, 6, 60, 2, 2, 0, 0, 0, 0xCCCCCC, 0xCCCCCC, 1 );
		sound_navigation_background.graphics.beginFill( 0x878787 );
		sound_navigation_background.graphics.drawRect( 2, 5, 2, 50 );
		sound_navigation_background.graphics.endFill();
		sound_navigation.addChild( sound_navigation_background );
		
		sound_scroller = new Sprite;
		sound_scroller.graphics.beginFill( 0xFF0000, 1 );
		sound_scroller.graphics.drawCircle( 0, 0, 3 );
		
		sound_navigation.addChild( sound_scroller );
		sound_scroller.x = 3;
		sound_scroller.y = 30;
		sound_level = 0.5;
		flvPlayer.volume = sound_level;
		
		sound_scroller.buttonMode = true;
		sound_scroller.addEventListener( MouseEvent.MOUSE_DOWN, sound_dragIt );
		
		sound_navigation.x = 30;
		sound_navigation.y = 216;
		
		sound_activate_btn = new sound_button;
		video_area.addChild( sound_activate_btn );
		sound_activate_btn.y = flvPlayer_background.y + flvPlayer_background.height + 3;
		sound_activate_btn.x = 10;
		sound_activate_btn.addEventListener( MouseEvent.CLICK, sound_activate_btn_click );
		
		var video_buttons_area : Sprite = new Sprite;
		window_part_1.addChild( video_buttons_area );
		video_buttons_area.y = video_area.y + video_area.height + 10;
		video_buttons_area.x = video_area.x;
		
		play_btn = new Button;
		play_btn.label = "GROTI";
		video_buttons_area.addChild( play_btn );
		//play_btn.visible = false;
		play_btn.x = 0;
		play_btn.addEventListener( MouseEvent.CLICK, play_btn_click );
		pause_btn = new Button;
		pause_btn.label = "PAUZĖ";
		video_buttons_area.addChild( pause_btn );
		pause_btn.x = 0;
		pause_btn.addEventListener( MouseEvent.CLICK, pause_btn_click );
		pause_btn.visible = false;
		play_game_btn = new Button;
		play_game_btn.addEventListener( MouseEvent.CLICK, play_game_btn_click );
		play_game_btn.label = "ŽAISTI";
		video_buttons_area.addChild( play_game_btn );
		play_game_btn.x = 110;
		friend_play_game_btn = new Button;
		friend_play_game_btn.visible = false;
		friend_play_game_btn.addEventListener( MouseEvent.CLICK, friend_play_game_btn_click );
		friend_play_game_btn.label = "ŽAISTI PRIEŠ DRAUGĄ";
		friend_play_game_btn.width = 150;
		video_buttons_area.addChild( friend_play_game_btn );
		friend_play_game_btn.x = 220;
		
		tab_1 = new Sprite;
		tab_1.name = "tab_1";
		tab_1.buttonMode = true;
		window_part_2.addChild( tab_1 );
		var tab_default1 : Sprite = new Sprite;
		tab_default1.name = "tab_default";
		add_tab_title( tab_default1, "Mano sugroti", "default" );
		tab_1.addChild( tab_default1 );
		tab_default1.mouseEnabled = false;
		tab_default1.mouseChildren = false;
		var tab_active1 : Sprite = new Sprite;
		tab_active1.name = "tab_active";
		add_tab_title( tab_active1, "Mano sugroti", "active" );
		tab_1.addChild( tab_active1 );
		tab_active1.mouseEnabled = false;
		tab_default1.mouseChildren = false;
		tab_default1.visible = false;
		tab_1.addEventListener( MouseEvent.CLICK, tab_click );
		
		tab_2 = new Sprite;
		tab_2.buttonMode = true;
		tab_2.name = "tab_2";
		window_part_2.addChild( tab_2 );
		var tab_default2 : Sprite = new Sprite;
		tab_default2.name = "tab_default";
		add_tab_title( tab_default2, "Geriausi rezultatai", "default" );
		tab_2.addChild( tab_default2 );
		tab_default2.mouseEnabled = false;
		var tab_active2 : Sprite = new Sprite;
		tab_active2.name = "tab_active";
		add_tab_title( tab_active2, "Geriausi rezultatai", "active" );
		tab_2.addChild( tab_active2 );
		tab_active2.mouseEnabled = false;
		tab_active2.visible = false;
		tab_2.addEventListener( MouseEvent.CLICK, tab_click );
		
		var space_val : Number = ( window_part_2.width - tab_1.width - tab_2.width ) / 5;
		
		tab_1.x = space_val * 2;
		tab_2.x = tab_1.x + tab_1.width + space_val;
		
		styled_table_obj_1 = new StyledTable();
		styled_table_obj_1.name = "styled_table_obj_1";
		window_part_2.addChild( styled_table_obj_1 );
		styled_table_obj_1.x = 10;
		styled_table_obj_1.y = tab_1.y + tab_1.height + 10;
		styled_table_obj_1.setTable( false );
		styled_table_obj_1.columns([ "Daina", "Lygis", "Taškai" ] );
		styled_table_obj_1.columnsWidth([ 330, 45, 55 ] );
		
		styled_table_obj_2 = new StyledTable();
		styled_table_obj_2.name = "styled_table_obj_2";
		window_part_2.addChild( styled_table_obj_2 );
		styled_table_obj_2.x = 10;
		styled_table_obj_2.y = tab_1.y + tab_1.height + 10;
		styled_table_obj_2.setTable( false );
		styled_table_obj_2.columns([ "Žaidėjas", "Daina", "Lygis", "Taškai" ] );
		styled_table_obj_2.columnsWidth([ 165, 165, 45, 55 ] );
		styled_table_obj_2.visible = false;
		
		m_window_cover = new Sprite;
		m_window_cover.graphics.beginFill( 0xFFFFFF, 0.5 );
		m_window_cover.graphics.drawRect( 0, 0, 1, 1 );
		m_window_cover.graphics.endFill();
		m_window_content_holder.addChild( m_window_cover );
		m_window_cover.visible = false;
		
		select_level_popup = new Sprite;
		m_window_content_holder.addChild( select_level_popup );
		select_level_popup.visible = false;
		
		var select_level_popup_background : Sprite = new Sprite;
		drawRoundRect( select_level_popup_background, 150, 110, 5, 5, 5, 5, 1, 0xCCCCCC, 0xFFFFFF, 0.9 );
		select_level_popup.addChild( select_level_popup_background );
		
		var select_level_popup_text : TextField = new TextField;
		select_level_popup.addChild( select_level_popup_text );
		select_level_popup_text.name = "select_level_popup_text";
		var popup_level_text_format : TextFormat = new TextFormat();
		popup_level_text_format.font = "Arial";
		popup_level_text_format.size = 16;
		popup_level_text_format.color = 0x000000;
		popup_level_text_format.align = "left";
		select_level_popup_text.selectable = false;
		select_level_popup_text.autoSize = "left";
		select_level_popup_text.defaultTextFormat = popup_level_text_format;
		select_level_popup_text.text = "Pasirinkite lygį";
		select_level_popup_text.y = 10;
		select_level_popup_text.x = select_level_popup.width / 2 - select_level_popup_text.width / 2;
		
		select_level_popup_stars_holder = new Sprite;
		select_level_popup_stars_holder.addChild( star_generator( 3, 0, 2, true ) );
		select_level_popup.addChild( select_level_popup_stars_holder );
		select_level_popup_stars_holder.scaleX = 2;
		select_level_popup_stars_holder.scaleY = 2;
		select_level_popup_stars_holder.y = 40;
		select_level_popup_stars_holder.x = select_level_popup.width / 2 - select_level_popup_stars_holder.width / 2;
		
		submit_level_btn = new Button;
		submit_level_btn.addEventListener( MouseEvent.CLICK, submit_level_btn_click );
		submit_level_btn.label = "GERAI";
		select_level_popup.addChild( submit_level_btn );
		submit_level_btn.y = 75;
		submit_level_btn.x = select_level_popup.width / 2 - submit_level_btn.width / 2;
		
		select_level_popup.x = m_window_content_holder.x + m_window_content_holder.width / 2 - select_level_popup.width / 2;
		//select_level_popup.y = m_window_content_holder.y + m_window_content_holder.height / 2 - select_level_popup.height / 2;
		select_level_popup.y = 100;
		
		for ( var i : uint = 1; i <= 3; i++ ) {
			var click_star_area : Sprite = new Sprite;
			click_star_area.graphics.beginFill( 0xFF0000, 0 );
			click_star_area.graphics.drawRect( 0, 0, 25, select_level_popup_stars_holder.height );
			click_star_area.graphics.endFill();
			click_star_area.name = "clickstar_" + i;
			select_level_popup.addChild( click_star_area );
			click_star_area.buttonMode = true;
			click_star_area.y = select_level_popup_stars_holder.y;
			click_star_area.x = select_level_popup_stars_holder.x + ( i - 1 ) * 30;
			click_star_area.addEventListener( MouseEvent.CLICK, click_star_area_click );
		}
		
		result_popup = new Sprite;
		m_window_content_holder.addChild( result_popup );
		//result_popup.visible = false;
		
		var result_popup_background : Sprite = new Sprite;
		drawRoundRect( result_popup_background, 230, 110, 5, 5, 5, 5, 1, 0xCCCCCC, 0xFFFFFF, 0.9 );
		result_popup.addChild( result_popup_background );
		
		var result_popup_text : TextField = new TextField;
		result_popup.addChild( result_popup_text );
		result_popup_text.name = "result_popup_text";
		var result_popup_text_format : TextFormat = new TextFormat();
		result_popup_text_format.font = "Arial";
		result_popup_text_format.size = 16;
		result_popup_text_format.color = 0x000000;
		result_popup_text_format.align = "left";
		result_popup_text.selectable = false;
		result_popup_text.autoSize = "left";
		result_popup_text.defaultTextFormat = result_popup_text_format;
		result_popup_text.text = "Jūsų rezultatas";
		result_popup_text.y = 10;
		result_popup_text.x = result_popup.width / 2 - result_popup_text.width / 2;
		
		result_popup_score = new TextField;
		result_popup.addChild( result_popup_score );
		result_popup_score.name = "result_popup_score";
		var result_popup_score_format : TextFormat = new TextFormat();
		result_popup_score_format.font = "Arial";
		result_popup_score_format.size = 25;
		result_popup_score_format.color = 0xF05A23;
		result_popup_score_format.align = "left";
		result_popup_score.selectable = false;
		result_popup_score.autoSize = "left";
		result_popup_score.defaultTextFormat = result_popup_score_format;
		result_popup_score.text = "0";
		result_popup_score.width = 230;
		result_popup_score.y = 35;
		result_popup_score.x = result_popup.width / 2 - result_popup_score.width / 2;
		
		submit_result_btn = new Button;
		submit_result_btn.addEventListener( MouseEvent.CLICK, submit_result_btn_click );
		submit_result_btn.label = "IŠSAUGOTI";
		result_popup.addChild( submit_result_btn );
		submit_result_btn.y = 75;
		submit_result_btn.x = 10;
		
		cancel_result_btn = new Button;
		cancel_result_btn.addEventListener( MouseEvent.CLICK, cancel_result_btn_click );
		cancel_result_btn.label = "UŽDARYTI";
		result_popup.addChild( cancel_result_btn );
		cancel_result_btn.y = 75;
		cancel_result_btn.x = result_popup.width - submit_result_btn.width - 10;
		
		result_popup.x = m_window_content_holder.x + m_window_content_holder.width / 2 - result_popup.width / 2;
		//result_popup.y = m_window_content_holder.y + m_window_content_holder.height / 2 - result_popup.height / 2;
		result_popup.y = 100;
		result_popup.visible = false;
		
		var user_points_text : TextField = new TextField;
		window_part_3.addChild( user_points_text );
		user_points_text.name = "user_points_text";
		var user_points_text_format : TextFormat = new TextFormat();
		user_points_text_format.font = "Arial";
		user_points_text_format.size = 12;
		user_points_text_format.color = 0x000000;
		user_points_text_format.align = "left";
		user_points_text.selectable = false;
		user_points_text.autoSize = "left";
		user_points_text.defaultTextFormat = user_points_text_format;
		user_points_text.text = "Jūsų taškai:";
		user_points_text.y = 10;
		user_points_text.x = window_part_3.width - user_points_text.width - 10;
		
		current_points_text = new TextField;
		window_part_3.addChild( current_points_text );
		current_points_text.name = "current_points_text";
		var current_points_text_format : TextFormat = new TextFormat();
		current_points_text_format.font = "Arial";
		current_points_text_format.size = 30;
		current_points_text_format.color = 0x6D6F71;
		current_points_text_format.align = "left";
		current_points_text.selectable = false;
		current_points_text.autoSize = "left";
		current_points_text.defaultTextFormat = current_points_text_format;
		current_points_text.text = "0";
		current_points_text.y = 10;
		current_points_text.x = 850 - current_points_text.width - 10;
		
		points_splitter = new Sprite;
		points_splitter.graphics.lineStyle( 1, 0xA6A9AB );
		points_splitter.graphics.moveTo( 0, 0 );
		points_splitter.graphics.lineTo( 0, 40 );
		window_part_3.addChild( points_splitter );
		points_splitter.y = user_points_text.y + user_points_text.height + 10;
		points_splitter.x = current_points_text.x - 10;
		
		current_points_text.y = points_splitter.y + points_splitter.height / 2 - current_points_text.height / 2;
		
		points_history_text = new TextField;
		window_part_3.addChild( points_history_text );
		points_history_text.name = "points_history_text";
		var points_history_text_format : TextFormat = new TextFormat();
		points_history_text_format.font = "Arial";
		points_history_text_format.size = 16;
		points_history_text_format.color = 0x000000;
		points_history_text_format.align = "right";
		points_history_text.selectable = false;
		points_history_text.autoSize = "right";
		points_history_text.defaultTextFormat = popup_level_text_format;
		points_history_text.text = "0";
		points_history_text.y = points_splitter.y + points_splitter.height / 2 - points_history_text.height / 2;
		points_history_text.x = points_splitter.x - points_history_text.width - 10;
		points_history_text.text = "";
		
		var points_history_area_mask : Sprite = new Sprite;
		points_history_area_mask.graphics.beginFill( 0xFF0000 );
		points_history_area_mask.graphics.drawRect( 0, 0, window_part_3.width - 20, points_splitter.height );
		points_history_area_mask.graphics.endFill();
		window_part_3.addChild( points_history_area_mask );
		points_history_area_mask.x = 10;
		points_history_area_mask.y = points_splitter.y;
		points_history_text.mask = points_history_area_mask;
		
		game_area = new Sprite;
		game_area.name = "game_area";
		window_part_3.addChild( game_area );
		game_area.x = 20
		game_area.y = 80;
		
		game_area.visible = true;
		lines_area = new Sprite;
		lines_area.name = "lines_area";
		game_area.addChild( lines_area );
		game_sliding_area = new Sprite;
		game_sliding_area.name = "game_sliding_area";
		game_sliding_area.x = 1000;
		game_area.addChild( game_sliding_area );
		game_time_sliding_area = new Sprite;
		game_time_sliding_area.graphics.beginFill( 0x0000FF );
		game_time_sliding_area.graphics.drawRect( 0, 0, 1, 150 );
		game_time_sliding_area.graphics.endFill();
		game_sliding_area.addChild( game_time_sliding_area );
		game_time_sliding_area.alpha = 0;
		
		game_sliding_mask_area = new Sprite;
		game_sliding_mask_area.graphics.beginFill( 0x00FF00, 1 );
		game_sliding_mask_area.graphics.drawRect( 0, 0, 780, 150 );
		game_sliding_mask_area.graphics.endFill();
		game_area.addChild( game_sliding_mask_area );
		game_sliding_mask_area.y = 0;
		game_sliding_mask_area.x = 38;
		game_sliding_target_line = new Sprite;
		game_sliding_target_line.name = "game_sliding_target_line";
		game_area.addChild( game_sliding_target_line );
		game_sliding_target_line.x = 100;
		
		game_sliding_area.x = game_sliding_target_line.x;
		
		game_sliding_area.mask = game_sliding_mask_area;
		
		disable_game_area();
		//update_current_points(123);
		//update_current_points(-123);
		//update_current_points(0);
		//update_current_points(1234);
		
		//clear_points_history();
		
		// window_part_3.addEventListener(KeyboardEvent.KEY_DOWN, detectKey);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, detectKey);
		
		var amfphp:AMFPHP = new AMFPHP(readResult, onFault).xcall("dm.MusicGame.get_all_music_game_info", MyManager.instance.avatar.id);
	}
	
	private function sound_dragIt( e : MouseEvent ) : void {
		sound_rect = new Rectangle( -1, 5, 0, 50 );
		sound_rect.x = 3;
		sound_scroller.startDrag( false, sound_rect );
		sound_scroller.addEventListener( MouseEvent.MOUSE_UP, sound_dropIt );
		sound_scroller.addEventListener( Event.ENTER_FRAME, sound_scrollIt );
	}
	
	private function sound_dropIt( e : MouseEvent ) : void {
		sound_scroller.stopDrag();
		sound_scroller.removeEventListener( Event.ENTER_FRAME, sound_scrollIt );
	}
	
	private function sound_scrollIt( e : Event ) : void {
		//sound_level = 50 - (sound_scroller.y - 5) * 2 / 100;
		sound_level = ( 100 - ( sound_scroller.y - 5 ) * 2 ) / 100;
		flvPlayer.volume = sound_level;
	/*var scrollerRange:Number = rect.height-2;
	   var contentRange:Number = rowsHolder.height - tableHeight-headerHolder.height + padding;
	   var percentage:Number = (scroller.y - scrollerMinY) / scrollerRange;
	   var targetY:Number = contentMaxY - percentage * contentRange;
	   rowsHolder.y = targetY;
	   follower.y = mouseY - follower.height / 2;
	 follower.x = mouseX - follower.width / 2;*/
	}
	
	private function saveResult() : void {
		var params:Array = [MyManager.instance.avatar.id, current_video_id, user_current_score, current_level, user_created_string];		
		var amfphp : AMFPHP = new AMFPHP( readResult2, onFault ).xcall( "dm.MusicGame.saveResult", params );
	}
	
	private function readResult2( r : Object ) : void {
		if ( r == false ) {
			trace( "Error reading records." );
		} else {
			styled_table_obj_1.clearRows();
			
			for each ( var x : Object in r.current_user_videos ) {
				styled_table_obj_1.addRow([ x.title, star_generator( 3, x.level, 1, true ), x.score ] );
			}
			
			if ( styled_table_obj_1.countRows() > 17 ) {
				styled_table_obj_1.columnsWidth([ 320, 45, 55 ] );
			}
			styled_table_obj_2.clearRows();
			
			for each ( x in r.top_scores ) {
				styled_table_obj_2.addRow([ x.user_name, x.video_title, star_generator( 3, x.level, 1, true ), x.score ] );
			}
			
			if ( styled_table_obj_2.countRows() > 17 ) {
				styled_table_obj_2.columnsWidth([ 160, 160, 45, 55 ] );
			}
			hide_window_cover();
			result_popup.visible = false;
			trace( "Rezultatai issaugoti" );
		}
	}
	
	private function enable_game_area() : void {
		window_part_3.visible = true;
		window_part_3.x = window_part_3.x;
		window_part_3.y = 350;
		update_m_window();
	}
	
	private function disable_game_area() : void {
		window_part_3.visible = false;
		window_part_3.x = 0;
		window_part_3.y = 0;
		update_m_window();
	}
	
	private function draw_level_lines() : void {
		while ( lines_area.numChildren > 0 ) {
			lines_area.removeChildAt( lines_area.numChildren - 1 );
		}
		game_sliding_target_line.graphics.clear();
		game_area.graphics.clear();
		
		switch ( current_level ) {
			case 1: 
				draw_row( lines_area, "row_1", "A", 20 );
				draw_row( lines_area, "row_2", "S", 50 );
				game_sliding_target_line.graphics.lineStyle( 2, 0xF05B22 );
				game_sliding_target_line.graphics.moveTo( 0, 1 );
				game_sliding_target_line.graphics.lineTo( 0, 90 );
				game_area.graphics.beginFill( 0xFFFFFF );
				game_area.graphics.drawRect( 0, 0, 830, 90 );
				game_area.graphics.endFill();
				break;
			case 2: 
				draw_row( lines_area, "row_1", "A", 20 );
				draw_row( lines_area, "row_2", "S", 50 );
				draw_row( lines_area, "row_3", "D", 80 );
				game_sliding_target_line.graphics.lineStyle( 2, 0xF05B22 );
				game_sliding_target_line.graphics.moveTo( 0, 1 );
				game_sliding_target_line.graphics.lineTo( 0, 120 );
				game_area.graphics.beginFill( 0xFFFFFF );
				game_area.graphics.drawRect( 0, 0, 830, 120 );
				game_area.graphics.endFill();
				break;
			case 3: 
				draw_row( lines_area, "row_1", "A", 20 );
				draw_row( lines_area, "row_2", "S", 50 );
				draw_row( lines_area, "row_3", "D", 80 );
				draw_row( lines_area, "row_4", "F", 110 );
				//draw_row(game_area,"row_5", "G", 140) ;
				game_sliding_target_line.graphics.lineStyle( 2, 0xF05B22 );
				game_sliding_target_line.graphics.moveTo( 0, 1 );
				game_sliding_target_line.graphics.lineTo( 0, 150 );
				game_area.graphics.beginFill( 0xFFFFFF );
				game_area.graphics.drawRect( 0, 0, 830, 150 );
				game_area.graphics.endFill();
				break;
		}
	}
	
	private function draw_row( holder : Sprite, row_name : String, letter : String, y_val : Number ) : void {
		var row_obj : Sprite = new Sprite;
		row_obj.name = "row_obj";
		holder.addChild( row_obj );
		row_obj.y = y_val;
		row_obj.x = 0;
		var row_letter_circle : Sprite = new Sprite;
		row_letter_circle.graphics.lineStyle( 2, 0xA6A9AB );
		row_letter_circle.graphics.drawCircle( 0, 0, 10 );
		row_obj.addChild( row_letter_circle );
		row_letter_circle.x = 16;
		row_letter_circle.y = 10;
		var l_format : TextFormat = new TextFormat();
		l_format.font = "Arial";
		l_format.size = 13;
		l_format.color = 0xA6A9AB;
		
		// var letter_obj : FlexTextField = new FlexTextField;
		var letter_obj : TextField = new TextField;
		row_obj.addChild( letter_obj );
		letter_obj.selectable = false;
		letter_obj.mouseEnabled = false;
		letter_obj.defaultTextFormat = l_format;
		letter_obj.text = letter;
		letter_obj.x = 10;
		row_obj.graphics.lineStyle( 2, 0xA6A9AB );
		row_obj.graphics.moveTo( 40, 10 );
		row_obj.graphics.lineTo( 810, 10 );
	}
	
	private function update_current_points( val : Number ) : void {
		var points_string : String;
		var current_points_text_format : TextFormat = new TextFormat();
		current_points_text_format.font = "Arial";
		current_points_text_format.size = 30;
		
		if ( val < 0 ) {
			points_string = "" + val as String;
			current_points_text_format.color = 0xE30614;
		} else if ( val > 0 ) {
			points_string = "+" + val as String;
			current_points_text_format.color = 0x3BAA35;
		} else {
			points_string = "" + val as String;
			current_points_text_format.color = 0x6D6F71;
		}
		current_points_text_format.align = "left";
		current_points_text.selectable = false;
		current_points_text.autoSize = "left";
		current_points_text.defaultTextFormat = current_points_text_format;
		current_points_text.x = 0;
		current_points_text.text = "" + user_current_score as String;
		current_points_text.x = 850 - current_points_text.width - 10;
		points_splitter.x = current_points_text.x - 10;
		update_points_history( points_string )
	}
	
	private function update_points_history( val : String ) : void {
		points_history_text.text = points_history_text.text + "   " + val;
		points_history_text.x = points_splitter.x - points_history_text.width - 10;
	}
	
	private function clear_points_history() : void {
		points_history_text.text = "";
		points_history_text.x = points_splitter.x - points_history_text.width - 10;
	}
	
	private function activate_window_cover() : void {
		//m_window_cover.width = m_window_content_holder.width;
		//m_window_cover.height = m_window_content_holder.height;	
		m_window_cover.width = 855;
		
		if ( window_part_3.visible == true ) {
			m_window_cover.height = 650;
		} else {
			m_window_cover.height = 340;
		}
		m_window_cover.visible = true;
	}
	
	private function hide_window_cover() : void {
		m_window_cover.width = 1;
		m_window_cover.height = 1;
		m_window_cover.visible = false;
	}
	
	private function list_song_selected( event : Event ) : void {
		disable_game_area();
		main_stars_holder.removeChildAt( 0 );
		main_stars_holder.addChild( star_generator( 3, 0, 2, true ) );
		pause_btn.visible = false;
		play_btn.visible = true;
		play_btn.enabled = true;
		friend_play_game_btn.enabled = true;
		play_game_btn.enabled = true;
		current_video_file = select_song_dropdown.selectedItem.data.file as String;
		new_video = true;
		current_video_id = select_song_dropdown.selectedItem.data.id;
		flvPlayer.stop();
		flvPlayer.seek( 0 );
	}
	
	private function onvideoplaying( e : Event ) : void {
		/*if (main_state == 1 && flvPlayer.bytesLoaded == flvPlayer.bytesTotal) {
		   var metaDataObj2:Object = flvPlayer.metadata as Object;
		   create_game(metaDataObj2.duration, get_video_cuepoints_array(), current_video_id);
		   pause_btn.enabled = true;
		 }*/
		update_game_slider( flvPlayer.playheadTime );
	}
	
	private function update_game_slider( time : Number ) : void {
		if ( flvPlayer.state == "playing" && game_is_playing == true ) {
			//current_points_text.focus = current_points_text;//reikalinga tam, kad kai paspaudi popup, tai nueini nuo stage, ir tada neveikia stage.addEventListener(KeyboardEvent.KEY_DOWN, detectKey);
			change_slider_position( time );
		}
	}
	
	public function detectKey( event : KeyboardEvent ) : void {
		if ( flvPlayer.state == "playing" && game_is_playing == true ) {
			check_press( event.keyCode );
		}
		trace( "[dm.minigames.musicgame.MusicGame.detectKey()]" );
		trace("The keypress code is: " + event.keyCode);
		trace("The keyLocation is: " + event.keyLocation);
		trace("The shiftKey is: " + event.shiftKey);
		trace("The altKey is: " + event.altKey);
	}
	
	public function check_press( code : Number ) : void {
		var key_letter : String = "-";
		
		switch ( code ) {
			case 65: 
				key_letter = "A";
				break;
			case 83: 
				key_letter = "S";
				break;
			case 68: 
				key_letter = "D";
				break;
			case 70: 
				key_letter = "F";
				break;
			case 71: 
				key_letter = "G";
				break;
		}
		var add_score : Number;
		add_score = 0;
		trace( key_letter + "---" + current_video_press_nodes[ next_press_node_index ][ 2 ] )
		
		if ( next_press_node_index != -1 ) {
			if ( need_press_key == false || key_letter != current_video_press_nodes[ next_press_node_index ][ 2 ] ) {
				if ( key_letter != current_video_press_nodes[ next_press_node_index ][ 2 ] ) {
					was_pressed = true;
				}
				good_press = false;
				
				if ( user_current_score > 0 ) {
					triple_num = 0;
					triple_sum = 0;
					
					if ( current_level == 1 ) {
						add_score = ( -1 ) * rule_level_1_wrong_press;
					} else if ( current_level == 2 ) {
						add_score = ( -1 ) * rule_level_2_wrong_press;
					} else {
						add_score = ( -1 ) * rule_level_3_wrong_press;
					}
					var idx : int = Math.floor( Math.random() * soundArray.length );
					
					if ( user_created_string_array[ next_press_node_index ] == "" || user_created_string_array[ next_press_node_index ] == '-' || user_created_string_array[ next_press_node_index ] == null ) {
						user_created_string_array[ next_press_node_index ] = current_video_press_nodes[ idx ][ 1 ];
					}
					
					//NEW START 2012-10-09
					//sound_channel = soundArray[idx].play();
					sound_channel = wrong_soundArray[ current_sound_number - 1 ].play();
					current_sound_number++;
					
					if ( current_sound_number > wrong_sounds_number ) {
						current_sound_number = 1;
					}
					//NEW END 2012-10-09
					
					var volumeAdjust : SoundTransform = new SoundTransform();
					volumeAdjust.volume = sound_level;
					sound_channel.soundTransform = volumeAdjust;
					
				}
			} else if ( good_press == false && need_press_key == true && key_letter == current_video_press_nodes[ next_press_node_index ][ 2 ] ) {
				add_score = int( 20 - Math.abs( node_position_x - current_position_x ) );
				
				if ( current_level == 1 ) {
					add_score = add_score * rule_level_1_right_press;
				} else if ( current_level == 2 ) {
					add_score = add_score * rule_level_2_right_press;
				} else {
					add_score = add_score * rule_level_3_right_press;
				}
				
				triple_num++;
				triple_sum += add_score;
				
				if ( user_created_string_array[ next_press_node_index ] == "" || user_created_string_array[ next_press_node_index ] == '-' || user_created_string_array[ next_press_node_index ] == null ) {
					user_created_string_array[ next_press_node_index ] = current_video_press_nodes[ next_press_node_index ][ 1 ];
				}
				
				sound_channel = soundArray[ next_press_node_index ].play();
				var volumeAdjust2 : SoundTransform = new SoundTransform();
				volumeAdjust2.volume = sound_level;
				sound_channel.soundTransform = volumeAdjust2;
				good_press = true;
				need_press_key = false;
				was_pressed = true;
			}
			
			if (( current_position_x >= node_position_x - 20 ) && ( current_position_x <= node_position_x + 20 ) ) {
				if ( add_score > 0 ) {
					change_press_points_state( next_press_node_index, 2 );
				} else if ( add_score < 0 ) {
					change_press_points_state( next_press_node_index, 3 );
				} else {
					change_press_points_state( next_press_node_index, 1 );
				}
			}
			
		}
		user_current_score += add_score;
		
		if ( user_current_score < 0 ) {
			user_current_score = 0;
		}
		
		update_current_points( add_score );
		
		//score_label.text = "Score: "+user_current_score;
		//var score_anim:score_animation= new score_animation(add_score);
		//score_animation_area.addChild(score_anim);
		
		if ( triple_num == 3 ) {
			if ( current_level == 1 ) {
				triple_sum = triple_sum * rule_level_1_triple;
			} else if ( current_level == 2 ) {
				triple_sum = triple_sum * rule_level_2_triple;
			} else {
				triple_sum = triple_sum * rule_level_3_triple;
			}
			user_current_score += triple_sum;
			//score_label.text = "Score: "+user_current_score;
			//var score_anim2:score_animation= new score_animation(triple_sum);
			update_current_points( triple_sum );
			//score_animation_area.addChild(score_anim2);	
			triple_num = 0;
			triple_sum = 0;
		}
	
	}
	
	private function change_slider_position( x_val : Number ) : void {
		if (( current_position_x >= node_position_x - 20 ) && ( current_position_x <= node_position_x + 20 ) ) {
			need_press_key = true;
			
			if ( was_pressed == true ) {
				need_press_key = false;
			}
		} else {
			need_press_key = false;
			good_press = false;
			was_pressed = false;
			
			if (( current_position_x >= node_position_x + 21 ) && ( current_position_x <= node_position_x + 25 ) ) {
				end_node = true;
			} else {
				end_node = false;
			}
		}
		
		current_position_x = x_val * speed;
		node_position_x = next_press_node_time * speed;
		
		game_sliding_area.x = (( -1 ) * x_val * speed ) + game_sliding_target_line.x;
		
		if (( user_current_score > 1 ) && ( was_pressed == false ) && ( need_press_key == true ) && ( end_node == true ) ) {
			var minus_points : Number;
			
			if ( current_level == 1 ) {
				minus_points = rule_level_1_miss_press;
			} else if ( current_level == 2 ) {
				minus_points = rule_level_2_miss_press;
			} else {
				minus_points = rule_level_3_miss_press;
			}
			user_current_score -= minus_points;
			
			if ( user_current_score < 0 ) {
				user_current_score = 0;
			} else {
				update_current_points( -minus_points );
			}
			
			change_press_points_state( next_press_node_index - 1, 3 );
			
			need_press_key = false;
			was_pressed = true;
			end_node = false;
			triple_num = 0;
			triple_sum = 0;
		}
		
		if ( user_created_string_array[ next_press_node_index ] == "" || user_created_string_array[ next_press_node_index ] == null ) {
			user_created_string_array[ next_press_node_index ] = "-";
		}
	}
	
	private function onflvPlayer_READY( event : VideoEvent ) : void {
		trace( "READY" );
		activate_metadata();
	}
	
	private function activate_metadata() : void {
		var metaDataObj : Object = flvPlayer.metadata as Object;
		/*trace("onFlvPlayback_READY");
		   trace("tempFlvPlayback.source: "+event.target.source);
		   trace("metaDataObj.canSeekToEnd: "+metaDataObj.canSeekToEnd);
		   trace("metaDataObj.cuePoints: "+metaDataObj.cuePoints);
		   trace("metaDataObj.audiocodecid: "+metaDataObj.audiocodecid);
		   trace("metaDataObj.audiodelay: "+metaDataObj.audiodelay);
		   trace("metaDataObj.audiodatarate: "+metaDataObj.audiodatarate);
		   trace("metaDataObj.videocodecid: "+metaDataObj.videocodecid);
		   trace("metaDataObj.framerate: "+metaDataObj.framerate);
		   trace("metaDataObj.videodatarate: "+metaDataObj.videodatarate);
		   trace("metaDataObj.height: "+metaDataObj.height);
		   trace("metaDataObj.width: "+metaDataObj.width);
		 trace("metaDataObj.duration: " + metaDataObj.duration);*/
		trace( "veikia uzsiloadinus" );
		create_game( metaDataObj.duration, get_video_cuepoints_array(), current_video_id );
	}
	
	private function get_video_cuepoints_array() : Array {
		var metaDataObj : Object = flvPlayer.metadata as Object;
		var info_array : Array = new Array();
		
		for ( var key : String in metaDataObj.cuePoints ) {
			var p_time : Number = metaDataObj.cuePoints[ key ].time;
			var p_name : String = metaDataObj.cuePoints[ key ].name;
			var letter : String = "";
			
			switch ( p_name.substr( 0, 1 ) ) {
				case "A": 
					letter = "A";
					break;
				case "B": 
					letter = "S";
					break;
				case "C": 
					letter = "D";
					break;
				case "D": 
					letter = "F";
					break;
				case "E": 
					letter = "G";
					break;
			}
			info_array.push([ p_time, p_name, letter ] );
		}
		return info_array;
	}
	
	private function create_game( all_time : Number, all_press_nodes : Array, video_id : Number ) : void {
		//trace("1A)"+all_time+"1B)"+all_press_nodes+"1C)"+video_id)
		
		next_press_node_index = 0;
		current_video_press_nodes = [];
		var i : Number;
		var letter_value : String;
		
		switch ( current_level ) {
			case 1: 
				for ( i = 0; i < all_press_nodes.length; i++ ) {
					letter_value = all_press_nodes[ i ][ 1 ].substring( 1, 0 )
					
					if ( letter_value == "A" || letter_value == "B" ) {
						current_video_press_nodes.push( all_press_nodes[ i ] );
					}
				}
				break;
			case 2: 
				for ( i = 0; i < all_press_nodes.length; i++ ) {
					letter_value = all_press_nodes[ i ][ 1 ].substring( 1, 0 )
					
					if ( letter_value == "A" || letter_value == "B" || letter_value == "C" ) {
						current_video_press_nodes.push( all_press_nodes[ i ] );
					}
				}
				break;
			case 3: 
				for ( i = 0; i < all_press_nodes.length; i++ ) {
					letter_value = all_press_nodes[ i ][ 1 ].substring( 1, 0 )
					
					if ( letter_value == "A" || letter_value == "B" || letter_value == "C" || letter_value == "D" ) {
						current_video_press_nodes.push( all_press_nodes[ i ] );
					}
				}
				break;
		}
		current_video_duration = all_time;
		trace( "vaiku skaicius" + game_sliding_area.numChildren )
		
		while ( game_sliding_area.numChildren > 1 ) {
			game_sliding_area.removeChildAt( game_sliding_area.numChildren - 1 );
		}
		game_time_sliding_area.width = all_time * speed;
		add_press_points( current_video_press_nodes );
		load_all_sounds( current_video_press_nodes, video_id );
		game_is_playing = true;
	}
	
	private function change_press_points_state( point_index : Number, state : Number ) : void {
		if ( point_index < current_video_press_nodes.length && point_index >= 0 ) {
			var holder_c : Object = game_sliding_area.getChildByName( "presspointcircle_" + current_video_press_nodes[ point_index ][ 1 ] );
			
			if ( holder_c != null ) {
				var default_c : Object = holder_c.getChildByName( "press_point_circle_default" );
				var true_c : Object = holder_c.getChildByName( "press_point_circle_true" );
				var false_c : Object = holder_c.getChildByName( "press_point_circle_false" );
				
				switch ( state ) {
					case 1: 
						default_c.visible = true;
						true_c.visible = false;
						false_c.visible = false;
						break;
					case 2: 
						default_c.visible = false;
						true_c.visible = true;
						false_c.visible = false;
						break;
					case 3: 
						default_c.visible = false;
						true_c.visible = false;
						false_c.visible = true;
						break;
				}
			}
		}
	}
	
	private function add_press_points( cue_points_and_letters : Array ) : void {
		if ( cue_points_and_letters.length > 0 ) {
			next_press_node_time = cue_points_and_letters[ 0 ][ 0 ];
			user_current_score = 0;
			
			for ( var m : uint = 0; m < cue_points_and_letters.length; m++ ) {
				var press_point_circle : Sprite = new Sprite;
				press_point_circle.name = "presspointcircle_" + cue_points_and_letters[ m ][ 1 ];
				game_sliding_area.addChild( press_point_circle );
				
				var press_point_circle_default : Sprite = new Sprite;
				press_point_circle.addChild( press_point_circle_default );
				press_point_circle_default.name = "press_point_circle_default";
				var grey_c : circle_grey = new circle_grey;
				press_point_circle_default.addChild( grey_c );
				press_point_circle_default.y = -press_point_circle_default.height / 2;
				
				var press_point_circle_true : Sprite = new Sprite;
				press_point_circle_true.visible = false;
				press_point_circle.addChild( press_point_circle_true );
				press_point_circle_true.name = "press_point_circle_true";
				var green_c : circle_green = new circle_green;
				press_point_circle_true.addChild( green_c );
				press_point_circle_true.y = -press_point_circle_true.height / 2;
				
				var press_point_circle_false : Sprite = new Sprite;
				press_point_circle_false.visible = false;
				press_point_circle.addChild( press_point_circle_false );
				press_point_circle_false.name = "press_point_circle_false";
				var orange_c : circle_orange = new circle_orange;
				press_point_circle_false.addChild( orange_c );
				press_point_circle_false.y = -press_point_circle_false.height / 2;
				
				var grad_c : circle_gradient = new circle_gradient;
				press_point_circle.addChild( grad_c );
				grad_c.y = -grad_c.height / 2;
				
				/*var press_point_circle_default:Sprite = new Sprite;
				   press_point_circle_default.name = "circle_default";
				   press_point_circle_default.graphics.lineStyle(2, 0x000000);
				   press_point_circle_default.graphics.beginFill(0xFFFFFF , 1);
				   press_point_circle_default.graphics.drawCircle( 0 , 0 , 10 );
				 press_point_circle.addChild(press_point_circle_default);*/
				
				/*var press_point:Label = new Label;
				   game_sliding_area.addChild(press_point);
				   press_point.name = "cuepoint_"+cue_points_and_letters[m][1];
				   press_point.text = cue_points_and_letters[m][2];
				   press_point.width = 20;
				 press_point.height = 20;*/
				press_point_circle.x = ( cue_points_and_letters[ m ][ 0 ] * speed - press_point_circle.width / 2 );
				
				//press_point.x = press_point_circle.x - 6;
				
				switch ( cue_points_and_letters[ m ][ 2 ] ) {
					case "A": 
						press_point_circle.y = 40 - press_point_circle.height / 2;
						break;
					case "S": 
						press_point_circle.y = 70 - press_point_circle.height / 2;
						break;
					case "D": 
						press_point_circle.y = 100 - press_point_circle.height / 2;
						break;
					case "F": 
						press_point_circle.y = 130 - press_point_circle.height / 2;
						break;
					case "G": 
						press_point_circle.y = 160 - press_point_circle.height / 2;
						break;
				}
					//press_point.y = press_point_circle.y-9;
			}
		}
	}
	
	private function load_all_sounds( cue_points_and_letters : Array, video_id : Number ) : void {
		soundArray = [];
		var i : int;
		var url : String;
		
		if ( main_state != 1 ) {
			for ( i = 0; i < cue_points_and_letters.length; i++ ) {
				url = FILE_PATH + "/Audio/" + video_id + "/" + cue_points_and_letters[ i ][ 1 ] + ".mp3";
				var req : URLRequest = new URLRequest( url );
				soundArray[ i ] = new Sound( req );
			}
		}
		
		//NEW START 2012-10-09
		wrong_soundArray = [];
		
		for ( i = 1; i <= wrong_sounds_number; i++ ) {
			url = FILE_PATH + "/Audio/wrong_answers_sounds/wrong_" + i + ".mp3";
			var req2 : URLRequest = new URLRequest( url );
			wrong_soundArray[ i - 1 ] = new Sound( req2 );
		}
		//NEW END 2012-10-09
	}
	
	private function loadingAdvanced( e : ProgressEvent ) : void {
		var percent : Number = Math.round(( e.bytesLoaded / e.bytesTotal ) * 100 );
		trace( "Video: " + select_song_dropdown.selectedItem.label + " " + percent + "%" );
		
		if ( percent > 99 ) {
			new_video = false;
		}
		trace( "Uploaded" )
	}
	
	private function onIOError( evt : IOErrorEvent ) : void {
		trace( "IOError loading file" );
	}
	
	private function onflvPlayer_COMPLETE( event : VideoEvent ) : void {
		if ( main_state == 2 ) {
			play_btn.visible = true;
			//game_area.visible = false;
			user_created_string = user_created_string_array.join( "," );
			trace( user_created_string );
			disable_game_area();
			play_btn.enabled = true;
			play_game_btn.enabled = true;
			friend_play_game_btn.enabled = true;
			activate_window_cover();
			result_popup_score.text = "" + user_current_score as String;
			result_popup_score.x = result_popup.width / 2 - result_popup_score.width / 2;
			result_popup.visible = true;
		}
	}
	
	private function cp_listener( eventObject : MetadataEvent ) : void {
		var letter_value : String;
		var case_index : Number = current_level;
		
		/*if (main_state == 2) {
		   case_index = playing_level;
		 }*/
		//trace(current_level+"---"+playing_level)
		switch ( case_index ) {
			case 1: 
				letter_value = eventObject.info.name.substring( 1, 0 )
				if ( letter_value == "A" || letter_value == "B" ) {
					activate_next_press_node();
				}
				break;
			case 2: 
				letter_value = eventObject.info.name.substring( 1, 0 )
				if ( letter_value == "A" || letter_value == "B" || letter_value == "C" ) {
					activate_next_press_node();
				}
				break;
			case 3: 
				letter_value = eventObject.info.name.substring( 1, 0 )
				if ( letter_value == "A" || letter_value == "B" || letter_value == "C" || letter_value == "D" ) {
					activate_next_press_node();
				}
				break;
		}
	}
	
	public function activate_next_press_node() : void {
		//NEW START 2012-10-09
		/*if (main_state==2 && soundArray.length>0) {
		   play_sound(next_press_node_index);
		 }*/
		
		/*sound_channel = wrong_soundArray[current_sound_number - 1].play();
		   var volumeAdjust:SoundTransform = new SoundTransform();
		   volumeAdjust.volume = sound_level;
		   sound_channel.soundTransform = volumeAdjust;
		   current_sound_number++;
		   if (current_sound_number > wrong_sounds_number) {
		   current_sound_number = 1;
		 }*/
		//NEW END 2012-10-09
		
		next_press_node_index += 1;
		end_node = true;
		
		if ( next_press_node_index == current_video_press_nodes.length ) {
			next_press_node_index = 0;
		}
		next_press_node_time = current_video_press_nodes[ next_press_node_index ][ 0 ];
		//trace(next_press_node_index)
	
	}
	
	public function play_sound( index : Number ) : void {
	/*if (soundArray[index] != "-" && main_state != 1) {
	   sound_channel = soundArray[index].play();
	   var volumeAdjust:SoundTransform = new SoundTransform();
	   volumeAdjust.volume = sound_level;
	   sound_channel.soundTransform = volumeAdjust;
	 }*/
	}
	
	private function click_star_area_click( event : MouseEvent ) : void {
		var entry_array : Array = event.target.name.split( "_" );
		select_level_popup_stars_holder.removeChildAt( 0 )
		select_level_popup_stars_holder.addChild( star_generator( 3, entry_array[ 1 ], 2, true ) );
		current_level = entry_array[ 1 ];
	}
	
	private function sound_activate_btn_click( event : MouseEvent ) : void {
		if ( sound_navigation.visible == true ) {
			sound_navigation.visible = false;
		} else {
			sound_navigation.visible = true;
		}
	}
	
	private function play_btn_click( event : MouseEvent ) : void {
		if ( select_song_dropdown.selectedIndex != -1 ) {
			enable_seek_bar();
			main_state = 1;
			flvPlayer.source = FILE_PATH + "/Video/" + current_video_file;
			flvPlayer.playWhenEnoughDownloaded();
			pause_btn.visible = true;
			play_btn.visible = false;
			play_game_btn.enabled = false;
			friend_play_game_btn.enabled = false;
		}
	}
	
	private function pause_btn_click( event : MouseEvent ) : void {
		flvPlayer.stop();
		pause_btn.visible = false;
		play_btn.visible = true;
		play_game_btn.enabled = true;
		friend_play_game_btn.enabled = true;
	}
	
	private function submit_result_btn_click( event : MouseEvent ) : void {
		saveResult();
	}
	
	private function cancel_result_btn_click( event : MouseEvent ) : void {
		result_popup.visible = false;
		hide_window_cover();
	}
	
	private function play_game_btn_click( event : MouseEvent ) : void {
		if ( select_song_dropdown.selectedIndex != -1 ) {
			main_state = 2;
			activate_window_cover();
			select_level_popup_stars_holder.removeChildAt( 0 )
			select_level_popup_stars_holder.addChild( star_generator( 3, 0, 2, true ) );
			select_level_popup.visible = true;
		}
	}
	
	private function friend_play_game_btn_click( event : MouseEvent ) : void {
		if ( select_song_dropdown.selectedIndex != -1 ) {
			main_state = 3;
				//this.activate_window_cover();
			/*flvPlayer.source = files_directory + "/Video/" +current_video_file;
			   flvPlayer.playWhenEnoughDownloaded();
			   pause_btn.visible = true;
			 play_btn.visible = false;*/
		}
	}
	
	private function submit_level_btn_click( event : MouseEvent ) : void {
		disable_seek_bar();
		enable_game_area();
		flvPlayer.stop();
		flvPlayer.seek( 0 );
		select_level_popup.visible = false;
		main_stars_holder.removeChildAt( 0 );
		main_stars_holder.addChild( star_generator( 3, current_level, 2, true ) );
		play_btn.enabled = false;
		play_game_btn.enabled = false;
		friend_play_game_btn.enabled = false;
		hide_window_cover();
		draw_level_lines();
		
		//main_parent.removeChildAt(main_parent.numChildren - 1);
		trace( flvPlayer.state );
		//if(flvPlayer.state=="seeking" && new_video==false){
		
		//}
		reset_game();
		update_game_slider( flvPlayer.playheadTime );
		flvPlayer.stop();
		flvPlayer.source = FILE_PATH + "/Video/" + current_video_file;
		flvPlayer.playWhenEnoughDownloaded();
		
		if ( flvPlayer.bytesLoaded == flvPlayer.bytesTotal ) {
			var metaDataObj2 : Object = flvPlayer.metadata as Object;
			create_game( metaDataObj2.duration, get_video_cuepoints_array(), current_video_id );
		}
	
		//activate_metadata();
	}
	
	public function reset_game() : void {
		user_current_score = 0;
		user_created_string_array = [];
		update_current_points( 0 );
		clear_points_history();
		trace( "zaidimas nuresetintas" );
	}
	
	private function enable_seek_bar() : void {
		seeker_cover.visible = false;
	}
	
	private function disable_seek_bar() : void {
		seeker_cover.visible = true;
	}
	
	private function onFault( fault : Object ) : void {
		var st : String = String( fault.description );
		trace( st );
	}
	
	private function readResult( r : Object ) : void {
		if ( r == false ) {
			trace( "Error reading records." );
		} else {
			styled_table_obj_1.clearRows();
			
			for each ( var x : Object in r.current_user_videos ) {
				styled_table_obj_1.addRow([ x.title, star_generator( 3, x.level, 1, true ), x.score ] );
			}
			
			if ( styled_table_obj_1.countRows() > 17 ) {
				styled_table_obj_1.columnsWidth([ 320, 45, 55 ] );
			}
			
			styled_table_obj_2.clearRows();
			
			for each ( x in r.top_scores ) {
				styled_table_obj_2.addRow([ x.user_name, x.video_title, star_generator( 3, x.level, 1, true ), x.score ] );
			}
			
			if ( styled_table_obj_2.countRows() > 17 ) {
				styled_table_obj_2.columnsWidth([ 160, 160, 45, 55 ] );
			}
			
			for each ( x in r.videos ) {
				var info_obj : Object = { id: x.id, file: x.file, title: x.title };
				select_song_dropdown.addItem({ label: x.title, data: info_obj } );
			}
			
			rule_level_1_right_press = r.rules.rule_level_1_right_press;
			rule_level_2_right_press = r.rules.rule_level_2_right_press;
			rule_level_3_right_press = r.rules.rule_level_3_right_press;
			rule_level_1_wrong_press = r.rules.rule_level_1_wrong_press;
			rule_level_2_wrong_press = r.rules.rule_level_2_wrong_press;
			rule_level_3_wrong_press = r.rules.rule_level_3_wrong_press;
			rule_level_1_miss_press = r.rules.rule_level_1_miss_press;
			rule_level_2_miss_press = r.rules.rule_level_2_miss_press;
			rule_level_3_miss_press = r.rules.rule_level_3_miss_press;
			rule_level_1_triple = r.rules.rule_level_1_triple;
			rule_level_2_triple = r.rules.rule_level_2_triple;
			rule_level_3_triple = r.rules.rule_level_3_triple;
			
			trace( "DUOMENYS UZKRAUTI" );
			
		}
	}
	
	private function star_generator( stars_number : Number, active_stars_number : Number, stars_type : Number, show_not_activated_stars : Boolean ) : Sprite {
		var stars_holder : Sprite = new Sprite;
		
		for ( var i : uint = 1; i <= stars_number; i++ ) {
			if ( i <= active_stars_number ) {
				if ( stars_type == 1 ) {
					var l_star_active : little_star_active = new little_star_active;
					
					if ( stars_holder.width != 0 ) {
						l_star_active.x = stars_holder.width + 2;
					}
					stars_holder.addChild( l_star_active );
				} else {
					
					var b_star_active : big_star_active = new big_star_active;
					
					if ( stars_holder.width != 0 ) {
						b_star_active.x = stars_holder.width + 2;
					}
					stars_holder.addChild( b_star_active );
				}
			} else if ( i > active_stars_number && show_not_activated_stars == true ) {
				if ( stars_type == 1 ) {
					var l_star_default : little_star_default = new little_star_default;
					
					if ( stars_holder.width != 0 ) {
						l_star_default.x = stars_holder.width + 2;
					}
					stars_holder.addChild( l_star_default );
				} else {
					var b_star_default : big_star_default = new big_star_default;
					
					if ( stars_holder.width != 0 ) {
						b_star_default.x = stars_holder.width + 2;
					}
					stars_holder.addChild( b_star_default );
				}
			}
		}
		
		return stars_holder;
	}
	
	private function tab_click( event : MouseEvent ) : void {
		var tab_default1 : Object = tab_1.getChildByName( 'tab_default' );
		var tab_active1 : Object = tab_1.getChildByName( 'tab_active' );
		tab_default1.visible = true;
		tab_active1.visible = false;
		var tab_default2 : Object = tab_2.getChildByName( 'tab_default' );
		var tab_active2 : Object = tab_2.getChildByName( 'tab_active' );
		tab_default2.visible = true;
		tab_active2.visible = false;
		var tab_default : Object = event.target.getChildByName( 'tab_default' );
		var tab_active : Object = event.target.getChildByName( 'tab_active' );
		tab_default.visible = false;
		tab_active.visible = true;
		
		var holder_object : Object = event.target.parent;
		var table_1 : Object = holder_object.getChildByName( 'styled_table_obj_1' );
		var table_2 : Object = holder_object.getChildByName( 'styled_table_obj_2' );
		
		if ( event.target.name == "tab_1" ) {
			table_1.visible = true;
			table_2.visible = false;
		} else {
			table_1.visible = false;
			table_2.visible = true;
		}
	
	}
	
	private function add_tab_title( holder : Sprite, title_val : String, type : String ) : void {
		var bg : Sprite = new Sprite;
		holder.addChild( bg );
		bg.mouseEnabled = false;
		var tab_format : TextFormat = new TextFormat();
		tab_format.font = "Arial";
		tab_format.size = 14;
		tab_format.color = 0xFFFFFF;
		var tab_title : TextField = new TextField;
		holder.addChild( tab_title );
		tab_title.autoSize = "left";
		tab_title.selectable = false;
		tab_title.multiline = false;
		tab_title.mouseEnabled = false;
		tab_title.defaultTextFormat = t_format;
		tab_title.text = title_val.toUpperCase();
		tab_title.x = title_padding_hor;
		tab_title.y = title_padding_ver;
		tab_title.wordWrap = false;
		tab_title.x = title_padding_hor;
		tab_title.y = title_padding_ver;
		var bg_color : Number;
		var bg_shadow_color_1 : Number;
		var bg_shadow_color_2 : Number;
		
		if ( type == "default" ) {
			bg_color = 0xB3B3B1;
			bg_shadow_color_1 = 0x838382;
			bg_shadow_color_2 = 0xB3B3B1;
		} else if ( type == "active" ) {
			bg_color = 0x878787;
			bg_shadow_color_1 = 0x797979;
			bg_shadow_color_2 = 0x878787;
		} else if ( type == "static" ) {
			bg_color = 0xF05A23;
			bg_shadow_color_1 = 0xC84E0C;
			bg_shadow_color_2 = 0xF05A23;
		}
		drawRoundRect( bg, tab_title.width + title_padding_hor * 2, tab_title.height + title_padding_ver * 2, 0, 0, title_corner, title_corner, 0, bg_color, bg_color, 1 );
		var fillType : String = "linear";
		var colors : Array = [ bg_shadow_color_1, bg_shadow_color_2 ];
		var alphas : Array = [ 1, 1 ];
		var ratios : Array = [ 0, 255 ];
		var matr : Matrix = new Matrix();
		matr.createGradientBox( bg.width, 6, Math.PI / 2, 3, 0 );
		bg.graphics.beginGradientFill( fillType, colors, alphas, ratios, matr );
		bg.graphics.moveTo( 0, 0 );
		bg.graphics.lineTo( bg.width, 0 );
		bg.graphics.lineTo( bg.width, 6 );
		bg.graphics.lineTo( 0, 6 );
		bg.graphics.endFill();
	}
	
	private function m_window_background_mouseDown( event : MouseEvent ) : void {
		this.startDrag();
	}
	
	private function m_window_background_mouseUp( event : MouseEvent ) : void {
		this.stopDrag();
	}
	
	private function update_close_btn() : void {
		close_btn.x = m_window_content_holder.width + 2 * m_window_padding;
		close_btn.x = 875;
		close_btn.y = close_circle_rad;
	}
	
	public function update_m_window() : void {
		m_window_content_holder.y = m_window_title_holder.y + m_window_title_holder.height + m_window_padding;
		m_window_content_holder.x = m_window_padding;
		update_m_window_background();
		update_close_btn();
		//trace(m_window_content_holder.height)
	}
	
	public function change_window_title( title : String ) : void {
		add_m_window_title( title );
		m_window_content_holder.y = m_window_title_holder.y + m_window_title_holder.height + m_window_padding;
		m_window_content_holder.x = m_window_padding;
		update_m_window_background();
		update_close_btn();
	}
	
	private function update_m_window_background() : void {
		var w_f_c_c : Number = close_circle_rad; //window frame close circle
		var w_f_c : Number = 10; //window frame corner
		var max_content_width : Number;
		
		if ( m_window_content_holder.width >= m_window_title_holder.width ) {
			max_content_width = m_window_content_holder.width + 2 * m_window_padding;
		} else {
			max_content_width = m_window_title_holder.width + 2 * m_window_padding;
		}
		//var w_f_w:Number = m_window_content_holder.width + 2 * m_window_padding;//window frame width
		var w_f_w : Number = 875;
		var w_f_h : Number;
		
		if ( window_part_3.visible == true ) {
			w_f_h = 650;
		} else {
			w_f_h = 390;
		}
		
		//var w_f_h:Number = m_window_content_holder.y+m_window_content_holder.height+m_window_padding-close_circle_rad;//window frame height
		//var w_f_h:Number = m_window_content_holder.height - close_circle_rad;
		m_window_background.graphics.clear();
		m_window_background.graphics.lineStyle( 1, 0xFFFFFF );
		m_window_background.graphics.beginFill( 0xFFFFFF, 0.5 );
		m_window_background.graphics.moveTo( 0, w_f_c + close_circle_rad );
		m_window_background.graphics.curveTo( 0, 0 + close_circle_rad, w_f_c, 0 + close_circle_rad );
		m_window_background.graphics.lineTo( w_f_w - close_circle_rad, 0 + close_circle_rad );
		m_window_background.graphics.curveTo( w_f_w - close_circle_rad, -close_circle_rad + close_circle_rad, w_f_w, -close_circle_rad + close_circle_rad );
		m_window_background.graphics.curveTo( w_f_w + close_circle_rad, -close_circle_rad + close_circle_rad, w_f_w + close_circle_rad, 0 + close_circle_rad );
		m_window_background.graphics.curveTo( w_f_w + close_circle_rad, close_circle_rad + close_circle_rad, w_f_w, w_f_c_c + close_circle_rad );
		m_window_background.graphics.lineTo( w_f_w, w_f_h - w_f_c + close_circle_rad );
		m_window_background.graphics.curveTo( w_f_w, w_f_h + close_circle_rad, w_f_w - w_f_c, w_f_h + close_circle_rad );
		m_window_background.graphics.lineTo( w_f_c, w_f_h + close_circle_rad );
		m_window_background.graphics.curveTo( 0, w_f_h + close_circle_rad, 0, w_f_h - w_f_c + close_circle_rad );
		m_window_background.graphics.endFill();
		m_window_background.alpha = 0.5;
	}
	
	private function add_m_window_title( title_val : String ) : void {
		t_format = new TextFormat();
		t_format.font = "Arial";
		t_format.size = 14;
		t_format.color = 0xFFFFFF;
		m_window_title.autoSize = "left";
		m_window_title.selectable = false;
		m_window_title.multiline = true;
		m_window_title.mouseEnabled = false;
		m_window_title.defaultTextFormat = t_format;
		m_window_title.text = title_val.toUpperCase();
		m_window_title.x = title_padding_hor;
		m_window_title.y = title_padding_ver;
		m_window_title_holder.x = m_window_padding;
		m_window_title_holder.y = close_circle_rad;
		
		if ( m_window_title.width > ( window_width - 2 * m_window_padding - close_circle_rad - 2 * title_padding_hor - 10 ) ) {
			m_window_title.wordWrap = true;
			m_window_title.width = window_width - 2 * m_window_padding - close_circle_rad - 2 * title_padding_hor - 10;
		}
		
		m_window_title_background.graphics.clear();
		drawRoundRect( m_window_title_background, m_window_title.width + title_padding_hor * 2, m_window_title.height + title_padding_ver * 2, 0, 0, title_corner, title_corner, 0, 0x000000, 0xF05A23, 1 );
		draw_title_shadow();
	}
	
	private function drawRoundRect( m_clip : Sprite, w : Number, h : Number, tl : Number, tr : Number, bl : Number, br : Number, thick : Number, borderColor : Number, bgColor : Number, trans : Number ) : void {
		if ( thick != 0 )
			m_clip.graphics.lineStyle( thick, borderColor );
		m_clip.graphics.beginFill( bgColor, trans );
		m_clip.graphics.moveTo( 0, tl );
		m_clip.graphics.curveTo( 0, 0, tl, 0 );
		m_clip.graphics.lineTo( w - tr, 0 );
		m_clip.graphics.curveTo( w, 0, w, tr );
		m_clip.graphics.lineTo( w, h - br );
		m_clip.graphics.curveTo( w, h, w - br, h );
		m_clip.graphics.lineTo( bl, h );
		m_clip.graphics.curveTo( 0, h, 0, h - bl );
		m_clip.graphics.endFill();
	}
	
	private function draw_title_shadow() : void {
		var fillType : String = "linear";
		var colors : Array = [ 0xC84E0C, 0xF05A23 ];
		var alphas : Array = [ 1, 1 ];
		var ratios : Array = [ 0, 255 ];
		var matr : Matrix = new Matrix();
		matr.createGradientBox( m_window_title_background.width, 6, Math.PI / 2, 3, 0 );
		m_window_title_background.graphics.beginGradientFill( fillType, colors, alphas, ratios, matr );
		m_window_title_background.graphics.moveTo( 0, 0 );
		m_window_title_background.graphics.lineTo( m_window_title_background.width, 0 );
		m_window_title_background.graphics.lineTo( m_window_title_background.width, 6 );
		m_window_title_background.graphics.lineTo( 0, 6 );
		m_window_title_background.graphics.endFill();
	}
	
	/**
	 *	On close button click
	 */
	protected function close_btn_click ( event : MouseEvent) : void {
		
		this.destroy();
		
	}

}

}