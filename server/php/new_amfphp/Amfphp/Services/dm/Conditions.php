<?php

/**
 * Base class for users operations
 * Users
 */
class Conditions {
	
	/**
	 *	PDO connection
	 * @var type PDO
	 */
	private $con;
	
    function __construct() { //Constructor
		$this->con = PDOConnection::con( basename(__DIR__) );
    }

    function checkCondition($condition) {
        $condition = ObjectUtil::objectToArray($condition);
        $label = $condition['label'];
        $params = $condition['params'];
        if (method_exists($this, $label)) {
            return $this->$label($params);
        } else {
            return null;
        }
    }

    function getAllConditionLabels() {
        $condition_rs = mysql_query("SELECT * FROM condition_labels;");
        $conditions = array();
        while ($condition = mysql_fetch_object($condition_rs)) {
            $param_rs = mysql_query("SELECT * FROM condition_param_labels WHERE condition_id=$condition->id;");
            $params = array();
            while ($param = mysql_fetch_object($param_rs))
                array_push($params, $param);
            $condition->params = $params;
            unset($condition->id);
            array_push($conditions, $condition);
        }
        return $conditions;
    }

    function saveCondition($condition) {
        if (!isset($condition->id)) {
            mysql_query("INSERT INTO conditions (label) VALUES ('$condition->label');");
            $conditionId = mysql_insert_id();
        } else {
            $conditionId = $condition->id;
            mysql_query("DELETE FROM condition_params WHERE condition_id=$conditionId;");
        }
        foreach ($condition->params as $param)
            mysql_query("INSERT INTO condition_params (condition_id, label, value) VALUES ($conditionId, '$param->label', '$param->value');");
        return $this->getConditionById($conditionId);
    }

    function getConditionById($conditionId) {
        $condition_rs = mysql_query("SELECT * FROM conditions WHERE id=$conditionId;");
        $condition = mysql_fetch_object($condition_rs);
        $param_rs = mysql_query("SELECT * FROM condition_params WHERE condition_id=$conditionId;");
        $params = array();
        while ($param = mysql_fetch_object($param_rs))
            array_push($params, $param);
        $condition->params = $params;
        return $condition;
    }

    /* CONDITION LIST */

    function getParamValueByLabel($params, $label) {
        $params = ObjectUtil::objectToArray($params);
        foreach ($params as $param) {
            if ($param['label'] == $label) {
                return $param['value'];
            }
        }
        return null;
    }

    function avatarRoleIs($params) {
        $avatarId = $this->getParamValueByLabel($params, 'avatarId');
        $roleId = $this->getParamValueByLabel($params, 'roleId');

        $avatar_rs = mysql_query("SELECT * FROM avatars WHERE id=$avatarId AND role_id=$roleId;");
        return (mysql_num_rows($avatar_rs) > 0);
    }

    function hasVar($params) {
        $avatarId = $this->getParamValueByLabel($params, 'avatarId');
        $label = $this->getParamValueByLabel($params, 'label');

        $var_rs = mysql_query("SELECT * FROM avatar_vars WHERE avatar_id=$avatarId AND label='$label';");
        return (mysql_num_rows($var_rs) > 0);
    }

    function noVar($params) {
        $avatarId = $this->getParamValueByLabel($params, 'avatarId');
        $label = $this->getParamValueByLabel($params, 'label');

        $var_rs = mysql_query("SELECT * FROM avatar_vars WHERE avatar_id=$avatarId AND label='$label';");
        if (!$var_rs) {
            return true;
        } else if (mysql_num_rows($var_rs) == 0) {
            return true;
        } else {
            return false;
        }
    }

    function varIs($params) {
        $avatarId = $this->getParamValueByLabel($params, 'avatarId');
        $label = $this->getParamValueByLabel($params, 'label');
        $value = $this->getParamValueByLabel($params, 'value');

        $var_rs = mysql_query("SELECT * FROM avatar_vars WHERE avatar_id=$avatarId AND label='$label';");
        if ($var_rs) {
            $var = mysql_fetch_object($var_rs);
            return $var->value == $value;
        } else {
            return false;
        }
    }

    function varMore($params) {
        $avatarId = $this->getParamValueByLabel($params, 'avatarId');
        $label = $this->getParamValueByLabel($params, 'label');
        $value = $this->getParamValueByLabel($params, 'value');

        $var_rs = mysql_query("SELECT * FROM avatar_vars WHERE avatar_id=$avatarId AND label='$label';");
        $var = mysql_fetch_object($var_rs);
        return (int) $var->value > (int) $value;
    }

    function varLess($params) {
        $avatarId = $this->getParamValueByLabel($params, 'avatarId');
        $label = $this->getParamValueByLabel($params, 'label');
        $value = $this->getParamValueByLabel($params, 'value');

        $var_rs = mysql_query("SELECT * FROM avatar_vars WHERE avatar_id=$avatarId AND label='$label';");
        if ($var_rs) {
            $var = mysql_fetch_object($var_rs);
            return (int) $var->value < (int) $value;
        } else {
            throw new Exception("varLess: Couldn\'t compare avatar $avatarId var $label with value $value");
        }
    }

    function hasItem($params) {
        $avatarId = $this->getParamValueByLabel($params, 'avatarId');
        $itemId = $this->getParamValueByLabel($params, 'itemId');

        $item_rs = mysql_query("SELECT * FROM items_to_avatars WHERE avatar_id=$avatarId AND item_id=$itemId;");
        return (mysql_num_rows($item_rs) > 0);
    }

    function noItem($params) {
        $avatarId = $this->getParamValueByLabel($params, 'avatarId');
        $itemId = $this->getParamValueByLabel($params, 'itemId');

        $item_rs = mysql_query("SELECT * FROM items_to_avatars WHERE avatar_id=$avatarId AND item_id=$itemId;");
        if ($item_rs) {
            return (mysql_num_rows($item_rs) == 0);
        } else {
            return true;
        }
    }
	
}

?>