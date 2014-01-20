package dm.game.components {
	import flare.core.Pivot3D;
	import flare.physics.core.AvatarController;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author
	 */
	public class InputController implements IComponent {
		
		private var _avatarController:AvatarController;
		
		public function InputController(skin:Pivot3D) {
			_avatarController = new AvatarController();
			_avatarController.restitution = 0;
			_avatarController.friction = 0;		
			
			this.skin = skin;
			
			var matrix:Matrix3D = new Matrix3D();
			matrix.appendTranslation(0, -_avatarController.collisionPrimitive.boundingSphere, 0);
			matrix.appendRotation(180, new Vector3D(0, 1, 0));
			_avatarController.initialTransformation = matrix;
		}
		
		public function get avatarController():AvatarController {
			return _avatarController;
		}
		
		public function get id():int {
			return 0;
		}
		
		public function get componentType():String {
			return "InputController";
		}
		
		public function set skin(skin:Pivot3D):void {
			if (_avatarController.skin)
				_avatarController.skin.removeComponent(_avatarController);
			skin.addComponent(_avatarController);
		}
		
		public function destroy():void {			
			
		}
	}

}