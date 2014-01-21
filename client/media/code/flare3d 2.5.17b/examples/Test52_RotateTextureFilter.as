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
	public class Test52_RotateTextureFilter extends Sprite 
	{
		[Embed(source="../bin/rotateTextureFilter.flsl.compiled", mimeType="application/octet-stream")]
		private static var rotateTextureFilter:Class;
		
		private var scene:Scene3D;
		private var rtFilter:FLSLFilter;
		
		public function Test52_RotateTextureFilter() 
		{
			scene = new Viewer3D( this, null, 0.5 );
			scene.autoResize = true;
			scene.antialias = 2;
			scene.skipFrames = false;
			
			// initialize the filter and his params.
			rtFilter = new FLSLFilter( new rotateTextureFilter );
			rtFilter.params.texture.value = new Texture3D( "tree.png" );
			rtFilter.params.angles.value = Vector.<Number>([0, 0, 0]);
			
			var shader:Shader3D = new Shader3D( "material", [ rtFilter, new TextureMapFilter() ] );
			var cube:Cube = new Cube( "cube", 10, 10, 10, 1, shader );
			
			scene.addChild( cube );
			scene.camera.setPosition( 10, 20, -20 );
			scene.camera.lookAt( 0, 0, 0 );
			scene.addEventListener( Scene3D.UPDATE_EVENT, updateEvent );
		}
		
		private function updateEvent(e:Event):void 
		{
			// we calculates the sin and cos values here to avoid extra operations inside the shadder.
			var angle:Number = ( getTimer() / 10 ) * Math.PI / 180;
			rtFilter.params.angles.value[0] = Math.cos( angle );
			rtFilter.params.angles.value[1] = Math.sin( angle );
			rtFilter.params.angles.value[2] = -Math.sin( angle );
		}
	}
}