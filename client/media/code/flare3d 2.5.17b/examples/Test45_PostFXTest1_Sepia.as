package  
{
	import flare.basic.*;
	import flare.core.*;
	import flare.loaders.*;
	import flare.materials.*;
	import flare.flsl.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	[SWF( width = 800, height = 450, frameRate = 60 )]
	
	/**
	 * @author Ariel Nehmad
	 */
	public class Test45_PostFXTest1_Sepia extends Sprite 
	{
		[Embed(source = "../bin/colorMatrix.flsl.compiled", mimeType = "application/octet-stream")]
		private var Sepia:Class;
		[Embed(source = "../bin/gamma.flsl.compiled", mimeType = "application/octet-stream")]
		private var Gamma:Class;
		
		private var scene:Viewer3D;
		private var filter:FLSLMaterial;
		
		public function Test45_PostFXTest1_Sepia() 
		{
			scene = new Viewer3D( this, null, 0.15, 0.5 );
			scene.autoResize = true;
			scene.antialias = 2;
			scene.skipFrames = false;
			scene.lights.ambientColor.setTo( 0.4, 0.3, 0.2 );
			
			// if a target texture is defined, flare will render the scene into the texture
			// instead to render into the back buffer.
			scene.targetTexture = new Texture3D( new Point( 1024, 512 ), true );
			scene.targetTexture.mipMode = Texture3D.MIP_NONE;
			
			filter = new FLSLMaterial( "sepia", new Sepia );
			
			// define the material to be used to render the target texture.
			scene.targetFilters.push( filter );
			
			scene.addChildFromFile( "chess2.zf3d" );
			
			scene.addEventListener( Scene3D.UPDATE_EVENT, updateEvent );
		}
		
		private function updateEvent(e:Event):void 
		{
			filter.params.blendValue.value[0] = Math.cos( getTimer() / 500 ) * 0.5 + 0.5;
		}
	}
}