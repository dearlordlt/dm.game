package dm.builder.interfaces.tools {
	import com.bit101.components.CheckBox;
	import com.bit101.components.ColorChooser;
	import com.bit101.components.ComboBox;
	import com.bit101.components.InputText;
	import com.bit101.components.List;
	import com.bit101.components.PushButton;
	import com.bit101.components.TextArea;
	import dm.builder.interfaces.BuilderLabel;
	import dm.builder.interfaces.SearchListWithCategories;
	import dm.game.managers.MyManager;
	// import dm.builder.interfaces.NewCondition;
	// import dm.builder.interfaces.NewFunction;
	import dm.builder.interfaces.SearchList;
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
	 * ...
	 * @author zenia
	 */
	public class AudioEditor extends SearchListWithCategories {
		
		private var label_ti:InputText;
		private var distance_ti:InputText
		private var audio_fr:FileReference;
		
		public function AudioEditor(parent:DisplayObjectContainer) {
			_width = 500;
			super(parent, "Audio editor", 8);
			refreshAudioList();
		}
		
		private function refreshAudioList():void {
			var amfphp:AMFPHP = new AMFPHP(onAudios).xcall("dm.Audio.getUserAudios", MyManager.instance.id);
		}
		
		private function onAudios(response:Object):void {
			item_list.items = response as Array;
		}
		
		override protected function onSelect(e:Event):void {
			if (item_list.selectedItem.id != 0) {
				label_ti.text = item_list.selectedItem.label;
				distance_ti.text = item_list.selectedItem.distance;
			} else
				clearData();
		}
		
		private function clearData():void {
			label_ti.text = "";
			distance_ti.text = "";
		}
		
		private function onAudioInfo(response:Object):void {
			label_ti.text = response.label;
		}
		
		override protected function createGUI():void {
			super.createGUI();
			
			item_list.height -= 60;
			
			var addAudio_btn:PushButton = new PushButton(_body, item_list.x, item_list.y + item_list.height + 5, "+", onAddAudioBtn);
			addAudio_btn.width = 20;
			
			var maxLabelWidth:Number = 77;
			
			var label_lbl:BuilderLabel = new BuilderLabel(_body, item_list.x + item_list.width + 20, 10, "Label: ");
			label_lbl.width = maxLabelWidth;
			label_lbl.textAlign = "right";
			label_ti = new InputText(_body, label_lbl.x + label_lbl.width + 5, label_lbl.y);
			
			var distance_lbl:BuilderLabel = new BuilderLabel(_body, item_list.x + item_list.width + 20, label_lbl.y + 30, "Distance: ");
			distance_lbl.width = maxLabelWidth;
			distance_lbl.textAlign = "right";
			distance_ti = new InputText(_body, distance_lbl.x + distance_lbl.width + 5, distance_lbl.y);
			
			var browse_btn:PushButton = new PushButton(_body, label_ti.x + label_ti.width + 10, label_ti.y, _("Browse"), onBrowseBtn);
			
			var save_btn:PushButton = new PushButton(_body, _width * 0.5, distance_ti.y + 30, "Save", onSaveBtn);
			save_btn.x -= save_btn.width * 0.5;
		}
		
		private function onBrowseBtn(e:MouseEvent):void {
			audio_fr = new FileReference();
			audio_fr.addEventListener(Event.SELECT, onFileSelect);
			var fileFilter:FileFilter = new FileFilter("Audio file", "*.mp3;*.wav");
			audio_fr.browse([fileFilter]);
		}
		
		private function onFileSelect(e:Event):void {
			label_ti.text = FileReference(e.currentTarget).name;
		}
		
		private function onAddAudioBtn(e:MouseEvent):void {
			item_list.addItemAt({id: 0, label: "New audio"}, 0);
			item_list.selectedIndex = 0;
		}
		
		private function onSaveBtn(e:MouseEvent):void {
			if (audio_fr == null) {
				if (item_list.selectedItem.id == 0) {
					WindowManager.instance.dispatchMessage("Select audio file to upload.");
					return;
				}
				var amfphp:AMFPHP = new AMFPHP(onAudioUpdate).xcall("dm.Audio.updateAudio", item_list.selectedItem.id, label_ti.text, distance_ti.text, MyManager.instance.id);
			} else {
				var request:URLRequest = new URLRequest("http://vds000004.hosto.lt/dm/uploadAudio.php?id=" + item_list.selectedItem.id + "&label=" + label_ti.text + "&distance=" + distance_ti.text + "&userid=" + MyManager.instance.id);
				audio_fr.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, onUpload);
				audio_fr.upload(request);
			}
			
			function onAudioUpdate(response:Object):void {
				refreshAudioList();
			}
		}
		
		private function onUpload(e:DataEvent):void {
			trace("File uploaded");
			trace(e.data);
		}
		
		private function onAudioSaved(response:Object):void {
			refreshAudioList();
		}
	
	}

}