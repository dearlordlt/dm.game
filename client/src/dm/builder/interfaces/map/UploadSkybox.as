package dm.builder.interfaces.map 
{
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
	import net.richardlord.ash.signals.Signal0;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class UploadSkybox  extends BuilderWindow {
	
		private const SKIN3D_OBJECT_TYPE_ID:int = 6;
		
		private var label_ti:InputText;
		private var upload_btn:PushButton;
		private var object_fr:FileReference;
		private var type_cb:ComboBox;
		
		public var skyboxUploadedSignal:Signal0 = new Signal0();
		
		public function UploadSkybox(parent:DisplayObjectContainer) {
			super(parent, _("Upload skybox"), 280, 130);
		}
		
		override protected function createGUI():void {
			var label_lbl:BuilderLabel = new BuilderLabel(_body, 10, 10, "Label: ");
			label_ti = new InputText(_body, label_lbl.x + label_lbl.textWidth + 5, label_lbl.y);
			
			var browse_btn:PushButton = new PushButton(_body, label_ti.x + label_ti.width + 10, label_ti.y, "Browse", onBrowseBtn);
			
			var type_lbl:BuilderLabel = new BuilderLabel(_body, label_lbl.x, label_lbl.y + 30, _("Type") + ": ");
			type_cb = new ComboBox(_body, type_lbl.x + type_lbl.textWidth + 5, type_lbl.y, "", ["folderJPG", "folderPNG", "horizontalCross", "verticalCross"]);
			
			upload_btn = new PushButton(_body, _width / 2, type_lbl.y + 40, "Upload", onUploadBtn);
			upload_btn.x -= upload_btn.width * 0.5;
			upload_btn.visible = false;
		}
		
		
		private function onUploadBtn(e:MouseEvent):void {
			var request:URLRequest = new URLRequest("http://vds000004.hosto.lt/dm/uploadSkybox.php?label=" + label_ti.text + "&type=" + type_cb.selectedItem);
			object_fr.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, onObjectUpload);
			object_fr.upload(request);
		}
		
		private function onObjectUpload(e:DataEvent):void {
			trace(e.data);
			WindowManager.instance.dispatchMessage("Skybox successfully uploaded.");
			skyboxUploadedSignal.dispatch();
			destroy();
		}
		
		private function onBrowseBtn(e:MouseEvent):void {
			object_fr = new FileReference();
			object_fr.addEventListener(Event.SELECT, onFileSelect);
			
			var fileFil:FileFilter = new FileFilter("Image", "*.jpg; *.jpeg; *.gif; *.png");
			
			object_fr.browse([fileFil]);
		}
		
		private function onFileSelect(e:Event):void {
			label_ti.text = object_fr.name;
			upload_btn.visible = true;
		}
	
	}

}