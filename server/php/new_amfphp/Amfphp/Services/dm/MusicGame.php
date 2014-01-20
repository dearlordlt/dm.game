<?php

class MusicGame
{

	function __construct() { //Constructor		

	}
	
	public function saveResult($params){
		$query = "INSERT INTO `music_game_users_videos`(`user_id`, `video_id`, `score`, `level`, `sounds_string`) VALUES ('".$params[0]."','".$params[1]."','".$params[2]."','".$params[3]."','".$params[4]."')";
		$result_set = mysql_query($query);
		$entry = new stdClass;
		$query = 'SELECT b.title AS title, b.file AS file, a.score AS score, a.level AS level, a.sounds_string AS sounds_string FROM  music_game_users_videos AS a LEFT JOIN music_game_videos AS b ON a.video_id = b.id WHERE a.user_id ="'.$params[0].'" ORDER BY a.level DESC, a.score DESC';
		$result_set = mysql_query($query);
		$rows=array();
		while($row=mysql_fetch_array($result_set)){
			$row_temp=new stdClass;
			$row_temp->title=$row['title'];
			$row_temp->file=$row['file'];
			$row_temp->score=$row['score'];
			$row_temp->level=$row['level'];
			if($row['sounds_string']==""){
				$row_temp->sounds_string="";
			}else{
				$row_temp->sounds_string=$row['sounds_string'];
			}
			$rows[]=$row_temp;
		}
		$entry->current_user_videos=$rows;
		$query = 'SELECT * FROM   music_game_users WHERE id ="'.$params[0].'"';
		$result_set = mysql_query($query);
		$row = mysql_fetch_assoc($result_set);
		$row_temp=new stdClass;
		$row_temp->id=$row['id'];
		$row_temp->name=$row['name'];
		$entry->current_user_info=$row_temp;
		$rows=array();
		$query = 'SELECT 
		a.user_id as user_id,a.video_id as video_id,a.score as score,a.level as level, b.name as user_name, c.title as video_title
		FROM 
		music_game_users_videos as a 
		INNER JOIN
		music_game_users as b ON a.user_id=b.id	
		INNER JOIN	
		music_game_videos as c ON a.video_id=c.id	
		ORDER BY 
		a.level DESC, 
		a.score DESC 
		LIMIT 20';
		$result_set = mysql_query($query);
		$rows=array();
		while($row=mysql_fetch_array($result_set)){
			$row_temp=new stdClass;
			$row_temp->user_id=$row['user_id'];
			$row_temp->user_name=$row['user_name'];
			$row_temp->video_id=$row['video_id'];
			$row_temp->video_title=$row['video_title'];
			$row_temp->score=$row['score'];
			$row_temp->level=$row['level'];
			$rows[]=$row_temp;
		}
		$entry->top_scores=$rows;
		return $entry; 
	}
	
	public function get_all_music_game_info($user_id){
		$entry = new stdClass;
		$query = 'SELECT title,value FROM music_game_rules WHERE id !=""';
		$result_set = mysql_query($query);
		$row_entry=new stdClass;
		while($row=mysql_fetch_array($result_set)){
			$row_entry->$row['title']=$row['value'];
		}
		$entry->rules=$row_entry;
		$query = 'SELECT * FROM  music_game_videos ORDER BY title ASC';
		$result_set = mysql_query($query);
		$rows=array();
		while($row=mysql_fetch_array($result_set)){
			$row_temp=new stdClass;
			$row_temp->id=$row['id'];
			$row_temp->title=$row['title'];
			$row_temp->file=$row['file'];
			$rows[]=$row_temp;
		}
		$entry->videos=$rows;
		$query = 'SELECT b.title AS title, b.file AS file, a.score AS score, a.level AS level, a.sounds_string AS sounds_string FROM  music_game_users_videos AS a LEFT JOIN music_game_videos AS b ON a.video_id = b.id WHERE a.user_id ="'.$user_id.'" ORDER BY a.level DESC, a.score DESC';
		$result_set = mysql_query($query);
		$rows=array();
		while($row=mysql_fetch_array($result_set)){
			$row_temp=new stdClass;
			$row_temp->title=$row['title'];
			$row_temp->file=$row['file'];
			$row_temp->score=$row['score'];
			$row_temp->level=$row['level'];
			if($row['sounds_string']==""){
				$row_temp->sounds_string="";
			}else{
				$row_temp->sounds_string=$row['sounds_string'];
			}
			$rows[]=$row_temp;
		}
		$entry->current_user_videos=$rows;
		$query = 'SELECT * FROM avatars WHERE id ="'.$user_id.'"';
		$result_set = mysql_query($query);
		$row = mysql_fetch_assoc($result_set);
		$row_temp=new stdClass;
		$row_temp->id=$row['id'];
		$row_temp->name=$row['name'];
		$entry->current_user_info=$row_temp;
		$rows=array();
		$query = 'SELECT 
		a.user_id as user_id,a.video_id as video_id,a.score as score,a.level as level, b.name as user_name, c.title as video_title
		FROM 
		music_game_users_videos as a 
		INNER JOIN
		avatars as b ON a.user_id=b.id	
		INNER JOIN	
		music_game_videos as c ON a.video_id=c.id	
		ORDER BY 
		a.level DESC, 
		a.score DESC 
		LIMIT 20';
		$result_set = mysql_query($query);
		$rows=array();
		while($row=mysql_fetch_array($result_set)){
			$row_temp=new stdClass;
			$row_temp->user_id=$row['user_id'];
			$row_temp->user_name=$row['user_name'];
			$row_temp->video_id=$row['video_id'];
			$row_temp->video_title=$row['video_title'];
			$row_temp->score=$row['score'];
			$row_temp->level=$row['level'];
			$rows[]=$row_temp;
		}
		$entry->top_scores=$rows;
		return $entry;
	}
}

?>