package  
{
	import flare.basic.*;
	import flare.collisions.*;
	import flare.core.*;
	import flare.events.*;
	import flare.modifiers.*;
	import flare.primitives.*;
	import flash.display.*;
	import flash.events.*;
	
	[SWF(frameRate = 60, width = 800, height = 450, backgroundColor = 0x000000)]
	
	/**
	 * How to control bones manually.
	 * @author Ariel Nehmad.
	 */
	public class Test20_ControlBones extends Sprite 
	{
		private var scene:Scene3D;
		private var model:Pivot3D;
		private var head:Pivot3D;
		private var floor:Plane;
		private var sphere:Sphere;
		
		public function Test20_ControlBones() 
		{
			scene = new Viewer3D(this);
			scene.camera = new Camera3D();
			scene.camera.setPosition( 0, 500, -500 );
			scene.camera.lookAt( 0, 50, 0 );
			scene.addEventListener( Scene3D.COMPLETE_EVENT, completeEvent );
			
			model = scene.addChildFromFile( "vaca.zf3d" );
		}
		
		private function completeEvent(e:Event):void 
		{
			// get our model and the skin modifier associated to it.
			var mesh:Mesh3D = model.getChildByName("Line01") as Mesh3D;
			var skin:SkinModifier = mesh.modifier as SkinModifier;
			
			// get the bone and prevents to be animated.
			head = skin.root.getChildByName( "CATRigHub02" );
			head.frames = null;
			
			sphere = new Sphere();
			sphere.parent = scene;
			
			floor = new Plane( "floor", 1000, 1000, 1, null, "+xz" );
			floor.addEventListener( MouseEvent3D.MOUSE_MOVE, mouseMoveEvent );
			floor.parent = scene;
		}
		
		private function mouseMoveEvent(e:MouseEvent3D):void 
		{
			var info:CollisionInfo = e.info;
			sphere.x = info.point.x;
			sphere.y = info.point.y;
			sphere.z = info.point.z;
			
			// this is not intent to be a good way to orient the bone.
			// it just to demostrate how it works.
			head.setRotation( sphere.x * 0.1, sphere.z * 0.1, 0 );
		}
	}
}