package dm.game.windows.chat {
	import com.electrotank.electroserver5.api.*;
	import com.electrotank.electroserver5.connection.AvailableConnection;
	import com.electrotank.electroserver5.connection.ESEngine;
	import com.electrotank.electroserver5.ElectroServer;
	import com.electrotank.electroserver5.server.Server;
	import com.electrotank.electroserver5.user.User;
	import com.electrotank.electroserver5.zone.Room;
	import dm.game.managers.MyManager;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import ucc.error.IllegalStateException;
	import ucc.logging.Logger;

/**
 * Creates and manages chat connection. It is needed because game connection is very tight with game logic and it is not posible to join other rooms to chat
 * @version $Id: ChatServerManager.as 213 2013-09-27 15:34:47Z rytis.alekna $
 */
[Event(name="dm.game.windows.chat.MessageEvent.PUBLIC_MESSAGE", type="dm.game.windows.chat.MessageEvent")]
public class ChatServerManager extends EventDispatcher {
		
	/** Electro server */
	protected var electroServer				: ElectroServer;
	
	/** connectionCredentials */
	protected var connectionCredentials 	: String;
	
	/** Room names to ids */
	protected var roomsByName				: Object = { };
	
	/** Room ids to names */
	protected var roomsById					: Object = { };
	
	/** All joined rooms */
	protected var rooms						: Array = [];
	
	/** zoneName */
	protected var zoneName 					: String;
	
	/** userName */
	protected var userName 					: String;
	
	/**
	 * (Constructor)
	 * - Returns a new ChatServerManager instance
	 */
	public function ChatServerManager() {
		
	}
	
	/** Singleton instance */
	private static var instance : ChatServerManager;
	
	/**
	 * Get singleton instance of class
	 * @return 	singleton instance	ChatServerManager
	 */
	public static function getInstance () : ChatServerManager {
		return ChatServerManager.instance ? ChatServerManager.instance : ( ChatServerManager.instance = new ChatServerManager() );
	}
	
	
	/**
	 * Determinates whether this instance is connected
	 */
	public function isConnected () : Boolean {
		return this.electroServer.engine.connected;
	}
	
	/**
	 * connects this instace.
	 */
	public function connect () : void {
		
		if ( this.electroServer && this.electroServer.engine.connected ) {
			throw new IllegalStateException( "Chat server is already connected!" );
		}
		
		if ( !this.connectionCredentials ) {
			throw new IllegalStateException( "Connection credentials not set!" );
		}
		
		var credentials:Array = this.connectionCredentials.split(":");
		
		this.electroServer = new ElectroServer();
		
		// listeners
			
		
		this.electroServer.engine.addEventListener(MessageType.ConnectionResponse.name, onConnectionResponse);
		this.electroServer.engine.addEventListener(MessageType.ConnectionClosedEvent.name, onConnectionClosed);
		this.electroServer.engine.addEventListener(MessageType.LoginResponse.name, this.onLoginResponse );
		
		this.electroServer.engine.addEventListener(MessageType.JoinRoomEvent.name, this.onJoinRoom );
		
			/*
			this.electroServer.engine.addEventListener(MessageType.PluginMessageEvent.name, onPluginMessage);
			//_es.engine.addEventListener(MessageType.RoomVariableUpdateEvent.name, onRoomVariableUpdate);
			this.electroServer.engine.addEventListener(MessageType.UserUpdateEvent.name, onUserUpdate);
			this.electroServer.engine.addEventListener(MessageType.UserVariableUpdateEvent.name, onUserVariableUpdate);		
			*/
			
		var server : Server = new Server("dm_chat");
		server.addAvailableConnection( new AvailableConnection(credentials[0], parseInt(credentials[1])) );
		this.electroServer.engine.addServer( server );
		
		Logger.log( "Establishing connection to chat server", Logger.LEVEL_INFO );
		
		this.electroServer.engine.connect();
		
	}
	
	/**
	 * Set connection credentials
	 * @param	connectionCredentials
	 */
	public function setConnectionCredentials(connectionCredentials:String, zoneName : String, userName : String ):void {
		this.userName = userName;
		this.zoneName = zoneName;
		this.connectionCredentials = connectionCredentials;
	}	
	
	/**
	 *	On connection response
	 */
	protected function onConnectionResponse ( event : ConnectionResponse ) : void {
		if ( event.successful ) {
			
			Logger.log( "Chat connection established", Logger.LEVEL_INFO );
			
			this.login();
			
		} else {
			Logger.log( "Chat connection couldn\'t be established", Logger.LEVEL_ERROR );
		}
	}
	
	/**
	 * login
	 */
	protected function login () : void {
		
		var loginRequest : LoginRequest = new LoginRequest();
		
		var avatar:EsObject = new EsObject();
		avatar.setString("name", MyManager.instance.avatar.name);
		avatar.setInteger("id", MyManager.instance.avatar.id);
		avatar.setInteger("characterType", MyManager.instance.avatar.character_type);
		avatar.setInteger("schoolId", MyManager.instance.school.id);
		loginRequest.userVariables["avatar"] = avatar;		
		
		loginRequest.userName = this.userName;
		
		trace( "[dm.game.windows.chat.ChatServerManager.login()]" );
		
		this.electroServer.engine.send( loginRequest );
		
	}
	
	public function joinRoom ( roomName : String ) : void {
		
		var createRoomRequest:CreateRoomRequest = new CreateRoomRequest();
		createRoomRequest.zoneName = this.zoneName;
		createRoomRequest.roomName = roomName;
		this.electroServer.engine.send( createRoomRequest );
		
	}
	
	public function sendPublicMessage ( message : String, room : Room ) : void {
		
		var pmr:PublicMessageRequest = new PublicMessageRequest();
		pmr.roomId 	= room.id;
		pmr.zoneId 	= room.zoneId;
		pmr.message = message;
		
		this.electroServer.engine.send(pmr);
		
	}
	
	/**
	 * Gets the engine of this instance.
	 */
	public function getEngine () : ESEngine {
		return this.electroServer.engine;
	}
	
	/**
	 * Gets the server of this instance.
	 */
	public function getServer () : ElectroServer {
		return this.electroServer;
	}
	
	private function onLoginResponse( event : LoginResponse):void {
		
		trace("EsManager: Login status: " + event.successful);
		
		if (!event.successful) {
			Logger.log( "Couldn\'t login to chat server: " + event.error.name, Logger.LEVEL_ERROR );
		} else {
			// esLoginSignal.dispatch();
		}
	}	
	
	protected function onConnectionClosed ( event : ConnectionClosedEvent ) : void {
		
		trace( "[dm.game.windows.chat.ChatServerManager.onConnectionClosed()]" );
	}
	
	/**
	 *	On join room
	 */
	protected function onJoinRoom ( event : JoinRoomEvent ) : void {
		
		var room : Room = this.electroServer.managerHelper.zoneManager.zoneByName( this.zoneName ).roomByName( event.roomName );
		
		this.roomsByName[ event.roomName ] = room;
		this.roomsById[ event.roomId ] = room;
		this.rooms.push( room );
		
		trace( "[dm.game.windows.chat.ChatServerManager.onJoinRoom()] : " + event.roomName );
	}
	
}

}