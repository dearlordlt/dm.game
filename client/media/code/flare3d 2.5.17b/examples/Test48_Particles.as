package  
{
	import flare.basic.*;
	import flare.core.*;
	import flare.materials.*;
	import flare.primitives.*;
	import flare.system.*;
	import flash.display.*;
	import flash.display3D.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	[SWF(frameRate = 60, width = 800, height = 450, backgroundColor = 0x000000)]
	
	/**
	 * @author Ariel Nehmad
	 */
	public class Test48_Particles extends Sprite 
	{
		private var scene:Scene3D;
		private var particles:Particles3D;
		private var cloned:Particles3D;
		
		public function Test48_Particles() 
		{
			scene = new Viewer3D( this );
			scene.camera.setPosition( 0, 100, -120 );
			scene.camera.lookAt( 0, 0, 0 );
			scene.autoResize = true;
			scene.skipFrames = false;
			
			particles = new Particles3D();
			particles.texture = new Texture3D( "smoke_particle.png" );
			particles.parent = scene;
			particles.setColors( [0xffffff, 0xff0000], [0, 255] );
			particles.randomSpin = 20;
			particles.endSize = new Point();
			particles.worldPositions = true;
			particles.worldVelocities = true;
			particles.addChild( new Cube("", 5, 5, 5 ) );
			
			cloned = particles.clone() as Particles3D;
			cloned.setColors( [0xffff00], [0] );
			cloned.blendMode = Particles3D.BLEND_SCREEN;
			cloned.duration = 0.5;
			cloned.loops = 1;
			cloned.randomVelocity = 100;
			cloned.velocity = new Vector3D( 0, 100, 0 );
			cloned.gravity = new Vector3D( 0, -50, 0 );
			cloned.delay = 0.5;
			cloned.x = -50;
			cloned.parent = scene;
			
			scene.addEventListener( Scene3D.UPDATE_EVENT, updateEvent );
		}
		
		private function updateEvent(e:Event):void 
		{
			if ( Input3D.keyHit( Input3D.SPACE ) )
				cloned.start();
				
			if ( Input3D.keyDown( Input3D.A ) )
				cloned.x -= 3;
			if ( Input3D.keyDown( Input3D.D ) )
				cloned.x += 3;
			if ( Input3D.keyDown( Input3D.W ) )
				cloned.z += 3;
			if ( Input3D.keyDown( Input3D.S ) )
				cloned.z -= 3;
				
			if ( Input3D.keyDown( Input3D.LEFT ) )
				particles.x -= 3;
			if ( Input3D.keyDown( Input3D.RIGHT ) )
				particles.x += 3;
			if ( Input3D.keyDown( Input3D.UP ) )
				particles.z += 3;
			if ( Input3D.keyDown( Input3D.DOWN ) )
				particles.z -= 3;
		}
	}
}