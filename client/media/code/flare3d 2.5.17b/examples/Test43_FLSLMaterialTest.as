package  
{
	import flare.basic.*;
	import flare.core.*;
	import flare.loaders.*;
	import flare.flsl.*;
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	
	[SWF( width = 800, height = 450, frameRate = 60 )]
	
	/**
	 * @author Ariel Nehmad
	 */
	public class Test43_FLSLMaterialTest extends Sprite 
	{
		//[Embed(source="../bin/example01.flsl.compiled", mimeType="application/octet-stream")]
		//[Embed(source="../bin/example02.flsl.compiled", mimeType="application/octet-stream")]
		//[Embed(source="../bin/example03.flsl.compiled", mimeType="application/octet-stream")]
		//[Embed(source="../bin/example04.flsl.compiled", mimeType="application/octet-stream")]
		//[Embed(source="../bin/example05.flsl.compiled", mimeType="application/octet-stream")]
		//[Embed(source="../bin/example05b.flsl.compiled", mimeType="application/octet-stream")]
		//[Embed(source="../bin/example06.flsl.compiled", mimeType="application/octet-stream")]
		//[Embed(source="../bin/example07.flsl.compiled", mimeType="application/octet-stream")]
		//[Embed(source="../bin/example08.flsl.compiled", mimeType="application/octet-stream")]
		//[Embed(source="../bin/example09.flsl.compiled", mimeType="application/octet-stream")]
		//[Embed(source="../bin/example10.flsl.compiled", mimeType="application/octet-stream")]
		//[Embed(source="../bin/example11.flsl.compiled", mimeType="application/octet-stream")]
		//[Embed(source="../bin/example12.flsl.compiled", mimeType="application/octet-stream")]
		//[Embed(source="../bin/example13.flsl.compiled", mimeType="application/octet-stream")]
		//[Embed(source="../bin/example14.flsl.compiled", mimeType="application/octet-stream")]
		//[Embed(source="../bin/example15.flsl.compiled", mimeType="application/octet-stream")]
		[Embed(source="../bin/example16.flsl.compiled", mimeType="application/octet-stream")]
		//[Embed(source="../bin/null.flsl.compiled", mimeType="application/octet-stream")]
		//[Embed(source="../bin/refract.flsl.compiled", mimeType="application/octet-stream")]
		private static var flsl:Class;
		private static var data:ByteArray = new flsl;
		
		private var scene:Scene3D;
		
		public function Test43_FLSLMaterialTest() 
		{
			scene = new Viewer3D( this, null, 0.2 );
			scene.autoResize = true;
			scene.antialias = 2;
			scene.skipFrames = false;
			scene.camera = new Camera3D();
			scene.camera.setPosition( 0, 20, -130 );
			scene.camera.lookAt( 0, 0, 0 );
			scene.addChildFromFile( "teapot2.zf3d" );
			scene.addEventListener( Scene3D.COMPLETE_EVENT, completeEvent );
		}
		
		private function completeEvent(e:Event):void 
		{
			var material:FLSLMaterial = new FLSLMaterial( "shader", data );
				
			scene.context.enableErrorChecking = true;
			
			for each ( var param:* in material.params ) trace( param, param.value );
			
			scene.setMaterial( material );
		}
	}
}