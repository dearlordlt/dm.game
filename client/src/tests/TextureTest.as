package tests {
	import com.bit101.components.CheckBox;
	import com.bit101.components.ColorChooser;
	import com.bit101.components.PushButton;
	import flare.basic.Scene3D;
	import flare.core.Camera3D;
	import flare.core.Pivot3D;
	import flare.core.Texture3D;
	import flare.loaders.Flare3DLoader1;
	import flare.materials.filters.ColorFilter;
	import flare.materials.filters.NormalMapFilter;
	import flare.materials.filters.SpecularMapFilter;
	import flare.materials.filters.TextureFilter;
	import flare.materials.Shader3D;
	import flare.primitives.Sphere;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class TextureTest extends Sprite {
		private var _scene:Scene3D;
		private var sceneContainer:Sprite;
		private var top:Pivot3D;
		private var head:Pivot3D
		private var head_cp:ColorChooser;
		private var diff_cb:CheckBox;
		private var nm_cb:CheckBox;
		private var sm_cb:CheckBox;
		;
		
		public function TextureTest() {
			sceneContainer = new Sprite();
			addChild(sceneContainer);
			
			var guiLayer:Sprite = new Sprite();
			addChild(guiLayer);
			head_cp = new ColorChooser(guiLayer, 10, 10, 0, onChange);
			head_cp.usePopup = true;
			
			diff_cb = new CheckBox(guiLayer, head_cp.x + head_cp.width + 10, head_cp.y, "diff", onChange);
			nm_cb = new CheckBox(guiLayer, diff_cb.x + diff_cb.width + 5, head_cp.y, "nm", onChange);
			sm_cb = new CheckBox(guiLayer, nm_cb.x + nm_cb.width + 5, head_cp.y, "sm", onChange);
			
			_scene = new Scene3D(sceneContainer);
			_scene.autoResize = true;
			_scene.camera = new Camera3D();
			_scene.camera.z = -200;
			_scene.camera.y = 150;
			_scene.addEventListener(Event.REMOVED_FROM_STAGE, onSceneRemove);
			_scene.addEventListener(Scene3D.COMPLETE_EVENT, onSceneComplete);
			
			_scene.registerClass(Flare3DLoader1);
			_scene.registerClass(SpecularMapFilter);
			
			/*var sphere:Sphere = new Sphere("sphere", 10);
			   sphere.setMaterial(mat);
			 _scene.addChild(sphere);*/
			//top = _scene.addChildFromFile("top.f3d") as Pivot3D;
			head = _scene.addChildFromFile("head.f3d") as Pivot3D;
		
		}
		
		private function onChange(e:Event):void {
			update();
		}
		
		private function update():void {
			/*
			var mat:Shader3D = new Shader3D();
			var nmf:NormalMapFilter = new NormalMapFilter(new Texture3D("head_nml.png"));
			var tf:TextureFilter = new TextureFilter(new Texture3D("head.png"));
			var cf:ColorFilter = new ColorFilter(head_cp.value);
			var smf:SpecularMapFilter = new SpecularMapFilter(new Texture3D("head_spm.png"));
			//tf1.repeatX = 1;
			//tf1.repeatY = 1;
			mat.filters = [cf];
			
			if (diff_cb.selected)
				mat.filters.push(tf);
			if (nm_cb.selected)
				mat.filters.push(nmf);
			if (sm_cb.selected)
				mat.filters.push(smf);
			
			head.setMaterial(mat);
			*/
		}
		
		private function onSceneComplete(e:Event):void {
			
		}
		
		private function onSceneRemove(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, onSceneRemove);
			removeChild(sceneContainer);
		}
	
	}

}