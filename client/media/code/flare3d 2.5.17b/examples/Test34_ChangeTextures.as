package  
{
	import flare.basic.*;
	import flare.core.*;
	import flare.materials.*;
	import flare.system.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	/**
	 * Change textures in realtime.
	 * 
	 * @author Ariel Nehmad
	 */
	public class Test34_ChangeTextures extends Sprite 
	{
		private var scene:Scene3D;
		private var preLoadedTexture0:Texture3D;
		private var preLoadedTexture1:Texture3D;
		private var preLoadedTexture2:Texture3D;
		private var shader:Shader3D;
		
		public function Test34_ChangeTextures() 
		{
			scene = new Viewer3D(this);
			scene.addEventListener( Scene3D.COMPLETE_EVENT, completeEvent );
			scene.addChildFromFile( "elsa.zf3d" );
			
			preLoadedTexture0 = scene.addTextureFromFile( "terrain.png" );
			preLoadedTexture1 = scene.addTextureFromFile( "tree.png" );
			preLoadedTexture2 = scene.addTextureFromFile( "displacement.jpg" );
		}
		
		private function completeEvent(e:Event):void 
		{
			shader = scene.getMaterialByName( "mElsa" ) as Shader3D;
			
			scene.addEventListener( Scene3D.UPDATE_EVENT, updateEvent );
		}
		
		private function updateEvent(e:Event):void 
		{
			// in this case, the first filter on the shader is a TextureFilter.
			
			// using this method, te texture will be loaded here, so the mesh will dissapear until the new texture is loaded.
			if ( Input3D.keyHit( Input3D.NUMBER_1 ) ) shader.filters[0].texture = new Texture3D( "metal.jpg" );
			if ( Input3D.keyHit( Input3D.NUMBER_2 ) ) shader.filters[0].texture = new Texture3D( "r42.jpg" );
			if ( Input3D.keyHit( Input3D.NUMBER_3 ) ) shader.filters[0].texture = new Texture3D( "reflections.jpg" );
			if ( Input3D.keyHit( Input3D.NUMBER_4 ) ) shader.filters[0].texture = new Texture3D( "gorda.png" );
			
			// using preloaded textures, the result will be immediately.
			if ( Input3D.keyHit( Input3D.NUMBER_5 ) ) shader.filters[0].texture = preLoadedTexture0;
			if ( Input3D.keyHit( Input3D.NUMBER_6 ) ) shader.filters[0].texture = preLoadedTexture1;
			if ( Input3D.keyHit( Input3D.NUMBER_7 ) ) shader.filters[0].texture = preLoadedTexture2;
		}
	}
}