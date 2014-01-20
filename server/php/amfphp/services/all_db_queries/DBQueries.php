<?php

class DBQueries{
	private $connection;

	public function __construct(){
				
		$this->connection = mysql_connect('localhost','root','DaBu320');
		mysql_set_charset('utf8', $this->connection);
		mysql_select_db('dm',$this->connection);
	}
	
	public function read_all_dialogs(){
		$query = 'SELECT * FROM  dialog_dialogs ORDER BY name ASC';
		$result_set = mysql_query($query,$this->connection);
		if($result_set){
			$rows=array();
			if(mysql_num_rows($result_set)>0){
				while($row=mysql_fetch_array($result_set)){
					$query2 = 'SELECT id FROM dialog_phrases WHERE dialog_id ="'.$row['id'].'"';
					$result_set2 = mysql_query($query2,$this->connection);
					$num_rows = mysql_num_rows($result_set2);
					$row[]=$num_rows;
					$rows[]=$row;
				}
				return $rows;
			}
		}else{
			return false;
		}
	}
	
	public function read_dialog($id){
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
	
	
	
	
	
	
	
	//-------------
	public function read_dialog_for_viewer($id){
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
					$rows_temp['functions']=$this->get_phrase_functions($row['id']);
					$rows_temp['conditions']=$this->get_phrase_conditions($row['id']);
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
		
		$query2 = 'SELECT * FROM  functions_to_phrases WHERE phrase_id ="'.$id.'"';
		$result_set2 = mysql_query($query2,$this->connection);
		$functions_array=array();
		while($row2=mysql_fetch_object($result_set2)){
			array_push($functions_array,$this->getFunctionById($row2->function_id));
		}
		$row['functions']=$functions_array;
		
		$query3 = 'SELECT * FROM  conditions_to_phrases WHERE phrase_id ="'.$id.'"';
		$result_set3 = mysql_query($query3,$this->connection);
		$conditions_array=array();
		while($row3=mysql_fetch_object($result_set3)){
			array_push($conditions_array,$this->getConditionById($row3->condition_id));
		}
		$row['conditions']=$conditions_array;
		
		return $row;
	}
	
	public function save_phrase_info($params){
		$date_time = gmdate("Y-m-d H:i:s");
		$query = 'UPDATE dialog_phrases SET text="'.$params['dialog_text'].'",subject="'.$params['subject'].'",priority="'.$params['priority'].'", last_modified_date="'.$date_time.'", last_modified_by="'.$params['user'].'" WHERE id="'.$params['id'].'"';  
		$result_set = mysql_query($query,$this->connection);
		//return mysql_error();
		//return $query;
		
		$query3 = 'DELETE FROM functions_to_phrases WHERE phrase_id ="'.$params['id'].'"';
		mysql_query($query3,$this->connection);
		foreach ($params['f_ids'] as $func_id){
			$query3 = 'INSERT INTO functions_to_phrases (`phrase_id`, `function_id`) VALUES ("'.$params['id'].'","'.$func_id.'")';
			$result_set3 = mysql_query($query3,$this->connection);
		}
		
		
		$query3 = 'DELETE FROM conditions_to_phrases WHERE phrase_id ="'.$params['id'].'"';
		mysql_query($query3,$this->connection);
		foreach ($params['c_ids'] as $cond_id){
			$query3 = 'INSERT INTO conditions_to_phrases (`phrase_id`, `condition_id`) VALUES ("'.$params['id'].'","'.$cond_id.'")';
			$result_set3 = mysql_query($query3,$this->connection);
		}
		
		
		
		
		
		/*$query2 = 'DELETE FROM dialog_phrase_function_params WHERE phrase_id ="'.$params['id'].'"';
		$result_set2 = mysql_query($query2,$this->connection);
		foreach ($params[5] as $f_key => $func){
				$query3 = 'INSERT INTO dialog_phrase_function_params (`phrase_id`, `function_id`, `param_id`, `param_value`) VALUES ("'.$params['id'].'","'.$func[0].'","'.$func[3].'","'.$func[5].'")';
				$result_set3 = mysql_query($query3,$this->connection);
		}
		$query3 = 'DELETE FROM dialog_phrase_condition_params WHERE phrase_id ="'.$params['id'].'"';
		$result_set3 = mysql_query($query2,$this->connection);
		foreach ($params[6] as $f_key => $cond){
				$query3 = 'INSERT INTO dialog_phrase_condition_params (`phrase_id`, `condition_id`, `param_id`, `param_value`) VALUES ("'.$params['id'].'","'.$cond[0].'","'.$cond[3].'","'.$cond[5].'")';
				$result_set3 = mysql_query($query3,$this->connection);
		}	*/	
		return mysql_error();
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
		$f_array=array();
		if($result_set){
			if(mysql_num_rows($result_set)>0){
				while($row=mysql_fetch_array($result_set)){
					$temp_array=array();
					$temp_array['f_id']=$row['id'];
					$temp_array['f_name']=$row['name'];
					$temp_array['f_type']=$row['type'];
					$query2 = 'SELECT * FROM  dialog_functions_params WHERE function_id ="'.$row['id'].'"';
					$result_set2 = mysql_query($query2,$this->connection);
					$p_array=array();
					while($row2=mysql_fetch_array($result_set2)){
						$temp_array2=array();
						$temp_array2['p_id']=$row2['id'];
						$temp_array2['p_name']=$row2['name'];
						$p_array[]=$temp_array2;
					}
					$temp_array['params']=$p_array;
					$f_array[]=$temp_array;
				}
			}
		}
		$main[]=$f_array;
		$query = 'SELECT * FROM  dialog_phrase_function_params WHERE phrase_id ="'.$id.'"';
		$result_set = mysql_query($query,$this->connection);
		$f_array=array();
		if($result_set){
			if(mysql_num_rows($result_set)>0){
				$num=-1;
				while($row=mysql_fetch_array($result_set)){
					$num++;
					$temp_array=array();
					$query2 = 'SELECT * FROM  dialog_functions WHERE id ="'.$row['function_id'].'"';
					$result_set2 = mysql_query($query2,$this->connection);
					$row2 = mysql_fetch_assoc($result_set2);
					$query3 = 'SELECT * FROM  dialog_functions_params WHERE id ="'.$row['param_id'].'"';
					$result_set3 = mysql_query($query3,$this->connection);
					$row3 = mysql_fetch_assoc($result_set3);
					$temp_array['f_id']=$row['function_id'];
					$temp_array['f_name']=$row2['name'];
					$temp_array['f_info_name']=$row2['name']." (".$row3['name'].")";
					$temp_array['f_type']=$row2['type'];
					$temp_array['p_id']=$row['param_id'];
					$temp_array['p_name']=$row3['name'];
					$temp_array['p_value']=$row['param_value'];
					$f_array[]=$temp_array;
				}
			}
		}
		$main[]=$f_array;
		return $main;
	}
	
	public function get_all_conditions_info($id){
		$main=array();	
		$query = 'SELECT * FROM  dialog_conditions ORDER BY name';
		$result_set = mysql_query($query,$this->connection);
		$c_array=array();
		if($result_set){
			if(mysql_num_rows($result_set)>0){
				while($row=mysql_fetch_array($result_set)){
					$temp_array=array();
					$temp_array['c_id']=$row['id'];
					$temp_array['c_name']=$row['name'];
					$temp_array['c_type']=$row['type'];
					$query2 = 'SELECT * FROM  dialog_conditions_params WHERE condition_id ="'.$row['id'].'"';
					$result_set2 = mysql_query($query2,$this->connection);
					$p_array=array();
					while($row2=mysql_fetch_array($result_set2)){
						$temp_array2=array();
						$temp_array2['p_id']=$row2['id'];
						$temp_array2['p_name']=$row2['name'];
						$p_array[]=$temp_array2;
					}
					$temp_array['params']=$p_array;
					$c_array[]=$temp_array;
				}
			}
		}
		$main[]=$c_array;
		$query = 'SELECT * FROM  dialog_phrase_condition_params WHERE phrase_id ="'.$id.'"';
		$result_set = mysql_query($query,$this->connection);
		$c_array=array();
		if($result_set){
			if(mysql_num_rows($result_set)>0){
				$num=-1;
				while($row=mysql_fetch_array($result_set)){
					$num++;
					$temp_array=array();
					$query2 = 'SELECT * FROM  dialog_conditions WHERE id ="'.$row['condition_id'].'"';
					$result_set2 = mysql_query($query2,$this->connection);
					$row2 = mysql_fetch_assoc($result_set2);
					$query3 = 'SELECT * FROM  dialog_conditions_params WHERE id ="'.$row['param_id'].'"';
					$result_set3 = mysql_query($query3,$this->connection);
					$row3 = mysql_fetch_assoc($result_set3);
					$temp_array['c_id']=$row['cunction_id'];
					$temp_array['c_name']=$row2['name'];
					$temp_array['c_info_name']=$row2['name']." (".$row3['name'].")";
					$temp_array['c_type']=$row2['type'];
					$temp_array['p_id']=$row['param_id'];
					$temp_array['p_name']=$row3['name'];
					$temp_array['p_value']=$row['param_value'];
					$c_array[]=$temp_array;
				}
			}
		}
		$main[]=$c_array;
		
		return $main;
	}
	
	function get_phrase_functions($id){
		$query2 = 'SELECT * FROM  functions_to_phrases WHERE phrase_id ="'.$id.'"';
		$result_set2 = mysql_query($query2,$this->connection);
		$functions_array=array();
		while($row2=mysql_fetch_object($result_set2)){
			array_push($functions_array,$this->getFunctionById($row2->function_id));
		}
		return $functions_array;
	}
	
	function get_phrase_conditions($id){
		$query3 = 'SELECT * FROM  conditions_to_phrases WHERE phrase_id ="'.$id.'"';
		$result_set3 = mysql_query($query3,$this->connection);
		$conditions_array=array();
		while($row3=mysql_fetch_object($result_set3)){
			array_push($conditions_array,$this->getConditionById($row3->condition_id));
		}
		return $conditions_array;
	}
	
	function getConditionById($conditionId) {
		$condition_rs = mysql_query("SELECT * FROM conditions WHERE id=".$conditionId.";",$this->connection);
		$condition = mysql_fetch_object($condition_rs);
		$param_rs = mysql_query("SELECT * FROM condition_params WHERE condition_id=".$conditionId.";",$this->connection);
		$params = array();
		while($param = mysql_fetch_object($param_rs))
			array_push($params, $param);
		$condition->params = $params;
		return $condition;
	}
	
	function getFunctionById($functionId) {
		$function_rs = mysql_query("SELECT * FROM functions WHERE id=".$functionId.";",$this->connection);
		$function = mysql_fetch_object($function_rs);
		$param_rs = mysql_query("SELECT * FROM function_params WHERE function_id=".$functionId.";",$this->connection);
		$params = array();
		while($param = mysql_fetch_object($param_rs))
			array_push($params, $param);
		$function->params = $params;
		return $function;
	}
	
}

?>