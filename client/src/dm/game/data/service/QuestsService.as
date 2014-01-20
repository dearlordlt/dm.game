package dm.game.data.service {
	import ucc.data.service.Service;
	

/**
 * Quests service
 * @version $Id: QuestsService.as 192 2013-07-25 18:49:46Z rytis.alekna $
 */
public class QuestsService extends Service {
		
	/** SERVICE_NAME */
	public static const SERVICE_NAME : String = "dm.Quest.";
	
	public static function getAllQuestsForAvatar ( avatarId : int ) : Service {
		return createService( SERVICE_NAME + "getAllQuestsForAvatar", [avatarId] );
	}
	
	public static function getAllQuests () : Service {
		return createService( SERVICE_NAME + "getAllQuests" );
	}
	
	public static function addQuestToAvatar ( questId :int, avatarId : int ) : Service {
		return createService( SERVICE_NAME + "addQuestToAvatar", [questId,avatarId] );
	}
	
	public static function completeAvatarQuest( avatarId : int, questId : int ) : Service {
		return createService( SERVICE_NAME + "completeAvatarQuest", [avatarId, questId] );
    }
	
	public static function createQuest ( label : String, description : String, mapLabel : String, markerX : int, markerY : int, roomId : int, lastModifiedBy : int ) : Service {
		return createService( SERVICE_NAME + "createQuest", [label, description, mapLabel, markerX, markerY, roomId, lastModifiedBy ] );
	}	
	
	public static function updateQuest ( id : int, label : String, description : String, mapLabel : String, markerX : int, markerY : int, roomId : int, lastModifiedBy : int ) : Service {
		return createService( SERVICE_NAME + "updateQuest", [ id, label, description, mapLabel, markerX, markerY, roomId, lastModifiedBy ] );
	}
	
	// conditions
	public static function hasQuest ( questId : int, avatarId : int ) : Service {
		return createService( SERVICE_NAME + "hasQuest", [questId, avatarId] );
	}
	
	public static function hasNotQuest ( questId : int, avatarId : int ) : Service {
		return createService( SERVICE_NAME + "hasNotQuest", [questId, avatarId] );
	}
	
	public static function questCompleted ( questId : int, avatarId : int ) : Service {
		return createService( SERVICE_NAME + "questCompleted", [questId, avatarId] );
	}
	
	public static function questNotCompleted ( questId : int, avatarId : int ) : Service {
		return createService( SERVICE_NAME + "questNotCompleted", [questId, avatarId] );
	}		
	
}

}