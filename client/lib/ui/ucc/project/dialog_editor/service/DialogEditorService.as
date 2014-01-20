package ucc.project.dialog_editor.service  {
	import ucc.data.service.Service;
	import ucc.project.dialog_editor.vo.Dialog;
	
/**
 * Dialog editor service
 *
 * @version $Id: DialogEditorService.as 69 2013-03-15 12:30:24Z rytis.alekna $
 */
public class DialogEditorService extends Service {
		
	/** SERVICE_NAME */
	public static const SERVICE_NAME : String = "dm.DialogEditor.";
	
    /**
     * Get all dialogs
     * @return array of all dialog headers
     */	
	public static function getAllDialogsHeaders ( userId : int ) : Service {
		return createService( SERVICE_NAME + "getAllDialogsHeaders", [userId] );
	}
	
    /**
     * Get all conditions
     * @return [
     *	    condition[
     *			label,
     *			params[
     *		   		id,
     *		   		label
     *	    	]
     *		]
	 * ]
     */
    public static function getAllConditions () : Service {
		return createService( SERVICE_NAME + "getAllConditions" );
	}
	
    /**
     * Get all functions
     * @return [
     *	    function[
     *			label,
     *			params[
     *		   		id,
     *		   		label
     *	    	]
     *		]
	 * ]
     */
    public static function getAllFunctions () : Service {	
		return createService( SERVICE_NAME + "getAllFunctions" );
	}
	
	/**
	 * Save dialog
	 * @param	dialog
	 * @return
	 */
	public static function saveDialog ( dialog : Object ) : Service {
		return createService( SERVICE_NAME + "saveDialog", [ dialog ] );
	}
	
	/**
	 * Delete dialog by id
	 * @param int $id
	 * @return bool true on success
	 */
	public static function deleteDialogById ( id : int ) : Service {
		return createService( SERVICE_NAME + "deleteDialogById", [id] );
	}
	
	/**
	 * Set permision to dialog
	 */
	public static function addPermisionToDialog ( dialogId : int, userId : int ) : Service {
		return createService( SERVICE_NAME + "addPermisionToDialog", [dialogId,userId] );
	}
	
	/**
	 * Set permision to dialog
	 */
	public static function removePermisionFromDialog ( dialogId : int, userId : int ) : Service {
		return createService( SERVICE_NAME + "removePermisionFromDialog", [dialogId,userId] );
	}	
	
	/**
	 * Has permissions too dialog
	 * @param	dialogId
	 * @param	userId
	 * @return
	 */
	public static function hasPermisionToDialog ( dialogId : int, userId : int ) : Service {
		return createService( SERVICE_NAME + "hasPermisionToDialog", [dialogId,userId] );
	}	
	
	/**
	 * Get all users assigned to dialog
	 * @param	dialogId
	 * @return	users (id and username)
	 */
	public static function getAllUsersAssignedToDialog ( dialogId : int ) : Service {
		return createService( SERVICE_NAME + "getAllUsersAssignedToDialog", [dialogId] );
	}
	
	/**
	 * Get all users (id and username)
	 * @return
	 */
	public static function getAllUsers () : Service {
		return createService( SERVICE_NAME + "getAllUsers" );
	}	
	
	/**
	 * Get avatar vote for dialog
	 * @param type $dialogId
	 * @param type $avatarId
	 * @return "Y" or "N" if vote exist or false if user haven't voted
	 */
	public static function getAvatarVoteForDialog ( dialogId : int, avatarId : int ) : Service {
		return createService( SERVICE_NAME + "getAvatarVoteForDialog", [dialogId, avatarId] );
	}
	
	/**
	 * Add vote for dialog
	 * @param type $dialogId
	 * @param type $avatarId
	 * @param type $vote
	 * @return dialog rating
	 */
	public static function addVoteForDialog ( dialogId : int, avatarId : int, vote : String ) : Service {
		return createService( SERVICE_NAME + "addVoteForDialog", [dialogId, avatarId, vote] );
	}
	
	/**
	 * Remove vote from dialog
	 * @param type $dialogId
	 * @param type $avatarId
	 * @return dialog rating
	 */
	public static function removeVoteFromDialog ( dialogId : int, avatarId : int ) : Service {
		return createService( SERVICE_NAME + "removeVoteFromDialog", [dialogId, avatarId] );
	}
	
	/**
	 * Get dialog rating
	 * @param type $dialogId
	 * @return object with int attributes 'positive' and 'negative'
	 */
	public static function getDialogRating ( dialogId : int, avatarId : int ) : Service {
		return createService( SERVICE_NAME + "getDialogRating", [dialogId, avatarId] );
	}	
	
	/**
	 * Get all topics
	 */
	public static function getAllTopics () : Service {
		return createService( SERVICE_NAME + "getAllTopics" );
	}
	
}
	
}