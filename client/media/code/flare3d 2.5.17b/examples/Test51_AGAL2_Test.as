package  
{
	import flare.basic.*;
	import flare.core.*;
	import flare.flsl.*;
	import flare.loaders.*;
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
	public class Test51_AGAL2_Test extends Sprite 
	{
		[Embed(source = "../bin/elsa.zf3d", mimeType = "application/octet-stream")]
		private var model:Class;
		[Embed(source = "../bin/mrt.flsl.compiled", mimeType = "application/octet-stream")]
		private var flsl:Class;
		
		private var scene:Scene3D;
		private var texture0:Texture3D;
		private var texture1:Texture3D;
		private var texture2:Texture3D;
		private var texture3:Texture3D;
		
		public function Test51_AGAL2_Test() 
		{
			Device3D.profile = Context3DProfile.BASELINE_EXTENDED;
			
			scene = new Viewer3D( this, null, 0.4 );
			scene.skipFrames = false;
			scene.autoResize = true;
			scene.antialias = 2;
			scene.registerClass( ZF3DLoader );
			
			var size:int = 2048;
			texture0 = new Texture3D( new Point( size, size ) );
			texture0.upload( scene );
			texture1 = new Texture3D( new Point( size, size ) );
			texture1.upload( scene );
			texture2 = new Texture3D( new Point( size, size ) );
			texture2.upload( scene );
			texture3 = new Texture3D( new Point( size, size ) );
			texture3.upload( scene );
			
			// external loading.
			scene.addChildFromFile( new model );
			scene.addEventListener( Scene3D.COMPLETE_EVENT, completeEvent );
			scene.addEventListener( Scene3D.RENDER_EVENT, renderEvent );
		}
		
		private function renderEvent(e:Event):void 
		{
			e.preventDefault();
			
			if ( !scene.context ) return;
			
			// this updates the input, animations and object states.
			scene.update();
			
			scene.context.setRenderToTexture( texture0.texture, true, 0, 0, 0 );
			scene.context.setRenderToTexture( texture1.texture, true, 0, 0, 1 );
			scene.context.setRenderToTexture( texture2.texture, true, 0, 0, 2 );
			scene.context.setRenderToTexture( texture3.texture, true, 0, 0, 3 );
			
			scene.context.clear();
			
			// setup seom global matrices and constants configurations.
			scene.setupFrame( scene.camera );
			// go trough each object to draw one by one.
			for each ( var p:Pivot3D in scene.renderList ) p.draw(false);
			// release GPU states.
			scene.endFrame();
			
			scene.context.setRenderToTexture( null, false, 0, 0, 1 );
			scene.context.setRenderToTexture( null, false, 0, 0, 2 );
			scene.context.setRenderToTexture( null, false, 0, 0, 3 );
			scene.context.setRenderToBackBuffer();
			
			scene.drawQuadTexture( texture0, 0, 0, 320, 240 );
			scene.drawQuadTexture( texture1, 325, 0, 320, 240 );
			scene.drawQuadTexture( texture2, 0, 245, 320, 240 );
			scene.drawQuadTexture( texture3, 325, 245, 320, 240 );
		}
		
		private function completeEvent(e:Event):void 
		{
			scene.context.enableErrorChecking = true;
			
			var material:FLSLMaterial = new FLSLMaterial( "", new flsl );
			material.params.cube.value = new Texture3D( "skybox2b.png", false, Texture3D.FORMAT_CUBEMAP );
			
			scene.setMaterial( material );
		}
	}
}