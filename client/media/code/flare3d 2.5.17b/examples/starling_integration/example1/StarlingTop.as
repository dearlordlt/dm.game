package starling_integration.example1
{
	import starling.display.*;
	import starling.textures.Texture;
	
	/**
	 * @author Ariel Nehmad
	 */
	public class StarlingTop extends Sprite
	{
		[Embed(source = "tree.png")]
		private var Tree:Class;
		
		public function StarlingTop()
		{
			var button0:Button = new Button( Texture.fromBitmap( new Tree ), "?" );
			button0.useHandCursor = true;
			
			addChild( button0 );
		}
	}
}