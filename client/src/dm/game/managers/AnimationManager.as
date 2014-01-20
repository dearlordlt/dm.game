package dm.game.managers {
	
	import com.electrotank.electroserver5.api.EsObject;
	import com.electrotank.electroserver5.api.UpdateUserVariableRequest;
	import dm.game.managers.EsManager;
	import dm.game.managers.MyManager;
	import dm.game.systems.render.Animation;
	import flare.core.Pivot3D;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import ucc.logging.Logger;
	import utils.AMFPHP;
	import utils.Utils;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class AnimationManager {
		
		public static const DEFAULT_IDLE_ANIMATION:String = "gadget";
		
		private static var _instance:AnimationManager;
		private static var _usingGetInstance:Boolean = false;
		
		public var animations:Array = new Array();
		
		private var _skinToAnimation:Dictionary = new Dictionary();
		
		public function AnimationManager() {
			if (!_usingGetInstance) {
				throw new Error("Please use getInstance().");
			}
			loadAnimations();
		}
		
		private function loadAnimations():void {
			var amfphp:AMFPHP = new AMFPHP(onAnimations, this.onAnimationsLoadFailed);
			amfphp.xcall("dm.Skin3D.getAllAnimations");
		}
		
		private function onAnimations(response:Object):void {
			for each (var animationObj:Object in response) {
				animations.push(new Animation(animationObj.label, animationObj.character_type_id, animationObj.start_frame, animationObj.end_frame, Boolean(animationObj.loop)));
			}
		}
		
		/**
		 * On animation load failed
		 * @param	response
		 */
		private function onAnimationsLoadFailed(response:Object):void {
			Logger.log("dm.game.managers.AnimationManager.onAnimationsLoadFailed() : Animations load failed", Logger.LEVEL_WARN);
		}
		
		public static function get instance():AnimationManager {
			if (_instance == null) {
				_usingGetInstance = true;
				_instance = new AnimationManager();
				_usingGetInstance = false;
			}
			return _instance;
		}
		
		public function playAnimation(skin:Pivot3D, animationLabel:String):void {
			var charType:int = skin.userData.subtype;
			Utils.clearNonMesh(skin);
			skin.frameSpeed = 0.4;
			skin.userData.currentAnimation = animationLabel;
			var animation:Animation = getAnimation(animationLabel, charType);
			if (animation != null) {
				skin.removeEventListener(Pivot3D.ENTER_FRAME_EVENT, onSkinEnterFrame);
				_skinToAnimation[skin] = animation;
				skin.addEventListener(Pivot3D.ENTER_FRAME_EVENT, onSkinEnterFrame);
				skin.gotoAndPlay(animation.startFrame, 20);
				
				if (skin == MyManager.instance.skin)
					updateAnimationVariable(animationLabel, charType);
			} else
				trace("dm.game.managers.AnimationManager.playAnimation() : Animation '" + animationLabel + "' not found for character type '" + charType + "'.");
		}
		
		private function onSkinEnterFrame(e:Event):void {
			var skin:Pivot3D = e.currentTarget as Pivot3D;
			var animation:Animation = _skinToAnimation[skin];
			if (int(skin.children[0].children[0].currentFrame) == animation.endFrame) {
				if (animation.loop)
					skin.gotoAndPlay(animation.startFrame);
				else {
					skin.stop();
					skin.removeEventListener(Pivot3D.ENTER_FRAME_EVENT, onSkinEnterFrame);
					delete _skinToAnimation[skin];
				}
			}
		}
		
		private function getAnimation(label:String, type:int):Animation {
			for each (var animation:Animation in animations)
				if (animation.label == label && animation.type == type)
					return animation;
			return null;
		}
		
		private function updateAnimationVariable(animationLabel:String, charType:int):void {
			var uuvr:UpdateUserVariableRequest = new UpdateUserVariableRequest();
			uuvr.name = "animation";
			var animation:EsObject = new EsObject();
			animation.setInteger("characterType", charType);
			animation.setString("animation", animationLabel);
			uuvr.value = animation;
			EsManager.instance.es.engine.send(uuvr);
		}
	
	}

}