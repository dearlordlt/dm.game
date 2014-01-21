package  
{
	import flare.basic.Scene3D;
	import flare.basic.Viewer3D;
	import flare.core.Texture3D;
	import flare.flsl.FLSLMaterial;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * @author Ariel Nehmad
	 */
	public class Test55_DreamPostFX extends Sprite 
	{
		[Embed(source = "../bin/dream.flsl.compiled", mimeType = "application/octet-stream")]
		private var Dream:Class;
		private var scene:Scene3D;
		
		public function Test55_DreamPostFX() 
		{
			scene = new Viewer3D( this );
			scene.skipFrames = false;
			scene.autoResize = true;
			scene.addChildFromFile( "planet.zf3d" );
			scene.targetTexture = new Texture3D( new Point( 1024, 512 ) );
			scene.targetFilters.push( new FLSLMaterial( "dream", new Dream ) );
		}
	}
}