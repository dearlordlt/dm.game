package dm.minigames.musicgame
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	/**
	 * ...
	 * @author Darius Dauskurdis dariusdxd@gmail.com
	 */
	
	 
	public class MusicGameTest extends Sprite 
	{
		
		public function MusicGameTest():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var music_game_object:MusicGame = new MusicGame;
			this.addChild(music_game_object);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, music_game_object.detectKey);
			
			
			
		}
		
		public function detectKey(event:KeyboardEvent):void {
		trace(event.keyCode)
		}
		
	}
	
}