<?php
	include('DBConnection.php');
	
	$tmpname = $_FILES['Filedata']['tmp_name'];
	$filename = $_FILES['Filedata']['name'];
	
	$entry = $_GET['entry'];
	$label = $_GET['label'];
	$categoryId = $_GET['category'];
	
	if (move_uploaded_file($tmpname, "assets/user_content/".$filename)) {
		if ((Boolean) $_GET['entry']) {
			mysql_query("INSERT INTO skin3d_elements (label, skin3d_type, path, subtype) VALUES ('".$label."', 2, 'assets/user_content/".$filename."', '');");
			$elementId = mysql_insert_id();
			mysql_query("INSERT INTO skin3d (label, type, subtype, category_id) VALUES ('".$label."', 2, '', ".$categoryId.");");
			$skinId = mysql_insert_id();
			mysql_query("INSERT INTO skin3d_elements_to_skins (skin3d_id, element_id) VALUES (".$skinId.", ".$elementId.");");
			
		}
		echo "Win";
	} else {
		echo "Fail ";
		echo mysql_error();
	}
	
?>