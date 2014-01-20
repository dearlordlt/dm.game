<?php

/**
 * Friends functionality
 *	Avatar means here a requester avatar (self). Friend means other avatar o which it is operating
 * @version $Id$
 */
require_once 'Avatar.php';
require_once 'Notifications.php';

class Friends {

	const NOT_FRIENDS = 0;
	const CONFIRMED = 1;
	const AWAITING_AVATAR_CONFIRMATION = 2;
	const AWATING_FRIEND_CONFIRMATION = 3;
	const BLOCKED_BY_AVATAR = 4;
	const BLOCKED_BY_FRIEND = 5;
	const BLOCKED_BY_BOTH	= 6;
	const WRONG_NAME		= 7;

	/**
	 *  PDO connection
	 * @var PDO
	 */
	private $con;

	/**
	 * COnstructor
	 */
	function __construct () {
		$this->con = PDOConnection::con( basename(__DIR__) );
		
	}

	function addFriend ( $avatarId, $friendId ) {

		$currentStatus = $this->getFriendshipStatus( $avatarId, $friendId );
		
		if ($currentStatus === self::NOT_FRIENDS) {
			
			$this->con->beginTransaction();
			
			try {
			
				if ( $this->realAddFriend($avatarId, $friendId) ) {


					// form notification

					// avatar name
					$avatar = new Avatar();
					$avatarName = $avatar->getAvatarById($avatarId)->name;

					$notifications = new Notifications();

					$notifications->addNotification(
							$friendId, 
							1, 
							Notifications::createFunction(
									"confirmFriend", 
									array( 
										"avatarId" => $avatarId,
										"friendId" => $friendId
									), 
									"Confirm"), 
							Notifications::createFunction(
									"declineFriend", 
									array(
										"avatarId" => $avatarId,
										"friendId" => $friendId,
										"block" => false
									),
									"Decline"
							), 
							array($avatarName)
					);
					
					$this->con->commit();
					
					return self::AWATING_FRIEND_CONFIRMATION;
				}
			
			} catch ( PDOException $error ) {
				$this->con->rollBack();
				
				return array (
					"error" => $error
				);
				
			}

			
		} else if ( $currentStatus === self::AWAITING_AVATAR_CONFIRMATION ) {
			if ( $this->realAddFriend($avatarId, $friendId) ) {
				
				// form notification
				
				// avatar name
				$avatar = new Avatar();
				$avatarName = $avatar->getAvatarById($avatarId)->name;
				
				$notifications = new Notifications();
				
				$notifications->addNotification(
						$friendId, 
						2, 
						null, 
						null, 
						array($avatarName)
				);
				
				return self::CONFIRMED;
			}
		} else {
			return $currentStatus;
		}
		
	}
	
	public function addFriendByName ( $avatarId, $friendName ) {
		
		// avatar name
		$avatar = new Avatar();
		
		$friend = $avatar->getAvatarByName($friendName);
		
		if ( $friend === false ) {
			return self::WRONG_NAME;
		} else {
			$friendId = $friend->id;
		}
		
		return $this->addFriend($avatarId, $friendId);
		
	}

		/**
	 * @internal real friend add functionality
	 */
	private function realAddFriend ( $avatarId, $friendId ) {
		$stm = $this->con->prepare( "INSERT INTO avatar_friends ( avatar_id, friend_id, blocked ) VALUES ( :avatarId, :friendId, 0 )" );

		return $stm->execute(
			array(
				"avatarId" => $avatarId,
				"friendId" => $friendId
				)
		);
	}
	
	/**
	 * Get friendship status
	 * @param type $avatarId
	 * @param type $friendId
	 * @return int 
	 *      0 - not friends, 
	 *      1 - confirmed friends, 
	 *      2 - avaiting avatar confirmation, 
	 *      3 - awaiting friend confirmation
	 */
	function getFriendshipStatus ( $avatarId, $friendId ) {
		
		$stmForward = $this->con->prepare("SELECT * FROM avatar_friends WHERE avatar_id = :avatarId AND friend_id = :friendId");
		
		$stmForward->execute(
			array(
				"avatarId" => $avatarId,
				"friendId" => $friendId
				)
		);
		
		$stmReturn = $this->con->prepare("SELECT * FROM avatar_friends WHERE avatar_id = :friendId AND friend_id = :avatarId");
		
		$stmReturn->execute(
			array(
				"avatarId" => $avatarId,
				"friendId" => $friendId
				)
		);
		
		if ( $stmForward->rowCount() > 0 ) {
			$forwardFriendship = $stmForward->fetchObject();
		}
		
		if ( $stmReturn->rowCount() > 0 ) {
			$returnFriendship = $stmReturn->fetchObject();
		}
		
		if ( isset($forwardFriendship) && isset($returnFriendship) ) {
			if ( ( $forwardFriendship->blocked == false ) && ( ( $returnFriendship->blocked == false ) ) ) {
				return self::CONFIRMED;
			} else {
				return self::BLOCKED_BY_BOTH;
			}
			
		}
		
		if ( isset($forwardFriendship) ) {
			if ( $forwardFriendship->blocked == true ) {
				return self::BLOCKED_BY_AVATAR;
			}
			
			return self::AWATING_FRIEND_CONFIRMATION;
			
		}
		
		if ( isset($returnFriendship) ) {
			if ( $returnFriendship->blocked == true ) {
				return self::BLOCKED_BY_FRIEND;
			}
			
			return self::AWAITING_AVATAR_CONFIRMATION;
		}
		
		return self::NOT_FRIENDS;
		
	}

	
	function removeFromFriends ( $avatarId, $friendId, $block = false ) {
		
		if ( !$block ) {
			$stm = $this->con->prepare("DELETE FROM avatar_friends 
										WHERE 
											( avatar_id = :avatarId AND friend_id = :friendId ) OR 
											( avatar_id = :friendId AND friend_id = :avatarId )");
			$stm->execute( 
					array(
						"avatarId" => $avatarId,
						"friendId" => $friendId						
					) 
			);
		} else {
			$stm = $this->con->prepare("DELETE FROM avatar_friends 
										WHERE avatar_id = :friendId AND friend_id = :avatarId");
			$stm->execute( 
					array(
						"avatarId" => $avatarId,
						"friendId" => $friendId						
					) 
			);
			
			$stm = $this->con->prepare("UPDATE avatar_friends SET blocked = 1 
										WHERE avatar_id = :avatarId AND friend_id = :friendId");
			
			$stm->execute( 
					array(
						"avatarId" => $avatarId,
						"friendId" => $friendId						
					) 
			);
			
		}
		
		
	}

	function getAllAcceptedFriends ( $avatarId ) {
		$stm = $this->con->prepare("SELECT avatars.*, avatar_friends.guest AS can_visit FROM avatars LEFT JOIN avatar_friends ON ( avatars.id = avatar_friends.friend_id ) WHERE avatar_friends.avatar_id = ? AND avatar_friends.blocked = false");
		
		$stm->execute( array( $avatarId ) );
		
		return $stm->fetchAll(PDO::FETCH_OBJ);
		
	}
	
	function getAllFriendsThatCanBeVisited ( $avatarId ) {
		
		$stm = $this->con->prepare("SELECT avatars.* FROM avatars LEFT JOIN avatar_friends ON ( avatars.id = avatar_friends.avatar_id ) WHERE avatar_friends.friend_id = ? AND avatar_friends.blocked = false AND avatar_friends.guest = true");
		
		$stm->execute( array( $avatarId ) );
		
		return $stm->fetchAll(PDO::FETCH_OBJ);
		
	}
	
	function getAvatarConfirmationPendingFriendships ( $avatarId ) {

		$stm = $this->con->prepare( "SELECT avatar_friends.id AS friendship_id, avatars.* 
                                    FROM avatars
                                    LEFT JOIN avatar_friends ON ( avatars.id = avatar_friends.avatar_id )
                                    WHERE avatar_friends.friend_id = ? AND avatar_friends.status = 'unconfirmed'
                                    " );

		$stm->execute( array($avatarId) );

		return $stm->fetchAll( PDO::FETCH_OBJ );
	}
	
	function makeFriendGuest ( $avatarId, $friendId, $make = true ) {
		
		$status = $this->getFriendshipStatus($avatarId, $friendId);
		
		if ( $status === self::CONFIRMED ) {
			
			$stm = $this->con->prepare( "UPDATE avatar_friends SET guest = :make WHERE avatar_id = :avatarId AND friend_id = :friendId" );
			
			return $stm->execute(
					array (
						"avatarId" => $avatarId,
						"friendId" => $friendId,
						"make" => $make
					)
			);
			
		} else {
			return false;
		}
		
	}
	
}

?>
