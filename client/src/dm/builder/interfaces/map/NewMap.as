package dm.builder.interfaces.map {
	
	import com.bit101.components.ComboBox;
	import com.bit101.components.InputText;
	import com.bit101.components.PushButton;
	import dm.builder.interfaces.BuilderLabel;
	import dm.builder.interfaces.BuilderWindow;
	import dm.builder.interfaces.YNMessage;
	import dm.game.managers.MapManager;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import utils.AMFPHP;
	
	/**
	 * ...
	 * @author
	 */
	public class NewMap extends BuilderWindow {
		private const MAP_OBJECT_TYPE_ID:int = 5;
		
		private var label_ti:InputText;
		private var width_ti:InputText;
		private var height_ti:InputText;
		private var skybox_cb:ComboBox;
		private var _existing:Boolean; // New map OR existing map properties
		private var category_cb:ComboBox;
		
		public function NewMap(parent:DisplayObjectContainer, existing:Boolean = false) {
			_existing = existing;
			
			var windowName:String = (existing) ? "Map properties" : "New map";
			super(parent, windowName, 250);
			
			new AMFPHP(onSkyboxes).xcall("dm.Maps.getAllSkyboxes");
			new AMFPHP(onCategories).xcall("dm.Category.getAllCategories");
		}
		
		private function onCategories(response:Object):void {
			for each (var category:Object in response)
				if (category.object_type_id == MAP_OBJECT_TYPE_ID)
					category_cb.addItem(category);
			category_cb.selectedIndex = 0;
		}
		
		private function onSkyboxes(response:Object):void {
			skybox_cb.removeAll();
			skybox_cb.items = response as Array;
			skybox_cb.selectedIndex = 0;
		}
		
		override protected function createGUI():void {
			var maxLabelWidth:int = 78;
			
			var label_lbl:BuilderLabel = new BuilderLabel(_body, 10, 10, _("Label") + ": ");
			label_lbl.width = maxLabelWidth;
			label_lbl.textAlign = "right";
			label_ti = new InputText(_body, label_lbl.x + label_lbl.width + 5, label_lbl.y, MapManager.instance.currentMap.label);
			
			var category_lbl:BuilderLabel = new BuilderLabel(_body, label_lbl.x, label_lbl.y + 25, _("Category") + ": ");
			category_lbl.width = maxLabelWidth;
			category_lbl.textAlign = "right";
			category_cb = new ComboBox(_body, category_lbl.x + category_lbl.width + 5, category_lbl.y);
			
			var size_lbl:BuilderLabel = new BuilderLabel(_body, 10, category_lbl.y + 30, "Size(meters): ");
			size_lbl.width = maxLabelWidth;
			size_lbl.textAlign = "right";
			width_ti = new InputText(_body, size_lbl.x + size_lbl.width + 5, size_lbl.y, MapManager.instance.currentMap.width);
			width_ti.width = 30;
			width_ti.maxChars = 4;
			var x_lbl:BuilderLabel = new BuilderLabel(_body, width_ti.x + width_ti.width + 5, width_ti.y, "x");
			height_ti = new InputText(_body, x_lbl.x + x_lbl.textWidth + 5, x_lbl.y, MapManager.instance.currentMap.height);
			height_ti.width = 30;
			height_ti.maxChars = 4;
			
			var skybox_lbl:BuilderLabel = new BuilderLabel(_body, label_lbl.x, size_lbl.y + 30, "Skybox: ");
			skybox_lbl.width = maxLabelWidth;
			skybox_lbl.textAlign = "right";
			skybox_cb = new ComboBox(_body, skybox_lbl.x + skybox_lbl.width, skybox_lbl.y);
			
			var uploadSkybox_btn:PushButton = new PushButton(_body, skybox_cb.x + skybox_cb.width + 5, skybox_cb.y, "Upload", onUploadSkyboxBtn);
			uploadSkybox_btn.width = 50;
			
			var btnLabel:String = (_existing) ? "Save" : "Create";
			var create_btn:PushButton = new PushButton(_body, _width * 0.5, height_ti.y + 60, btnLabel, onCreateBtn);
			create_btn.x -= create_btn.width * 0.5;
			
			bodyHeight -= 50;
		}
		
		private function onUploadSkyboxBtn(e:MouseEvent):void {
			var uploadSkybox:UploadSkybox = new UploadSkybox(null);
			uploadSkybox.skyboxUploadedSignal.add(onSkyboxUploaded);
		}
		
		private function onSkyboxUploaded():void {
			new AMFPHP(onSkyboxes).xcall("dm.Maps.getAllSkyboxes");
		}
		
		private function onCreateBtn(e:MouseEvent):void {
			var msg:YNMessage = new YNMessage(parent, "Message", "You want to create new map. All changes made to current map will be lost. Are you sure?");
			msg.selectSignal.add(onSelect);
			destroy();
			function onSelect(answer:int):void {
				if (answer)
					MapManager.instance.createNewMap(label_ti.text, int(width_ti.text), int(height_ti.text), category_cb.selectedItem.id, skybox_cb.selectedItem, !_existing);
			}
		}
	
	}

}