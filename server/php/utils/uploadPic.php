<?php
	include_once('DBConnection.php');
	include_once('ImageManipulator.php');
	
	if ( !empty($_FILES) ) {
	
		$validation_type = 1;

		if ($validation_type == 1) {
		
			$mime = array('image/gif' => 'gif',
						  'image/jpeg' => 'jpeg',
						  'image/png' => 'png' ); /* ,
						  'application/x-shockwave-flash' => 'swf',
						  'image/psd' => 'psd',
						  'image/bmp' => 'bmp',
						  'image/tiff' => 'tiff',
						  'image/tiff' => 'tiff',
						  'image/jp2' => 'jp2',
						  'image/iff' => 'iff',
						  'image/vnd.wap.wbmp' => 'bmp',
						  'image/xbm' => 'xbm',
						  'image/vnd.microsoft.icon' => 'ico'); */
		} else if($validation_type == 2) {
			$image_extensions_allowed = array('jpg', 'jpeg', 'png', 'gif' ); //  , 'bmp');
		}

		$upload_image_to_folder = './../dm_avatar_pics/';	
	
		$file = $_FILES['Filedata'];

		$file_name = $file['name'];

		$error = ''; // Empty

		// Get File Extension (if any)

		$ext = strtolower(substr(strrchr($file_name, "."), 1));

		// Check for a correct extension. The image file hasn't an extension? Add one
		
		if($validation_type == 1) {
			$file_info = getimagesize($_FILES['Filedata']['tmp_name']);

			if( empty( $file_info ) ) {
				$error .= "The uploaded file doesn't seem to be an image.";
			} else {
			
				$file_mime = $file_info['mime'];
			
				if( ( $ext == 'jpc' ) || ( $ext == 'jpx' ) || ( $ext == 'jb2') ) {
					$extension = $ext;
				} else {
					$extension = ($mime[$file_mime] == 'jpeg') ? 'jpg' : $mime[$file_mime];
				}
			
				if(!$extension) {
					$extension = '';  
					$file_name = str_replace('.', '', $file_name); 
				}
			}
		} else if($validation_type == 2) {
			if(!in_array($ext, $image_extensions_allowed)){
				$exts = implode(', ',$image_extensions_allowed);
				$error .= "You must upload a file with one of the following extensions: ".$exts;
			}
			
			$extension = $ext;
		}
		
		// No errors were found?
		if ( empty( $error ) ) {
		
			$new_file_name = str_replace( array (' ', '.'), '_', microtime() ).'.'.$extension;
			
			$manipulator = new ImageManipulator($file['tmp_name']);
			$manipulator->resample( 146, 146 );
			
			try {
				$manipulator->save( $upload_image_to_folder.$new_file_name );
				$move_file = true;
			} catch ( Exception $error ) {
				$move_file = false;
			}
			
			// $move_file = move_uploaded_file($file['tmp_name'], $upload_image_to_folder.$new_file_name);
			
			if ($move_file) {
				
				$done = 'The image has been uploaded.';
				
				// now save this filename to DB
				$avatarId = mysql_real_escape_string( $_GET['avatarid'] );
				
				// remove old
				$result = mysql_query( "SELECT picture FROM avatars WHERE id = $avatarId;" );
				
				$oldImageName = mysql_fetch_object( $result )->picture;
				
				if ( $oldImageName !== "default.jpg" ) {
					unlink( $upload_image_to_folder.$oldImageName );
				}
				
				$result = mysql_query( "UPDATE avatars SET picture = '$new_file_name' WHERE id = $avatarId;" );
			   
				if ( $result ) {
					echo "true";
				} else {
					echo "false";
				}
			   
			} else {
			
				echo "false";
				
			}
			
		} else {
			// remove unsuccessfull upload
			@unlink($file['tmp_name']);
			echo "false";
		}
		
	}	
	
?>