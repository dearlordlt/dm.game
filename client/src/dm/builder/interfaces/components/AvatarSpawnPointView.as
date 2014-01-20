package dm.builder.interfaces.components {
	
	import com.bit101.components.InputText;
	import com.bit101.components.List;
	import com.bit101.components.PushButton;
	import dm.builder.interfaces.BuilderLabel;
	import dm.builder.interfaces.BuilderWindow;
	import dm.builder.interfaces.ConditionProperties;
	import dm.game.components.AvatarSpawnPoint;
	import dm.game.components.Skin3D;
	import dm.game.managers.EntityManager;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import ucc.ui.window.WindowsManager;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class AvatarSpawnPointView extends BuilderWindow {
		
		private var condition_list:List;
		private var _avatarSpawnPoint:AvatarSpawnPoint;
		private var rotation_ti:InputText;
		
		public function AvatarSpawnPointView(parent:DisplayObjectContainer, avatarSpawPoint:AvatarSpawnPoint) {
			_avatarSpawnPoint = avatarSpawPoint;
			super(parent, "AvatarSpawnPoint", 210, 150);
		}
		
		override protected function createGUI():void {
			var rotation_lbl:BuilderLabel = new BuilderLabel(_body, 10, 10, "Rotation: ");
			rotation_ti = new InputText(_body, rotation_lbl.textWidth + 5, rotation_lbl.y, String(_avatarSpawnPoint.rotationY), onRotationChange);
			var conditions_lbl:BuilderLabel = new BuilderLabel(_body, rotation_lbl.x, rotation_lbl.y + 20, "Spawn conditions: ");
			conditions_lbl.width = _width - 10;
			condition_list = new List(_body, conditions_lbl.x, conditions_lbl.y + 20, _avatarSpawnPoint.conditions);
			var addCondition_btn:PushButton = new PushButton(_body, condition_list.x + condition_list.width + 10, condition_list.y, "Add", onAddConditionBtn);
			addCondition_btn.width -= 20;
			var removeCondition_btn:PushButton = new PushButton(_body, addCondition_btn.x, addCondition_btn.y + 30, "Remove", onRemoveConditionBtn);
			removeCondition_btn.width = addCondition_btn.width;
		}
		
		private function onRotationChange(e:Event):void {
			Skin3D(EntityManager.instance.currentEntity.get(Skin3D)).skin.setRotation(0, int(rotation_ti.text) - 90, 0);
			_avatarSpawnPoint.rotationY = int(rotation_ti.text);
		}
		
		private function onRemoveConditionBtn(e:MouseEvent):void {
			condition_list.removeItemAt(condition_list.selectedIndex);
		}
		
		private function onAddConditionBtn(e:MouseEvent):void {
			trace("OnAddBtn: " + parent.parent);
			var newCondition:ConditionProperties = WindowsManager.getInstance().createWindow(ConditionProperties) as ConditionProperties;
			newCondition.conditionSavedSignal.add(onConditionSaved);
		}
		
		private function onConditionSaved(condition:Object):void {
			_avatarSpawnPoint.conditions.push(condition);
			condition_list.items = _avatarSpawnPoint.conditions;
		}
	
	}

}