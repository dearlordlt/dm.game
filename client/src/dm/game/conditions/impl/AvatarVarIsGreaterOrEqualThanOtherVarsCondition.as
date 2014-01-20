package dm.game.conditions.impl {
	import dm.game.conditions.BaseCondition;
	import dm.game.managers.MyManager;
	import ucc.project.tag.service.TagsService;
	

/**
 * 
 * @version $Id: AvatarVarIsGreaterOrEqualThanOtherVarsCondition.as 207 2013-09-04 14:31:08Z rytis.alekna $
 */
public class AvatarVarIsGreaterOrEqualThanOtherVarsCondition extends BaseCondition {
		
	/** VAR_NAME */
	public static const LABEL : String = "label";
		
	/** OTHER_VARS */
	public static const OTHER_LABELS : String = "otherLabels";
		
	
	/**
	 * (Constructor)
	 * - Returns a new AvatarVarIsGreaterOrEqualThanOtherVarsCondition instance
	 */
	public function AvatarVarIsGreaterOrEqualThanOtherVarsCondition() {
		
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function execute (  ) : void {
		TagsService.avatarVarIsEqualOrGreaterThenOthersVars( MyManager.instance.avatar.id, this.getParamValueByLabel( LABEL ), this.getParamValueByLabel( OTHER_LABELS ) )
			.addResponders( this.onResultHandler, this.onResultHandler )
			.call();
	}
	
	
	/**
	 *	On result handler
	 */
	protected function onResultHandler ( result : Object ) : void {
		this.onResult( Boolean( result ) );
	}
	
	
	
}

}