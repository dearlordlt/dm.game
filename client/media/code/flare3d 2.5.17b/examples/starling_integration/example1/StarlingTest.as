package starling_integration.example1
{
	import flare.basic.*;
	import flare.core.*;
	import flash.display.*;
	import flash.display3D.*;
	import flash.events.*;
	import starling.core.*;
	
	[SWF(width = 550, height = 350, frameRate = 60)]
	/**
	 * Flare3D + Starling integration.
	 * 
	 * @author Ariel Nehmad
	 */
	public class StarlingTest extends Sprite 
	{
		[Embed(source = "vaca.zf3d", mimeType = "application/octet-stream")]
		private var Model:Class;
		
		private var scene:Scene3D;
		private var model:Pivot3D;
		private var starlingBack:Starling;
		private var starlingTop:Starling;
		
		public function StarlingTest() 
		{
			scene = new Viewer3D( this );
			scene.autoResize = true;
			scene.clearColor.setTo( 1, 1, 1 );
			scene.addEventListener( Event.CONTEXT3D_CREATE, contextCreateEvent );
			scene.addEventListener( Scene3D.RENDER_EVENT, renderEvent );
			
			model = scene.addChildFromFile( new Model );
		}
		
		private function contextCreateEvent(e:Event):void 
		{
			starlingBack = new Starling( StarlingBack, stage, null, stage.stage3Ds[ scene.stageIndex ] );
			starlingBack.start();
			
			starlingTop = new Starling( StarlingTop, stage, null, stage.stage3Ds[ scene.stageIndex ] );
			starlingTop.start();
		}
		
		private function renderEvent(e:Event):void 
		{
			// prevents the 3d scene to render.
			// we'll handle the render by our own.
			e.preventDefault();
			
			// draw starling background.
			starlingBack.nextFrame();
			
			// starling writes the depth buffer, so we need to clear it before draw the 3D stuff.
			scene.context.clear( 0, 0, 0, 1, 1, 0, Context3DClearMask.DEPTH );
			
			// render 3D scene.
			scene.render();
			
			// draw starling ui.
			starlingTop.nextFrame();
		}
	}
}
