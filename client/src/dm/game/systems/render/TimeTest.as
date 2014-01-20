package dm.game.systems.render {
	
	import dm.builder.interfaces.WindowManager;
	import flare.core.Pivot3D;
	import flare.physics.core.AvatarController;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import net.hires.debug.Stats;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class TimeTest extends Sprite {
		
		private const TEST_DURATION_SEC:int = 20;
		private var _fpsSum:Number = 0;
		private var _framePassed:int = 0;
		private var _stats:Stats;
		private var _avatarController:AvatarController;
		

		
		public function TimeTest(parent:DisplayObjectContainer, avatarController:AvatarController) {
			parent.addChild(this);		
			_avatarController = avatarController;
		}
		
		public function test():void {
			trace("TimeTest started");
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			var timer:Timer = new Timer(1000, TEST_DURATION_SEC);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			timer.start();
		}
		
		private function onEnterFrame(e:Event):void {
			_avatarController.turn(1);
			_framePassed++;
		}
		
		private function onTimerComplete(e:TimerEvent):void {
			trace("Average fps: " + _fpsSum / TEST_DURATION_SEC);
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			WindowManager.instance.dispatchMessage("Average fps: " + _fpsSum / TEST_DURATION_SEC);
		}
		
		private function onTimer(e:TimerEvent):void {
			trace(_framePassed);
			_fpsSum += _framePassed;
			_framePassed = 0;
		}
	
	}

}