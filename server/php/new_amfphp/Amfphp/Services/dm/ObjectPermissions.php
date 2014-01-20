<?php

/**
 * Base class for loot operations
 * Loot
 */
class ObjectPermissions {

    function __construct() { //Constructor
    }   

    function getObjectTypes() {
        $type_rs = mysql_query("SELECT * FROM object_types;");
        $types = array();
        while ($type = mysql_fetch_object($type_rs))
            $types[] = $type;
        return $types;
    }

    function getObjectModerators($objectId, $objectType) {
        $user_rs = mysql_query("SELECT id, username FROM users WHERE id IN (SELECT moderator_id FROM object_permissions WHERE object_id=".$objectId." AND object_type='".$objectType."');");
        $users = array();
        while ($user = mysql_fetch_object($user_rs))
            $users[] = $user;
        return $users;
    }

    function addModeratorToObject($userId, $objectType, $objectId) {
        return mysql_query("INSERT INTO object_permissions (object_type, object_id, moderator_id) VALUES ('".$objectType."', ".$objectId.", ".$userId.");");
    }

    function removeModeratorFromObject($userId, $objectType, $objectId) {
        return mysql_query("DELETE FROM object_permissions WHERE object_type='".$objectType."' AND object_id=".$objectId." AND moderator_id=".$userId.";");
    }

}

?>