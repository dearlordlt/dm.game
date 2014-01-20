package dm.game.systems.render {
	
	import dm.game.systems.CameraManager;
	import flare.core.Particle3D;
	import flare.core.ParticleEmiter3D;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class CustomParticle extends Particle3D {
		
		private var _fallSpeed:int;
		
		public function CustomParticle(fallSpeed:int) {
			_fallSpeed = fallSpeed;
		}
		
		override public function init(emiter:ParticleEmiter3D):void {
			x = randRange(CameraManager.instance.camera.x - 1000, CameraManager.instance.camera.x + 1000);
			z = randRange(CameraManager.instance.camera.z - 1000, CameraManager.instance.camera.z + 1000);
			y = CameraManager.instance.camera.y + 500;
		}
		
		override public function update(time:Number):void {
			y -= _fallSpeed;
		}
		
		override public function clone():Particle3D {
			return new CustomParticle(_fallSpeed);
		}
		
		private function randRange(minNum:Number, maxNum:Number):Number {
			return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
		}
	
	}

}