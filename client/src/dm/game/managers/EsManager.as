package dm.game.managers {
	
	import com.electrotank.electroserver5.api.ConnectionClosedEvent;
	import com.electrotank.electroserver5.api.ConnectionResponse;
	import com.electrotank.electroserver5.api.CreateRoomRequest;
	import com.electrotank.electroserver5.api.EsObject;
	import com.electrotank.electroserver5.api.JoinRoomEvent;
	import com.electrotank.electroserver5.api.LeaveRoomRequest;
	import com.electrotank.electroserver5.api.LoginRequest;
	import com.electrotank.electroserver5.api.LoginResponse;
	import com.electrotank.electroserver5.api.MessageType;
	import com.electrotank.electroserver5.api.PluginMessageEvent;
	import com.electrotank.electroserver5.api.UserUpdateEvent;
	import com.electrotank.electroserver5.api.UserVariableUpdateEvent;
	import com.electrotank.electroserver5.connection.AvailableConnection;
	import com.electrotank.electroserver5.ElectroServer;
	import com.electrotank.electroserver5.server.Server;
	import com.electrotank.electroserver5.user.User;
	import com.electrotank.electroserver5.zone.Room;
	import dm.builder.interfaces.WindowManager;
	import dm.game.data.service.AvatarService;
	import dm.game.data.service.RoomService;
	import dm.game.data.service.RoomsService;
	import dm.game.windows.alert.Alert;
	import dm.game.windows.DmWindowManager;
	import net.richardlord.ash.signals.Signal0;
	import net.richardlord.ash.signals.Signal1;
	import ucc.error.IllegalStateException;
	import ucc.logging.Logger;
	import ucc.ui.window.WindowsManager;
	import ucc.util.Delegate;
	import utils.AMFPHP;
	
	/**
	 * Electro server manager
	 * @author zenia
	 */
	public class EsManager {
		
		public static const HOME_ROOM_NAME:String = "home";
		
		/** connection credentials */
		protected var connectionCredentials:String;
		
		private static var _instance:EsManager;
		
		private static var _usingGetInstance:Boolean = false;
		
		private var _es:ElectroServer;
		
		private var _room:Room;
		
		private var _roomData:Object;
		
		public var esLoginSignal:Signal0 = new Signal0();
		
		public var esJoinRoomSignal:Signal1 = new Signal1(JoinRoomEvent);
		
		public var esPluginMessageSignal:Signal1 = new Signal1(PluginMessageEvent);
		
		public var userUpdateSignal:Signal1 = new Signal1(UserUpdateEvent);
		
		public var userVariableUpdateSignal:Signal1 = new Signal1(UserVariableUpdateEvent);
		
		//Log.setLogAdapter(new ES5TraceAdapter());
		
		public function EsManager() {
			if (!_usingGetInstance) {
				throw new Error("Please use getInstance().");
			}
			
			_es = new ElectroServer();
			setupEsListeners();
		}
		
		public static function get instance():EsManager {
			if (_instance == null) {
				_usingGetInstance = true;
				_instance = new EsManager();
				_usingGetInstance = false;
			}
			return _instance;
		}
		
		private function setupEsListeners():void {
			_es.engine.addEventListener(MessageType.ConnectionResponse.name, onConnectionResponse);
			_es.engine.addEventListener(MessageType.ConnectionClosedEvent.name, onConnectionClosed);
			_es.engine.addEventListener(MessageType.LoginResponse.name, onLoginResponse);
			_es.engine.addEventListener(MessageType.JoinRoomEvent.name, onJoinRoom);
			_es.engine.addEventListener(MessageType.PluginMessageEvent.name, onPluginMessage);
			//_es.engine.addEventListener(MessageType.RoomVariableUpdateEvent.name, onRoomVariableUpdate);
			_es.engine.addEventListener(MessageType.UserUpdateEvent.name, onUserUpdate);
			_es.engine.addEventListener(MessageType.UserVariableUpdateEvent.name, onUserVariableUpdate);
		}
		
		private function onConnectionClosed(e:ConnectionClosedEvent):void {
			trace("dm.game.managers.EsManager.onConnectionClosed() : serverId" + e.serverId);
		}
		
		private function onUserVariableUpdate(e:UserVariableUpdateEvent):void {
			userVariableUpdateSignal.dispatch(e);
		}
		
		private function onUserUpdate(e:UserUpdateEvent):void {
			trace("EsManager.onUserUpdate");
			userUpdateSignal.dispatch(e);
		}
		
		/**
		 * Set connection credentials
		 * @param	connectionCredentials
		 */
		public function setConnectionCredentials(connectionCredentials:String):void {
			this.connectionCredentials = connectionCredentials;
		}
		
		public function connect(connectionCredentials:String):void {
			
			if (!connectionCredentials) {
				connectionCredentials = this.connectionCredentials;
			}
			
			var credentials:Array = connectionCredentials.split(":");
			var server:Server = new Server("localhost");
			// var server : Server = new Server( connectionCredentials );
			trace("[dm.game.managers.EsManager.setConnectionCredentials] credentials[ 0 ], parseInt( credentials[ 1 ] : " + credentials[0], parseInt(credentials[1]));
			server.addAvailableConnection(new AvailableConnection(credentials[0], parseInt(credentials[1])));
			//server.addAvailableConnection(new AvailableConnection("localhost", 9899));
			_es.engine.addServer(server);
			
			trace("EsManager: Establishing connection...");
			if (_es.engine.servers.length == 0) {
				throw new IllegalStateException("dm.game.managers.EsManager.connect() : Can\'t open connection while no credentials set!");
			}
			_es.engine.connect();
		}
		
		private function onConnectionResponse(e:ConnectionResponse):void {
			if (!e.successful) {
				Logger.log("dm.game.managers.EsManager.onConnectionResponse() : Connection failed ");
				Alert.show(_("There was a problem while connecting to game server!"), _("Connection failed"));
			} else {
				this.login(MyManager.instance.avatar.name);
			}
		}
		
		private function onPluginMessage(e:PluginMessageEvent):void {
			//trace(e.parameters);
			esPluginMessageSignal.dispatch(e);
		}
		
		public function login(userName:String):void {
			trace("EsManager: Logging in...");
			var lr:LoginRequest = new LoginRequest();
			lr.userName = userName;
			
			trace( "[dm.game.managers.EsManager.login] MyManager.instance.avatar : " + JSON.stringify( MyManager.instance.avatar, null, 4 ) );
			
			var avatar:EsObject = new EsObject();
			avatar.setString("name", MyManager.instance.avatar.name);
			avatar.setInteger("id", MyManager.instance.avatar.id);
			avatar.setInteger("skin3dId", MyManager.instance.avatar.skin3d_id);
			avatar.setInteger("characterType", MyManager.instance.avatar.character_type);
			avatar.setInteger("schoolId", MyManager.instance.school.id);
			lr.userVariables["avatar"] = avatar;
			
			_es.engine.send(lr);
		}
		
		private function onLoginResponse(e:LoginResponse):void {
			trace("EsManager: Login status: " + e.successful);
			
			if (!e.successful) {
				Alert.show(e.error.name);
			} else {
				esLoginSignal.dispatch();
			}
		}
		
		/**
		 * Join room
		 */
		public function joinRoom(label:String):void {
			
			trace("EsManager: Joining room '" + label + "'.");
			var dbRoomName:String = (label.split('@')[0] == HOME_ROOM_NAME) ? HOME_ROOM_NAME : label;			
			var amfphp:AMFPHP = new AMFPHP(Delegate.create(onRoomData, label), Delegate.create(this.onRoomDataLoadFail, label));
			amfphp.xcall("dm.Room.getRoomByLabel", dbRoomName);
			DmWindowManager.instance.showPreloader();
		}
		
		/**
		 * On room data loaded
		 */
		protected function onRoomData(response:Object, label:String):void {
			// leaving current room
			leaveCurrentRoom();
			trace("EsManager.onRoomData()");
			_roomData = response;
			var createRoomRequest:CreateRoomRequest = new CreateRoomRequest();
			createRoomRequest.zoneName = "MoonWorld";
			createRoomRequest.roomName = label;
			_es.engine.send(createRoomRequest);
		}
		
		/**
		 * On room data load fail failed
		 */
		protected function onRoomDataLoadFail(roomLabel:String, label:String):void {
			Alert.show("No room with name: '" + label + "'");
		}
		
		/**
		 * Leave current room
		 */
		private function leaveCurrentRoom():void {
			if (!_room) {
				return;
			}
			var lrr:LeaveRoomRequest = new LeaveRoomRequest();
			lrr.roomId = _room.id;
			lrr.zoneId = _room.zoneId;
			_es.engine.send(lrr);
		}
		
		private function onJoinRoom(e:JoinRoomEvent):void {
			trace("EsManager: onJoinRoom()");
			_room = _es.managerHelper.zoneManager.zoneById(e.zoneId).roomById(e.roomId);
			esJoinRoomSignal.dispatch(e);
		}
		
		/*private function onRoomVariableUpdate(e:RoomVariableUpdateEvent):void {
		   trace("EsManager.onRoomVariableUpdate()");
		 }*/
		
		public function get es():ElectroServer {
			return _es;
		}
		
		public function get room():Room {
			return _room;
		}
		
		public function get me():User {
			return _es.managerHelper.userManager.me;
		}
		
		public function get roomData():Object {
			return _roomData;
		}
	}

}