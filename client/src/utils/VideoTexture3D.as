package utils {
	import flare.core.Texture3D;
	import flare.system.Device3D;
	import flash.display.BitmapData;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	/**
	 * This example shows how to create a dynamic animated texture from a video.
	 *
	 * @author Ariel Nehmad
	 */
	public class VideoTexture3D extends Texture3D {
		
		private var _connection:NetConnection;
		private var _url:String;
		private var _init:Boolean;
		
		public var stream:NetStream;
		public var video:Video;
		
		public function VideoTexture3D(url:String, width:int, height:int, transparent:Boolean = false) {
			super(new BitmapData(width, height, transparent), true);
			
			// disable the mip mapping to speed up the uploads.
			super.mipMode = Texture3D.MIP_NONE;
			
			// tells to the texture that doesn't need to load anything.
			// we'll stream the video by our own.
			super.loaded = true;
			
			video = new Video(width, height);
			video.deblocking = 1;
			video.smoothing = false;
			video.addEventListener("enterFrame", updateVideoEvent);
			video.addEventListener(Event.REMOVED_FROM_STAGE, onVideoRemoved);
			
			_url = url;
			_connection = new NetConnection();
			_connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			_connection.connect(null);
		}
		
		private function onVideoRemoved(e:Event):void 
		{
			//removeEventListener(Event.REMOVED_FROM_STAGE, onVideoRemoved);
			trace("VIDEO REMOVED");
		}
		
		/**
		 * Manages the video streaming status.
		 */
		private function netStatusHandler(e:NetStatusEvent):void {
			switch (e.info.code) {
				case "NetConnection.Connect.Success":
					
					stream = new NetStream(_connection);
					stream.client = {onMetaData: function(obj:Object):void {
						}}
					stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, function(e:*):void {
						});
					stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
					stream.checkPolicyFile = true;
					stream.bufferTime = 10;
					stream.play(_url);
					
					video.attachNetStream(stream);
					
					break;
				case "NetStream.Play.Complete": 
				case "NetStream.Play.Stop":
					stream.play();
					break;
				case "NetStream.Play.StreamNotFound":
					trace("Unable to locate video: " + _url);
					break;
			}
		}
		
		/**
		 * Here we update the texture bitmapData and upload the texture to the graphics card.
		 */
		private function updateVideoEvent(e:Event):void {
			if (bitmapData) {
				bitmapData.draw(video);
				upload(Device3D.scene);
			} else
				destroy();
		}
		
		public function destroy():void {
			stream.close();
			_connection.close();
			video.removeEventListener("enterFrame", updateVideoEvent);
		}
	}
}