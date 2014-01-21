package  
{
	import flare.basic.*;
	import flare.core.*;
	import flare.loaders.*;
	import flare.system.*;
	import flash.display.*;
	import flash.display3D.*;
	import flash.events.*;
	
	[SWF( width = 800, height = 450, frameRate = 60 )]
	
	/**
	 * @author Ariel Nehmad
	 */
	public class Test50_ManualRender extends Sprite 
	{
		private var scene:Scene3D;
		
		public function Test50_ManualRender() 
		{
			scene = new Viewer3D( this, null, 0.4 );
			scene.autoResize = true;
			scene.antialias = 2;
			scene.registerClass( ZF3DLoader );
			
			// external loading.
			scene.addChildFromFile( "chess.zf3d" );
			scene.skipFrames = false;
			scene.addEventListener( Scene3D.RENDER_EVENT, renderEvent );
		}
		
		private function renderEvent(e:Event):void 
		{
			// prevents the default engine rendering.
			e.preventDefault();
			
			if ( !scene.context ) return;
			
			// clears the frame buffer.
			scene.context.clear();
			
			// this updates the input, animations and object states.
			scene.update();
			
			var easy:Boolean = true;
			
			// you can optionally use your own states.
			Device3D.ignoreStates = true;
			scene.context.setCulling( Context3DTriangleFace.BACK );
			scene.context.setDepthTest( true, Context3DCompareMode.LESS_EQUAL );
			scene.context.setBlendFactors( Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO );
			
			if ( easy ) scene.render( scene.camera );
			else
			{
				// setup seom global matrices and constants configurations.
				scene.setupFrame( scene.camera );
				// go trough each object to draw one by one.
				for each ( var p:Pivot3D in scene.renderList ) p.draw(false);
				// release GPU states.
				scene.endFrame();
			}
		}
	}
}