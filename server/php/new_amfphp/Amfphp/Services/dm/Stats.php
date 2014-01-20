<?php

class Stats {

    function __construct() { //Constructor
    }

    function reportTradeCheating($cheatedId, $cheaterId, $cheated) {
        mysql_query("INSERT INTO trade_cheat_log (cheated_id, cheater_id, cheated) VALUES ($cheatedId, $cheaterId, $cheated) ON DUPLICATE KEY UPDATE cheated=$cheated;");
    }

}

?>