package dm.game.systems {
	
	import dm.builder.interfaces.WindowManager;
	import dm.game.components.Interaction;
	import dm.game.components.Skin3D;
	import dm.game.conditions.ConditionChecker;
	import dm.game.effects.FadingTextEffect;
	import dm.game.functions.FunctionExecutor;
	import dm.game.managers.EsManager;
	import dm.game.managers.MyManager;
	import dm.game.managers.UserManager;
	import dm.game.nodes.InteractionNode;
	import dm.game.windows.DmWindowManager;
	import flare.core.Pivot3D;
	import flare.core.Texture3D;
	import flare.materials.filters.AlphaMaskFilter;
	import flare.materials.filters.TextureFilter;
	import flare.materials.Shader3D;
	import flare.primitives.Plane;
	import flare.utils.Pivot3DUtils;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import net.richardlord.ash.core.Game;
	import net.richardlord.ash.core.NodeList;
	import net.richardlord.ash.core.System;
	import net.richardlord.ash.signals.Signal1;
	import utils.Utils;
	
	/**
	 * Interaction system
	 * @version $Id: InteractionSystem.as 189 2013-07-18 13:29:57Z zenia.sorocan $
	 */
	public class InteractionSystem extends System {
		
		private static var _instance:InteractionSystem;
		private static var _usingGetInstance:Boolean = false;
		
		private const INTERACTION_DISTANCE:int = 250;
		private var _nodes:NodeList;
		private var fadingText:FadingTextEffect;
		private var checkTimer:Timer;
		
		private var _currentAvailableAvatars:Array = new Array();
		private var _currentAvailableInteractions:Array = new Array();
		
		public var availableInteractionsChangeSignal:Signal1 = new Signal1(Array);
		
		public function InteractionSystem() {
			if (!_usingGetInstance) {
				throw new Error("Please use 'instance' property).");
			}
			
			init();
		}
		
		public static function get instance():InteractionSystem {
			if (_instance == null) {
				_usingGetInstance = true;
				_instance = new InteractionSystem();
				_usingGetInstance = false;
			}
			return _instance;
		}
		
		private function init():void {
			InputSystem.interactionKeyHitSignal.add(onInteractionKeyHit);
			
			checkTimer = new Timer(500);
			checkTimer.addEventListener(TimerEvent.TIMER, onTimer);
			checkTimer.start();
		}
		
		private function onTimer(e:TimerEvent):void {
			checkAvailableAvatars();
			checkAvailableInteractions();
			
			if (_currentAvailableInteractions.length > 0)
				onDistance();
			else if (fadingText != null) {
				fadingText.hide();
				fadingText = null;
			}
		}
		
		// Updates _currentAvailableAvatars array and dispatches signal if array changed
		private function checkAvailableAvatars():void {
			var avatars:Array = new Array();
			
			for (var userName:String in UserManager.instance.usersToEntities) {
				try {
					var skin:Pivot3D = UserManager.instance.usersToEntities[userName].get(Skin3D).skin as Pivot3D;
				} catch (err:Error) {
					//trace("InteractionSystem: User avatar skin is not set or loaded yet.");
					return;
				}
				
				if (skin != null && MyManager.instance.skin != null) {
					var distance:int = Math.sqrt(Math.pow(skin.x - MyManager.instance.skin.x, 2) + Math.pow(skin.y - MyManager.instance.skin.y, 2) + Math.pow(skin.z - MyManager.instance.skin.z, 2));
					
					if (distance < INTERACTION_DISTANCE)
						avatars.push(userName);
				}
			}
			
			if (!Utils.compareArrays(_currentAvailableAvatars, avatars)) {
				_currentAvailableAvatars = avatars.slice();
				availableInteractionsChangeSignal.dispatch(getCurrentInteractions());
			}
		}
		
		// Updates _currentAvailableInteractions array and dispatches signal if array changed
		private function checkAvailableInteractions():void {
			var interactions:Array = new Array();
			
			for (var interactionNode:InteractionNode = _nodes.head; interactionNode; interactionNode = interactionNode.next) {
				var skin:Pivot3D = interactionNode.skin3d.skin;
				
				if (skin != null && MyManager.instance.skin != null && interactionNode.interaction.available) {
					var distance:int = Math.sqrt(Math.pow(skin.x - MyManager.instance.skin.x, 2) + Math.pow(skin.y - MyManager.instance.skin.y, 2) + Math.pow(skin.z - MyManager.instance.skin.z, 2));
					
					if (distance < INTERACTION_DISTANCE)
						interactions.push(interactionNode.interaction);
				}
			}
			
			if (!Utils.compareArrays(_currentAvailableInteractions, interactions)) {
				_currentAvailableInteractions = interactions.slice();
				availableInteractionsChangeSignal.dispatch(getCurrentInteractions());
			}
		}
		
		private function getCurrentInteractions():Array {
			var currentInteractions:Array = new Array();
			
			for each (var avatarName:String in _currentAvailableAvatars) {
				var avatarId:int = EsManager.instance.es.managerHelper.userManager.userByName(avatarName).userVariableByName("avatar").value.getInteger("id");
				currentInteractions.push({label: avatarName, avatarId: avatarId});
			}
			
			for each (var interaction:Interaction in _currentAvailableInteractions)
				currentInteractions.push({label: interaction.label, avatarId: NaN, interaction: interaction});
			
			return currentInteractions;
		}
		
		private function addInteractionIcon(node:InteractionNode):void {
			try {
				var skin:Pivot3D = node.skin3d.skin;
			} catch (e:Error) {
				WindowManager.instance.dispatchMessage("Entity '" + node.entity.label + "' doesn't have assigned Skin3D element. Interaction inavailable.");
				return;
			}
			
			if (skin != null) {
				if (node.interaction.iconPlane) {
					node.interaction.iconPlane.parent.removeChild(node.interaction.iconPlane);
					node.interaction.iconPlane.dispose();
				}
				
				var icon:Sprite = (node.interaction.available) ? new InteractionTrue() : new InteractionFalse();
				var bmData:BitmapData = new BitmapData(icon.width, icon.height, true, 0);
				bmData.draw(icon);
				var texture:Texture3D = new Texture3D(bmData);
				var shader:Shader3D = new Shader3D("", [ /*new ColorFilter(0), */new TextureFilter(texture), new AlphaMaskFilter()]);
				var planeHolder:Pivot3D = new Pivot3D();
				skin.scene.addChild(planeHolder);
				var plane:Plane = new Plane("", bmData.width * 0.5, bmData.height * 0.5, 1, shader);
				planeHolder.addChild(plane);
				node.interaction.iconPlane = planeHolder;
			}
		}
		
		private function onDistance():void {
			if (fadingText != null)
				return;
			fadingText = new FadingTextEffect(_("Press \'Space\' to interact."));
			DmWindowManager.instance.windowLayer.addChild(fadingText);
			fadingText.x = fadingText.stage.stageWidth * 0.5 - fadingText.getWidth() * 0.5;
			fadingText.y = fadingText.stage.stageHeight * 0.25;
			fadingText.display();
		}
		
		private function onInteractionKeyHit():void {
			var distance:int;
			var skin:Pivot3D;
			
			checkAvailableInteractions();
			if (_currentAvailableInteractions.length > 0) {
				fadingText.hide();
				var functionExecutor:FunctionExecutor = new FunctionExecutor();
				functionExecutor.executeFunctions(Interaction(_currentAvailableInteractions[0]).functions);
			}
			
			checkAvailableAvatars();
			if (_currentAvailableAvatars.length > 0) {
				var avatarId:int = EsManager.instance.es.managerHelper.userManager.userByName(_currentAvailableAvatars[0]).userVariableByName("avatar").value.getInteger("id");
					// TODO: open avatar profile
			}
		}
		
		override public function removeFromGame(game:Game):void {
		
		}
		
		override public function addToGame(game:Game):void {
			_nodes = game.getNodeList(InteractionNode);
			_nodes.nodeAdded.add(onInteractionNodeAdd);
		}
		
		private function onInteractionNodeAdd(node:InteractionNode):void {
			checkInteractionNodeConditions(node);
		}
		
		private function checkInteractionNodeConditions(node:InteractionNode):void {
			var conditionChecker:ConditionChecker = new ConditionChecker();
			conditionChecker.checkConditions(node.interaction.conditions, onResult);
			
			function onResult(result:Boolean):void {
				node.interaction.available = result;
				addInteractionIcon(node);
			}
		}
		
		public function recheckInteractionConditions():void {
			for (var node:InteractionNode = _nodes.head; node; node = node.next)
				checkInteractionNodeConditions(node);
		}
		
		override public function update(time:Number):void {
			for (var node:InteractionNode = _nodes.head; node; node = node.next) {
				try {
					node.interaction.iconPlane.x = node.skin3d.skin.x;
					node.interaction.iconPlane.z = node.skin3d.skin.z;
					node.interaction.iconPlane.y = Pivot3DUtils.getBounds(node.skin3d.skin).radius * 2 + 50;
					node.interaction.iconPlane.setRotation(node.skin3d.skin.scene.camera.getRotation().x, node.skin3d.skin.scene.camera.getRotation().y, node.skin3d.skin.scene.camera.getRotation().z);
				} catch (err:Error) {
					// nothing serious
				}
			}
		}
	
	}
}