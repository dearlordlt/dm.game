package dm.builder.interfaces.components {
	
	import com.bit101.components.CheckBox;
	import com.bit101.components.InputText;
	import com.bit101.components.PushButton;
	import dm.builder.interfaces.BuilderLabel;
	import dm.builder.interfaces.BuilderMessage;
	import dm.builder.interfaces.BuilderWindow;
	import dm.game.components.Light;
	import dm.game.managers.EntityManager;
	import flare.core.Pivot3D;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import net.richardlord.ash.core.Entity;
	import ucc.ui.window.WindowsManager;
	import utils.AMFPHP;
	
	/**
	 * ...
	 * @author
	 */
	public class LightView extends BuilderWindow {
		
		private var x_ti:InputText;
		private var y_ti:InputText;
		private var z_ti:InputText;
		private var rotationX_ti:InputText;
		private var rotationY_ti:InputText;
		private var rotationZ_ti:InputText;
		
		private var _light:Light;
		
		public function LightView(parent:DisplayObjectContainer, light:Light) {
			_light = light;
			super(parent, "_light.light3d3D", 210, 150);
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function initialize():void {
			super.initialize();
			displayProperties();
			_light.light3d.addEventListener(Pivot3D.UPDATE_TRANSFORM_EVENT, onTransformChange);
		}
		
		override protected function createGUI():void {
			var hint_lbl:BuilderLabel = new BuilderLabel(_body, 5, 5, "Press 'V' to move _light.light3d to mouse position");
			hint_lbl.width = _width - 10;
			
			var x_lbl:BuilderLabel = new BuilderLabel(_body, 5, 50, "X: ");
			x_ti = new InputText(_body, x_lbl.x + x_lbl.textWidth + 5, x_lbl.y, "", onPropertiesChange);
			x_ti.width = 50;
			x_ti.maxChars = 5;
			x_ti.restrict = "0-9"
			
			var y_lbl:BuilderLabel = new BuilderLabel(_body, x_lbl.x, x_lbl.y + 20, "Y: ");
			y_ti = new InputText(_body, y_lbl.x + y_lbl.textWidth + 5, y_lbl.y, "", onPropertiesChange);
			y_ti.width = 50;
			y_ti.maxChars = 5;
			y_ti.restrict = "-0-9"
			
			var z_lbl:BuilderLabel = new BuilderLabel(_body, y_lbl.x, y_lbl.y + 20, "Z: ");
			z_ti = new InputText(_body, z_lbl.x + z_lbl.textWidth + 6, z_lbl.y, "", onPropertiesChange);
			z_ti.width = 50;
			z_ti.maxChars = 5;
			z_ti.restrict = "0-9"
			
			var rotationX_lbl:BuilderLabel = new BuilderLabel(_body, x_ti.x + x_ti.width + 10, x_ti.y, "rotationX: ");
			rotationX_ti = new InputText(_body, rotationX_lbl.x + rotationX_lbl.textWidth + 5, rotationX_lbl.y, "", onPropertiesChange);
			rotationX_ti.width = 50;
			rotationX_ti.maxChars = 5;
			rotationX_ti.restrict = "0-9"
			
			var rotationY_lbl:BuilderLabel = new BuilderLabel(_body, y_ti.x + y_ti.width + 10, y_ti.y, "rotationY: ");
			rotationY_ti = new InputText(_body, rotationY_lbl.x + rotationY_lbl.textWidth + 5, rotationY_lbl.y, "", onPropertiesChange);
			rotationY_ti.width = 50;
			rotationY_ti.maxChars = 5;
			rotationY_ti.restrict = "0-9"
			
			var rotationZ_lbl:BuilderLabel = new BuilderLabel(_body, z_ti.x + z_ti.width + 10, z_ti.y, "rotationZ: ");
			rotationZ_ti = new InputText(_body, rotationZ_lbl.x + rotationZ_lbl.textWidth + 6, rotationZ_lbl.y, "", onPropertiesChange);
			rotationZ_ti.width = 50;
			rotationZ_ti.maxChars = 5;
			rotationZ_ti.restrict = "0-9"
			
			close_btn.addEventListener(MouseEvent.CLICK, onCloseBtn1, false, 1);
		}
		
		private function onPropertiesChange(e:Event):void {
			trace("_light.light3d3DView.onPropertiesChange()");
			_light.light3d.removeEventListener(Pivot3D.UPDATE_TRANSFORM_EVENT, onTransformChange);
			
			if (!isNaN(Number(y_ti.text))) {
				_light.light3d.setPosition(Number(x_ti.text), Number(y_ti.text), Number(z_ti.text));
			}
			_light.light3d.setRotation(Number(rotationX_ti.text), Number(rotationY_ti.text), Number(rotationZ_ti.text));
			
			_light.light3d.addEventListener(Pivot3D.UPDATE_TRANSFORM_EVENT, onTransformChange);
		}
		
		public function displayProperties():void {
			x_ti.text = _light.light3d.x.toString();
			y_ti.text = _light.light3d.y.toString();
			z_ti.text = _light.light3d.z.toString();
			rotationX_ti.text = _light.light3d.getRotation().x.toString();
			rotationY_ti.text = _light.light3d.getRotation().y.toString();
			rotationZ_ti.text = _light.light3d.getRotation().z.toString();
		}
		
		private function onTransformChange(e:Event):void {
			displayProperties();
		}
		
		private function onCloseBtn1(e:MouseEvent):void {
			close_btn.removeEventListener(MouseEvent.CLICK, onCloseBtn1);
			close_btn.removeEventListener(MouseEvent.CLICK, onCloseBtn);
			_light.light3d.removeEventListener(Pivot3D.UPDATE_TRANSFORM_EVENT, onTransformChange);
			EntityManager.instance.currentEntity.remove(Light);
		}
	}
}