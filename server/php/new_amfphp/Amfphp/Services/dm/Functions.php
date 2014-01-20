<?php
/**
 * Base class for users operations
 * Users
 */
class Functions
{	
    function __construct() { //Constructor
	}
	
	function getAllFunctionLabels() {
		$function_rs = mysql_query("SELECT * FROM function_labels;");
		$functions = array();
		while($function = mysql_fetch_object($function_rs)) {
			$param_rs = mysql_query("SELECT * FROM function_param_labels WHERE function_id=".$function->id.";");
			$params = array();
			while($param = mysql_fetch_object($param_rs))
				array_push($params, $param);
			$function->params = $params;
			unset($function->id);
			array_push($functions, $function);
		}
		return $functions;
	}
	
	function saveFunction($function) {		
		if (!isset($function->id) ) {
			mysql_query("INSERT INTO functions (label) VALUES ('".$function->label."');");
			$functionId = mysql_insert_id();
		} else {
			$functionId = $function->id;
			mysql_query("DELETE FROM function_params WHERE function_id=".$functionId.";");
		}
		foreach ($function->params as $param)
			mysql_query("INSERT INTO function_params (function_id, label, value) VALUES (".$functionId.", '".$param->label."', '".$param->value."');");
		return $this->getFunctionById($functionId);
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

}
?>