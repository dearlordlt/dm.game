<?php
	
	require_once 'PDOConnection.php';
	
	class MediaManager {
		
		/** Upload folder */
		const UPLOAD_FOLDER = './../dm_media_uploads/';
		
		/**
		 * Types to extensions
		 */
		static $TYPES_TO_EXTENSIONS = array (
			"video" => array ( 'flv', 'f4v' ),
			"audio" => array ( 'mp3' ),
			"image" => array ( 'jpg', 'jpeg', 'png', 'gif' ),
			"swf"	=> array ( 'swf' )
		);
		
		static $ALLOWED_EXTENSIONS = array('jpg', 'jpeg', 'png', 'gif', 'swf', 'flv', 'f4v', 'mp3' );
		
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
		
		private $userId;
		
		private $categoryId;

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
			
			if ( !isset($request["user"]) ) {
				throw new Exception("User ID not provided!", 7);
			} else {
				$this->userId = $request["user"];
			}
			
			if ( !empty( $request["label"] ) ) {
				$this->label = $request["label"];
			}
			
			if ( !empty( $request["category_id"] ) ) {
				$this->categoryId = $request["category_id"];
			} else {
				$this->categoryId = 0;
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
			
			$stm = $this->con->prepare("SELECT * FROM media WHERE id = ?");
			$stm->execute(array($this->id));
			$oldEntry = $stm->fetchObject();
			$unlinkResult = unlink( self::UPLOAD_FOLDER.$oldEntry->type.'/'.$oldEntry->path );

			if ( !$unlinkResult ) {
				throw new Exception("Failed to delete file!", 6);
			}			
			
			$stm = $this->con->prepare("DELETE FROM media WHERE id = ?");
			$stm->execute(array($this->id));
			
		}
		
		function updateDBEntry () {
			
			if ( !empty($this->id) ) {
				
				// remove old file first
				$stm = $this->con->prepare("SELECT * FROM media WHERE id = ?");
				$stm->execute(array($this->id));
				$oldEntry = $stm->fetchObject();
				$unlinkResult = unlink( self::UPLOAD_FOLDER.$oldEntry->type.'/'.$oldEntry->path );
				
				if ( !$unlinkResult ) {
					throw new Exception("Failed to delete old file!", 5);
				}
				
				$stm = $this->con->prepare("UPDATE media SET label = :label, path = :path, type = :type, category_id = :category_id, WHERE id = :id");
				
				$stm->execute(
					array(
						"id"	=> $this->id,
						"label" => ( $this->label ? $this->label : $this->fileName ),
						"path"	=> $this->newFileName,
						"type"	=> $this->fileType,
						"category_id" => $this->categoryId,
						"last_modified_by" => $this->userId
					)
				);
			} else {
				
				$stm = $this->con->prepare("INSERT INTO media ( label, path, type, category_id, last_modified_by ) VALUES( :label, :path, :type, :category_id, :last_modified_by )");
				
				$stm->execute(
					array(
						"label" => ( $this->label ? $this->label : $this->fileName ),
						"path"	=> $this->newFileName,
						"type"	=> $this->fileType,
						"category_id" => $this->categoryId,
						"last_modified_by" => $this->userId
					)
				);
			}
			
		}
		
		function updateLabel () {
			
			if ( !empty($this->label) ) {
				$stm = $this->con->prepare("UPDATE media SET label = :label, last_modified_by = :last_modified_by, category_id = :category_id WHERE id = :id");

				$stm->execute(
					array (
						"id"	=> $this->id,
						"label" => $this->label,
						"last_modified_by" => $this->userId,
						"category_id" => $this->categoryId
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

new MediaManager();
	
?>