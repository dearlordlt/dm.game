package dm.builder.interfaces.components {
	
	import com.bit101.components.PushButton;
	import dm.builder.interfaces.BuilderLabel;
	import dm.builder.interfaces.BuilderWindow;
	import dm.game.components.NPC;
	import dm.game.managers.EntityManager;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class NPCView extends BuilderWindow {
		
		/** npc */
		protected var npc:NPC;
		
		public function NPCView(parent:DisplayObjectContainer, npc:NPC) {
			this.npc = npc;
			super(parent, "NPC");
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function draw():void {
			super.draw();
			close_btn.addEventListener(MouseEvent.CLICK, onCloseBtn1, false, 1);
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function initialize():void {
			super.initialize();
			if (npc.id == 0) {
				createDummy();
				var select_btn:PushButton = new PushButton(_dummy, 0, 0, "Select NPC", onSelectNpcBtn);
				select_btn.x = _width * 0.5 - select_btn.width * 0.5;
				select_btn.y = bodyHeight * 0.5 - select_btn.height * 0.5;
			} else {
				var msg_lbl:BuilderLabel = new BuilderLabel(_body, 10, 10, "NPC '" + npc.label + "' was assigned to this entity. If you want to modify this component, use 'NpcEditor' in 'Tools' menu. Also make sure entity has Skin3D component.");
				msg_lbl.width = _width - 10;
				msg_lbl.height = bodyHeight - 10;
			}
		
		}
		
		private function onSelectNpcBtn(e:MouseEvent):void {
			new SelectNPC(parent.parent.parent.parent);
		}
		
		private function onCloseBtn1(e:MouseEvent):void {
			close_btn.removeEventListener(MouseEvent.CLICK, onCloseBtn1);
			close_btn.removeEventListener(MouseEvent.CLICK, onCloseBtn);
			EntityManager.instance.currentEntity.remove(NPC);
		}
	
	}

}