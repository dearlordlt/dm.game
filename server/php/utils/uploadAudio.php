<?php
	include('DBConnection.php');
	
	$tmpname = $_FILES['Filedata']['tmp_name'];
	$filename = $_FILES['Filedata']['name'];
	
	$label = $_GET['label'];
	$distance = $_GET['distance'];
	$uploaderId = $_GET['userid'];
	
	if (move_uploaded_file($tmpname, "assets/audio/".$filename))
		mysql_query("INSERT INTO audio (label, path, distance, last_modified, last_modified_by) VALUES ('".$label."', 'assets/audio/".$filename."', ".$distance.", NOW(), ".$uploaderId.");");
   echo mysql_error();
   echo "sup";
	
?>