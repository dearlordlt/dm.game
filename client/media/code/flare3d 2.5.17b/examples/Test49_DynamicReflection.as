package  
{
	import flare.basic.*;
	import flare.core.*;
	import flare.loaders.*;
	import flare.materials.*;
	import flare.materials.filters.*;
	import flare.primitives.*;
	import flare.utils.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	[SWF( width = 800, height = 450, frameRate = 60 )]
	
	/**
	 * @author Ariel Nehmad
	 */
	public class Test49_DynamicReflection extends Sprite 
	{
		[Embed(source = "../bin/skybox2b.png", mimeType = "application/octet-stream")] private var skybox:Class;
		
		private var scene:Scene3D;
		private var teapot:Pivot3D;
		private var chess:Pivot3D;
		
		private var projTexture:Texture3D;
		private var projCamera:Camera3D;
		
		private var envCamera:Camera3D;
		private var envTexture:Texture3D;
		private var envSphere:Pivot3D;
		private var envShader:Shader3D;
		
		private var reflectiveMaterial:Shader3D;
		
		public function Test49_DynamicReflection() 
		{
			scene = new Viewer3D( this, null, 0.3 );
			scene.skipFrames = false;
			scene.antialias = 2;
			scene.autoResize = true;
			scene.registerClass( ZF3DLoader );
			scene.addEventListener( Scene3D.PROGRESS_EVENT, progressEvent );
			scene.addEventListener( Scene3D.COMPLETE_EVENT, completeEvent );
			scene.addChild( new SkyBox( new skybox ) )
			
			chess = scene.addChildFromFile( "chess2.zf3d" );
			teapot = scene.addChildFromFile( "teapot2.zf3d" );
			
			// this texture will be used to render the scene into the texture to be mapped
			// in a hidden sphere.
			projTexture = new Texture3D( new Point( 512, 512 ), true );
			
			// this textire will be used to draw the hidden sphere into the result
			// environment texture to be applied over the model.
			envTexture = new Texture3D( new Point( 512, 512 ), true );
		}
		
		private function progressEvent(e:Event):void 
		{
			//trace( scene.loadProgress );
		}
		
		private function completeEvent(e:Event):void 
		{
			trace( "complete" );
			
			var textureMap:TextureMapFilter = new TextureMapFilter( projTexture );
				textureMap.repeatX = -2;
				textureMap.repeatY = 1;
			
			envShader = new Shader3D( "envMaterial", [textureMap], false );
			envSphere = new Sphere( "sphere", 128, 24, envShader );
			
			// camera to take the scene projection.
			projCamera = new Camera3D( "projCamera", 135 );
			projCamera.parent = envSphere;
			
			// camera to take the envSphere into a texture.
			envCamera = new Camera3D( "envCamera", 30 );
			envCamera.aspectRatio = 1;
			envCamera.z = -0.5 / envCamera.zoom * 256;
			envCamera.parent = envSphere;
			envCamera.viewPort
			
			// the reflective material.
			reflectiveMaterial = new Shader3D( "reflection", [new EnvironmentMapFilter( envTexture )] );
			
			teapot.setMaterial( reflectiveMaterial );
			
			scene.addEventListener( Scene3D.POSTRENDER_EVENT, postRenderEvent );
		}
		
		private function postRenderEvent(e:Event):void 
		{
			teapot.rotateY( -0.5 );
			teapot.x = Math.cos( getTimer() / 2000 ) * 100;
			teapot.z = Math.cos( getTimer() / 1850 ) * 100;
			teapot.y = 100;
			
			// place the envSphere in the origin point of the reflection.
			envSphere.setPosition( teapot.x, teapot.y, teapot.z );
			// point the envSphere to the scene camera vector.
			Pivot3DUtils.lookAtWithReference( envSphere, 0, 0, 0, scene.camera, scene.camera.getUp(false) );
			
			teapot.visible = false;
			
			// render the scene to a texture.
			scene.render( projCamera, false, projTexture );
			
			teapot.visible = true;
			
			// custom pass to draw the sphere with the projected texture into the final texture.
			// we'll get a texture like this: http://msdn.microsoft.com/en-us/library/windows/desktop/bb147401(v=vs.85).aspx
			scene.context.setRenderToTexture( envTexture.texture );
			scene.context.clear();
			scene.setupFrame( envCamera );
			envSphere.draw( true );
			scene.context.setRenderToBackBuffer();
		}
	}
}