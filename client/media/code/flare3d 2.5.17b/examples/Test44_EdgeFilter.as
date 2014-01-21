package  
{
	import flare.basic.*;
	import flare.core.*;
	import flare.flsl.*;
	import flare.loaders.*;
	import flare.materials.*;
	import flare.materials.filters.*;
	import flare.primitives.*;
	import flare.system.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	[SWF( width = 800, height = 450, frameRate = 60 )]
	
	/**
	 * @author Ariel Nehmad.
	 */
	public class Test44_EdgeFilter extends Sprite 
	{
		[Embed(source="../bin//edgeFilter.flsl.compiled", mimeType="application/octet-stream")]
		private static var edgeFilter:Class;
		
		private var scene:Scene3D;
		private var shader:Shader3D;
		
		public function Test44_EdgeFilter() 
		{
			scene = new Viewer3D(this, null, 0.25, 1 );
			scene.autoResize = true;
			scene.antialias = 2;
			
			scene.lights.techniqueName = LightFilter.LINEAR;
			scene.lights.maxDirectionalLights = 1;
			scene.lights.maxPointLights = 1;
			scene.lights.defaultLight.color.setTo( 0.4, 0.3, 0.2 );
			
			scene.registerClass( ZF3DLoader );
			scene.addChildFromFile( "vaca.zf3d" );
			scene.addEventListener( Scene3D.COMPLETE_EVENT, completeEvent );
			
			var l:Light3D = new Light3D();
			l.setPosition( -100, 100, 0 );
			l.setParams( 0x3060ff, 200, 1, 1, true );
			l.parent = scene;
		}
		
		private function completeEvent(e:Event):void 
		{
			shader = scene.getMaterialByName( "Material #360" ) as Shader3D;
			//shader = new Shader3D( "", null, true, Shader3D.VERTEX_SKIN );
			shader.filters.push( new FLSLFilter( new edgeFilter, BlendMode.NORMAL ) );
			shader.filters.push( new NormalMapFilter( new Texture3D( "1895-normal.jpg" ) ) );
			shader.filters.push( new SpecularFilter( 50, 0.2 ) );
			shader.build();
			
			scene.setMaterial( shader );
			
			scene.addEventListener( Scene3D.UPDATE_EVENT, updateEvent );
		}
		
		private function updateEvent(e:Event):void 
		{
			if ( Input3D.keyHit( Input3D.NUMBER_1 ) ) scene.lights.techniqueName = LightFilter.NO_LIGHTS;
			if ( Input3D.keyHit( Input3D.NUMBER_2 ) ) scene.lights.techniqueName = LightFilter.PER_VERTEX;
			if ( Input3D.keyHit( Input3D.NUMBER_3 ) ) scene.lights.techniqueName = LightFilter.LINEAR;
			if ( Input3D.keyHit( Input3D.NUMBER_4 ) ) scene.lights.techniqueName = LightFilter.SAMPLED;
		}
	}
}