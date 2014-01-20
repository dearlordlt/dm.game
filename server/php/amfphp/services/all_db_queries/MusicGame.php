<?php

class MusicGame{
	private $connection;

	public function __construct(){		
		$this->connection = mysql_connect('localhost','root','DaBu320');
		mysql_set_charset('utf8', $this->connection);
		mysql_select_db('dm',$this->connection);
	}
	
	public function saveResult($params){
		$query = "INSERT INTO `music_game_users_videos`(`user_id`, `video_id`, `score`, `level`, `sounds_string`) VALUES ('".$params[0]."','".$params[1]."','".$params[2]."','".$params[3]."','".$params[4]."')";
		$result_set = mysql_query($query,$this->connection);
		$entry = new stdClass;
		$query = 'SELECT b.title AS title, b.file AS file, a.score AS score, a.level AS level, a.sounds_string AS sounds_string FROM  music_game_users_videos AS a LEFT JOIN music_game_videos AS b ON a.video_id = b.id WHERE a.user_id ="'.$params[0].'" ORDER BY a.level DESC, a.score DESC';
		$result_set = mysql_query($query,$this->connection);
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
		$result_set = mysql_query($query,$this->connection);
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
		$result_set = mysql_query($query,$this->connection);
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
		$result_set = mysql_query($query,$this->connection);
		$row_entry=new stdClass;
		while($row=mysql_fetch_array($result_set)){
			$row_entry->$row['title']=$row['value'];
		}
		$entry->rules=$row_entry;
		$query = 'SELECT * FROM  music_game_videos ORDER BY title ASC';
		$result_set = mysql_query($query,$this->connection);
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
		$result_set = mysql_query($query,$this->connection);
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
		$query = 'SELECT * FROM   music_game_users WHERE id ="'.$user_id.'"';
		$result_set = mysql_query($query,$this->connection);
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
		$result_set = mysql_query($query,$this->connection);
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
	
	
	
	
	
	/*
	
	public function load_rules(){
		$query = 'SELECT title,value FROM music_repeater_rules WHERE id !=""';
		$result_set = mysql_query($query,$this->connection);
		$rows=array();
		while($row=mysql_fetch_array($result_set)){
			$rows[$row['title']]=$row['value'];
		}
		return $rows;
	}
	
	public function get_all_video(){
		$query = 'SELECT * FROM  music_repeater_videos ORDER BY title ASC';
		$result_set = mysql_query($query,$this->connection);
		if($result_set){
			$rows=array();
			if(mysql_num_rows($result_set)>0){
				while($row=mysql_fetch_array($result_set)){
					$row_temp=array();
					$row_temp[0]=$row['title'];
					$row_temp[1]=$row['file'];
					$rows[]=$row_temp;
				}
				return $rows;
			}
		}else{
			return false;
		}
	}
	
	public function get_user_video($params){
		$query = 'SELECT b.title AS title, b.file AS file, a.score AS score, a.level AS level, a.sounds_string AS sounds_string FROM  music_repeater_users_videos AS a LEFT JOIN music_repeater_videos AS b ON a.video_id = b.id WHERE a.user_id ="'.$params[0].'" ORDER BY a.level DESC, a.score DESC';
		$result_set = mysql_query($query,$this->connection);
		if($result_set){
			$rows=array();
			if(mysql_num_rows($result_set)>0){
				while($row=mysql_fetch_array($result_set)){
					$row_temp=array();
					$row_temp[0]=$row['title'];
					$row_temp[1]=$row['file'];
					$row_temp[2]=$row['score'];
					$row_temp[3]=$row['level'];
					if($row['sounds_string']==""){
						$row_temp[4]="";
					}else{
						$row_temp[4]=$row['sounds_string'];
					}
					$rows[]=$row_temp;
				}
				return $rows;
			}
		}else{
			return false;
		}
	}
	
	
	public function get_user_video_info($params){
		$query = 'SELECT score, level, sounds_string FROM  music_repeater_users_videos WHERE user_id ="'.$params[0].'" AND video_id ="'.$params[1].'"';
		$result_set = mysql_query($query,$this->connection);
		$row_temp=array();
		$row = mysql_fetch_assoc($result_set);
		$row_temp=array();
		if($row['score']=="" || $row['level']==""){
			$row_temp[0]="";
			$row_temp[1]="";
			$row_temp[2]="";
		}else{
			$row_temp[0]=$row['score'];
			$row_temp[1]=$row['level'];
			$row_temp[2]=$row['sounds_string'];
		}
		return $row_temp;
	}
	
	public function insert_user_video_info($params){
		$query = "INSERT INTO `music_repeater_users_videos`(`user_id`, `video_id`, `score`, `level`, `sounds_string`) VALUES ('".$params[0]."','".$params[1]."','".$params[2]."','".$params[3]."','".$params[4]."')";
		$result_set = mysql_query($query,$this->connection);
	}
	
	
	public function update_user_video_info($params){
		$query = 'UPDATE music_repeater_users_videos SET score="'.$params[2].'", level="'.$params[3].'", sounds_string="'.$params[4].'" WHERE user_id ="'.$params[0].'" AND video_id ="'.$params[1].'"';  
		$result_set = mysql_query($query,$this->connection);
	}
	
	public function get_friends_video($params){
		$query1 = 'SELECT a.friend_id AS friend_id, b.name AS name FROM  music_repeater_user_friends AS a LEFT JOIN music_repeater_users AS b ON a.friend_id = b.id WHERE a.user_id ="'.$params[0].'" ORDER BY b.name ASC';
		$result_set1 = mysql_query($query1,$this->connection);
		$rows1=array();
		while($row1=mysql_fetch_array($result_set1)){
			$row_temp1=array();
			$row_temp1[0]=$row1['friend_id'];
			$row_temp1[1]=$row1['name'];
			$query = 'SELECT d.title AS title, d.file AS file, c.score AS score, c.level AS level, c.sounds_string AS sounds_string FROM  music_repeater_users_videos AS c LEFT JOIN music_repeater_videos AS d ON c.video_id = d.id WHERE c.user_id ="'.$row1['friend_id'].'" ORDER BY c.level DESC, c.score DESC';
			$result_set = mysql_query($query,$this->connection);
			$rows=array();
			while($row=mysql_fetch_array($result_set)){
				$row_temp=array();
				$row_temp[0]=$row['title'];
				$row_temp[1]=$row['file'];
				$row_temp[2]=$row['score'];
				$row_temp[3]=$row['level'];
				if($row['sounds_string']==""){
					$row_temp[4]="";
				}else{
					$row_temp[4]=$row['sounds_string'];
				}
				$rows[]=$row_temp;
			}
			$row_temp1[2]=$rows;
			$rows1[]=$row_temp1;
		}
		return $rows1;			
	}
	*/
	
		/*public function get_friends_list($params){
		$query = 'SELECT a.friend_id AS friend_id, b.name AS name FROM  music_repeater_user_friends AS a LEFT JOIN music_repeater_users AS b ON a.friend_id = b.id WHERE a.user_id ="'.$params[0].'" ORDER BY b.name ASC';
		$result_set = mysql_query($query,$this->connection);
		if($result_set){
			$rows=array();
			if(mysql_num_rows($result_set)>0){
				while($row=mysql_fetch_array($result_set)){
					$row_temp=array();
					$row_temp[0]=$row['friend_id'];
					$row_temp[1]=$row['name'];
					$rows2=array();
					
					$row_temp[2]=$rows2;
					$rows[]=$row_temp;
				}
				return $rows;
			}
		}else{
			return false;
		}
	}*/
	
	
	/*public function read_dialog($id){
		$rows=array();
		$query = 'SELECT * FROM  dialog_dialogs WHERE id ="'.$id.'"';
		$result_set = mysql_query($query,$this->connection);
		$row = mysql_fetch_assoc($result_set);
		$row_temp=array();
		$row_temp['id']=1;
		$row_temp['dbid']=0;
		$row_temp['dialog_id']=$row['id'];
		$row_temp['parentid']=-1;
		$row_temp['returnid']=0;
		$query2 = 'SELECT id FROM dialog_phrases WHERE dialog_id ="'.$row['id'].'"';
		$result_set2 = mysql_query($query2,$this->connection);
		$num_rows = mysql_num_rows($result_set2);
		if($num_rows){
			$row_temp['haschilds']=true;
		}else{
			$row_temp['haschilds']=false;
		}
		$row_temp['hierarchy']='';
		$row_temp['priority']=0;
		$row_temp['subject']='main';
		$row_temp['x_y']=$row['x_y'];
		$row_temp['dtext']='';
		$rows[]=$row_temp;		
		
		$query = 'SELECT * FROM  dialog_phrases WHERE dialog_id ="'.$id.'" ORDER BY id';
		$result_set = mysql_query($query,$this->connection);
		if($result_set){
			
			if(mysql_num_rows($result_set)>0){
				$num=1;
				while($row=mysql_fetch_array($result_set)){
					$num++;
					$rows_temp=array();
					$rows_temp['id']=$num;
					$rows_temp['dbid']=$row['id'];
					$rows_temp['dialog_id']=$row['dialog_id'];
					$rows_temp['parentid']=$row['parent_id'];
					$rows_temp['returnid']=0;
					$query2 = 'SELECT id FROM dialog_phrases WHERE parent_id ="'.$row['id'].'"';
					$result_set2 = mysql_query($query2,$this->connection);
					$num_rows = mysql_num_rows($result_set2);
					if($num_rows){
						$rows_temp['haschilds']=true;
					}else{
						$rows_temp['haschilds']=false;
					}
					$rows_temp['hierarchy']='';
					$rows_temp['priority']=$row['priority'];
					$rows_temp['subject']=$row['subject'];
					$rows_temp['x_y']=$row['x_y'];
					$rows_temp['dtext']=$this->safe_text_to_string($row['text']);
					$rows[]=$rows_temp;
				}
			}
		}else{
			return false;
		}
		return $rows;
	}
	
	
	
	public function get_dialog_info($id){
		$query = 'SELECT * FROM  dialog_dialogs WHERE id ="'.$id.'"';
		$result_set = mysql_query($query,$this->connection);
		$row = mysql_fetch_assoc($result_set);
		return $row;
	}
	
	public function save_dialog_info($params){
		$date_time = gmdate("Y-m-d H:i:s");
		$query = 'UPDATE dialog_dialogs SET name="'.$params[1].'", last_modified_date="'.$date_time.'", last_modified_by="'.$params[2].'" WHERE id="'.$params[0].'"';  
		$result_set = mysql_query($query,$this->connection);
		return params;
	}
	
	
	public function get_phrase_info($id){
		$query = 'SELECT * FROM  dialog_phrases WHERE id ="'.$id.'"';
		$result_set = mysql_query($query,$this->connection);
		$row = mysql_fetch_assoc($result_set);
		return $row;
	}
	
	public function save_phrase_info($params){
		$date_time = gmdate("Y-m-d H:i:s");
		$query = 'UPDATE dialog_phrases SET text="'.$params[1].'",subject="'.$params[2].'",priority="'.$params[3].'", last_modified_date="'.$date_time.'", last_modified_by="'.$params[4].'" WHERE id="'.$params[0].'"';  
		$result_set = mysql_query($query,$this->connection);
		foreach ($params[5] as $f_key => $func){
			$query2 = 'DELETE FROM dialog_phrase_function_params WHERE phrase_id ="'.$params[0].'" AND function_id ="'.$f_key.'"';
			$result_set2 = mysql_query($query2,$this->connection);
			if($func['is_assigned']==true){
				foreach ($func['attributes'] as $a_key => $atr){
					$query3 = 'INSERT INTO dialog_phrase_function_params (`phrase_id`, `function_id`, `param_id`, `param_value`) VALUES ("'.$params[0].'","'.$f_key.'","'.$a_key.'","'.$atr['assigned_value'].'")';
					$result_set3 = mysql_query($query3,$this->connection);
				}
			}
		}
		foreach ($params[6] as $c_key => $cond){
			$query2 = 'DELETE FROM dialog_phrase_condition_params WHERE phrase_id ="'.$params[0].'" AND function_id ="'.$c_key.'"';
			$result_set2 = mysql_query($query2,$this->connection);
			if($cond['is_assigned']==true){
				foreach ($cond['attributes'] as $a_key => $atr){
					$query3 = 'INSERT INTO dialog_phrase_condition_params (`phrase_id`, `condition_id`, `param_id`, `param_value`) VALUES ("'.$params[0].'","'.$c_key.'","'.$a_key.'","'.$atr['assigned_value'].'")';
					$result_set3 = mysql_query($query3,$this->connection);
				}
			}
		}			
		return $true;
	}
	
	
	public function save_data_to_db($nodes_array){
		$convert_array=array();

		// INSERTING NEW NODES
		foreach ($nodes_array as $key => $node){
			if($node['saved'] == false){
				$query = 'INSERT INTO dialog_phrases (dialog_id, parent_id, priority, subject, text) VALUES ("'.$node['dialog_id'].'","'.$node['parentid'].'","'.$node['priority'].'","'.$node['subject'].'","'.$node['dtext'].'")';
				$result_set = mysql_query($query,$this->connection);
				$last_db_id = $this->select_max_val('id','dialog_phrases');
				$convert_array[$node['dbid']] = $last_db_id;
				$node['saved'] = true;
			}
		}
		
		// UPDATING OLD NODES
		foreach ($nodes_array as $key => $node){
			if (array_key_exists($node['dbid'], $convert_array)) {
				$node['dbid']=$convert_array[$node['dbid']];
			}
			if (array_key_exists($node['parentid'], $convert_array)) {
				$node['parentid']=$convert_array[$node['parentid']];
			}
			$query2 = 'UPDATE dialog_phrases SET dialog_id="'.$node['dialog_id'].'", parent_id="'.$node['parentid'].'", priority="'.$node['priority'].'", subject="'.$node['subject'].'", text="'.$node['dtext'].'" WHERE id="'.$node['dbid'].'"';  
			$result_set2 = mysql_query($query2,$this->connection);
		}
		
		// DELETING UNNECESSARY NODES
		foreach ($nodes_array as $key => $node){
		
		}
		
		return $nodes_array;
	
	}
	
	public function save_field_to_db($params){
		$query = 'UPDATE dialog_phrases SET text="'.$this->string_to_safe_text($params[0]).'" WHERE id="'.$params[1].'"';  
		$result_set = mysql_query($query,$this->connection);
		return $params;
	}
	
	
	public function string_to_safe_text($str) {
		$str = str_replace('"', "&#34;", $str);
		return $str;
	}
	
	public function safe_text_to_string($str) {
		$str = str_replace("&#34;", '"', $str);
		return $str;
	}
	
	public function add_node_to_db($params){
		if($params[3]=="main" || $params[3]=="me"){
			$subject="npc";
		}elseif($params[3]=="npc"){
			$subject="me";
		}else{
			$subject="";
		}
		$query = 'INSERT INTO dialog_phrases (dialog_id, parent_id, priority, subject) VALUES ("'.$params[0].'","'.$params[1].'","0","'.$subject.'")';
		$result_set = mysql_query($query,$this->connection);
		$last_db_id = $this->select_max_val('id','dialog_phrases');
		$entry=array();
		$entry['id']=$params[2];
		$entry['dbid']=$last_db_id;
		$entry['dialog_id']=$params[0];
		$entry['parentid']=$params[1];
		$entry['returnid']=0;
		$entry['haschilds']=false;
		$entry['hierarchy']='';
		$entry['priority']=0;
		$entry['subject']=$subject;
		$entry['dtext']='';
		return $entry;
	}
	
	public function update_node_xy($params){
		if($params[2]==true){
			$query = 'UPDATE dialog_dialogs SET x_y="'.$params[0].'" WHERE id="'.$params[1].'"';  
		}else{
			$query = 'UPDATE dialog_phrases SET x_y="'.$params[0].'" WHERE id="'.$params[1].'"';  
		}
		$result_set = mysql_query($query,$this->connection);
		return true;
	}
	
	public function delete_node_from_db($params){
		$query = 'DELETE FROM dialog_phrases WHERE id IN ('.implode(',',$params).')';
		$result_set = mysql_query($query,$this->connection);
		return true;
	}
	
	public function delete_dialog($params){
		$query = 'DELETE FROM dialog_dialogs WHERE id = "'.$params.'"';
		$result_set = mysql_query($query,$this->connection);
		return $params;
	}
	
	public function select_max_val($f_name,$table_name){
		$query = 'SELECT MAX('.$f_name.') as max_value FROM '.$table_name;
		$result_set = mysql_query($query,$this->connection);
		$row=mysql_fetch_array($result_set);
		return $row['max_value'];
	} 
	
	public function add_dialog($params){
		$date_time = gmdate("Y-m-d H:i:s");
		$query = "INSERT INTO `dialog_dialogs`(`name`, `created_date`, `created_by`, `last_modified_date`, `last_modified_by`) VALUES ('".$params[0]."','".$date_time."','".$params[1]."','".$date_time."','".$params[1]."')";
		$result_set = mysql_query($query,$this->connection);
		return $query ;
	}
	
	public function get_all_functions_info($id){
		$main=array();		
		$query = 'SELECT * FROM  dialog_functions ORDER BY name';
		$result_set = mysql_query($query,$this->connection);
		if($result_set){
			if(mysql_num_rows($result_set)>0){
				while($row=mysql_fetch_array($result_set)){
					$f_array=array();
					$f_array['name']=$row['name'];
					$query4 = 'SELECT param_value FROM  dialog_phrase_function_params WHERE phrase_id ="'.$id.'" AND function_id ="'.$row['id'].'"';
					$result_set4 = mysql_query($query4,$this->connection);
					if(mysql_num_rows($result_set4)>0){
						$f_array['is_assigned']=true;
					}else{
						$f_array['is_assigned']=false;
					}
						$at_array=array();
							$query2 = 'SELECT * FROM  dialog_functions_params WHERE function_id ="'.$row['id'].'" ORDER BY name';
							$result_set2 = mysql_query($query2,$this->connection);
							while($row2=mysql_fetch_array($result_set2)){
								$at_array['name']=$row2['name'];
								$query3 = 'SELECT param_value FROM  dialog_phrase_function_params WHERE phrase_id ="'.$id.'" AND function_id ="'.$row['id'].'" AND param_id ="'.$row2['id'].'"';
								$result_set3 = mysql_query($query3,$this->connection);
								$row3=mysql_fetch_array($result_set3);
								if($row3['param_value'] !=""){
									$at_array['assigned_value']=$row3['param_value'];
								}else{
									$at_array['assigned_value']="";
								}
								$f_array['attributes'][$row2['id']]=$at_array;
							}	
					$main[$row['id']]=$f_array;
				}
			}
		}else{
			return false;
		}
		return $main;
	}
	
	public function get_all_conditions_info($id){
		$main=array();		
		$query = 'SELECT * FROM  dialog_conditions ORDER BY name';
		$result_set = mysql_query($query,$this->connection);
		if($result_set){
			if(mysql_num_rows($result_set)>0){
				while($row=mysql_fetch_array($result_set)){
					$f_array=array();
					$f_array['name']=$row['name'];
					$query4 = 'SELECT param_value FROM  dialog_phrase_condition_params WHERE phrase_id ="'.$id.'" AND condition_id ="'.$row['id'].'"';
					$result_set4 = mysql_query($query4,$this->connection);
					if(mysql_num_rows($result_set4)>0){
						$f_array['is_assigned']=true;
					}else{
						$f_array['is_assigned']=false;
					}
						$at_array=array();
							$query2 = 'SELECT * FROM  dialog_conditions_params WHERE condition_id ="'.$row['id'].'" ORDER BY name';
							$result_set2 = mysql_query($query2,$this->connection);
							while($row2=mysql_fetch_array($result_set2)){
								$at_array['name']=$row2['name'];
								$query3 = 'SELECT param_value FROM  dialog_phrase_condition_params WHERE phrase_id ="'.$id.'" AND condition_id ="'.$row['id'].'" AND param_id ="'.$row2['id'].'"';
								$result_set3 = mysql_query($query3,$this->connection);
								$row3=mysql_fetch_array($result_set3);
								if($row3['param_value'] !=""){
									$at_array['assigned_value']=$row3['param_value'];
								}else{
									$at_array['assigned_value']="";
								}
								$f_array['attributes'][$row2['id']]=$at_array;
							}	
					$main[$row['id']]=$f_array;
				}
			}
		}else{
			return false;
		}
		return $main;
	}
	
	*/
	
	
	
	
}

?>