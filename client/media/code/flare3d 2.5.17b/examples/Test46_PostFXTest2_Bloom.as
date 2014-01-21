package  
{
	import flare.basic.*;
	import flare.core.*;
	import flare.loaders.*;
	import flare.materials.*;
	import flare.flsl.*;
	import flare.primitives.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	[SWF( width = 800, height = 450, frameRate = 60 )]
	
	/**
	 * @author Ariel Nehmad
	 */
	public class Test46_PostFXTest2_Bloom extends Sprite 
	{
		[Embed(source = "../bin/bloom.flsl.compiled", mimeType = "application/octet-stream")]
		private var bloomFilter:Class;
		
		private var scene:Viewer3D;
		private var quad:Quad;
		private var bloomTexture:Texture3D;
		private var bloomMaterial:FLSLMaterial;
		
		public function Test46_PostFXTest2_Bloom() 
		{
			scene = new Viewer3D( this, null, 0.1 );
			scene.registerClass( ZF3DLoader );
			scene.autoResize = true;
			scene.skipFrames = false;
			scene.antialias = 2;
			
			scene.lights.defaultLight = null;
			scene.lights.ambientColor.setTo( 0.6, 0.6, 0.6 );
			
			// creates a dynamic 256x256 texture.
			// we'll render this texture by our own, letting to flare render
			// the scene normally.
			bloomTexture  = new Texture3D( new Point( 256, 256 ), true );
			
			// creates the flsl bloom material..
			bloomMaterial = new FLSLMaterial( "bloom", new bloomFilter );
			bloomMaterial.params.bloomTexture.value = bloomTexture;
			bloomMaterial.params.intensity.value[0] = 3;
			bloomMaterial.params.power.value[0] = 2;
			
			// creates the quad to draw the effect into screen.
			quad = new Quad( "bloom", 0, 0, 0, 0, true, bloomMaterial );
			
			scene.addChildFromFile( "chess.zf3d" );
			scene.addEventListener( Scene3D.COMPLETE_EVENT, completeEvent );
		}
		
		private function completeEvent(e:Event):void 
		{
			scene.addEventListener( Scene3D.POSTRENDER_EVENT, postRenderEvent );
		}
		
		private function postRenderEvent(e:Event):void 
		{
			// after the scene has been rendered, 
			// render the scene again into the small bloom texture.
			scene.render( scene.camera, false, bloomTexture );
			
			// draw and sum the result with the already rendered scene.
			quad.draw();
		}
	}
}