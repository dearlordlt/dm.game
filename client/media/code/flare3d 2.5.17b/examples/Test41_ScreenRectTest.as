package  
{
	import flare.basic.*;
	import flare.core.*;
	import flare.flsl.*;
	import flare.loaders.*;
	import flare.materials.*;
	import flare.materials.filters.*;
	import flare.primitives.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	[SWF( width = 800, height = 450, frameRate = 60 )]
	
	/**
	 * @author Ariel Nehmad.
	 */
	public class Test41_ScreenRectTest extends Sprite 
	{
		private var scene:Scene3D;
		
		public function Test41_ScreenRectTest() 
		{
			scene = new Viewer3D(this, null, 0.25, 1 );
			scene.autoResize = true;
			scene.antialias = 2;
			
			scene.registerClass( ZF3DLoader );
			scene.addChildFromFile( "test.zf3d" );
			scene.addEventListener( Scene3D.POSTRENDER_EVENT, postRenderEvent );
		}
		
		private function postRenderEvent(e:Event):void 
		{
			graphics.clear();
			var r:Rectangle = new Rectangle;
			for each ( var m:Mesh3D in scene.renderList )
			{
				// gets the screen object rectangle if it is in front of the camera.
				if ( m.getScreenRect( r ) ) {
					graphics.beginFill( 0xff0000, 0.4 );
					graphics.drawRect( r.x, r.y, r.width, r.height );
				}
				
				// gets the 2D scaled object position.
				var coords:Vector3D = m.getScreenCoords();
				var screenRatio:Number = scene.viewPort.width / scene.camera.zoom;
				var scale:Number = 1;
				
				graphics.beginFill( 0x00ff00 );
				graphics.drawCircle( coords.x, coords.y, scale / coords.w * screenRatio );
			}
		}
	}
}