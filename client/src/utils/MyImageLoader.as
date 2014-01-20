package utils {
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class MyImageLoader extends EventDispatcher {
		
		private var _loader:Loader;
		private var _path:String;
		
		public function MyImageLoader(path:String) {
			_loader = new Loader();
			_path = path;
		}
		
		public function load():void {
			var request:URLRequest = new URLRequest(_path);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			_loader.load(request);
		}
		
		private function onLoadComplete(e:Event):void {
			dispatchEvent(e);
		}
		
		public function get bitmap():Bitmap {
			return _loader.content as Bitmap;
		}
		
		public function dispose():void {
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
			_loader.unload();
		}
	
	}

}