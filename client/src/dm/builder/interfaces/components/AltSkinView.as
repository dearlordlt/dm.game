package dm.builder.interfaces.components {
	
	import com.bit101.components.List;
	import com.bit101.components.PushButton;
	import dm.builder.interfaces.BuilderLabel;
	import dm.builder.interfaces.BuilderWindow;
	import dm.game.components.AltSkin;
	import dm.game.components.Skin3D;
	import dm.game.managers.EntityManager;
	import dm.game.systems.render.SkinFactory;
	import dm.game.systems.render.SkinRecipient;
	import flare.core.Pivot3D;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import ucc.ui.window.WindowsManager;
	import utils.AMFPHP;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class AltSkinView extends BuilderWindow implements SkinRecipient {
		
		private var _altskin:AltSkin;
		private var skin_list:List;
		
		public function AltSkinView(parent:DisplayObjectContainer, altskin:AltSkin) {
			_altskin = altskin;
			super(parent, "Altering skin", 210, 150);
		}
		
		public override function initialize():void {
			super.initialize();
			
			if (!_altskin.data) {
				createDummy();
				var select_btn:PushButton = new PushButton(_dummy, 0, 0, "Select altering skin", onSelectAltSkinBtn);
				select_btn.x = _width * 0.5 - select_btn.width * 0.5;
				select_btn.y = bodyHeight * 0.5 - select_btn.height * 0.5;
			} else {
				skin_list.items = _altskin.data.skins3d;
				if (!EntityManager.instance.currentEntity.has(Skin3D))
					for each (var item:Object in skin_list.items)
						if (item.is_default == 1) {
							skin_list.selectedItem = item;
							break;
						}
			}
		}
		
		private function onSelectAltSkinBtn(e:MouseEvent):void {
			WindowsManager.getInstance().createWindow(SelectAltSkin);
		}
		
		override protected function createGUI():void {
			var skins_lbl:BuilderLabel = new BuilderLabel(_body, 5, 10, "Skins: ");
			skin_list = new List(_body, skins_lbl.x, skins_lbl.y + 20);
			skin_list.addEventListener(Event.SELECT, onSkinSelect);
			
			close_btn.addEventListener(MouseEvent.CLICK, onCloseBtn1, false, 1);
		}
		
		private function onSkinSelect(e:Event):void {
			var amfphp:AMFPHP = new AMFPHP(onSkinData).xcall("dm.Skin3D.getSkinById", skin_list.selectedItem.id);
		}
		
		private function onSkinData(response:Object):void {
			SkinFactory.createSkin(response, this);
		}
		
		public function receive(skin:Pivot3D, skinInfo:Object):void {
			if (EntityManager.instance.currentEntity.has(Skin3D)) {
				var oldSkin:Pivot3D = Skin3D(EntityManager.instance.currentEntity.get(Skin3D)).skin;
				skin.setPosition(oldSkin.x, oldSkin.y, oldSkin.z);
				skin.setRotation(oldSkin.getRotation().x, oldSkin.getRotation().y, oldSkin.getRotation().z);
			} else {
				var entityData:Object = EntityManager.instance.entityProperties[EntityManager.instance.currentEntity];
				if (entityData) {
					skin.setPosition(entityData.x, entityData.y, entityData.z);
					skin.setRotation(entityData.rotationX, entityData.rotationY, entityData.rotationZ);
					delete EntityManager.instance.entityProperties[EntityManager.instance.currentEntity];
				}
			}
			EntityManager.instance.currentEntity.add(new Skin3D(skin, false));
		}
		
		private function onCloseBtn1(e:MouseEvent):void {
			close_btn.removeEventListener(MouseEvent.CLICK, onCloseBtn1);
			close_btn.removeEventListener(MouseEvent.CLICK, onCloseBtn);
			EntityManager.instance.currentEntity.remove(AltSkin);
			EntityManager.instance.currentEntity.remove(Skin3D);
		}
	
	}

}