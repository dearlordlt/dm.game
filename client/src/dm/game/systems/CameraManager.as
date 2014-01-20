package dm.game.systems {
	
	import flare.core.Camera3D;
	import flare.core.Pivot3D;
	import flare.utils.Pivot3DUtils;
	import flash.geom.Vector3D;
	import net.richardlord.ash.core.System;
	
	/**
	 * ...
	 * @author
	 */
	public class CameraManager extends System {
		
		public static const MODE_IDLE:int = 0;
		public static const MODE_FOLLOW:int = 1;
		
		public var camera:Camera3D;
		private var _mode:int;
		private var _followTarget:Pivot3D;
		
		private static var _allowInstantiation:Boolean = false;
		private static var _instance:CameraManager;
		
		public function CameraManager() {
			if (!_allowInstantiation)
				throw(new Error("Use 'instance' property to get an instance"));
		}
		
		public static function get instance():CameraManager {
			if (!_instance) {
				_allowInstantiation = true;
				_instance = new CameraManager();
				_allowInstantiation = false;
			}
			return _instance;
		}
		
		public function follow(target:Pivot3D):void {
			_followTarget = target;
			_mode = MODE_FOLLOW;
		}
		
		public function idle():void {
			_mode = MODE_IDLE;
		}
		
		override public function update(time:Number):void {
			switch (_mode) {
				case MODE_FOLLOW: 
					//Pivot3DUtils.setPositionWithReference(_camera, 0, 7 * Pivot3DUtils.getBounds(_followTarget).radius, 10 * Pivot3DUtils.getBounds(_followTarget).radius, _followTarget, 0.1)
					//Pivot3DUtils.lookAtWithReference(_camera, 0, 1.75 * Pivot3DUtils.getBounds(_followTarget).radius, 0, _followTarget, new Vector3D(0, 1, 0), 0.5);
					Pivot3DUtils.lookAtWithReference(camera, 0, 100, 0, _followTarget, new Vector3D(0, 1, 0), 0.1);
					Pivot3DUtils.setPositionWithReference(camera, 0, 200, 300, _followTarget, 0.1);					
					break;
				case MODE_IDLE: 
					break;
			}
		}
	
	}

}