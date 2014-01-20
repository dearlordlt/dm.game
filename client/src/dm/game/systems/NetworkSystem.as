package dm.game.systems {
	
	import com.electrotank.electroserver5.api.ConnectionResponse;
	import com.electrotank.electroserver5.api.EsObject;
	import com.electrotank.electroserver5.api.JoinRoomEvent;
	import com.electrotank.electroserver5.api.LoginRequest;
	import com.electrotank.electroserver5.api.LoginResponse;
	import com.electrotank.electroserver5.api.MessageType;
	import com.electrotank.electroserver5.api.PluginMessageEvent;
	import com.electrotank.electroserver5.api.PluginRequest;
	import com.electrotank.electroserver5.api.RoomVariableUpdateEvent;
	import com.electrotank.electroserver5.api.UserUpdateEvent;
	import com.electrotank.electroserver5.api.UserVariableUpdateEvent;
	import com.electrotank.electroserver5.ElectroServer;
	import flash.events.Event;
	import net.richardlord.ash.core.System;
	
	/**
	 * ...
	 * @author
	 */
	public class NetworkSystem extends System {
		
		private var _es:ElectroServer;
		
		public function NetworkSystem() {
			
			_es = new ElectroServer();
			
			_es.engine.addEventListener(MessageType.ConnectionResponse.name, onConnectionResponse);
			_es.engine.addEventListener(MessageType.LoginResponse.name, onLoginResponse);
			_es.engine.addEventListener(MessageType.JoinRoomEvent.name, onJoinRoom);
			_es.engine.addEventListener(MessageType.PluginMessageEvent.name, onPluginMessage);
			_es.engine.addEventListener(MessageType.UserUpdateEvent.name, onUserUpdate);
			_es.engine.addEventListener(MessageType.RoomVariableUpdateEvent.name, onRoomVariableUpdate);
			_es.engine.addEventListener(MessageType.UserVariableUpdateEvent.name, onUserVariableUpdate);
			
			connect();
		}
		
		private function onUserUpdate(e:UserUpdateEvent):void {

		}
		
		private function onRoomVariableUpdate(e:RoomVariableUpdateEvent):void {
		
		}
		
		private function onUserVariableUpdate(e:UserVariableUpdateEvent):void {
		
		}
		
		private function onPluginMessage(e:PluginMessageEvent):void {
		
		}
		
		private function connect():void {
			_es.loadAndConnect("config/connections.xml");
		}
		
		private function onConnectionResponse(e:ConnectionResponse):void {
			trace("Connection: " + e.successful);
			
			// login
			var lr:LoginRequest = new LoginRequest();
			lr.userName = "Vasia2";
			lr.password = "pwd";
			_es.engine.send(lr);
		}
		
		private function onLoginResponse(e:LoginResponse):void {
			trace("Login: " + e.successful);
			
			// join room
			var pr:PluginRequest = new PluginRequest();
			pr.pluginName = "DmExt";
			pr.parameters = new EsObject();
			pr.parameters.setString("action", "joinRoom");
			pr.parameters.setString("roomName", "MoonWorld");
			_es.engine.send(pr);
		}
		
		private function onJoinRoom(e:JoinRoomEvent):void {
			trace("NetworkSystem.onRoomJoin(): Room '" + e.roomName + "' joined.");
			trace("RoomVariables: " + e.roomVariables.length);
		}
	}
}