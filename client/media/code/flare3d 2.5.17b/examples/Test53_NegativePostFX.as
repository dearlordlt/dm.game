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
	public class Test53_NegativePostFX extends Sprite 
	{
		[Embed(source = "../bin/negative.flsl.compiled", mimeType = "application/octet-stream")]
		private var Negative:Class;
		private var scene:Scene3D;
		
		public function Test53_NegativePostFX() 
		{
			scene = new Viewer3D( this );
			scene.skipFrames = false;
			scene.autoResize = true;
			scene.addChildFromFile( "planet.zf3d" );
			scene.targetTexture = new Texture3D( new Point( 1024, 512 ) );
			scene.targetFilters.push( new FLSLMaterial( "negative", new Negative ) );
		}
	}
}