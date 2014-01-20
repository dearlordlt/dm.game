package dm.game.systems {
	
	import dm.game.managers.AnimationManager;
	import dm.game.managers.MyManager;
	import dm.game.managers.UserManager;
	import dm.game.nodes.InputNode;
	import flare.physics.core.AvatarController;
	import flare.system.Input3D;
	import flash.utils.Dictionary;
	import net.richardlord.ash.core.Game;
	import net.richardlord.ash.core.NodeList;
	import net.richardlord.ash.core.System;
	import net.richardlord.ash.signals.Signal0;
	import ucc.ui.window.WindowEvent;
	import ucc.ui.window.WindowsManager;
	import utils.AMFPHP;
	
	/**
	 * ...
	 * @author
	 */
	public class InputSystem extends System {
		
		private const WALK:String = "walk";
		private const RUN:String = "run";
		
		private const WALK_FORWARD:String = "walkForward";
		private const WALK_BACKWARDS:String = "walkBackwards";
		private const ROTATE_LEFT:String = "rotateLeft";
		private const ROTATE_RIGHT:String = "rotateRight";
		private const TOGGLE_RUN:String = "toggleRun";
		
		private var _inputNodes:NodeList;
		
		private var _currentAvatarMoveSpeed:Number = 300;
		
		private var _avatarWalkSpeed:Number = 300;
		private var _avatarRunSpeed:Number = 600;
		
		public static var avatarRotationSpeed:Number = 2;
		
		private var _runModeOn:Boolean = false;
		private var _toggleRunKeyIsDown:Boolean = false;
		
		public static var interactionKeyHitSignal:Signal0 = new Signal0();
		
		private static var _inputEnabled:Boolean = true;
		
		private var _initialised:Boolean = false;
		
		private var _actionsToKeys_keyDown:Dictionary = new Dictionary();
		private var _actionsToKeys_keyHit:Dictionary = new Dictionary();
		
		public function InputSystem() {
			var amfphp:AMFPHP = new AMFPHP(onControls, null, true);
			amfphp.xcall("dm.Controls.getUserControls", MyManager.instance.id);
		}
		
		private function onControls(response:Object):void { // Response is array of { label: function name, key_press_type: keyDown or keyHit, default_key_code: default key code, key_code: user defined key code or null if not defined }
			_initialised = true;
			
			for each (var action:Object in response) {
				var keyCode:uint = (action.key_code) ? action.key_code : action.default_key_code;
				switch (action.key_press_type) {
					case "keyDown": 
						_actionsToKeys_keyDown[action.label] = keyCode;
						break;
					
					case "keyHit": 
						_actionsToKeys_keyHit[action.label] = keyCode;
						break;
				}
				
			}
		}
		
		override public function addToGame(game:Game):void {
			_inputNodes = game.getNodeList(InputNode);
			WindowsManager.getInstance().addEventListener(WindowEvent.WINDOW_FOCUS_IN, onWindowFocusIn);
			WindowsManager.getInstance().addEventListener(WindowEvent.WINDOW_FOCUS_OUT, onWindowFocusOut);
		}
		
		private function onWindowFocusOut(e:WindowEvent):void {
			_inputEnabled = true;
		}
		
		private function onWindowFocusIn(e:WindowEvent):void {
			_inputEnabled = false;
		}
		
		private function startTimer():void {
		
		}
		
		override public function update(time:Number):void {
			if (_initialised && _inputEnabled) {
				for (var inputNode:InputNode = _inputNodes.head; inputNode; inputNode = inputNode.next) {
					
					var avatarController:AvatarController = inputNode.inputController.avatarController;
					
					var action:String;
					
					//trace(Input3D.keyDown(Input3D.W));
					
					for (action in _actionsToKeys_keyDown)
						if (Input3D.keyDown(_actionsToKeys_keyDown[action]))
							try {
								this[action](avatarController);
							} catch (error:Error) {
								trace(error.getStackTrace());
							}
					
					for (action in _actionsToKeys_keyHit)
						if (Input3D.keyHit(_actionsToKeys_keyHit[action]))
							try {
								this[action](avatarController);
							} catch (error:Error) {
								trace(error.getStackTrace());
							}
					
					if (Input3D.keyHit(_actionsToKeys_keyDown[WALK_FORWARD]))
						if (!_runModeOn)
							AnimationManager.instance.playAnimation(avatarController.skin, WALK);
						else
							AnimationManager.instance.playAnimation(avatarController.skin, RUN);
					
					if (Input3D.keyHit(_actionsToKeys_keyDown[TOGGLE_RUN]))
						_toggleRunKeyIsDown = true;
					
					if (Input3D.keyUp(_actionsToKeys_keyDown[TOGGLE_RUN]) && _toggleRunKeyIsDown) {
						_toggleRunKeyIsDown = false;
						toggleRun(avatarController);
					}
					
					if ((avatarController.skin.userData.currentAnimation == WALK || avatarController.skin.userData.currentAnimation == RUN) && Input3D.keyUp(_actionsToKeys_keyDown[WALK_FORWARD])) {
						AnimationManager.instance.playAnimation(avatarController.skin, AnimationManager.DEFAULT_IDLE_ANIMATION);
					}
				}
			}
		}
		
		override public function removeFromGame(game:Game):void {
			WindowsManager.getInstance().removeEventListener(WindowEvent.WINDOW_FOCUS_IN, onWindowFocusIn);
			WindowsManager.getInstance().removeEventListener(WindowEvent.WINDOW_FOCUS_OUT, onWindowFocusOut);
		}
		
		static public function get inputEnabled():Boolean {
			return _inputEnabled;
		}
		
		/* Actions */
		
		private function walkForward(avatarController:AvatarController):void {
			avatarController.move(_currentAvatarMoveSpeed);
			UserManager.instance.updatePositionVariable(avatarController.skin);
			//trace(avatarController.x + " / " + avatarController.y + " / " + avatarController.z);
		}
		
		private function walkBackwards(avatarController:AvatarController):void {
			avatarController.move(-_currentAvatarMoveSpeed);
			UserManager.instance.updatePositionVariable(avatarController.skin);
		}
		
		private function rotateLeft(avatarController:AvatarController):void {
			avatarController.turn(-avatarRotationSpeed);
			UserManager.instance.updatePositionVariable(avatarController.skin);
		}
		
		private function rotateRight(avatarController:AvatarController):void {
			avatarController.turn(avatarRotationSpeed);
			UserManager.instance.updatePositionVariable(avatarController.skin);
		}
		
		private function interact(avatarController:AvatarController):void {
			interactionKeyHitSignal.dispatch();
		}
		
		private function autorun(avatarController:AvatarController):void {
			_runModeOn = !_runModeOn;
			_currentAvatarMoveSpeed = (_runModeOn) ? _avatarRunSpeed : _avatarWalkSpeed;
			if (avatarController.skin.userData.currentAnimation == WALK || avatarController.skin.userData.currentAnimation == RUN)
				AnimationManager.instance.playAnimation(avatarController.skin, (_runModeOn) ? RUN : WALK);
		}
		
		private function toggleRun(avatarController:AvatarController):void {
			if (!_toggleRunKeyIsDown) {
				_runModeOn = !_runModeOn;
				_currentAvatarMoveSpeed = (_runModeOn) ? _avatarRunSpeed : _avatarWalkSpeed;
				if (avatarController.skin.userData.currentAnimation == WALK || avatarController.skin.userData.currentAnimation == RUN)
					AnimationManager.instance.playAnimation(avatarController.skin, (_runModeOn) ? RUN : WALK);
			}
		}
		
		// Animations
		
		private function wave(avatarController:AvatarController):void {
			AnimationManager.instance.playAnimation(avatarController.skin, "wave");
		}
		
		private function valio(avatarController:AvatarController):void {
			AnimationManager.instance.playAnimation(avatarController.skin, "valio");
		}
		
		private function throw_a(avatarController:AvatarController):void {
			AnimationManager.instance.playAnimation(avatarController.skin, "throw_a");
		}
		
		private function jump(avatarController:AvatarController):void {
			AnimationManager.instance.playAnimation(avatarController.skin, "jump_a");
		}
		
		private function handshake(avatarController:AvatarController):void {
			AnimationManager.instance.playAnimation(avatarController.skin, "handshake");
		}
		
		private function argue(avatarController:AvatarController):void {
			AnimationManager.instance.playAnimation(avatarController.skin, "argue");
		}
		
		private function gadget(avatarController:AvatarController):void {
			AnimationManager.instance.playAnimation(avatarController.skin, "gadget");
		}
	
	}
}