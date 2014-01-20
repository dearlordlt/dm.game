package dm.builder.interfaces.components {
	
	import com.bit101.components.CheckBox;
	import com.bit101.components.InputText;
	import com.bit101.components.PushButton;
	import dm.builder.interfaces.BuilderLabel;
	import dm.builder.interfaces.BuilderMessage;
	import dm.builder.interfaces.BuilderWindow;
	import dm.game.components.Skin3D;
	import dm.game.managers.EntityManager;
	import dm.game.systems.render.SkinFactory;
	import dm.game.systems.render.SkinRecipient;
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
	public class Skin3DView extends BuilderWindow implements SkinRecipient {
		
		private var x_ti:InputText;
		private var y_ti:InputText;
		private var z_ti:InputText;
		private var rotationX_ti:InputText;
		private var rotationY_ti:InputText;
		private var rotationZ_ti:InputText;
		private var hasCollision_cb:CheckBox;
		
		private var _skinInfoToEntity:Dictionary = new Dictionary();
		
		private var _skin3d:Skin3D;
		
		public function Skin3DView(parent:DisplayObjectContainer, skin3d:Skin3D) {
			_skin3d = skin3d;
			super(parent, "Skin3D", 210, 150);
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function initialize():void {
			super.initialize();
			
			if (!skin3d.enabled)
				close_btn.visible = false;
			
			//trace("Skin3DView.initialize()");
			if (skin == null) {
				createDummy();
				var select_btn:PushButton = new PushButton(_dummy, 0, 0, "Select skin", onSelectSkinBtn);
				select_btn.x = _width * 0.5 - select_btn.width * 0.5;
				select_btn.y = bodyHeight * 0.5 - select_btn.height * 0.5;
			} else {
				//trace("Skin3DView.initialize(): skin != null");
				displayProperties();
				skin.addEventListener(Pivot3D.UPDATE_TRANSFORM_EVENT, onSkinTransformChange);
				if (skin3d.skin.userData != null)
					label = "Skin3D: " + skin.userData.label;
			}
		
		}
		
		override protected function createGUI():void {
			var hint_lbl:BuilderLabel = new BuilderLabel(_body, 5, 5, "Press 'V' to move skin to mouse position");
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
			trace("Skin3DView.onPropertiesChange()");
			skin.removeEventListener(Pivot3D.UPDATE_TRANSFORM_EVENT, onSkinTransformChange);
			
			if (!isNaN(Number(y_ti.text))) {
				skin.setPosition(Number(x_ti.text), Number(y_ti.text), Number(z_ti.text));
			}
			skin.setRotation(Number(rotationX_ti.text), Number(rotationY_ti.text), Number(rotationZ_ti.text));
			
			skin.addEventListener(Pivot3D.UPDATE_TRANSFORM_EVENT, onSkinTransformChange);
		}
		
		private function onSelectSkinBtn(e:MouseEvent):void {
			SelectSkin3D(WindowsManager.getInstance().createWindow(SelectSkin3D)).skin3dSelectedSignal.add(onSkinSelected);
		}
		
		private function onSkinSelected(minSkinInfo:Object):void {
			createDummy();
			var amfphp:AMFPHP = new AMFPHP(onFullSkinInfo).xcall("dm.Skin3D.getSkinById", minSkinInfo.id);
		}
		
		private function onFullSkinInfo(fullSkinInfo:Object):void {
			_skinInfoToEntity[fullSkinInfo] = EntityManager.instance.currentEntity;
			SkinFactory.createSkin(fullSkinInfo, this);
		}
		
		public function receive(skin:Pivot3D, skinInfo:Object):void {
			// TODO: Check multiple createSkin simultainiously
			var entity:Entity = _skinInfoToEntity[skinInfo] as Entity;
			delete _skinInfoToEntity[skinInfo];
			entity.add(new Skin3D(skin));
			new BuilderMessage(parent, "Message", "Skin sucessfully assigned to entity");
		}
		
		public function displayProperties():void {
			//trace("Skin3DView.displayProperties()");
			x_ti.text = skin.x.toString();
			y_ti.text = skin.y.toString();
			z_ti.text = skin.z.toString();
			rotationX_ti.text = skin.getRotation().x.toString();
			rotationY_ti.text = skin.getRotation().y.toString();
			rotationZ_ti.text = skin.getRotation().z.toString();
			//hasCollision_cb.selected = Boolean(_skin3d.skin.usePhysics);
		}
		
		public function get skin3d():Skin3D {
			return _skin3d;
		}
		
		private function get skin():Pivot3D {
			return _skin3d.skin;
		}
		
		private function onSkinTransformChange(e:Event):void {
			//trace("Skin3DView.onSkinTransformChange()");
			displayProperties();
		}
		
		private function onCloseBtn1(e:MouseEvent):void {
			close_btn.removeEventListener(MouseEvent.CLICK, onCloseBtn1);
			close_btn.removeEventListener(MouseEvent.CLICK, onCloseBtn);
			skin.removeEventListener(Pivot3D.UPDATE_TRANSFORM_EVENT, onSkinTransformChange);
			EntityManager.instance.currentEntity.remove(Skin3D);
		}
	}
}