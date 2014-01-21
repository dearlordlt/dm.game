package  
{
	import flare.basic.*;
	import flare.core.*;
	import flare.primitives.*;
	import flare.system.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	[SWF( width = 800, height = 450, frameRate = 60 )]
	
	/**
	 * @author Ariel Nehmad
	 */
	public class Test38_ShapeExample extends Sprite 
	{
		private var scene:Scene3D;
		private var value:Number = 0;
		private var cube:Cube;
		private var shape:Shape3D;
		
		public function Test38_ShapeExample() 
		{
			scene = new Viewer3D(this);
			scene.autoResize = true;
			scene.addEventListener( Scene3D.COMPLETE_EVENT, completeEvent );
			scene.addChildFromFile( "shapes.zf3d" );
			
			cube = new Cube( "cube", 2, 2, 2 );
			scene.addChild( cube );
		}
		
		private function completeEvent(e:Event):void 
		{
			shape = scene.getChildByName( "Line001" ) as Shape3D;
			
			scene.forEach( drawShapes, Shape3D );
			scene.addEventListener( Scene3D.UPDATE_EVENT, updateEvent );
		}
		
		private function drawShapes( shape:Shape3D ):void 
		{
			shape.addChild( new DebugShape( shape ) );
		}
		
		private function updateEvent(e:Event):void 
		{
			value += 0.002;
			if ( value > 1 ) value -= 1;
			
			var pos:Vector3D = shape.getPoint( value );
			var dir:Vector3D = shape.getTangent( value );
			
			cube.setPosition( pos.x, pos.y, pos.z );
			cube.setOrientation( dir );
		}
	}
}