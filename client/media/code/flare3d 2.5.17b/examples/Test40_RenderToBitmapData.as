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
	import flash.display3D.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	[SWF( width = 800, height = 450, frameRate = 60 )]
	
	/**
	 * @author Ariel Nehmad
	 */
	public class Test40_RenderToBitmapData extends Sprite 
	{
		[Embed(source = "../bin/skybox2b.png", mimeType = "application/octet-stream")] private var skybox:Class;
		
		private var scene:Scene3D;
		private var teapot:Pivot3D;
		private var chess:Pivot3D;
		
		private var secondCamera:Camera3D;
		
		private var bmp:BitmapData;
		
		public function Test40_RenderToBitmapData() 
		{
			scene = new Viewer3D( this, null, 0.3 );
			scene.antialias = 2;
			scene.autoResize = true;
			scene.registerClass( ZF3DLoader );
			scene.addEventListener( Scene3D.PROGRESS_EVENT, progressEvent );
			scene.addEventListener( Scene3D.COMPLETE_EVENT, completeEvent );
			scene.addChild( new SkyBox( new skybox ) )
			
			chess = scene.addChildFromFile( "chess2.zf3d" );
			teapot = scene.addChildFromFile( "teapot2.zf3d" );
			
			secondCamera = new Camera3D( "secondCamera" );
			secondCamera.viewPort = new Rectangle( 0, 0, 200, 200 );
			secondCamera.z = -100;
			
			bmp = new BitmapData( 200, 200, true );
			
			addChild( new Bitmap( bmp ) ).x = 300;
		}
		
		private function progressEvent(e:Event):void 
		{
			//trace( scene.loadProgress );
		}
		
		private function completeEvent(e:Event):void 
		{
			trace( "complete" );
			
			teapot.parent = null;
			
			scene.addEventListener( Scene3D.RENDER_EVENT, renderEvent );
		}
		
		private function renderEvent(e:Event):void 
		{
			teapot.rotateY( -0.5 );
			
			// if you want to draw with alpha.
			scene.clearColor.setTo( 0, 0, 0 );
			scene.clearColor.w = 0;
			
			// render to bitmap data.
			scene.setupFrame( secondCamera );
			teapot.draw();
			scene.context.drawToBitmapData( bmp );
			
			// clear the frame and setup to draw the main camera frame.
			scene.context.clear();
			scene.setupFrame( scene.camera );
		}
	}
}