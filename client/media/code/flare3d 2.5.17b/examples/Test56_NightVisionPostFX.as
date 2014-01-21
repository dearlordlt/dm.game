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
	public class Test56_NightVisionPostFX extends Sprite 
	{
		[Embed(source = "../bin/nightVision.flsl.compiled", mimeType = "application/octet-stream")]
		private var NightVision:Class;
		private var scene:Scene3D;
		
		public function Test56_NightVisionPostFX() 
		{
			scene = new Viewer3D( this );
			scene.skipFrames = false;
			scene.autoResize = true;
			scene.addChildFromFile( "planet.zf3d" );
			scene.targetTexture = new Texture3D( new Point( 1024, 512 ) );
			scene.targetFilters.push( new FLSLMaterial( "nightVision", new NightVision ) );
		}
	}
}