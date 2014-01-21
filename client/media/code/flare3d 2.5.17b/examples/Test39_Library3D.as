package  
{
	import flare.basic.*;
	import flare.core.*;
	import flare.loaders.*;
	import flare.system.*;
	import flash.display.*;
	import flash.events.*;
	
	[SWF( width = 800, height = 450, frameRate = 60 )]
	
	/**
	 * @author Ariel Nehmad
	 */
	public class Test39_Library3D extends Sprite
	{
		[Embed(source = "../bin/elsa.zf3d", mimeType = "application/octet-stream")] private var model0:Class;
		[Embed(source = "../bin/vaca.zf3d", mimeType = "application/octet-stream")] private var model1:Class;
		[Embed(source = "../bin/teapot2.zf3d", mimeType = "application/octet-stream")] private var model2:Class;
		[Embed(source = "../bin/chess2.zf3d", mimeType = "application/octet-stream")] private var model3:Class;
		
		private var scene:Scene3D;
		private var library:Library3D;
		
		public function Test39_Library3D() 
		{
			scene = new Viewer3D(this);
			scene.autoResize = true;
			scene.camera.setPosition( 130, 140, -150 );
			scene.camera.lookAt( 0, 0, 0 );
			
			library = new Library3D( 10, false );
			libraryPushItem( new Flare3DLoader( new model0 ), "elsa" );
			libraryPushItem( new Flare3DLoader( new model1 ), "vaca" );
			libraryPushItem( new Flare3DLoader( new model2 ), "teapot2" );
			libraryPushItem( new Flare3DLoader( new model3 ), "chess" );
			library.addEventListener( "progress", progressEvent );
			library.addEventListener( "complete", completeEvent );
			library.load()
		}
		
		private function libraryPushItem( item:ILibraryExternalItem, name:String ):void
		{
			if ( !library.getItem( name ) ) {
				library.push( item );
				library.addItem( name, item );
			}
		}
		
		private function progressEvent(e:Event):void 
		{
			trace( "progress", library.progress );
		}
		
		private function completeEvent(e:Event):void 
		{
			scene.addChild( library.getItem( "elsa" ) as Pivot3D );
			scene.addChild( library.getItem( "vaca" ) as Pivot3D );
			scene.addChild( library.getItem( "teapot2" ) as Pivot3D );
			scene.addChild( library.getItem( "chess" ) as Pivot3D );
			
			trace( "complete" );
		}
	}
}