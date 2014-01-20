package dm.game.managers {
	
	import com.electrotank.electroserver5.api.EsObject;
	import com.electrotank.electroserver5.api.PluginMessageEvent;
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import dm.game.components.AvatarLabel;
	import dm.game.components.NPC;
	import dm.game.components.Skin3D;
	import flare.basic.Scene3D;
	import flare.core.Pivot3D;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import net.richardlord.ash.core.Entity;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class NpcManager {
		
		private static var _instance:NpcManager;
		private static var _usingGetInstance:Boolean = false;
		public var scene:Scene3D;
		
		private var _movingSkins:Array = new Array();
		
		public function NpcManager() {
			if (!_usingGetInstance)
				throw new Error("Please use getInstance().");
			EsManager.instance.esPluginMessageSignal.add(onPluginMessage);
			EntityManager.instance.componentAddedSignal.add(onComponentAdded);
			
			createTimer();
		}
		
		private function onComponentAdded(entity:Entity, componentClass:Class):void {
			if (componentClass == NPC)
				entity.add(new AvatarLabel(entity.label));
		}
		
		private function createTimer():void {
			var timer:Timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
		}
		
		private function onTimer(e:TimerEvent):void {
			for each (var skin:Pivot3D in _movingSkins) {
				//trace("Rotation: " + int(skin.userData.serverRotationY));
				trace("Coords: (" + int(skin.x) + ", " + int(skin.z) + ")");
			}
		}
		
		public static function get instance():NpcManager {
			if (_instance == null) {
				_usingGetInstance = true;
				_instance = new NpcManager();
				_usingGetInstance = false;
			}
			return _instance;
		}
		
		private function onPluginMessage(e:PluginMessageEvent):void {
			var params:EsObject = e.parameters;
			
			try {
				var npcEventType:String = params.getString("npcEvent");
			} catch (error:Error) {
				return;
			}
			
			var entity:Entity;
			for each (entity in EntityManager.instance.entities)
				if (entity.id == params.getInteger("entityId"))
					break;
			try {
				var skin:Pivot3D = Skin3D(entity.get(Skin3D)).skin;
			} catch (e:Error) {
				//throw new Error("NPC must have skin.");
				return;
			}
			
			switch (npcEventType) {
				case "onMovementStart": 
					var position:EsObject = params.getEsObject("position");
					var destination:EsObject = params.getEsObject("destination");
					skin.setPosition(position.getInteger("x"), position.getInteger("y"), position.getInteger("z"));
					// trace("Current coords: (" + skin.x + ", " + skin.z + ")");
					skin.lookAt(destination.getInteger("x"), skin.y, destination.getInteger("z"));
					skin.rotateY(180);
					//trace("Wanted rotation: " + rotationY + " | Current rotation: " + skin.getRotation().y);
					AnimationManager.instance.playAnimation(skin, "walk");
					TweenLite.to(skin, destination.getInteger("time"), {x: destination.getInteger("x"), y: destination.getInteger("y"), z: destination.getInteger("z"), ease: Linear.easeNone});
					break;
				
				case "onPlayAnimation": 
					AnimationManager.instance.playAnimation(skin, params.getString("label"));
					break;
				
				case "onWait": 
					AnimationManager.instance.playAnimation(skin, AnimationManager.DEFAULT_IDLE_ANIMATION);
					break;
			}
		}
		
		private function calculateRotation(z:int, x:int):int {
			return Math.atan2(z, x) * (180 / Math.PI);
		}
	}

}