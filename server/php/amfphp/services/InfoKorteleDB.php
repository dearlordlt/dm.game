<?php
class InfoKorteleDB {

	function getAll () {
	$con = mysql_connect("localHost","root","");
	if (!$con) {
		die('Could not connect: ' . mysql_error());
	}
	
	mysql_select_db("infokortele", $con);
	
	$result = mysql_query("SELECT * FROM info");
	
	while ($row = mysql_fetch_array($result)) {
		//echo $row;
		$arrayResult[] = $row; 
	}
	
	mysql_close($con);
	
	return $arrayResult;
	}
	
	function getSmthg ($TPavadinimas) {
	$con = mysql_connect("localHost","root","");
	if (!$con) {
		die('Could not connect: ' . mysql_error());
	}
	
	mysql_select_db("infokortele", $con);
	
	$result = mysql_query("SELECT * FROM `info` AS i LEFT JOIN `paveiksleliai` AS p ON i.TPavadinimas = p.SRCID WHERE i.TPavadinimas = '" . $TPavadinimas ."'");

	while ($row = mysql_fetch_array($result)) {
		//echo $row;
		$arrayResult[] = $row; 
	}
	
	mysql_close($con);
	
	return $arrayResult;
	}	
	
	function getStraipsniai ($TPavadinimas) {
	$con = mysql_connect("localHost","root","");
	if (!$con) {
		die('Could not connect: ' . mysql_error());
	}
	
	mysql_select_db("infokortele", $con);
	
	$result = mysql_query("SELECT p.Pavadinimas, p.Priority, p.Straipsnis, p.Autorius, p.SRCID FROM `straipsniai` AS p, `info`  AS i WHERE i.TPavadinimas = '" . $TPavadinimas ."' AND i.ID = p.SRCID ORDER BY p.Priority");

	while ($row = mysql_fetch_array($result)) {
		//echo $row;
		$arrayResult[] = $row; 
	}
	
	mysql_close($con);
	
	return $arrayResult;
	}	
	
	function updatetAplankyta ($TPavadinimas, $Atvertas) {
	$con = mysql_connect("localHost","root","");
	if (!$con) {
		die('Could not connect: ' . mysql_error());
	}
	
	mysql_select_db("infokortele", $con);
	$Atvertas++;
	
	$result = mysql_query("UPDATE `info` SET `Atvertas`='". $Atvertas ."' WHERE TPavadinimas = '" . $TPavadinimas ."'");

	mysql_close($con);
	
	return 1;

	}	
	
	function updateInfo ($data) {
	$con = mysql_connect("localHost","root","");
	if (!$con) {
		die('Could not connect: ' . mysql_error());
	}
	
	mysql_select_db("infokortele", $con);
	
	$query = "UPDATE `info` SET `Pavadinimas`='". $data['Pavadinimas'] ."', `TPavadinimas`='". $data['TPavadinimas'] ."', `KurimoData`='". $data['KurimoData'] ."', `Aprasymas`='" . $data['Aprasymas'] ."', `RodytiPaveiksliukus`=" . $data['RodytiPaveiksliukus'] .", `RodytiAtvertas`=". $data['RodytiAtvertas'] ." WHERE `TPavadinimas` = '" . $data['TPavadinimas'] ."'";
	$result = mysql_query($query);

	mysql_close($con);
	
	return $query;

	}	
	
	function insertInfo ($data) {
	$con = mysql_connect("localHost","root","");
	if (!$con) {
		die('Could not connect: ' . mysql_error());
	}
	
	mysql_select_db("infokortele", $con);
	
	$query = "INSERT INTO `info`(`TPavadinimas`, `KurimoData`, `Pavadinimas`, `Aprasymas`, `Atvertas`, `RodytiAtvertas`, `LeistiRedaguoti`, `RodytiPaveiksliukus`, `info`, `straipsniai`, `video`, `audio`, `nuotraukos`, `testai`, `kita`) VALUES ('" . $data['TPavadinimas'] . "','" . $data['KurimoData'] . "','" . $data['Pavadinimas'] . "','" . $data['Aprasymas'] . "', 0, " . $data['RodytiAtvertas'] . "," . $data['LeistiRedaguoti'] . "," . $data['RodytiPaveiksliukus'] . ",1,0,0,0,0,0,0)";
	$result = mysql_query($query);
	
	//fwrite($result . " " . $query, "blaLog.txt", 100);
	//mail("kebabas@gmail.com", "error log", $result . " " . $query);
	
	mysql_close($con);
	
	return $result . " " . $query ;

	}		

	function getnuorodos ($idas) {
	$con = mysql_connect("localHost","root","");
	if (!$con) {
		die('Could not connect: ' . mysql_error());
	}
	
	mysql_select_db("infokortele", $con);
	
	$result = mysql_query("SELECT * FROM `nuorodos` WHERE `SRCID` = '" . $idas . "'");

	while ($row = mysql_fetch_array($result)) {
		//echo $row;
		$arrayResult[] = $row; 
	}
	
	mysql_close($con);
	
	return $arrayResult;
	}
	
	function updateStraipsnis ($data) {
	$con = mysql_connect("localHost","root","");
	if (!$con) {
		die('Could not connect: ' . mysql_error());
	}
	
	mysql_select_db("infokortele", $con);
	
	$query = "UPDATE `straipsniai` SET `Pavadinimas`='". $data['Pavadinimas'] ."', `Straipsnis`='" . $data['Straipsnis'] ."', `Autorius`='" . $data['Autorius'] ."' WHERE `SRCID` = " . $data['SRCID'] ." AND  `Priority` = " . $data['Priority'];
	$result = mysql_query($query);

	mysql_close($con);
	
	return $query;

	}		
	
	function insertStraipsnis ($data) {
	$con = mysql_connect("localHost","root","");
	if (!$con) {
		die('Could not connect: ' . mysql_error());
	}
	
	mysql_select_db("infokortele", $con);
	//not finished
	$query = "INSERT INTO `straipsniai`(`SRCID`, `Pavadinimas`, `Straipsnis`, `Autorius`, `Priority`) VALUES ('" . $data['SRCID'] . "','" . $data['Pavadinimas'] . "','" . $data['Straipsnis'] . "','" . $data['Autorius'] . "', " . $data['Priority'] .")";
	$result = mysql_query($query);
	
	//fwrite($result . " " . $query, "blaLog.txt", 100);
	//mail("kebabas@gmail.com", "error log", $result . " " . $query);
	
	mysql_close($con);
	
	return $result . " " . $query ;

	}	
	
	function updateNuorodos ($nuorodos) {
	$con = mysql_connect("localHost","root","");
	if (!$con) {
		die('Could not connect: ' . mysql_error());
	}
	
	mysql_select_db("infokortele", $con);
	for ($i = 0; $i < count($nuorodos); $i++){
		if ($nuorodos[$i]["action"] == "add") {
			$query = "INSERT INTO `nuorodos`(`SRCID`, `nuoroda`) VALUES ('" . $nuorodos[$i]['SRCID'] . "','" . $nuorodos[$i]['nuoroda'] . "')";
			$result = mysql_query($query);
		}
		else if ($nuorodos[$i]["action"] == "remove") {
			$query = "DELETE FROM `infokortele`.`nuorodos` WHERE `nuorodos`.`SRCID` = '" . $nuorodos[$i]['SRCID'] . "' AND `nuorodos`.`nuoroda` = '" . $nuorodos[$i]['nuoroda'] . "' LIMIT 1";
			$result = mysql_query($query);
		}		
	}
	
	mysql_close($con);
	
	return 1 ;
		
	}
	
	function updateStrPriority($name, $where, $which) {
	$con = mysql_connect("localHost","root","");
	if (!$con) {
		die('Could not connect: ' . mysql_error());
	}
	
	mysql_select_db("infokortele", $con);		
	
	if ($where == 'hell') {
		$query = "UPDATE `straipsniai` SET Priority = -1 WHERE `SRCID` = " . $name ." AND `Priority` = " . $which;
		$result = mysql_query($query);
		$query = "UPDATE `straipsniai` SET Priority = ". $which ." WHERE `SRCID` = " . $name ." AND `Priority` = " . ($which + 1);
		$result = mysql_query($query);
		$query = "UPDATE `straipsniai` SET Priority = ". ($which + 1) ." WHERE `SRCID` = " . $name ." AND `Priority` = -1";
		$result = mysql_query($query);				
	}
	if ($where == 'heaven') {
		$query = "UPDATE `straipsniai` SET Priority = -1 WHERE `SRCID` = " . $name ." AND `Priority` = " . $which;
		$result = mysql_query($query);
		$query = "UPDATE `straipsniai` SET Priority = ". $which ." WHERE `SRCID` = " . $name ." AND `Priority` = " . ($which - 1);
		$result = mysql_query($query);
		$query = "UPDATE `straipsniai` SET Priority = ". ($which - 1) ." WHERE `SRCID` = " . $name ." AND `Priority` = -1";
		$result = mysql_query($query);
	}
	
	mysql_close($con);
	
	return 1 ;	
	}

	function getVideo ($TPavadinimas) {
	$con = mysql_connect("localHost","root","");
	if (!$con) {
		die('Could not connect: ' . mysql_error());
	}
	
	mysql_select_db("infokortele", $con);
	
	$result = mysql_query("SELECT v.SRCID, v.Aprasymas, v.link, v.Priority, v.Autorius, v.Pavadinimas FROM `video` AS v, `info` WHERE `info`.TPavadinimas = '" . $TPavadinimas ."' AND `info`.ID = v.SRCID ORDER BY v.Priority");

	while ($row = mysql_fetch_array($result)) {
		//echo $row;
		$arrayResult[] = $row; 
	}
	
	mysql_close($con);
	
	return $arrayResult;
	}
		
	function updateStrPriorityV($name, $where, $which) {
	$con = mysql_connect("localHost","root","");
	if (!$con) {
		die('Could not connect: ' . mysql_error());
	}
	
	mysql_select_db("infokortele", $con);		
	
	if ($where == 'hell') {
		$query = "UPDATE `video` SET Priority = -1 WHERE `SRCID` = " . $name ." AND `Priority` = " . $which;
		$result = mysql_query($query);
		$query = "UPDATE `video` SET Priority = ". $which ." WHERE `SRCID` = " . $name ." AND `Priority` = " . ($which + 1);
		$result = mysql_query($query);
		$query = "UPDATE `video` SET Priority = ". ($which + 1) ." WHERE `SRCID` = " . $name ." AND `Priority` = -1";
		$result = mysql_query($query);				
	}
	if ($where == 'heaven') {
		$query = "UPDATE `video` SET Priority = -1 WHERE `SRCID` = " . $name ." AND `Priority` = " . $which;
		$result = mysql_query($query);
		$query = "UPDATE `video` SET Priority = ". $which ." WHERE `SRCID` = " . $name ." AND `Priority` = " . ($which - 1);
		$result = mysql_query($query);
		$query = "UPDATE `video` SET Priority = ". ($which - 1) ." WHERE `SRCID` = " . $name ." AND `Priority` = -1";
		$result = mysql_query($query);
	}
	
	mysql_close($con);
	
	return 1 ;	
	}
	
	function updatevideo ($data) {
	$con = mysql_connect("localHost","root","");
	if (!$con) {
		die('Could not connect: ' . mysql_error());
	}
	
	mysql_select_db("infokortele", $con);
	
	$query = "UPDATE `video` SET `Pavadinimas`='". $data['Pavadinimas'] ."', `Aprasymas`='" . $data['Aprasymas'] ."', `Autorius`='" . $data['Autorius'] ."', `link`='". $data['link'] ."' WHERE `SRCID` = " . $data['SRCID'] ." AND  `Priority` = " . $data['Priority'];
	$result = mysql_query($query);

	mysql_close($con);
	
	return $query;

	}		
	
	function insertvideo ($data) {
	$con = mysql_connect("localHost","root","");
	if (!$con) {
		die('Could not connect: ' . mysql_error());
	}
	
	mysql_select_db("infokortele", $con);
	//not finished
	$query = "INSERT INTO `video`(`SRCID`, `Pavadinimas`, `Aprasymas`, `Autorius`, `Priority`, `link`) VALUES ('" . $data['SRCID'] . "','" . $data['Pavadinimas'] . "','" . $data['Aprasymas'] . "','" . $data['Autorius'] . "', " . $data['Priority'] .", '". $data['link'] ."')";
	$result = mysql_query($query);
	
	//fwrite($result . " " . $query, "blaLog.txt", 100);
	//mail("kebabas@gmail.com", "error log", $result . " " . $query);
	
	mysql_close($con);
	
	return $result . " " . $query ;

	}
	
	function getaudio ($TPavadinimas) {
	$con = mysql_connect("localHost","root","");
	if (!$con) {
		die('Could not connect: ' . mysql_error());
	}
	
	mysql_select_db("infokortele", $con);
	
	$result = mysql_query("SELECT v.SRCID, v.Aprasymas, v.Audio, v.Priority, v.Pavadinimas FROM `audio` AS v, `info` WHERE `info`.TPavadinimas = '" . $TPavadinimas ."' AND `info`.ID = v.SRCID ORDER BY v.Priority");

	while ($row = mysql_fetch_array($result)) {
		//echo $row;
		$arrayResult[] = $row; 
	}
	
	mysql_close($con);
	
	return $arrayResult;
	}
		
	function updateStrPriorityA($name, $where, $which) {
	$con = mysql_connect("localHost","root","");
	if (!$con) {
		die('Could not connect: ' . mysql_error());
	}
	
	mysql_select_db("infokortele", $con);		
	
	if ($where == 'hell') {
		$query = "UPDATE `audio` SET Priority = -1 WHERE `SRCID` = " . $name ." AND `Priority` = " . $which;
		$result = mysql_query($query);
		$query = "UPDATE `audio` SET Priority = ". $which ." WHERE `SRCID` = " . $name ." AND `Priority` = " . ($which + 1);
		$result = mysql_query($query);
		$query = "UPDATE `audio` SET Priority = ". ($which + 1) ." WHERE `SRCID` = " . $name ." AND `Priority` = -1";
		$result = mysql_query($query);				
	}
	if ($where == 'heaven') {
		$query = "UPDATE `audio` SET Priority = -1 WHERE `SRCID` = " . $name ." AND `Priority` = " . $which;
		$result = mysql_query($query);
		$query = "UPDATE `audio` SET Priority = ". $which ." WHERE `SRCID` = " . $name ." AND `Priority` = " . ($which - 1);
		$result = mysql_query($query);
		$query = "UPDATE `audio` SET Priority = ". ($which - 1) ." WHERE `SRCID` = " . $name ." AND `Priority` = -1";
		$result = mysql_query($query);
	}
	
	mysql_close($con);
	
	return 1 ;	
	}
	
	function updateaudio ($data) {
	$con = mysql_connect("localHost","root","");
	if (!$con) {
		die('Could not connect: ' . mysql_error());
	}
	
	mysql_select_db("infokortele", $con);
	
	$query = "UPDATE `audio` SET `Pavadinimas`='". $data['Pavadinimas'] ."', `Aprasymas`='" . $data['Aprasymas'] ."', `Audio`='". $data['Audio'] ."' WHERE `SRCID` = " . $data['SRCID'] ." AND  `Priority` = " . $data['Priority'];
	$result = mysql_query($query);

	mysql_close($con);
	
	return $query;

	}		
	
	function insertaudio ($data) {
	$con = mysql_connect("localHost","root","");
	if (!$con) {
		die('Could not connect: ' . mysql_error());
	}
	
	mysql_select_db("infokortele", $con);
	//not finished
	$query = "INSERT INTO `audio`(`SRCID`, `Pavadinimas`, `Aprasymas`, `Priority`, `Audio`) VALUES ('" . $data['SRCID'] . "','" . $data['Pavadinimas'] . "','" . $data['Aprasymas'] . "', " . $data['Priority'] .", '". $data['Audio'] ."')";
	$result = mysql_query($query);
	
	//fwrite($result . " " . $query, "blaLog.txt", 100);
	//mail("kebabas@gmail.com", "error log", $result . " " . $query);
	
	mysql_close($con);
	
	return $result . " " . $query ;

	}		
	
	function getPaveiksliukai ($TPavadinimas) {
	$con = mysql_connect("localHost","root","");
	if (!$con) {
		die('Could not connect: ' . mysql_error());
	}
	
	mysql_select_db("infokortele", $con);
	
	$result = mysql_query("SELECT * FROM `Paveiksleliai` WHERE `Paveiksleliai`.SRCID = '" . $TPavadinimas  . "' ORDER BY `Priority`");

	while ($row = mysql_fetch_array($result)) {
		//echo $row;
		$arrayResult[] = $row; 
	}
	
	mysql_close($con);
	
	return $arrayResult;
	}
		
	function updatePaveiksliukai ($data) {
	$con = mysql_connect("localHost","root","");
	if (!$con) {
		die('Could not connect: ' . mysql_error());
	}
	
	mysql_select_db("infokortele", $con);
	
	$query = "UPDATE `Paveiksleliai` SET `Pavadinimas`='". $data['Pavadinimas'] ."', `Paveiksliukas`='". $data['Paveiksliukas'] ."' WHERE `SRCID` = '" . $data['SRCID'] ."' AND  `Priority` = " . $data['Priority'];
	$result = mysql_query($query);

	mysql_close($con);
	
	return $query;

	}		
	
	function insertPaveiksliukai ($data) {
	$con = mysql_connect("localHost","root","");
	if (!$con) {
		die('Could not connect: ' . mysql_error());
	}
	
	mysql_select_db("infokortele", $con);
	//not finished
	$query = "INSERT INTO `paveiksleliai`(`SRCID`, `Priority`, `Paveiksliukas`, `Pavadinimas`) VALUES ('" . $data['SRCID'] . "', '". $data['Priority'] ."', '". $data['Paveiksliukas'] ."', '". $data['Pavadinimas'] ."')";
	$result = mysql_query($query);
	
	//fwrite($result . " " . $query, "blaLog.txt", 100);
	//mail("kebabas@gmail.com", "error log", $result . " " . $query);
	
	mysql_close($con);
	
	return $result . " " . $query ;

	}				
}
?>