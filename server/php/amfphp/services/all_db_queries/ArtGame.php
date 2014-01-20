<?php

class ArtGame{

	private $connection;
	private $files_url="http://vds000004.hosto.lt/art_game/images/";
	private $files_root_url="http://vds000004.hosto.lt/art_game/images/";
	//private $files_url="http://localhost/art_game/images/";
	//private $files_root_url="E:/xampp/htdocs/art_game/images/";

	public function __construct(){
		$this->connection = mysql_connect('localhost','root','DaBu320');
		mysql_set_charset('utf8', $this->connection);
		mysql_select_db('dm',$this->connection);
	}
	
	public function load_riddles_list(){
		$query = 'SELECT * FROM  art_game_riddles ORDER BY name ASC';
		$result_set = mysql_query($query,$this->connection);
		$rows=array();
		while($row=mysql_fetch_array($result_set)){
			$entry=array();
			$entry['id']=$row['id'];
			$entry['name']=$row['name'];
			$entry['image']=$row['image'];
			$rows[]=$entry;
		}
		return $rows;
	}
	
	public function get_all_riddle_info($id){
		$rows=array();
		$query = 'SELECT * FROM  art_game_riddles WHERE id ="'.$id.'"';
		$result_set = mysql_query($query,$this->connection);
		$row = mysql_fetch_assoc($result_set);
		$row_temp=array();
		$row_temp['id']=$row['id'];
		$row_temp['name']=$row['name'];
		$row_temp['image']=$row['image'];
		if($row['image']!=""){
			if(111==222) {
				//$query3 = 'UPDATE art_game_riddles SET image="" WHERE id ="'.$row['id'].'"'; 
				//$result_set3 = mysql_query($query3,$this->connection);
				$row_temp['image']='';
			}
		}
		$query2 = 'SELECT * FROM  art_game_answers WHERE riddle_id ="'.$row['id'].'"';
		$result_set2 = mysql_query($query2,$this->connection);
		$rows2=array();
		while($row2=mysql_fetch_array($result_set2)){
			$entry=array();
			$entry['id']=$row2['id'];
			$entry['text']=$row2['text'];
			$entry['is_correct']=$row2['is_correct'];
			$rows2[]=$entry;
		}
		$row_temp['answers']=$rows2;
		return $row_temp;	
	}
	
	public function get_random_riddles($num){
		$rows=array();
		$query = 'SELECT * FROM  art_game_riddles ORDER BY RAND() LIMIT '.$num;
		$result_set = mysql_query($query,$this->connection);
		$main_entry=array();
		while($row=mysql_fetch_array($result_set)){
			$row_temp=array();
			$row_temp['id']=$row['id'];
			$row_temp['name']=$row['name'];
			$row_temp['image']=$row['image'];
			if($row['image']!=""){
				if(111==222) {
					//$query3 = 'UPDATE art_game_riddles SET image="" WHERE id ="'.$row['id'].'"'; 
					//$result_set3 = mysql_query($query3,$this->connection);
					$row_temp['image']='';
				}
			}
			$query2 = 'SELECT * FROM  art_game_answers WHERE riddle_id ="'.$row['id'].'"';
			$result_set2 = mysql_query($query2,$this->connection);
			$rows2=array();
			while($row2=mysql_fetch_array($result_set2)){
				$entry=array();
				$entry['id']=$row2['id'];
				$entry['text']=$row2['text'];
				$entry['is_correct']=$row2['is_correct'];
				$rows2[]=$entry;
			}
			$row_temp['answers']=$rows2;
			$main_entry[]=$row_temp;
		}
		return $main_entry;	
	}
	
	public function get_all_high_scores(){
		$rows=array();
		$query = 'SELECT * FROM  art_game_high_scores ORDER BY score DESC LIMIT 10';
		$result_set = mysql_query($query,$this->connection);
		$main_entry=array();
		while($row=mysql_fetch_array($result_set)){
			$main_entry[]=$row;
		}
		return $main_entry;	
	}
	
	public function share_score($params){
		$query = "INSERT INTO `art_game_high_scores`(`name`, `score`) VALUES ('".$params[0]."','".$params[1]."')";
		$result_set = mysql_query($query,$this->connection);
		$query = 'SELECT id, min(score) AS min_score FROM art_game_high_scores';
		$result_set = mysql_query($query,$this->connection);
		$row = mysql_fetch_assoc($result_set);
		$query = 'DELETE FROM art_game_high_scores WHERE id = "'.$row['id'].'"';
		$result_set = mysql_query($query,$this->connection);
	}
	
	public function insert_riddle(){
		
		$query = 'SELECT * FROM  art_game_riddles WHERE is_new ="1"';
		$result_set = mysql_query($query,$this->connection);
		$number_of_rows = mysql_num_rows($result_set);
		if ($number_of_rows == 0){
			$query = "INSERT INTO `art_game_riddles`(`name`, `is_new`) VALUES ('New riddle','1')";
			$result_set = mysql_query($query,$this->connection);
		}
		$rows=array();
		$query = 'SELECT * FROM  art_game_riddles WHERE is_new ="1"';
		$result_set = mysql_query($query,$this->connection);
		$row = mysql_fetch_assoc($result_set);
		$row_temp=array();
		$row_temp['id']=$row['id'];
		$row_temp['name']=$row['name'];
		$row_temp['image']=$row['image'];
		$query2 = 'SELECT * FROM  art_game_answers WHERE riddle_id ="'.$row['id'].'"';
		$result_set2 = mysql_query($query2,$this->connection);
		$rows2=array();
		while($row2=mysql_fetch_array($result_set2)){
			$entry=array();
			$entry['id']=$row2['id'];
			$entry['text']=$row2['text'];
			$entry['is_correct']=$row2['is_correct'];
			$rows2[]=$entry;
		}
		$row_temp['answers']=$rows2;
		return $row_temp;	
	}
	
	public function update_riddle_name($params){
		$query = 'UPDATE art_game_riddles SET name="'.$params[1].'", is_new="'.$params[2].'" WHERE id ="'.$params[0].'"';  
		$result_set = mysql_query($query,$this->connection);
	}
	
	public function add_answer($params){
		$query = 'SELECT * FROM art_game_answers WHERE is_correct ="1" AND riddle_id="'.$params[0].'"';
		$result_set = mysql_query($query,$this->connection);
		$number_of_rows = mysql_num_rows($result_set);
		if ($number_of_rows == 0){
			$is_correct_value=1;
		}else{
			$is_correct_value=0;
		}
		if($params[1]==""){
			$text="-";
		}else{
			$text=$params[1];
		}
		$query = "INSERT INTO `art_game_answers` (`riddle_id`, `text`, `is_correct`) VALUES ('".$params[0]."','".$text."','".$is_correct_value."')";
		$result_set = mysql_query($query,$this->connection);
	}
	
	public function select_correct_answer($params){
		$query = 'UPDATE art_game_answers SET is_correct="0" WHERE riddle_id ="'.$params[0].'"';  
		$result_set = mysql_query($query,$this->connection);
		$query = 'UPDATE art_game_answers SET is_correct="1" WHERE id ="'.$params[1].'"';  
		$result_set = mysql_query($query,$this->connection);
	}
	
	public function remove_answer($id){
		$query = 'DELETE FROM art_game_answers WHERE id = "'.$id.'"';
		$result_set = mysql_query($query,$this->connection);
	}
	
	public function edit_answer($params){
		$query = 'UPDATE art_game_answers SET text="'.$params[1].'" WHERE id ="'.$params[0].'"'; 
		$result_set = mysql_query($query,$this->connection);
	}
	
	public function update_image($params){
		$query = 'UPDATE art_game_riddles SET image="'.$params[1].'" WHERE id ="'.$params[0].'"'; 
		$result_set = mysql_query($query,$this->connection);
	}
	
	
}

?>