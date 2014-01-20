package dm.builder.interfaces.tools.solidobjecteditor {
	import dm.builder.interfaces.map.World3D;
	import flare.basic.Scene3D;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author
	 */
	public class SolidObjectEditorWorld extends World3D {
		
		public function SolidObjectEditorWorld(parent:DisplayObjectContainer, viewPortWidth:Number, viewPortHeight:Number, viewPortXPos:Number = 0, viewPortYPos:Number = 0) {
			super(parent, viewPortWidth, viewPortHeight, viewPortXPos, viewPortYPos);
			_scene.autoResize = false;
		}
		
		override protected function onSceneComplete(e:Event):void {
			
			//_scene.addEventListener(Scene3D.UPDATE_EVENT, onSceneUpdate);
			
			_scene.camera.x = -800;
			_scene.camera.y = 1000;
			_scene.camera.z = -4000;
			_scene.camera.rotateY(10);
			_scene.camera.fieldOfView = 40;
			//_scene.addChildFromFile("assets/buildings/test.f3d");
		}
	
	}

}