package  
{
	import flare.basic.*;
	import flare.core.*;
	import flare.primitives.*;
	import flash.display.*;
	import flash.events.*;
 
	[SWF( width = 800, height = 450, frameRate = 60 )]
	
	/**
	 * This example shows how to convert 3D units to 2D pixel units relative to any camera.
	 * @author Ariel Nehmad
	 */
	public class Test42_Plane3Dto2D extends Sprite 
	{
		private var scene:Scene3D 
		private var plane:Plane;
		private var planePixelsHeight:int;
		private var planePixelsWidth:int;
 
		public function Test42_Plane3Dto2D() 
		{
			stage.align = "topLeft";
			stage.scaleMode = "noScale";
			
			scene = new Scene3D( this );
			scene.camera = new Camera3D( "", 90 );
			scene.autoResize = true;
			
			stage.addEventListener( Event.RESIZE, resizeStageEvent );
			
			planePixelsWidth = 450;
			planePixelsHeight = 350;
			
			plane = new Plane( "plane", planePixelsWidth, planePixelsHeight );
			
			scene.addChild( plane );
			
			resizeStageEvent(null);
		}
		
		private function resizeStageEvent(e:Event):void 
		{
			// this is the magic distance from the plane to the camera.
			// here we are just moving the plane far from the camera, but is the same thing moving the camera backward
			// using a negative value.
			scene.camera.z = -0.5 / scene.camera.zoom * stage.stageWidth;
			
			// just draws the rectangle on the screen to compare against the 3d plane.
			graphics.clear();
			graphics.lineStyle( 1, 0xff0000 );
			graphics.drawRect( stage.stageWidth * 0.5 - planePixelsWidth * 0.5, 
							   stage.stageHeight * 0.5 - planePixelsHeight * 0.5, 
							   planePixelsWidth, 
							   planePixelsHeight);
		}
	}
}