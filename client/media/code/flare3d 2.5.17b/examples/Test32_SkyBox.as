package  
{
	import flare.basic.*;
	import flare.primitives.*;
	import flash.display.*;
	import flash.events.*;
	
	/**
	 * SkyBox example.
	 * 
	 * @author Ariel Nehmad
	 */
	public class Test32_SkyBox extends Sprite 
	{
		[Embed(source = "../bin/skybox1.png")] 				private var Sky:Class;
		[Embed(source = "../bin/skybox_folder/front.jpg")] 	private var Front:Class;
		[Embed(source = "../bin/skybox_folder/back.jpg")] 	private var Back:Class;
		[Embed(source = "../bin/skybox_folder/left.jpg")] 	private var Left:Class;
		[Embed(source = "../bin/skybox_folder/right.jpg")] 	private var Right:Class;
		[Embed(source = "../bin/skybox_folder/top.jpg")] 	private var Top:Class;
		[Embed(source = "../bin/skybox_folder/bottom.jpg")]	private var Bottom:Class;
		
		private var scene:Scene3D;
		
		public function Test32_SkyBox() 
		{
			scene = new Viewer3D( this );
			scene.addEventListener( Scene3D.PROGRESS_EVENT, progressEvent );
			scene.addEventListener( Scene3D.COMPLETE_EVENT, completeEvent );
			
			// method 1 loads the complete skybox from a single image.
			//var sky:SkyBox = new SkyBox( "skybox1.png", SkyBox.HORIZONTAL_CROSS, scene );
			
			// method 2 loads the skybox from a folder.
			//var sky:SkyBox = new SkyBox( "skybox_folder", SkyBox.FOLDER_JPG, scene );
			
			// method 3 loads the skybox from a BitmapData array.
			var sky:SkyBox = new SkyBox( [new Front, new Back, new Right, new Left, new Top, new Bottom], SkyBox.BITMAP_DATA_ARRAY, scene );
			
			scene.addChild( sky );
		}
		
		private function progressEvent(e:Event):void 
		{
			trace( scene.loadProgress );
		}
		
		private function completeEvent(e:Event):void 
		{
			trace( "completed" );
		}
		
	}

}