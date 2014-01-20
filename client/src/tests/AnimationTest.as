package tests {
	import com.bit101.components.PushButton;
	import flare.basic.Scene3D;
	import flare.core.Camera3D;
	import flare.core.Particle3D;
	import flare.core.ParticleEmiter3D;
	import flare.core.Pivot3D;
	import flare.core.Texture3D;
	import flare.loaders.Flare3DLoader1;
	import flare.materials.filters.ColorFilter;
	import flare.materials.filters.TextureFilter;
	import flare.materials.ParticleMaterial3D;
	import flare.materials.Shader3D;
	import flare.primitives.Sphere;
	import flare.utils.Pivot3DUtils;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class AnimationTest extends Sprite {
		
		private var sceneContainer:Sprite
		private var _scene:Scene3D;
		private var legs:Pivot3D;
		private var anim:Pivot3D;
		
		private var sphere:Sphere;
		private var angle:int = 0;
		private var particleEmitter:ParticleEmiter3D;
		
		public function AnimationTest() {
			sceneContainer = new Sprite();
			addChild(sceneContainer);
			
			//addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			_scene = new Scene3D(sceneContainer);
			_scene.autoResize = true;
			_scene.camera = new Camera3D();
			_scene.camera.z = -300;
			_scene.addEventListener(Event.REMOVED_FROM_STAGE, onSceneRemove);
			
			//_scene.registerClass(Flare3DLoader1);
			
			var mat:Shader3D = new Shader3D();
			var tf:TextureFilter = new TextureFilter(new Texture3D("assets/textures/serious.png"));
			var cf:ColorFilter = new ColorFilter(0x00FF00);
			tf.repeatX = 1;
			tf.repeatY = 1;
			mat.filters = [cf, tf];
			
			sphere = new Sphere("sphere", 10);
			sphere.setMaterial(mat);
			_scene.addChild(sphere);
			
			var texture:Texture3D = _scene.addTextureFromFile("drop.png");
			var particleMaterial:ParticleMaterial3D = new ParticleMaterial3D("", [new TextureFilter(texture)]);
			particleMaterial.build();
			particleEmitter = new ParticleEmiter3D("rain", particleMaterial, new MyParticle());
			particleEmitter.emitParticlesPerFrame = 20;
			particleEmitter.particlesLife = 50;
			_scene.addChild(particleEmitter);

			
			//legs = _scene.addChildFromFile("palace.f3d");
			//anim = _scene.addChildFromFile("assets/anim.f3d");
			
			_scene.addEventListener(Scene3D.COMPLETE_EVENT, onSceneComplete);
			_scene.addEventListener(Scene3D.UPDATE_EVENT, onSceneUpdate);
			
			var kill_btn:PushButton = new PushButton(this, 0, 0, "kill", onClick);
		
		}
		
		private function onSceneUpdate(e:Event):void {
			//trace("sup");
			particleEmitter.update();
		}
		
		private function onClick(e:MouseEvent):void {
			angle += 30;
			sphere.setRotation(0, angle, 0);
			trace("Angle: " + angle + " | Rotation: " + sphere.getRotation().y);
		}
		
		private function onEnterFrame(e:Event):void {
			angle++;
			sphere.setRotation(0, angle, 0);
			trace("Angle: " + angle + " | Rotation: " + sphere.getRotation().y);
		}
		
		private function onSceneComplete(e:Event):void {
			//Pivot3DUtils.appendAnimation(legs, anim);
			//legs.play();
		}
		
		private function onSceneRemove(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, onSceneRemove);
			removeChild(sceneContainer);
		}
		
		private function onKillBtn(e:MouseEvent):void {
			_scene.dispose();
		}
	
	}

}