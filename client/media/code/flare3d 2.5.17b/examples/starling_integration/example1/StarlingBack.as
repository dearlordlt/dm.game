package starling_integration.example1
{
	import starling.display.*;
	import starling.textures.*;
	
	/**
	 * @author Ariel Nehmad
	 */
	public class StarlingBack extends Sprite
	{
		[Embed(source = "reflections.jpg")]
		private var Backgounrd:Class;
		
		public function StarlingBack()
		{
			var texture:Texture = Texture.fromBitmap( new Backgounrd );
			var image:Image = new Image( texture );
			
			addChild( image );
		}
	}
}