package dm.builder.interfaces.tools.texturemanager {
	
	import com.bit101.components.CheckBox;
	import com.bit101.components.InputText;
	import com.bit101.components.PushButton;
	import dm.builder.interfaces.BuilderLabel;
	import dm.builder.interfaces.BuilderMessage;
	import dm.builder.interfaces.BuilderWindow;
	import dm.builder.interfaces.WindowManager;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author
	 */
	public class NewTexture extends BuilderWindow {
		
		private var texture_fr:FileReference;
		private var label_ti:InputText;
		private var upload_btn:PushButton;
		private var transparent_cb:CheckBox;
		
		public function NewTexture(parent:DisplayObjectContainer) {
			super(parent, "New texture", 300, 80);
			
			var label_lbl:BuilderLabel = new BuilderLabel(_body, 10, 10, "Label: ");
			label_ti = new InputText(_body, label_lbl.x + label_lbl.textWidth + 5, label_lbl.y);
			
			var transparent_lbl:BuilderLabel = new BuilderLabel(_body, label_lbl.x, label_lbl.y + 20, "Has transparency: ");
			transparent_cb = new CheckBox(_body, transparent_lbl.x + transparent_lbl.textWidth + 5, transparent_lbl.y + 3);			
			
			var browse_btn:PushButton = new PushButton(_body, label_ti.x + label_ti.width + 10, label_ti.y, "Browse", onBrowseBtn);
			
			upload_btn = new PushButton(_body, _width / 2, browse_btn.y + browse_btn.height + 20, "Upload", onUploadBtn);
			upload_btn.x -= upload_btn.width * 0.5;
			upload_btn.visible = false;
		}
		
		private function onUploadBtn(e:MouseEvent):void {
			var transparent:int = int(transparent_cb.selected);
			var request:URLRequest = new URLRequest("http://vds000004.hosto.lt/dm/uploadTexture.php?label=" + label_ti.text + "&transparent=" + transparent);
			texture_fr.addEventListener(Event.COMPLETE, onTextureUpload);
			texture_fr.upload(request);
		}
		
		private function onTextureUpload(e:Event):void {
			new BuilderMessage(parent, "Message", "Texture successfully uploaded");
			try { TextureManager(WindowManager.instance.getWindowById("TextureManager")).loadData(); } catch (e:Error) { trace("TextureManager window isn't opened"); }
			destroy();
		}
		
		private function onBrowseBtn(e:MouseEvent):void {
			texture_fr = new FileReference();
			texture_fr.addEventListener(Event.SELECT, onFileSelect);
			
			var fileFil:FileFilter = new FileFilter("Image", "*.gif;*.jpg;*.png");
			
			texture_fr.browse([fileFil]);
		}
		
		private function onFileSelect(e:Event):void {
			label_ti.text = texture_fr.name;
			upload_btn.visible = true;
		}
	
	}

}