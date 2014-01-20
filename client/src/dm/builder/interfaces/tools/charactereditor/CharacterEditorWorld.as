package dm.builder.interfaces.tools.charactereditor {
	
	import dm.builder.interfaces.map.World3D;
	import flare.basic.Scene3D;
	import flare.core.Pivot3D;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class CharacterEditorWorld extends World3D {
		
		private var _character:Pivot3D;
		
		public function CharacterEditorWorld(parent:DisplayObjectContainer, viewPortWidth:Number, viewPortHeight:Number, viewPortXPos:Number = 0, viewPortYPos:Number = 0) {
			super(parent, viewPortWidth, viewPortHeight, viewPortXPos, viewPortYPos);
			_scene.autoResize = false;
		}
		
		override protected function onSceneComplete(e:Event):void {
			
			_scene.addEventListener(Scene3D.UPDATE_EVENT, onSceneUpdate);
			
			//_scene.camera.x = -500;
			_scene.camera.y = 100;
			_scene.camera.z = -200;
			//_scene.camera.rotateY(20);
			//_scene.camera.fieldOfView = 40;			
		}
		
		public function update(parts:Array):void {
			try {
				_scene.removeChild(_character)
			} catch (e:Error) {
			}
			_character = new Pivot3D("character");
			_scene.addChild(_character);
			
			for each (var partName:String in parts) {
				var part:Pivot3D = _scene.library.getItem(partName) as Pivot3D;
				_character.addChild(part);
			}
		}
		
		private function onSceneUpdate(e:Event):void {
		
		}
		
		public function get character():Pivot3D {
			return _character;
		}
	
	}

}