package tests 
{
	import dm.game.conditions.Condition;
	import dm.game.conditions.ConditionChecker;
	import dm.game.managers.EntityManager;
	import dm.game.managers.MyManager;
	import flash.display.Sprite;
	import net.richardlord.ash.core.Entity;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class ConditionTest extends Sprite 
	{
		
		public function ConditionTest() 
		{
			/*
			var cc:ConditionChecker = new ConditionChecker();
			var c0:Condition = new Condition("characterTypeIs", { avatarId: 33, characterType: 1 }, true);
			var c1:Condition = new Condition("characterTypeIs", { avatarId: 10 }, true);
			var c2:Condition = new Condition("characterTypeIs", { avatarId: 11, characterType: 1 }, true);
			var conditions:Vector.<Condition> = new Vector.<Condition>();
			conditions.push(c0, c1, c2);
			
			cc.checkConditions(conditions, onResult);
			*/
			EntityManager.instance.componentAddedSignal.add(onComponentAdded);
			MyManager.instance.avatar.id;
		}
		
		private function onComponentAdded(entity:Entity, componentClass:Class):void 
		{
			
		}
		
		private function onResult(response:Object):void 
		{
			trace(response);
		}
		
	}

}