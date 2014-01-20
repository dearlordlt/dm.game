package dm.game.systems {
	
	import dm.game.components.Skin3D;
	import dm.game.components.TransformEnabled;
	import dm.game.managers.EntityManager;
	import dm.game.nodes.TransformNode;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import net.richardlord.ash.core.Entity;
	import net.richardlord.ash.core.Game;
	import net.richardlord.ash.core.NodeList;
	import net.richardlord.ash.core.System;
	
	/**
	 * ...
	 * @author
	 */
	public class TransformSystem extends System {
		
		private var _nodes:NodeList;
		private var _displayContainer:DisplayObjectContainer;
		private var _btnsToNodes:Dictionary = new Dictionary();
		
		private const MOVE_BTN_NAME:String = "moveBtn";
		private const DESTROY_BTN_NAME:String = "destroyBtn";
		
		public function TransformSystem(displayContainer:DisplayObjectContainer) {
			_displayContainer = displayContainer;
		}
		
		override public function removeFromGame(game:Game):void {
		
		}
		
		override public function addToGame(game:Game):void {
			_nodes = game.getNodeList(TransformNode);
			_nodes.nodeAdded.add(onNodeAdded);
			_nodes.nodeRemoved.add(onNodeRemoved);
		}
		
		private function onNodeAdded(node:TransformNode):void {
			var btns:Sprite = new Sprite();
			
			var move_btn:Sprite = new MoveBtn();
			move_btn.addEventListener(MouseEvent.MOUSE_DOWN, onMoveBtnMouseDown);
			_displayContainer.addChild(btns);
			
			btns.addChild(move_btn).name = MOVE_BTN_NAME;
			var destroy_btn:Sprite = new DestroyBtn();
			destroy_btn.addEventListener(MouseEvent.CLICK, onDestroyBtn);
			btns.addChild(destroy_btn).name = DESTROY_BTN_NAME;
			destroy_btn.x = move_btn.width;
			
			node.transformEnabled.btns = btns;
			
			_btnsToNodes[btns] = node;
		}
		
		private function onNodeRemoved(node:TransformNode):void {
			node.transformEnabled.btns.getChildByName(MOVE_BTN_NAME).removeEventListener(MouseEvent.MOUSE_DOWN, onMoveBtnMouseDown);
			node.transformEnabled.btns.getChildByName(DESTROY_BTN_NAME).removeEventListener(MouseEvent.CLICK, onDestroyBtn);
			_displayContainer.removeChild(node.transformEnabled.btns);
			delete _btnsToNodes[node.transformEnabled.btns];
		}
		
		private function onMoveBtnMouseDown(e:MouseEvent):void {
			var node:TransformNode = _btnsToNodes[e.currentTarget.parent];
			
			if (EntityManager.instance.currentEntity != node.entity)
				EntityManager.instance.currentEntity = node.entity;
			
			node.transformEnabled.transformObject.startDrag();
			_displayContainer.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			function onMouseUp(e:MouseEvent):void {
				_displayContainer.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				node.transformEnabled.transformObject.stopDrag();
			}
		}
		
		private function onDestroyBtn(e:MouseEvent):void {
			EntityManager.instance.removeEntity(TransformNode(_btnsToNodes[e.currentTarget.parent]).entity);
		}
		
		override public function update(time:Number):void {
			for (var node:TransformNode = _nodes.head; node; node = node.next) {
				node.transformEnabled.btns.x = node.transformEnabled.transformObject.getScreenCoords().x;
				node.transformEnabled.btns.y = node.transformEnabled.transformObject.getScreenCoords().y;
			}
		}
	
	}

}