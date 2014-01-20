<?php
	
	require_once 'PDOConnection.php';
	
	class GalleryManager {
		
		/** Upload folder */
		const UPLOAD_FOLDER = './../dm_gallery_uploads/';
		
		/**
		 * Types to extensions
		 */
		static $TYPES_TO_EXTENSIONS = array (
			"video" => array ( 'flv', 'f4v' ),
			"audio" => array ( 'mp3' ),
			"image" => array ( 'jpg', 'jpeg', 'png', 'gif' ),
			"swf"	=> array ( 'swf' )
		);
		
		static $ALLOWED_EXTENSIONS = array('jpg', 'jpeg', 'png', 'gif' );
		
		/**
		 * @var PDO 
		 */
		private $con;
		
		private $id;
		
		private $file;
		
		private $label;
		
		private $fileName;
		
		private $newFileName;
		
		private $fileType;
		
		private $avatarId;
		
		private $description;

		/**
		 * Constructor
		 */
		function __construct () {
			
			$this->con = PDOConnection::con("dm");
			
			try {
				$this->handleRequest($_REQUEST, $_FILES);
			} catch ( Exception $error ) {
				
				if ( isset($this->file) ) {
					@unlink($this->file['tmp_name']);
				}
				
				$output = new stdClass();
				$output->result		= 0;
				$output->message	= $error->getMessage();
				$output->stackTrace	= $error->getTrace();
				echo json_encode($output);
				return;
			}

			$output = new stdClass();
			$output->result		= 1;
			$output->message	= "Entry successfuly saved!";
			
			echo json_encode($output);
			
		}
		
		function handleRequest ( &$request, &$files ) {
			
			error_log( "request: ".var_export($request, true));
			error_log( "files: ".var_export($files, true));
			
			if ( !isset($request["avatar"]) ) {
				throw new Exception("Avatar ID not provided!", 7);
			} else {
				$this->avatarId = $request["avatar"];
			}
			
			if ( !empty( $request["label"] ) ) {
				$this->label = $request["label"];
			}
			
			if ( !empty( $request["description"] ) ) {
				$this->description = $request["description"];
			} else {
				$this->description = "";
			}
			
			if ( isset($request["id"]) ) {
				$this->id = $request["id"];
				
				if ( !isset($request["delete"] ) ) {
					if ( !empty($files) ) {
						$this->moveFile($files);
					} else {
						$this->updateLabel();
					}
				} else {
					$this->deleteFile();
				}
				
				
			} else {
				if ( empty($files) ) {
					throw new Exception("No files uploading!", 2 );
				} else {
					$this->moveFile($files);
				}
			}
			
			
		}
		
		function moveFile ( $files ) {
			
			$this->file = $files['Filedata'];
			$this->fileName = $this->file['name'];
			
			$ext = strtolower(substr(strrchr($this->fileName, "."), 1));
			
			if ( !$this->isFileValid($ext) ) {
				throw new Exception("Invalid file extension!", 3 );
			}
			
			$this->fileType = $this->getFileType($ext);
			
			// move
			
			$this->newFileName = str_replace( array (' ', '.'), '_', microtime() ).'.'.$ext;
			
			$fileMoveResult = move_uploaded_file($this->file['tmp_name'], self::UPLOAD_FOLDER.$this->fileType.'/'.$this->newFileName);			
			
			if ( $fileMoveResult ) {
				
				$this->updateDBEntry();
				
			} else {
				throw new Exception("File move failed!", 4);
			}
			
		}
		
		function deleteFile () {
			
			$stm = $this->con->prepare("SELECT * FROM gallery_images WHERE id = ?");
			$stm->execute(array($this->id));
			$oldEntry = $stm->fetchObject();
			$unlinkResult = unlink( self::UPLOAD_FOLDER.'image/'.$oldEntry->source );

			if ( !$unlinkResult ) {
				throw new Exception("Failed to delete file!", 6);
			}			
			
			$stm = $this->con->prepare("DELETE FROM gallery_images WHERE id = ?");
			$stm->execute(array($this->id));
			
		}
		
		function updateDBEntry () {
			
			if ( !empty($this->id) ) {
				
				// remove old file first
				$stm = $this->con->prepare("SELECT * FROM gallery_images WHERE id = ?");
				$stm->execute(array($this->id));
				$oldEntry = $stm->fetchObject();
				$unlinkResult = unlink( self::UPLOAD_FOLDER.$oldEntry->type.'/'.$oldEntry->source );
				
				if ( !$unlinkResult ) {
					throw new Exception("Failed to delete old file!", 5);
				}
				
				$stm = $this->con->prepare("UPDATE gallery_images SET label = :label, source = :path, type = :type, description = :description WHERE id = :id");
				
				$stm->execute(
					array(
						"id"	=> $this->id,
						"label" => ( $this->label ? $this->label : $this->fileName ),
						"path"	=> $this->newFileName,
						"description" => $this->description
					)
				);
			} else {
				
				$stm = $this->con->prepare("INSERT INTO gallery_images ( label, avatar_id, source, description ) VALUES( :label, :avatarId, :path, :description )");
				
				$stm->execute(
					array(
						"label" => ( $this->label ? $this->label : $this->fileName ),
						"path"	=> $this->newFileName,
						"description" => $this->description,
						"avatarId" => $this->avatarId
					)
				);
			}
			
		}
		
		function updateLabel () {
			
			if ( !empty($this->label) ) {
				$stm = $this->con->prepare("UPDATE gallery_images SET label = :label, description = :description WHERE id = :id");

				$stm->execute(
					array (
						"id"	=> $this->id,
						"label" => $this->label,
						"description" => $this->description 
					)
				);
			}
			
		}
		
		/**
		 * Get file type (audio, video,image)
		 * @param type $ext
		 * @return type or false
		 */
		function getFileType ( $ext ) {
			foreach ( self::$TYPES_TO_EXTENSIONS as $type => $extensions ) {
				if ( in_array( $ext, $extensions ) ) {
					return $type;
				}
			}			
			
			return false;
			
		}
		
		function isFileValid ($ext) {
			return in_array($ext, self::$ALLOWED_EXTENSIONS);
		}
		
	}

	new GalleryManager();
	
?>