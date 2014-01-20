package dm.builder.interfaces.entity {
	
	import com.bit101.components.InputText;
	import com.bit101.components.PushButton;
	import dm.builder.interfaces.BuilderLabel;
	import dm.builder.interfaces.BuilderMessage;
	import dm.builder.interfaces.BuilderWindow;
	import dm.game.components.MapObject;
	import dm.game.managers.EntityManager;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import net.richardlord.ash.core.Entity;
	
	/**
	 * ...
	 * @author
	 */
	public class NewEntity extends BuilderWindow {
		
		private var name_ti:InputText;
		
		public function NewEntity(parent:DisplayObjectContainer) {
			super(parent, "New entity", 210, 80)
		}
		
		private function onCreateBtn(e:MouseEvent):void {
			if (name_ti.text != "") {
				var entity:Entity = new Entity();
				entity.label = name_ti.text;
				entity.id = 0;
				EntityManager.instance.addEntity(entity);
				entity.add(new MapObject());
				//EntityManager.instance.entitySelectedSignal.dispatch(entity);
				new BuilderMessage(parent, "Message", "Entity successfully created");
				destroy();
			} else
				new BuilderMessage(parent, "Error", "Please enter entity name");
		}
		
		override protected function createGUI():void {
			var name_lbl:BuilderLabel = new BuilderLabel(_body, 10, 10, "Entity name: ");
			name_ti = new InputText(_body, name_lbl.x + name_lbl.textWidth + 5, name_lbl.y);
			var create_btn:PushButton = new PushButton(_body, _width * 0.5, name_lbl.y + name_lbl.textHeight + 20, "Create", onCreateBtn);
			create_btn.x -= create_btn.width * 0.5;
		}
	
	}

}