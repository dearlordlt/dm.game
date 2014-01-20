package dm.builder.interfaces.tools {
	
	import com.bit101.components.CheckBox;
	import com.bit101.components.ComboBox;
	import com.bit101.components.InputText;
	import com.bit101.components.PushButton;
	import dm.builder.interfaces.BuilderLabel;
	import dm.builder.interfaces.BuilderWindow;
	import dm.builder.interfaces.WindowManager;
	import flash.display.DisplayObjectContainer;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import utils.AMFPHP;
	
	/**
	 * Object uploader
	 * @version $Id: ObjectUploader.as 170 2013-06-25 07:24:51Z zenia.sorocan $
	 */
	public class ObjectUploader extends BuilderWindow {
	
		private const SKIN3D_OBJECT_TYPE_ID:int = 6;
		
		private var label_ti:InputText;
		private var upload_btn:PushButton;
		private var object_fr:FileReference;
		private var createEntry_cb:CheckBox;
		private var category_cb:ComboBox;
		
		public function ObjectUploader(parent:DisplayObjectContainer) {
			super(parent, _("Object uploader"), 280, 130);
			
			var amfphp:AMFPHP = new AMFPHP(onCategories);
			amfphp.xcall("dm.Category.getAllCategories");
			function onCategories(response:Object):void {
				for each (var category:Object in response)
					if (category.object_type_id == SKIN3D_OBJECT_TYPE_ID)
						category_cb.addItem(category);
				category_cb.selectedIndex = 0;
				category_cb.selectedIndex = 0;
			}
		}
		
		override protected function createGUI():void {
			var label_lbl:BuilderLabel = new BuilderLabel(_body, 10, 10, "Label: ");
			label_ti = new InputText(_body, label_lbl.x + label_lbl.textWidth + 5, label_lbl.y);
			
			var browse_btn:PushButton = new PushButton(_body, label_ti.x + label_ti.width + 10, label_ti.y, "Browse", onBrowseBtn);
			
			var category_lbl:BuilderLabel = new BuilderLabel(_body, label_lbl.x, label_lbl.y + 30, "Category: ");
			category_cb = new ComboBox(_body, category_lbl.x + category_lbl.textWidth + 5, category_lbl.y);
			
			var createEntry_lbl:BuilderLabel = new BuilderLabel(_body, category_lbl.x, category_lbl.y + 30, "Create entry: ");
			createEntry_cb = new CheckBox(_body, createEntry_lbl.x + createEntry_lbl.textWidth + 5, createEntry_lbl.y + 4, "", onCreateEntryCb);
			createEntry_cb.selected = true;
			
			upload_btn = new PushButton(_body, _width / 2, createEntry_lbl.y + 30, "Upload", onUploadBtn);
			upload_btn.x -= upload_btn.width * 0.5;
			upload_btn.visible = false;
		}
		
		private function onCreateEntryCb(e:Event):void {
			label_ti.enabled = createEntry_cb.selected;
			category_cb.enabled = createEntry_cb.selected;
		}
		
		private function onUploadBtn(e:MouseEvent):void {
			var entry:int = (createEntry_cb.selected) ? 1 : 0;
			var request:URLRequest = new URLRequest("http://vds000004.hosto.lt/dm/uploadObject.php?label=" + label_ti.text + "&category=" + category_cb.selectedItem.id + "&entry=" + entry);
			object_fr.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, onObjectUpload);
			object_fr.upload(request);
		}
		
		private function onObjectUpload(e:DataEvent):void {
			trace(e.data);
			WindowManager.instance.dispatchMessage("Object successfully uploaded.");
			destroy();
		}
		
		private function onBrowseBtn(e:MouseEvent):void {
			object_fr = new FileReference();
			object_fr.addEventListener(Event.SELECT, onFileSelect);
			
			var fileFil:FileFilter = new FileFilter("Flare3D resource", "*.f3d");
			
			object_fr.browse([fileFil]);
		}
		
		private function onFileSelect(e:Event):void {
			label_ti.text = object_fr.name;
			upload_btn.visible = true;
		}
	
	}

}