<?php

/**
 * Base class for loot operations
 * Loot
 */
class AltSkin {

    function __construct() { //Constructor
        include_once 'Conditions.php';
    }

    function getAllAltskins() {
        $altskin_rs = mysql_query("SELECT * FROM altskins;");
        $allAltskins = array();
        while ($altskin = mysql_fetch_object($altskin_rs)) {
            $allAltskins[] = $altskin;
        }
        return $allAltskins;
    }

    function getUserAltskins($userId) {
        $userId = mysql_real_escape_string($userId);

        $admin_rs = mysql_query("SELECT * FROM users WHERE id=".$userId." AND isadmin='Y';");
        if (mysql_num_rows($admin_rs) > 0)
            return $this->getAllAltskins();

        $altskin_rs = mysql_query("SELECT * FROM altskins WHERE id IN (SELECT object_id FROM object_permissions WHERE object_type='altskin' AND moderator_id=".$userId.");");
        $allAltskins = array();
        while ($altskin = mysql_fetch_object($altskin_rs)) {
            $allAltskins[] = $altskin;
        }
        return $allAltskins;
    }

    function getAltskinById($altskinId) {
        $conditionClass = new Conditions();

        $altskinId = mysql_real_escape_string($altskinId);

        $altskin_rs = mysql_query("SELECT * FROM altskins WHERE id=$altskinId;");
        $altskin = mysql_fetch_object($altskin_rs);

        $skin3d_rs = mysql_query("SELECT skin3d.id, altskins_skin3d_to_altskin.id AS skin3d_to_altskin_id, label, skin3d_id, is_default FROM altskins_skin3d_to_altskin LEFT JOIN skin3d ON skin3d_id = skin3d.id WHERE altskin_id=$altskinId;");
        while ($skin3d = mysql_fetch_object($skin3d_rs)) {
            $skin3dCondition_rs = mysql_query("SELECT condition_id FROM conditions_to_altskin_skins3d WHERE skin3d_to_altskin_id=$skin3d->skin3d_to_altskin_id;");

            while ($skin3dCondition = mysql_fetch_object($skin3dCondition_rs))
                $skin3d->conditions[] = $conditionClass->getConditionById($skin3dCondition->condition_id);

            $altskin->skins3d[] = $skin3d;
        }

        return $altskin;
    }

    function saveAltskin($altskin, $userId) {
        $conditionClass = new Conditions();

        $userId = mysql_real_escape_string($userId);
        $altskin->label = mysql_real_escape_string($altskin->label);
        $altskin->category_id = mysql_real_escape_string($altskin->category_id);

        if (!isset($altskin->id)) {
            mysql_query("INSERT INTO altskins (label, last_modified, last_modified_by, category_id) VALUES ('$altskin->label', NOW(), $userId, $altskin->category_id);");
            $altskinId = mysql_insert_id();
            mysql_query("INSERT INTO object_permissions (object_type, object_id, moderator_id) VALUES ('altskin', $altskinId, $userId);");
        } else {
            $altskinId = $altskin->id;
            mysql_query("UPDATE altskins SET label='$altskin->label', last_modified=NOW(), last_modified_by=$userId, category_id=$altskin->category_id WHERE id=$altskinId;");
            mysql_query("DELETE FROM altskins_skin3d_to_altskin WHERE altskin_id=$altskinId;");
        }

        foreach ($altskin->skins3d as $skin3d) {
            mysql_query("INSERT INTO altskins_skin3d_to_altskin (altskin_id, skin3d_id, is_default) VALUES ($altskinId, $skin3d->id, $skin3d->is_default);");
            $skin3dToAltskinId = mysql_insert_id();
            
            if (isset($skin3d->conditions))
                foreach ($skin3d->conditions as $condition) {
                    $conditionId = $conditionClass->saveCondition($condition)->id;
                    //return $conditionClass->saveCondition($condition);
                    mysql_query("INSERT INTO conditions_to_altskin_skins3d (skin3d_to_altskin_id, condition_id) VALUES ($skin3dToAltskinId, $conditionId);");
                }
        }
    }

}

?>