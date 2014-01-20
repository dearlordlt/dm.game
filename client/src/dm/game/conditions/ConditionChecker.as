package dm.game.conditions {
	
	import dm.game.conditions.impl.AnswerToQuestionIncorrectCondition;
	import dm.game.conditions.impl.AvatarVarIsGreaterOrEqualThanOtherVarsCondition;
	import dm.game.conditions.impl.HasEqualOrMoreItemsCondition;
	import dm.game.conditions.impl.HasItemCondition;
	import dm.game.conditions.impl.HasNotQuestCondition;
	import dm.game.conditions.impl.HasQuestCondition;
	import dm.game.conditions.impl.QuestCompletedCondition;
	import dm.game.conditions.impl.QuestionAnsweredCondition;
	import dm.game.conditions.impl.QuestionNotAnsweredCondition;
	import dm.game.conditions.impl.QuestNotCompletedCondition;
	import dm.game.conditions.impl.TimeoutNotPassedCondition;
	import dm.game.conditions.impl.TimeoutPassedCondition;
	import dm.game.managers.EsManager;
	import dm.game.managers.MyManager;
	import utils.AMFPHP;
	
	/**
	 * Conditions checker
	 * @author zenia
	 */
	public class ConditionChecker {
		
		/** Conditions to classes */
		private static const conditionsToClasses	: Object = {
			
			"hasQuest"					: HasQuestCondition,
			"hasNotQuest" 				: HasNotQuestCondition,
			"questCompleted" 			: QuestCompletedCondition,
			"questNotCompleted" 		: QuestNotCompletedCondition,
			"questionAnswered"			: QuestionAnsweredCondition,
			"answerToQuestionIncorrect"	: AnswerToQuestionIncorrectCondition,
			"questionNotAnswered"		: QuestionNotAnsweredCondition,
			"varIsEqualOrGreaterThanOthers" : AvatarVarIsGreaterOrEqualThanOtherVarsCondition,
			"timeoutPassed"				: TimeoutPassedCondition,
			"timeoutNotPassed"			: TimeoutNotPassedCondition,
			"hasItem"					: HasItemCondition,
			"hasEqualOrMoreItems"		: HasEqualOrMoreItemsCondition
			
			
		}
		
		public var avatarId:int;
		
		/**
		 * Class constructor
		 */
		public function ConditionChecker() {
		
		}
		
		/**
		 * Check conditions
		 */
		public function checkConditions(conditions:Array, onResult:Function):void {
			if (!conditions || conditions.length == 0) {
				onResult(true);
				return;
			}
			
			var conditionsChecked:int = 0;
			
			for each (var condition:Object in conditions) {
				this.checkCondition(condition, onResponse);
			}
			
			function onResponse(response:Object):void {
				if (response == false) {
					onResult(false);
					return;
				}
				
				if (response == null) {
					onResult(null);
					return;
				}
				
				if (response == true) {
					conditionsChecked++;
					if (conditionsChecked == conditions.length) {
						onResult(true);
						return;
					}
				}
			}
		}
		
		/**
		 * Check condition
		 * @param	condition	?
		 * @param	onResult	callback function
		 */
		public function checkCondition(condition:Object, onResult:Function):void {
			//trace("ConditionChecker: Checking " + condition.label + "(" + condition.params[0].value + ")");
			
			if (!condition) {
				throw new ArgumentError("dm.game.conditions.ConditionChecker.checkCondition() : no condition provided!")
			}
			
			if ( conditionsToClasses[condition.label] ) {
				var externalCondition : Condition = new conditionsToClasses[condition.label];
				externalCondition.setParams( condition.params, onResult );
				externalCondition.execute();
				return;
			}
			
			trace("Checking '" + condition.label + "' condition for avatar id '" + ((avatarId) ? avatarId : MyManager.instance.avatar.id) + "'.");
			
			try {
				onResult(this[condition.label](condition.params));
			} catch (error:Error) {
				//trace("dm.game.conditions.ConditionChecker.checkCondition() : No condition '" + condition.label + "' in AS3. Checking AMFPHP...");
				condition.params.push({label: "avatarId", value: (avatarId) ? avatarId : MyManager.instance.avatar.id});
				var amfphp:AMFPHP = new AMFPHP(onResult, null, true);
				amfphp.xcall("dm.Conditions.checkCondition", condition);
			}
		}

		// CONDITIONS
		
		private function isHometown(params:Object):Boolean {
			return MyManager.instance.school.id == EsManager.instance.roomData.id;
		}
		
		private function characterTypeIs(params:Object):Boolean {
			return MyManager.instance.skin.userData.subtype == params.characerTypeId;
		}
		
		
	}

}