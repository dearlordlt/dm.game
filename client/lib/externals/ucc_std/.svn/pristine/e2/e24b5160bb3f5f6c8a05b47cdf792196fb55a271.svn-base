package ucc.net {
	
	import flash.events.NetStatusEvent;
	import flash.utils.Dictionary;
	
	/**
	 * Net status info utility
	 */
	public class NetStatusInfo {
		
		/** Status */
		static private const STATUS : String = "status";
		
		/** Error */
		static private const ERROR : String = "error";
		
		/** Waring */
		static private const WARNING : String = "warning";
		
		private var _code : String;
		private var _level : String;
		private var _meaning : String;
		
		/**
		 * Net status info
		 * @param	code
		 * @param	level
		 * @param	meaning
		 */
		public function NetStatusInfo( code : String, level : String, meaning : String ) {
			this._code = code;
			this._level = level;
			this._meaning = meaning;
		}
		
		public function get code() : String {
			return _code;
		}
		
		public function get level() : String {
			return _level;
		}
		
		public function get meaning() : String {
			return _meaning;
		}
		
		public function toString() : String {
			return "NetStatusEvent level: " + this.level + ", code : " + this.code + ", meaning: " + this.meaning;
		}
		
		public static const NETSTREAM_BUFFER_EMPTY : NetStatusInfo = new NetStatusInfo( "NetStream.Buffer.Empty", STATUS, "Data is not being received quickly enough to fill the buffer. Data flow will be interrupted until the buffer refills, at which time a NetStream.Buffer.Full message will be sent and the stream will begin playing again." );
		
		public static const NETSTREAM_BUFFER_FULL : NetStatusInfo = new NetStatusInfo( "NetStream.Buffer.Full", STATUS, "The buffer is full and the stream will begin playing." );
		
		public static const NETSTREAM_BUFFER_FLUSH : NetStatusInfo = new NetStatusInfo( "NetStream.Buffer.Flush", STATUS, "Data has finished streaming, and the remaining buffer will be emptied." );
		
		public static const NETSTREAM_FAILED : NetStatusInfo = new NetStatusInfo( "NetStream.Failed", ERROR, "Flash Media Server only. An error has occurred for a reason other than those listed in other event codes." );
		
		public static const NETSTREAM_PUBLISH_START : NetStatusInfo = new NetStatusInfo( "NetStream.Publish.Start", STATUS, "Publish was successful." );
		
		public static const NETSTREAM_PUBLISH_BADNAME : NetStatusInfo = new NetStatusInfo( "NetStream.Publish.BadName", ERROR, "Attempt to publish a stream which is already being published by someone else." );
		
		public static const NETSTREAM_PUBLISH_IDLE : NetStatusInfo = new NetStatusInfo( "NetStream.Publish.Idle", STATUS, "The publisher of the stream is idle and not transmitting data." );
		
		public static const NETSTREAM_UNPUBLISH_SUCCESS : NetStatusInfo = new NetStatusInfo( "NetStream.Unpublish.Success", STATUS, "The unpublish operation was successfuul." );
		
		public static const NETSTREAM_PLAY_START : NetStatusInfo = new NetStatusInfo( "NetStream.Play.Start", STATUS, "Playback has started." );
		
		public static const NETSTREAM_PLAY_STOP : NetStatusInfo = new NetStatusInfo( "NetStream.Play.Stop", STATUS, "Playback has stopped." );
		
		public static const NETSTREAM_PLAY_FAILED : NetStatusInfo = new NetStatusInfo( "NetStream.Play.Failed", ERROR, "An error has occurred in playback for a reason other than those listed elsewhere in this table, such as the subscriber not having read access." );
		
		public static const NETSTREAM_PLAY_STREAMNOTFOUND : NetStatusInfo = new NetStatusInfo( "NetStream.Play.StreamNotFound", ERROR, "The FLV passed to the play() method can't be found." );
		
		public static const NETSTREAM_PLAY_RESET : NetStatusInfo = new NetStatusInfo( "NetStream.Play.Reset", STATUS, "Caused by a play list reset." );
		
		public static const NETSTREAM_PLAY_PUBLISHNOTIFY : NetStatusInfo = new NetStatusInfo( "NetStream.Play.PublishNotify", STATUS, "The initial publish to a stream is sent to all subscribers." );
		
		public static const NETSTREAM_PLAY_UNPUBLISHNOTIFY : NetStatusInfo = new NetStatusInfo( "NetStream.Play.UnpublishNotify", STATUS, "An unpublish from a stream is sent to all subscribers." );
		
		public static const NETSTREAM_PLAY_INSUFFICIENTBW : NetStatusInfo = new NetStatusInfo( "NetStream.Play.InsufficientBW", WARNING, "Flash Media Server only. The client does not have sufficient bandwidth to play the data at normal speed." );
		
		public static const NETSTREAM_PLAY_FILESTRUCTUREINVALID : NetStatusInfo = new NetStatusInfo( "NetStream.Play.FileStructureInvalid", ERROR, "The application detects an invalid file structure and will not try to play this type of file. For AIR and for Flash Player 9.0.115.0 and later." );
		
		public static const NETSTREAM_PLAY_NOSUPPORTEDTRACKFOUND : NetStatusInfo = new NetStatusInfo( "NetStream.Play.NoSupportedTrackFound", ERROR, "The application does not detect any supported tracks (video, audio or data) and will not try to play the file. For AIR and for Flash Player 9.0.115.0 and later." );
		
		public static const NETSTREAM_PLAY_TRANSITION : NetStatusInfo = new NetStatusInfo( "NetStream.Play.Transition", STATUS, "Flash Media Server only. The stream transitions to another as a result of bitrate stream switching. This code indicates a success status event for the NetStream.play2() call to initiate a stream switch. If the switch does not succeed, the server sends a NetStream.Play.Failed event instead. For Flash Player 10 and later. Flash Media Server 3.5 and later only. The server received the command to transition to another stream as a result of bitrate stream switching. This code indicates a success status event for the NetStream.play2() call to initiate a stream switch. If the switch does not succeed, the server sends a NetStream.Play.Failed event instead. When the stream switch occurs, an onPlayStatus event with a code of \"NetStream.Play.TransitionComplete\" is dispatched. For Flash Player 10 and later." );
		
		public static const NETSTREAM_PAUSE_NOTIFY : NetStatusInfo = new NetStatusInfo( "NetStream.Pause.Notify", STATUS, "The stream is paused." );
		
		public static const NETSTREAM_UNPAUSE_NOTIFY : NetStatusInfo = new NetStatusInfo( "NetStream.Unpause.Notify", STATUS, "The stream is resumed." );
		
		public static const NETSTREAM_RECORD_START : NetStatusInfo = new NetStatusInfo( "NetStream.Record.Start", STATUS, "Recording has started." );
		
		public static const NETSTREAM_RECORD_NOACCESS : NetStatusInfo = new NetStatusInfo( "NetStream.Record.NoAccess", ERROR, "Attempt to record a stream that is still playing or the client has no access right." );
		
		public static const NETSTREAM_RECORD_STOP : NetStatusInfo = new NetStatusInfo( "NetStream.Record.Stop", STATUS, "Recording stopped." );
		
		public static const NETSTREAM_RECORD_FAILED : NetStatusInfo = new NetStatusInfo( "NetStream.Record.Failed", ERROR, "An attempt to record a stream failed." );
		
		public static const NETSTREAM_SEEK_FAILED : NetStatusInfo = new NetStatusInfo( "NetStream.Seek.Failed", ERROR, "The seek fails, which happens if the stream is not seekable." );
		
		public static const NETSTREAM_SEEK_INVALIDTIME : NetStatusInfo = new NetStatusInfo( "NetStream.Seek.InvalidTime", ERROR, "For video downloaded with progressive download, the user has tried to seek or play past the end of the video data that has downloaded thus far, or past the end of the video once the entire file has downloaded. The message.details property contains a time code that indicates the last valid position to which the user can seek." );
		
		public static const NETSTREAM_SEEK_NOTIFY : NetStatusInfo = new NetStatusInfo( "NetStream.Seek.Notify", STATUS, "The seek operation is complete." );
		
		public static const NETCONNECTION_CALL_BADVERSION : NetStatusInfo = new NetStatusInfo( "NetConnection.Call.BadVersion", ERROR, "Packet encoded in an unidentified format." );
		
		public static const NETCONNECTION_CALL_FAILED : NetStatusInfo = new NetStatusInfo( "NetConnection.Call.Failed", ERROR, "The NetConnection.call method was not able to invoke the server-side method or command." );
		
		public static const NETCONNECTION_CALL_PROHIBITED : NetStatusInfo = new NetStatusInfo( "NetConnection.Call.Prohibited", ERROR, "An Action Message Format (AMF) operation is prevented for security reasons. Either the AMF URL is not in the same domain as the file containing the code calling the NetConnection.call() method, or the AMF server does not have a policy file that trusts the domain of the the file containing the code calling the NetConnection.call() method." );
		
		public static const NETCONNECTION_CONNECT_CLOSED : NetStatusInfo = new NetStatusInfo( "NetConnection.Connect.Closed", STATUS, "The connection was closed successfully." );
		
		public static const NETCONNECTION_CONNECT_FAILED : NetStatusInfo = new NetStatusInfo( "NetConnection.Connect.Failed", ERROR, "The connection attempt failed." );
		
		public static const NETCONNECTION_CONNECT_SUCCESS : NetStatusInfo = new NetStatusInfo( "NetConnection.Connect.Success", STATUS, "The connection attempt succeeded." );
		
		public static const NETCONNECTION_CONNECT_REJECTED : NetStatusInfo = new NetStatusInfo( "NetConnection.Connect.Rejected", ERROR, "The connection attempt did not have permission to access the application." );
		
		public static const NETSTREAM_CONNECT_CLOSED : NetStatusInfo = new NetStatusInfo( "NetStream.Connect.Closed", STATUS, "The P2P connection was closed successfully.  The info.stream property indicates which stream has closed." );
		
		public static const NETSTREAM_CONNECT_FAILED : NetStatusInfo = new NetStatusInfo( "NetStream.Connect.Failed", ERROR, "The P2P connection attempt failed.  The info.stream property indicates which stream has failed." );
		
		public static const NETSTREAM_CONNECT_SUCCESS : NetStatusInfo = new NetStatusInfo( "NetStream.Connect.Success", STATUS, "The P2P connection attempt succeeded.  The info.stream property indicates which stream has succeeded." );
		
		public static const NETSTREAM_CONNECT_REJECTED : NetStatusInfo = new NetStatusInfo( "NetStream.Connect.Rejected", ERROR, "The P2P connection attempt did not have permission to access the other peer.  The info.stream property indicates which stream was rejected." );
		
		public static const NETCONNECTION_CONNECT_APPSHUTDOWN : NetStatusInfo = new NetStatusInfo( "NetConnection.Connect.AppShutdown", ERROR, "The specified application is shutting down." );
		
		public static const NETCONNECTION_CONNECT_INVALIDAPP : NetStatusInfo = new NetStatusInfo( "NetConnection.Connect.InvalidApp", ERROR, "The application name specified during connect is invalid." );
		
		public static const SHAREDOBJECT_FLUSH_SUCCESS : NetStatusInfo = new NetStatusInfo( "SharedObject.Flush.Success", STATUS, "The \"pending\" status is resolved and the SharedObject.flush() call succeeded." );
		
		public static const SHAREDOBJECT_FLUSH_FAILED : NetStatusInfo = new NetStatusInfo( "SharedObject.Flush.Failed", ERROR, "The \"pending\" status is resolved, but the SharedObject.flush() failed." );
		
		public static const SHAREDOBJECT_BADPERSISTENCE : NetStatusInfo = new NetStatusInfo( "SharedObject.BadPersistence", ERROR, "A request was made for a shared object with persistence flags, but the request cannot be granted because the object has already been created with different flags." );
		
		public static const SHAREDOBJECT_URIMISMATCH : NetStatusInfo = new NetStatusInfo( "SharedObject.UriMismatch", ERROR, "An attempt was made to connect to a NetConnection object that has a different URI (URL) than the shared object." );
		
		/**
		 * Get info object by code
		 */
		public static function getNetStatusInfoByCode( code : String ) : NetStatusInfo {
			
			var netStatusInfo : NetStatusInfo;
			
			if ( netStatusInfo = NetStatusInfoTable.getInstance().getNetStatusByCode( code ) ) {
				return netStatusInfo;
			} else {
				trace( "[utils.NetStatusInfo.getInfoObjectByCode] : NetStatusInfo with code " + code + " not found!" );
				return null;
			}
		
		}
	
	}
}

