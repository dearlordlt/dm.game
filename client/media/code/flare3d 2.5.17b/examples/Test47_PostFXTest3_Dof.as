package  
{
	import flare.basic.*;
	import flare.core.*;
	import flare.loaders.*;
	import flare.materials.*;
	import flare.materials.filters.*;
	import flare.flsl.*;
	import flare.primitives.*;
	import flare.system.*;
	import flash.display.*;
	import flash.display3D.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	[SWF( width = 800, height = 450, frameRate = 60 )]
	
	/**
	 * @author Ariel Nehmad
	 */
	public class Test47_PostFXTest3_Dof extends Sprite 
	{
		[Embed(source = "../bin/dof.flsl.compiled", mimeType = "application/octet-stream")]
		private var fovFilter:Class;
		private var fovData:ByteArray = new fovFilter();
		[Embed(source = "../bin/skybox2b.png", mimeType = "application/octet-stream")] 
		private var skybox:Class;
		
		private var scene:Viewer3D;
		private var quad:Quad;
		
		private var sceneTexture:Texture3D;
		private var depthTexture:Texture3D;
		
		private var depthMaterial:FLSLMaterial;
		private var dofMaterial:FLSLMaterial;
		
		public function Test47_PostFXTest3_Dof() 
		{
			scene = new Viewer3D( this, null, 0.1 );
			scene.registerClass( ZF3DLoader );
			scene.autoResize = true;
			scene.skipFrames = false;			
			scene.antialias = 2;
			
			depthTexture = new Texture3D( new Point( 512, 256 ), true );
			sceneTexture = new Texture3D( new Point( 512, 256 ), true );
			
			depthMaterial = new FLSLMaterial( "dof", fovData, "depth" );
			depthMaterial.params.nearFar.value[0] = 100;
			depthMaterial.params.nearFar.value[1] = 500;
			
			dofMaterial = new FLSLMaterial( "dof", fovData, "dof" );
			dofMaterial.params.sceneTexture.value = sceneTexture;
			dofMaterial.params.depthTexture.value = depthTexture;
			
			quad = new Quad( "depth", 0, 0, 0, 0, true, dofMaterial );
			
			scene.addChildFromFile( "chess2.zf3d" );
			scene.addEventListener( Scene3D.COMPLETE_EVENT, completeEvent );
			scene.addChild( new SkyBox( new skybox ) )
		}
		
		private function completeEvent(e:Event):void 
		{
			scene.addEventListener( Scene3D.UPDATE_EVENT, updateEvent );
			scene.addEventListener( Scene3D.POSTRENDER_EVENT, postRenderEvent );
		}
		
		private function updateEvent(e:Event):void 
		{
			if ( Input3D.keyHit( Input3D.NUMBER_1 ) ) scene.lights.techniqueName = LightFilter.NO_LIGHTS;
			if ( Input3D.keyHit( Input3D.NUMBER_2 ) ) scene.lights.techniqueName = LightFilter.PER_VERTEX;
			if ( Input3D.keyHit( Input3D.NUMBER_3 ) ) scene.lights.techniqueName = LightFilter.LINEAR;
			if ( Input3D.keyHit( Input3D.NUMBER_4 ) ) scene.lights.techniqueName = LightFilter.SAMPLED;
		}
		
		private function postRenderEvent(e:Event):void 
		{
			// make sure the texture is ready to use.
			if ( !depthTexture.scene ) depthTexture.upload( scene );
			
			// this time, we'll render our custom depth pass.
			scene.context.setRenderToTexture( depthTexture.texture, true );
			// need to clear the texture before draw.
			scene.context.clear();
			
			// draws everything on the render list.
			var len:int = scene.renderList.length;
			for ( var i:int = 0; i < len; i++ ) scene.renderList[i].draw( false, depthMaterial );
			
			//continue drawing to the back buffer again.
			scene.context.setRenderToBackBuffer();
			
			// render the scene to a texture to mix with the depth texture.
			scene.render( scene.camera, false, sceneTexture );
			
			quad.draw();
		}
	}
}