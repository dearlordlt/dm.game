package tests {
	import com.bit101.components.HUISlider;
	import dm.builder.interfaces.BuilderLabel;
	import dm.builder.interfaces.BuilderWindow;
	import dm.game.systems.InputSystem;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class AvatarSpeedTweaker extends BuilderWindow {
		
		private var rotationSpeedSlider:HUISlider;
		private var walkSpeedSlider:HUISlider;
		private var walkSpeed_lbl:BuilderLabel;
		private var rotationSpeed_lbl:BuilderLabel;
		
		public function AvatarSpeedTweaker(parent:DisplayObjectContainer) {
			super(parent, "Speed tweaker", 300, 60);
			
			walkSpeedSlider = new HUISlider(_body, 10, 10, "Walk speed", onWalkSpeedChange);
			walkSpeedSlider.minimum = 20;
			walkSpeedSlider.maximum = 5000;
			walkSpeed_lbl = new BuilderLabel(_body, walkSpeedSlider.x + walkSpeedSlider.width + 10, walkSpeedSlider.y, String(InputSystem.currentAvatarMoveSpeed));
			
			rotationSpeedSlider = new HUISlider(_body, walkSpeedSlider.x, walkSpeedSlider.y + 20, "Rotation speed", onRotationSpeedChange);
			rotationSpeedSlider.minimum = 1;
			rotationSpeedSlider.maximum = 10;
			rotationSpeed_lbl = new BuilderLabel(_body, rotationSpeedSlider.x + rotationSpeedSlider.width + 10, rotationSpeedSlider.y, String(InputSystem.avatarRotationSpeed));
		}
		
		private function onRotationSpeedChange(e:Event):void {
			InputSystem.avatarRotationSpeed = rotationSpeedSlider.value;
			rotationSpeed_lbl.text = String(int(InputSystem.avatarRotationSpeed));
		}
		
		private function onWalkSpeedChange(e:Event):void {
			InputSystem.currentAvatarMoveSpeed = walkSpeedSlider.value;
			walkSpeed_lbl.text = String(int(InputSystem.currentAvatarMoveSpeed));
		}
	
	}

}