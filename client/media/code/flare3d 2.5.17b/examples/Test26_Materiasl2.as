package 
{
	import flare.basic.*;
	import flare.core.*;
	import flare.materials.*;
	import flare.materials.filters.*;
	import flare.system.*;
	import flare.utils.*;
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	
	[SWF(frameRate = 60, width = 800, height = 450, backgroundColor = 0x000000)]
	
	/**
	 * Working with materials.
	 * 
	 * @author Ariel Nehmad
	 */
	public class Test26_Materiasl2 extends Sprite 
	{
		private var scene:Scene3D;
		private var model:Pivot3D;
		
		private var diffuse:Texture3D;
		private var normal:Texture3D;
		private var environment:Texture3D;
		private var specular:Texture3D;
	
		public function Test26_Materiasl2() 
		{
			scene = new Viewer3D( this );
			scene.lights.ambientColor.setTo( 0.2, 0.2, 0.2 );
			
			scene.camera = new Camera3D();
			scene.camera.setPosition( 250, 70, 0 );
			scene.camera.lookAt( 0, 70, 0 );
			
			model = scene.addChildFromFile( "vaca.zf3d" );
			diffuse = scene.addTextureFromFile( "metal.jpg" );
			specular = scene.addTextureFromFile( "terrain.png" );
			normal = scene.addTextureFromFile( "images.jpg" );
			environment = scene.addTextureFromFile( "rusty.png" );
			
			scene.addEventListener( Scene3D.COMPLETE_EVENT, completeEvent )
			scene.pause();
		}
		
		private function completeEvent(e:Event):void 
		{
			var tFilter:TextureMapFilter = new TextureMapFilter( diffuse );
			
			var sFilter:SpecularMapFilter = new SpecularMapFilter( specular, 50, 5 );
			sFilter.repeatX = 2;
			sFilter.repeatY = 2;
			
			var nFilter:NormalMapFilter = new NormalMapFilter( normal );
			nFilter.repeatX = 5;
			nFilter.repeatY = 5;
			
			var eFilter:EnvironmentMapFilter = new EnvironmentMapFilter( environment, BlendMode.MULTIPLY, 1, EnvironmentMapFilter.PER_PIXEL );
			
			// creates a new material for a skinned mesh.
			var material:Shader3D = new Shader3D( "test", null, true, Shader3D.VERTEX_SKIN );
			material.filters.push( tFilter );
			material.filters.push( nFilter );
			material.filters.push( sFilter );
			material.filters.push( eFilter );
			material.build();
			
			model.getChildByName( "Line01" ).setMaterial( material );
			
			scene.resume();
		}
	}
}

