package ucc.project.tag.service {
	import org.as3commons.lang.IllegalArgumentError;
	import ucc.data.service.Service;
	

/**
 * Tags service
 * @version $Id: TagsService.as 207 2013-09-04 14:31:08Z rytis.alekna $
 */
public class TagsService extends Service {
		
	/** SERVICE_NAME */
	public static const SERVICE_NAME : String = "dm.Tags.";
	
	/**
	 * Create tag
	 * @param	tagName
	 */
	public static function createTag ( tagName : String, comment : String, makeDefault : Boolean, defaultValue : String ) : Service {
		return createService( SERVICE_NAME + "createTag", [tagName, comment, makeDefault, defaultValue ] );
	}
	
	public static function updateVar ( varId : int, varName : String, comment : String, makeDefault : Boolean, defaultValue : String ) : Service {
		return createService( SERVICE_NAME + "updateVar", [varId, varName, comment, makeDefault, defaultValue] );
	}	
	
	/**
	 * Create tag
	 * @param	tagName
	 */
	public static function createTagGroup ( groupName : String, comment : String ) : Service {
		return createService( SERVICE_NAME + "createTagGroup", [groupName, comment] );
	}
	
	/**
	 * Remove var from group
	 * @param	varId
	 * @param	groupId
	 */
	public static function removeVarFromGroup ( varId : int, groupId : int ) : Service {	
		return createService( SERVICE_NAME + "removeVarFromGroup", [varId, groupId] );
	}
	
	/**
	 * Add var to group
	 * @param type $varId
	 * @param type $groupId
	 */
	public static function addVarToGroup ( varId : int, groupId : int ) : Service {
		return createService( SERVICE_NAME + "addVarToGroup", [varId, groupId] );
	}
	
	/**
	 * Get avatars by var value
	 * 
 			0 => "=", // value
			1 => "<",
			2 => ">",
			3 => ">=",
			4 => "<=",
			5 => "!=",
			6 => "=", // label
			7 => "!=", // label
	 * 
	 * 
	 * @param	tag
	 * @param	operator
	 * @param	value
	 * @return
	 */
	public static function getAvatarsByVarValue ( tag : String = null, operator : int = 0, value : String = null ) : Service {
		
		if ( ( operator >= 0 ) && ( operator <= 7 ) ) {
			return createService( SERVICE_NAME + "getAvatarsByVarValue", [tag, operator, value] );
		} else {
			throw new IllegalArgumentError("ucc.project.tag.service.TagsService.getAvatarsByVarValue() : unknown operator provided");
		}
		
	}
	
	/**
	 * Get all tags?
	 * @return
	 */
	public static function getAllTags () : Service {
		return createService( SERVICE_NAME + "getAllTags" );
	}
	
	/**
	 * Get all groups
	 */
	public static function getAllGroups () : Service {
		return createService( SERVICE_NAME + "getAllGroups" );
	}
	
	/**
	 * Get avatar tags by group id
	 * @param type $groupId
	 * @return type
	 */
	public static function getAvatarTagsByGroupLabel ( avatarId : int, groupLabel : String ) : Service {	
		return createService( SERVICE_NAME + "getAvatarTagsByGroupLabel", [avatarId, groupLabel] );
	}
	
	/**
	 * Get avatar tags by group id
	 * @param type $groupId
	 * @return type
	 */
	public static function getAvatarTagsByGroupId ( avatarId : int, groupId : int ) : Service {
		return createService( SERVICE_NAME + "getAvatarTagsByGroupId", [avatarId, groupId] );
	}
	
	/**
	 * Get all tags by group id
	 * @param	groupId
	 * @return
	 */
	public static function getAllTagsByGroupId ( groupId : int ) : Service {
		return createService( SERVICE_NAME + "getAllTagsByGroupId", [groupId] );
	}
	
	/**
	 * Get all tags by group label
	 * @param	groupId
	 * @return
	 */
	public static function getAllTagsByGroupLabel ( groupLabel : String ) : Service {
		return createService( SERVICE_NAME + "getAllTagsByGroupLabel", [groupLabel] );
	}
	
	/**
	 * Get all avatar vars
	 * @param	avatarId
	 * @return
	 */
	public static function getAvatarVars ( avatarId : int ) : Service {
		return createService( SERVICE_NAME + "getAvatarVars", [avatarId] );
	}
	
	/**
	 * Set tags to avatars
	 * @param	avatars
	 * @param	tag
	 * @param	value
	 * @return
	 */
	public static function setTagsToAvatars ( avatars : Array, tag : String, value : String ) : Service {
		return createService( SERVICE_NAME + "setTagsToAvatars", [avatars, tag, value] );
	}
	
	/**
	 * Delete avatars var
	 * @param	avatars
	 * @param	tag
	 */
	public static function deleteAvatarsVar ( avatars : Array, tag : String ) : Service {
		return createService( SERVICE_NAME + "deleteAvatarsVar", [avatars, tag] );
	}
	
	
	public static function getTagUsageStatistics ( varName : String ) : Service {
		return createService( SERVICE_NAME + "getTagUsageStatistics", [varName] );
	}

	public static function deleteVar ( varName : String ) : Service {
		return createService( SERVICE_NAME + "deleteVar", [varName] );
	}
	
	public static function avatarVarIsEqualOrGreaterThenOthersVars ( avatarId : int, varName : String, otherVars : String ) : Service {
		return createService( SERVICE_NAME + "avatarVarIsEqualOrGreaterThenOthersVars", [avatarId, varName, otherVars] );
	}
	
}

}