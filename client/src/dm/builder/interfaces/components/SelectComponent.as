package dm.builder.interfaces.components {
	
	import com.bit101.components.PushButton;
	import dm.builder.interfaces.BuilderMessage;
	import dm.builder.interfaces.SearchList;
	import dm.game.components.AltSkin;
	import dm.game.managers.EntityManager;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
	import utils.AMFPHP;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SelectComponent extends SearchList {
		
		public function SelectComponent(parent:DisplayObjectContainer) {
			super(parent, "Select component");
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function draw():void {
			super.draw();
			bodyHeight += 50;
			
			var ok_btn:PushButton = new PushButton(_body, _body.width * 0.5, item_list.y + item_list.height + 10, "OK", onOkBtn);
			ok_btn.x -= ok_btn.width * 0.5;
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function initialize():void {
			var amfphp:AMFPHP = new AMFPHP(onComponentTypes);
			amfphp.xcall("dm.Builder.getComponentTypes");
		}
		
		private function onOkBtn(e:MouseEvent):void {
			var componentClass:Class = getDefinitionByName("dm.game.components." + item_list.selectedItem.label) as Class;
			var viewClass:Class = getDefinitionByName("dm.builder.interfaces.components." + item_list.selectedItem.view_class) as Class;
			if (EntityManager.instance.currentEntity) {
				//try {
				EntityManager.instance.currentEntity.add(new componentClass());
					//} catch (e:Error) {
					//new BuilderMessage(parent, "Error", e.message);
					//}
			} else
				new BuilderMessage(parent, "Error", "Please select entity first");
			destroy();
		}
		
		private function onComponentTypes(response:Object):void {
			items = response as Array;
		}
	
	}

}