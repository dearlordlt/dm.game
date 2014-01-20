package dm.builder.interfaces.tools.custombuildingeditor {
	
	import dm.builder.interfaces.map.World3D;
	import flare.basic.Scene3D;
	import flare.core.Pivot3D;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author
	 */
	public class CustomBuildingEditorWorld extends World3D {
		
		private var _floor1:Pivot3D;
		private var _floorN:Pivot3D;
		private var _balconies:Vector.<Pivot3D> = new Vector.<Pivot3D>();
		/*
		   public var spinX:Number = 0;
		   public var spinY:Number = 0;
		   public var distance:Number = -1000;
		   public var lookAt:Pivot3D = new Pivot3D();
		   public var target:Pivot3D;
		
		 */
		
		private var _building:Pivot3D;
		
		public function CustomBuildingEditorWorld(parent:DisplayObjectContainer, viewPortWidth:Number, viewPortHeight:Number, viewPortXPos:Number = 0, viewPortYPos:Number = 0) {			
			super(parent, viewPortWidth, viewPortHeight, viewPortXPos, viewPortYPos);
			_scene.autoResize = false;
		}
		
		override protected function onSceneComplete(e:Event):void {
			
			_scene.addEventListener(Scene3D.UPDATE_EVENT, onSceneUpdate);
			
			_scene.camera.x = -500;
			_scene.camera.y = 1000;
			_scene.camera.z = -4000;
			_scene.camera.rotateY(20);
			_scene.camera.fieldOfView = 40;
			
			update("aparth_a", 1)
		}
		
		public function update(type:String, floorNum:int):void {
			try {
				_scene.removeChild(_building)
			} catch (e:Error) {}
			_building = CustomBuildingFactory.build(_scene.library, type, floorNum);
			_scene.addChild(_building);
		}
		
		private function onSceneUpdate(e:Event):void {
		
		}
		
		public function get building():Pivot3D {
			return _building;
		}
	
	}

}