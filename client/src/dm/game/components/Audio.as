package dm.game.components {
	import com.greensock.loading.data.MP3LoaderVars;
	import com.greensock.loading.MP3Loader;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class Audio implements IComponent {
		
		private var _id:int = 0;
		public var label:String;
		public var sound:MP3Loader;
		public var distance:Number;
		
		public function Audio(data:Object = null) {
			if (data != null) {
				_id = data.id;
				label = data.label;
				distance = data.distance;
				sound = new MP3Loader(data.path, {autoplay: false, volume: 0});
			}
		}
		
		public function get id():int {
			return _id;
		}
		
		public function get componentType():String {
			return "Audio";
		}
		
		public function destroy():void {
			if (sound != null) {
				sound.pauseSound();
				sound.unload();
				sound.dispose();
				sound = null;
			}
		}
	
	}

}