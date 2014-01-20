package dm.builder.interfaces.tools {
	import com.bit101.components.HSlider;
	import com.bit101.components.HUISlider;
	import dm.builder.Builder;
	import dm.builder.interfaces.BuilderLabel;
	import dm.builder.interfaces.BuilderWindow;
	import flare.core.Camera3D;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class CameraSettings extends BuilderWindow {
		
		private var _camera:Camera3D;
		private var fov_sldr:HSlider;
		private var zoom_sldr:HSlider;
		
		public function CameraSettings(parent:DisplayObjectContainer) {
			_camera = Builder.world.scene.camera;
			super(parent, "Camera settings", 200, 70);
		}
		
		override protected function createGUI():void {
			var zoom_lbl:BuilderLabel = new BuilderLabel(_body, 10, 10, "Zoom: ");
			zoom_lbl.width = zoom_lbl.textWidth + 5;
			zoom_lbl.textAlign = "right";
			zoom_sldr = new HSlider(_body, zoom_lbl.x + zoom_lbl.textWidth + 10, zoom_lbl.y + 3, onZoomChange);
			zoom_sldr.minimum = 0;
			zoom_sldr.maximum = 50;
			zoom_sldr.value = _camera.zoom;
			
			var fov_lbl:BuilderLabel = new BuilderLabel(_body, zoom_lbl.x, zoom_lbl.y + 20, "FOV: ");
			fov_lbl.width = zoom_lbl.width;
			fov_lbl.textAlign = "right";
			fov_sldr = new HSlider(_body, zoom_sldr.x, fov_lbl.y + 3, onFovChange);
			fov_sldr.minimum = 0;
			fov_sldr.maximum = 180;
			fov_sldr.value = _camera.fieldOfView;
		}
		
		private function onZoomChange(e:Event):void {
			trace(_camera.zoom + " / " + zoom_sldr.value);
			_camera.zoom = zoom_sldr.value;			
		}
		
		private function onFovChange(e:Event):void {
			_camera.fieldOfView = fov_sldr.value;
		}
	
	}

}