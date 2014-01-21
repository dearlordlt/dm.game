package  
{
	import flare.basic.*;
	import flare.core.*;
	import flare.materials.*;
	import flare.materials.filters.*;
	import flare.primitives.*;
	import flash.display.*;
	import flash.events.*;
	
	/**
	 * ...
	 * @author Ariel Nehmad
	 */
	public class Test15_SimpleNormalMap extends Sprite 
	{
		private var scene:Scene3D;
		private var sphere:Mesh3D;
		
		public function Test15_SimpleNormalMap() 
		{
			scene = new Viewer3D(this);
			scene.camera.setPosition( 0, 0, -15 );
			
			var shader:Shader3D = new Shader3D();
			shader.filters.push( new TextureMapFilter( new Texture3D( "tex6.jpg" ) ) );
			shader.filters.push( new NormalMapFilter( new Texture3D( "images.jpg" ) ) );
			shader.filters.push( new EnvironmentMapFilter( new Texture3D( "reflections.jpg" ), BlendMode.MULTIPLY, 1.5 ) );
			shader.build();
			
			shader.filters[1].repeatX = 4;
			shader.filters[1].repeatY = 4;
			
			sphere = new Sphere( "sphere", 5, 25, shader );
			sphere.parent = scene;
			
			scene.addEventListener( Scene3D.UPDATE_EVENT, updateEvent );
		}
		
		private function updateEvent(e:Event):void 
		{
			sphere.rotateY(0.5);
		}
	}
}