package dm.builder.interfaces.map {
	
	import com.bit101.components.ComboBox;
	import com.bit101.components.InputText;
	import com.bit101.components.PushButton;
	import dm.builder.interfaces.BuilderLabel;
	import dm.builder.interfaces.BuilderWindow;
	import dm.game.managers.MapManager;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import utils.AMFPHP;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class SaveMapAs extends BuilderWindow {
		private const MAP_OBJECT_TYPE_ID:int = 5;
		
		private var label_ti:InputText;		
		private var category_cb:ComboBox;
		
		public function SaveMapAs(parent:DisplayObjectContainer) {
			var amfphp:AMFPHP = new AMFPHP(onCategories).xcall("dm.Category.getAllCategories");
			super(parent, _("Save map as..."));
		}
		
		private function onCategories(response:Object):void {
			for each (var category:Object in response)
				if (category.object_type_id == MAP_OBJECT_TYPE_ID)
					category_cb.addItem(category);
			category_cb.selectedIndex = 0;
		}
		
		override protected function createGUI():void {
			var label_lbl:BuilderLabel = new BuilderLabel(_body, 10, 20, _("Label") + ": ");
			
			label_ti = new InputText(_body, label_lbl.x, label_lbl.y);
			label_ti.x -= label_ti.width * 0.5;
			
			var category_lbl:BuilderLabel = new BuilderLabel(_body, label_lbl.x, label_lbl.y + 25, _("Category") + ": ");
			category_lbl.width = category_lbl.textWidth;
			category_lbl.textAlign = "right";
			category_cb = new ComboBox(_body, category_lbl.x + category_lbl.textWidth + 5, category_lbl.y);
			
			label_lbl.width = category_lbl.width;
			label_lbl.textAlign = "right";
			label_ti.x = category_cb.x;
			
			var save_btn:PushButton = new PushButton(_body, _width * 0.5, category_lbl.y + 40, _("Save"), onSaveBtn);
			save_btn.x -= save_btn.width * 0.5;
			
			bodyHeight -= 70;
		}
		
		private function onSaveBtn(e:MouseEvent):void {
			if (label_ti.text != "")
				MapManager.instance.saveMapAs(label_ti.text, category_cb.selectedItem.id);
			destroy();
		}
	
	}

}