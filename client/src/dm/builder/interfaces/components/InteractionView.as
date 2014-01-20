package dm.builder.interfaces.components {
	
	import com.bit101.components.PushButton;
	import dm.builder.interfaces.BuilderLabel;
	import dm.builder.interfaces.BuilderWindow;
	import dm.game.components.Interaction;
	import dm.game.managers.EntityManager;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class InteractionView extends BuilderWindow {
		
		private var _interaction:Interaction;

		
		public function InteractionView(parent:DisplayObjectContainer, interaction:Interaction) {
			_interaction = interaction;
			super(parent, "Interaction");
			

		}
		
		
		/**
		 *	@inheritDoc
		 */
		public override function initialize (  ) : void {
			super.initialize();
			if (_interaction.id == 0) {
				createDummy();
				var select_btn:PushButton = new PushButton(_dummy, 0, 0, "Select Interaction", onSelectInteractionBtn);
				select_btn.x = _width * 0.5 - select_btn.width * 0.5;
				select_btn.y = bodyHeight * 0.5 - select_btn.height * 0.5;
			} else {
				var msg_lbl:BuilderLabel = new BuilderLabel(_body, 10, 10, "Interaction '" + _interaction.label + "' was assigned to this entity. If you want to modify this component, use 'InteractionEditor' in 'Tools' menu. Also make sure entity has Skin3D component.");
				msg_lbl.width = _width - 10;
				msg_lbl.height = bodyHeight - 10;
			}
			
			close_btn.addEventListener(MouseEvent.CLICK, onCloseBtn1, false, 1);
		}
		
		private function onSelectInteractionBtn(e:MouseEvent):void 
		{
			new SelectInteraction(parent.parent.parent.parent);
		}
		
		override protected function createGUI():void {

		}
		
		private function onCloseBtn1(e:MouseEvent):void {
			close_btn.removeEventListener(MouseEvent.CLICK, onCloseBtn1);
			close_btn.removeEventListener(MouseEvent.CLICK, onCloseBtn);
			EntityManager.instance.currentEntity.remove(Interaction);
		}

	}

}