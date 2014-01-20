<?php

class DBQueries{

    function __construct() { //Constructor
	}
	
	public function getUserById($id=""){
		$row_temp->id=$id;
		$row_temp->username="";
		$row_temp->password="";
		$row_temp->isadmin="";
		if($id==""){
			return $row_temp;
		}
		$query = 'SELECT * FROM  users WHERE id ="'.$id.'"'; 
		$result_set = mysql_query($query);
		if($result_set){
			if(mysql_num_rows($result_set)>0){
				$row=mysql_fetch_object($result_set);
				return $row;
			}
		}else{
			return $row_temp;
		}
	}
	
	public function getDialogEditors($dialog_id){
		$dialog_ids_string="";
		$query = 'SELECT * FROM  dialogs_editors WHERE dialog_id ="'.$dialog_id.'"';
		$result_set = mysql_query($query);
		$num=0;
		while($row=mysql_fetch_object($result_set)){
			$num++;
			if($num>1){
				$dialog_ids_string.=",";
			}
			$dialog_ids_string.=$row->editor_id;
		}
		return $dialog_ids_string;
	}
	
	public function readAllDialogs($params=""){
		$query = 'SELECT a.id,a.name,a.created_date,a.created_by,a.last_modified_date,a.last_modified_by,a.topic,a.x_y,b.username as created_by_username,b.isadmin as created_by_is_admin,c.username as last_modified_by_username,c.isadmin as last_modified_by_is_admin FROM  dialog_dialogs as a'; 
		$query .= ' LEFT JOIN users as b';
		$query .= ' ON a.created_by = b.id';
		$query .= ' LEFT JOIN users as c';
		$query .= ' ON a.last_modified_by = c.id';
		$query .= ' WHERE a.id !="-1"'; 
		if($params['name']!=""){
			$query .= ' AND a.name LIKE "%'.$params['name'].'%"';
		}
		if($params['created_by']!=""){
			$query .= ' AND b.username LIKE "%'.$params['created_by'].'%"';
		}
		if($params['topic']!=""){
			$query .= ' AND a.topic LIKE "%'.$params['topic'].'%"';
		}
		$query .= ' ORDER BY a.name ASC';
		$result_set = mysql_query($query);
		if($result_set){
			$rows=array();
			if(mysql_num_rows($result_set)>0){
				while($row=mysql_fetch_object($result_set)){
					$query2 = 'SELECT id FROM dialog_phrases WHERE dialog_id ="'.$row->id.'"';
					$result_set2 = mysql_query($query2);
					$num_rows = mysql_num_rows($result_set2);
					$row->count=$num_rows;
					$row->editors_ids=$this->getDialogEditors($row->id);
					$rows[]=$row;
				}
				return $rows;
			}
		}else{
			return false;
		}
	}
	
	public function readDialog($id){
		$rows=array();
		$query1 = 'SELECT * FROM  dialog_dialogs WHERE id ="'.$id.'"';
		$result_set1 = mysql_query($query1);
		$row1 =  mysql_fetch_object($result_set1);
		$row1->type="dialog";
		$row1->editors_ids=$this->getDialogEditors($row1->id);
		$row1->created_by=$this->getUserById($row1->created_by);
		$row1->last_modified_by=$this->getUserById($row1->last_modified_by);
		$query2 = 'SELECT id FROM dialog_phrases WHERE dialog_id ="'.$row1->id.'"';
		$result_set2 = mysql_query($query2);
		$num_rows = mysql_num_rows($result_set2);
		$row1->dialog_id=$row1->id;
		if($row1->x_y==""){
			$row1->x_y="0_0";
		}
		if($num_rows){
			$row1->haschilds=true;
		}else{
			$row1->haschilds=false;
		}
		$row1->subject="main";
		$row1->childsnum=$num_rows;
		$rows[]=$row1;
		$query3 = 'SELECT * FROM  dialog_phrases WHERE dialog_id ="'.$id.'" ORDER BY id';
		$result_set3 = mysql_query($query3);
			while($row3=mysql_fetch_object($result_set3)){
				$row3->type="node";
				$row3->created_by=$this->getUserById($row3->created_by);
				$row3->last_modified_by=$this->getUserById($row3->last_modified_by);
				$query4 = 'SELECT id FROM dialog_phrases WHERE parent_id ="'.$row3->id.'"';
				$result_set4 = mysql_query($query4);
				$num_rows2 = mysql_num_rows($result_set4);
				if($row3->x_y==""){
					$row3->x_y="0_0";
				}
				if($num_rows2){
					$row3->haschilds=true;
				}else{
					$row3->haschilds=false;
				}
				$row3->childsnum=$num_rows;
				$row3->functions=$this->get_phrase_functions($row3->id);
				$row3->conditions=$this->get_phrase_conditions($row3->id);
				$rows[]=$row3;
			}
		return $rows;
	}
	
	function get_phrase_functions($id){
		$query2 = 'SELECT * FROM  functions_to_phrases WHERE phrase_id ="'.$id.'"';
		$result_set2 = mysql_query($query2);
		$functions_array=array();
		while($row2=mysql_fetch_object($result_set2)){
			array_push($functions_array,$this->getFunctionById($row2->function_id));
		}
		return $functions_array;
	}
	
	function get_phrase_conditions($id){
		$query3 = 'SELECT * FROM  conditions_to_phrases WHERE phrase_id ="'.$id.'"';
		$result_set3 = mysql_query($query3);
		$conditions_array=array();
		while($row3=mysql_fetch_object($result_set3)){
			array_push($conditions_array,$this->getConditionById($row3->condition_id));
		}
		return $conditions_array;
	}
	
	function getConditionById($conditionId) {
		$condition_rs = mysql_query("SELECT * FROM conditions WHERE id=".$conditionId.";");
		$condition = mysql_fetch_object($condition_rs);
		$param_rs = mysql_query("SELECT * FROM condition_params WHERE condition_id=".$conditionId.";");
		$params = array();
		while($param = mysql_fetch_object($param_rs))
			array_push($params, $param);
		$condition->params = $params;
		return $condition;
	}
	
	function getFunctionById($functionId) {
		$function_rs = mysql_query("SELECT * FROM functions WHERE id=".$functionId.";");
		$function = mysql_fetch_object($function_rs);
		$param_rs = mysql_query("SELECT * FROM function_params WHERE function_id=".$functionId.";");
		$params = array();
		while($param = mysql_fetch_object($param_rs))
			array_push($params, $param);
		$function->params = $params;
		return $function;
	}
	
	
	public function updateNodePosition($params){
		$xy=$params['x']."_".$params['y'];
		if($params['is_main']==true){
			$query = 'UPDATE dialog_dialogs SET x_y="'.$xy.'" WHERE id="'.$params['id'].'"';  
		}else{
			$query = 'UPDATE dialog_phrases SET x_y="'.$xy.'" WHERE id="'.$params['id'].'"';  
		}
		$result_set = mysql_query($query);
		return true;
	}
	
	public function addNodeToDatabase($params){
		$date_time = gmdate("Y-m-d H:i:s");
		$query = 'INSERT INTO dialog_phrases (dialog_id, parent_id, priority, subject, x_y, created_date, created_by, last_modified_date, last_modified_by) VALUES ("'.$params['dialog_id'].'","'.$params['parent_id'].'","0","'.$params['subject'].'","'.$params['x_y'].'","'.$date_time.'","'.$params['author'].'","'.$date_time.'","'.$params['author'].'")';
		$result_set = mysql_query($query);
		return true;
	}
	
	public function deleteNodeFromDatabase($params){
		$id=$params['id']!="" ? $params['id'] : -1;
		if($params['type']=="node"){
			$ids=$this->getChildsIds($id,true);
		}elseif($params['type']=="dialog"){
			$query1 = 'DELETE FROM dialog_dialogs WHERE id = "'.$id.'"';
			$result_set1 = mysql_query($query1);
			$query2 = 'SELECT id FROM dialog_phrases WHERE parent_id=0 AND dialog_id ="'.$id.'"';
			$num=0;
			$result_set2 = mysql_query($query2);
			while($row2=mysql_fetch_object($result_set2)){
				$num++;
				if($num>1){
					$ids.=",";
				}
				$ids.=$this->getChildsIds($row2->id,true);
			}
			$query4 = 'DELETE FROM dialogs_editors WHERE dialog_id="'.$id.'"';
			$result_set4 = mysql_query($query4);
		}
		$query3 = 'DELETE FROM dialog_phrases WHERE id IN ('.$ids.')';
		$result_set3 = mysql_query($query3);
		return true;
	}
	
	public function getChildsIds($id,$first=false){
		if($first==false){
			$ids.=",".$id;
		}else{
			$ids.=$id;
		}
		$query = 'SELECT id FROM dialog_phrases WHERE parent_id ="'.$id.'"';
		$result_set = mysql_query($query);
		while($row=mysql_fetch_object($result_set)){
			$ids.=$this->getChildsIds($row->id);
		}
		return $ids;
	}
	
	public function getAllUsers(){
		$query = 'SELECT * FROM  users  ORDER BY username ASC'; 
		$result_set = mysql_query($query);
		if($result_set){
			$rows=array();
			while($row=mysql_fetch_object($result_set)){
				$rows[]=$row;
			}
			return $rows;
		}else{
			return false;
		}
	}
	
	public function updateDialogInfo($params){
		if($params['dialog_title']!=""){
			$date_time = gmdate("Y-m-d H:i:s");
			$query = 'UPDATE dialog_dialogs SET name="'.mysql_real_escape_string($params['dialog_title']).'", last_modified_date="'.$date_time.'", last_modified_by="'.$params['last_modified_by'].'", topic="'.mysql_real_escape_string($params['topic']).'" WHERE id="'.$params['dialog_id'].'"';  
			$result_set = mysql_query($query);
			$query2 = 'DELETE FROM dialogs_editors WHERE dialog_id="'.$params['dialog_id'].'"';
			$result_set2 = mysql_query($query2);
			if($params['editors']!=""){
				$query3 = 'INSERT INTO `dialogs_editors` (`dialog_id`, `editor_id`) VALUES ';
				$editors_ids_array = explode(",", $params['editors']);
				$num=0;
				foreach($editors_ids_array as $key => $val) {
					$num++;
					if($num>1){
						$query3.=",";
					}
					$query3.='("'.$params['dialog_id'].'","'.$val.'")';
				}
				$query3.=';';
			}
			$result_set3 = mysql_query($query3);
		}else{
			return false;
		}

		if($params['copy_from_id']!=-1 && $params['copy_from_id']!="" ){
			$this->copyDialogNodes($params['copy_from_id'],$params['dialog_id'],$params['last_modified_by']);
		}
		return true;
	}
		
	public function updatePhraseInfo($params){
		$date_time = gmdate("Y-m-d H:i:s");
		$query = 'UPDATE dialog_phrases SET text="'.mysql_real_escape_string($params['phrase']).'",subject="'.mysql_real_escape_string($params['subject']).'",priority="'.$params['priority'].'", last_modified_date="'.$date_time.'", last_modified_by="'.$params['last_modified_by'].'" WHERE id="'.$params['id'].'"';  
		$result_set = mysql_query($query);
		
		
		$query3 = 'DELETE FROM functions_to_phrases WHERE phrase_id ="'.$params['id'].'"';
		mysql_query($query3);
		foreach ($params['f_ids'] as $func_id){
			$query4 = 'INSERT INTO functions_to_phrases (`phrase_id`, `function_id`) VALUES ("'.$params['id'].'","'.$func_id.'")';
			$result_set4 = mysql_query($query4);
		}
		
		$query5 = 'DELETE FROM conditions_to_phrases WHERE phrase_id ="'.$params['id'].'"';
		mysql_query($query5);
		foreach ($params['c_ids'] as $cond_id){
			$query6 = 'INSERT INTO conditions_to_phrases (`phrase_id`, `condition_id`) VALUES ("'.$params['id'].'","'.$cond_id.'")';
			$result_set6 = mysql_query($query6);
		}
		
		return true;
	}

	public function copyDialogNodes($from_dialog_id,$to_dialog_id,$user_id){
		$query = 'SHOW TABLE STATUS LIKE "dialog_phrases"';	
		$result_set = mysql_query($query);
		$row = mysql_fetch_assoc($result_set);
		$next_inc_value = $row['Auto_increment'];  
		$date_time = gmdate("Y-m-d H:i:s");
		
		$query2 = 'SELECT * FROM  dialog_phrases WHERE dialog_id ="'.$from_dialog_id.'" ORDER BY id';
		$result_set2 = mysql_query($query2);
		$id_convert_array=array();
		$new_id=$next_inc_value-1;
		$query3 ='INSERT INTO `dialog_phrases` (`id`, `dialog_id`, `parent_id`, `priority`, `subject`, `x_y`, `text`, `created_date`, `created_by`, `last_modified_date`, `last_modified_by`) VALUES';
		while($row2=mysql_fetch_object($result_set2)){
			$new_id++;
			if($new_id>$next_inc_value){
				$query3 .=",";
			}
			if (isset($id_convert_array[$row2->parent_id]) && $row2->parent_id !=0) {
				$new_parent_id=$id_convert_array[$row2->parent_id];
			}else{
				$new_parent_id=0;
			}
			
			
			$query3 .="\n(".$new_id.", ".$to_dialog_id.", ".$new_parent_id.", ".$row2->priority.", '".$row2->subject."', '".$row2->x_y."', '".mysql_real_escape_string($row2->text)."', '".$date_time."', '".$user_id."', '".$date_time."', '".$user_id."')";
			$id_convert_array[$row2->id]=$new_id;
		}
		$query3 .=";";
		$result_set3 = mysql_query($query3);
		return true;	
	}
	
	public function addDialog($params){
		$query = 'SELECT id FROM dialog_dialogs WHERE name ="'.$params['name'].'"';
		$result_set = mysql_query($query);
		$num_rows = mysql_num_rows($result_set);
		if(strlen($params['name'])<3 || $num_rows >0 ){
			return false;
		}else{
			$date_time = gmdate("Y-m-d H:i:s");
			$query = "INSERT INTO `dialog_dialogs`(`name`, `created_date`, `created_by`, `last_modified_date`, `last_modified_by`) VALUES ('".mysql_real_escape_string($params['name'])."','".$date_time."','".$params['created_by']."','".$date_time."','".$params['last_modified_by']."')";
			$result_set = mysql_query($query);
			return true;
		}
	}
	
}

?>