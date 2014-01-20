package dm.game.systems {
	
	import dm.game.components.AvatarLabel;
	import dm.game.components.Skin3D;
	import dm.game.managers.EntityManager;
	import dm.game.nodes.AvatarLabelNode;
	import flare.basic.Scene3D;
	import flare.core.Pivot3D;
	import flare.core.Texture3D;
	import flare.materials.filters.AlphaMaskFilter;
	import flare.materials.filters.ColorFilter;
	import flare.materials.filters.TextureFilter;
	import flare.materials.Shader3D;
	import flare.primitives.Plane;
	import flare.utils.Pivot3DUtils;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import net.richardlord.ash.core.Entity;
	import net.richardlord.ash.core.Game;
	import net.richardlord.ash.core.NodeList;
	import net.richardlord.ash.core.System;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class Element2DPlacementSystem extends System {
		
		private var _avatarLabelNodes:NodeList;
		private var _displayContainer:DisplayObjectContainer;
		private var _scene:Scene3D;
		
		private var currentLabelColor:uint = 0xFFFFFF;
		
		public static var avatarWalkSpeed:Number = 100;
		public static var avatarRotationSpeed:Number = 5;
		
		public function Element2DPlacementSystem(displayContainer:DisplayObjectContainer, scene:Scene3D) {
			_displayContainer = displayContainer;
			EntityManager.instance.componentAddedSignal.add(onComponentAdded);
			_scene = scene;
		}
		
		private function onComponentAdded(entity:Entity, componentClass:Class):void {
			if (componentClass == AvatarLabel) {
				var avatarLabel:AvatarLabel = AvatarLabel(entity.get(AvatarLabel));
				var skin:Pivot3D = Skin3D(entity.get(Skin3D)).skin;
				if (skin != null) {
					var tf:TextField = new TextField();
					tf.text = avatarLabel.label;
					currentLabelColor = avatarLabel.color;
					tf.setTextFormat(textFormat);
					tf.width = tf.textWidth + 5;
					tf.height = tf.textHeight + 5;
					var bmData:BitmapData = new BitmapData(tf.width, tf.height, true, 0);
					bmData.draw(tf, null, null, null, null, true);
					var texture:Texture3D = new Texture3D(bmData);
					var shader:Shader3D = new Shader3D("", [new TextureFilter(texture), new AlphaMaskFilter()]);
					var namePlane:Plane = new Plane("", bmData.width * 0.5, bmData.height * 0.5, 1, shader);
					avatarLabel.namePlane = namePlane;
					//namePlane.y = Pivot3DUtils.getBounds(skin).radius * 2;
					_scene.addChild(namePlane);
					trace(namePlane.x);
					//_displayContainer.addChild(tf);
				} else
					throw new Error("Entity has 'AvatarLabel' component, but doesn't have skin");
			}
		}
		
		override public function addToGame(game:Game):void {
			_avatarLabelNodes = game.getNodeList(AvatarLabelNode);
		}
		
		override public function update(time:Number):void {
			for (var avatarLabelNode:AvatarLabelNode = _avatarLabelNodes.head; avatarLabelNode; avatarLabelNode = avatarLabelNode.next) {
				if (avatarLabelNode.skin3d.skin != null) {
					/*avatarLabelNode.avatarLabel.tf.x = avatarLabelNode.skin3d.skin.getScreenCoords().x;
					 avatarLabelNode.avatarLabel.tf.y = avatarLabelNode.skin3d.skin.getScreenCoords().y - 10;*/
					avatarLabelNode.avatarLabel.namePlane.x = avatarLabelNode.skin3d.skin.x;
					avatarLabelNode.avatarLabel.namePlane.z = avatarLabelNode.skin3d.skin.z;
					avatarLabelNode.avatarLabel.namePlane.y = Pivot3DUtils.getBounds(avatarLabelNode.skin3d.skin).radius * 2;
					avatarLabelNode.avatarLabel.namePlane.setRotation(_scene.camera.getRotation().x, _scene.camera.getRotation().y, _scene.camera.getRotation().z);
				}
				
			}
		}
		
		private function get textFormat():TextFormat {
			var textFormat:TextFormat = new TextFormat();
			textFormat.color = currentLabelColor;
			textFormat.size = 32;
			textFormat.font = "HelvNeueCondDDB";
			return textFormat;
		}
	}

}