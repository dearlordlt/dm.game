package  
{
	import flare.basic.*;
	import flare.core.*;
	import flare.loaders.*;
	import flare.primitives.*;
	import flash.display.*;
	import flash.events.*;
	
	[SWF( width = 800, height = 450, frameRate = 60 )]
	
	/**
	 * @author Ariel Nehmad
	 */
	public class Test37_DebugPrimitives extends Sprite 
	{
		private var scene:Scene3D;
		private var shapes:Pivot3D;
		
		public function Test37_DebugPrimitives() 
		{
			scene = new Viewer3D(this, null, 0.4 );
			scene.autoResize = true;
			scene.antialias = 2;
			
			scene.camera = new Camera3D();
			scene.camera.far = 10000000;
			scene.camera.setPosition( 0, 10, 30 );
			scene.camera.lookAt( 0, 0, 0 );
			
			scene.addChild( new Radius( "radius", 5 ) );
			scene.addChild( new Dummy( "dummy", 8, 1, 0x8080ff ) ).x = -10;
			scene.addChild( new Dot( "point", 5, 0xffff00 ) ).x = 10;
			scene.addChild( new Cross( "cross", 10, 0x00ff00 ) ).z = -10;
			scene.addChild( new Quad( "quad", 30, 60, 120, 120 ) );
			
			var mesh:Mesh3D = new Cylinder( "cyl", 4, 10, 30 );
			mesh.setPosition( 0, -5, 10 );
			mesh.addChild( new DebugWireframe( mesh, 0xff0000 ) );
			mesh.parent = scene;
			
			var light:Light3D = new Light3D();
			light.infinite = false;
			light.radius = 5;
			light.setPosition( -10, 10, -10 )
			light.addChild( new DebugLight( light ) );
			light.parent = scene;
			
			scene.addEventListener( Scene3D.COMPLETE_EVENT, completeEvent );
			scene.addChildFromFile( "shapes.zf3d" );
		}
		
		private function completeEvent(e:Event):void 
		{
			trace( "complete" );
			
			scene.forEach( drawShapes, Shape3D );
		}
		
		private function drawShapes( shape:Shape3D ):void 
		{
			shape.addChild( new DebugShape( shape ) );
		}
	}
}