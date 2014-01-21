package  
{
	import flare.basic.*;
	import flare.core.*;
	import flare.loaders.*;
	import flare.primitives.*;
	import flare.system.*;
	import flash.display.*;
	import flash.events.*;
	
	[SWF( width = 800, height = 450, frameRate = 60 )]
	
	/**
	 * @author Ariel Nehmad
	 */
	public class Test36_CubeMapLighting extends Sprite 
	{
		private var scene:Scene3D;
		
		public function Test36_CubeMapLighting() 
		{
			scene = new Viewer3D(this, null, 0.2 );
			scene.registerClass( ZF3DLoader );
			scene.autoResize = true;
			scene.antialias = 2;
			
			scene.camera = new Camera3D();
			scene.camera.setPosition( -80, 80, 80 );
			scene.camera.lookAt( 0, 0, 0 );
			
			scene.lights.defaultLight = null;
			scene.lights.maxDirectionalLights = 0;
			scene.lights.maxPointLights = 0;
			scene.lights.ambientColor.setTo( 0, 0, 0 );
			
			// cubemap lighting works even in NO_LIGHTS mode and provides a super fast
			// approach for static lighting, specially for mobile devices.
			// cubeMap can be used with normal maps and could be used to emulate
			// indirect global skybox lighting.
			scene.lights.cubeMap = new Texture3D( "cubemap18.png", false, Texture3D.FORMAT_CUBEMAP );
			
			scene.addChildFromFile( "teapot2.zf3d" );
			scene.addEventListener( Scene3D.UPDATE_EVENT, updateEvent );
		}
		
		private function updateEvent(e:Event):void 
		{
			if ( Input3D.keyHit( Input3D.NUMBER_1 ) ) {
				trace( "------------------" );
				scene.lights.maxDirectionalLights = 0;
				scene.lights.maxPointLights = 0;
			}
			if ( Input3D.keyHit( Input3D.NUMBER_2 ) ) {
				trace( "------------------" );
				scene.lights.maxDirectionalLights = 0;
				scene.lights.maxPointLights = 1;
			}
			if ( Input3D.keyHit( Input3D.NUMBER_3 ) ) {
				trace( "------------------" );
				scene.lights.maxDirectionalLights = 1;
				scene.lights.maxPointLights = 1;
			}
		}
	}
}