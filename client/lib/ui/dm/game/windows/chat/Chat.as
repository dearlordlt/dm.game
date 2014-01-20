package dm.game.windows.chat {

import com.electrotank.electroserver5.api.JoinRoomEvent;
import com.electrotank.electroserver5.api.LeaveRoomEvent;
import com.electrotank.electroserver5.api.LeaveRoomRequest;
import com.electrotank.electroserver5.api.LoginResponse;
import com.electrotank.electroserver5.api.MessageType;
import com.electrotank.electroserver5.api.PrivateMessageEvent;
import com.electrotank.electroserver5.api.PrivateMessageRequest;
import com.electrotank.electroserver5.api.PublicMessageEvent;
import com.electrotank.electroserver5.api.PublicMessageRequest;
import com.electrotank.electroserver5.user.User;
import com.electrotank.electroserver5.zone.Room;
import dm.game.functions.ParameterizedCommand;
import dm.game.managers.EsManager;
import dm.game.managers.MyManager;
import dm.game.windows.alert.Alert;
import dm.game.windows.chat.command.AddFriendByNameCommand;
import dm.game.windows.chat.command.QueryAvatarProfile;
import dm.game.windows.DmWindow;
import dm.game.windows.DmWindowManager;
import dm.game.windows.trade.TradeManager;
import fl.controls.Button;
import fl.controls.TextArea;
import fl.controls.TextInput;
import fl.events.ComponentEvent;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.TextEvent;
import flash.geom.Point;
import flash.text.StyleSheet;
import flash.ui.Keyboard;
import flash.utils.Dictionary;
import org.as3commons.lang.StringUtils;
import ucc.util.ArrayUtil;
import ucc.util.sprintf;
import utils.AMFPHP;

/**
 * Chat windows
 * @version $Id: Chat.as 216 2013-10-02 05:00:40Z rytis.alekna $
 */
[Single]
[Updatable]
public class Chat extends DmWindow {
	
	/** Event name postfix */
	public static const EVENT_NAME_POSTFIX		: String = "#";
	
	/** Chat line template */
	private static const CHAT_LINE_TEMPLATE		: String = "<font color=\"\#%s\">[%s] <a href='event:" + AVATAR_LINK_EVENT + EVENT_NAME_POSTFIX + "%s'><u>%s</u></a> : %s</font><br>";
	private static const SYSTEM_LINE_TEMPLATE	: String = "<font color=\"\#%s\">[%s] %s : %s</font><br>";
	
	/** CHAT_USER_NAME_PREFIX */
	public static const CHAT_USER_NAME_PREFIX : String = "\x20__chatuser__";
	
	public static const ADMIN_ROOM_NAME			: String = "\x20ADMIN";
	

	
	/** Text event type matcher */
	private static const EVENT_NAME_MATCHER		: RegExp = /^(?P<eventType>[a-z]+)\#(?P<text>.*)$/i;
	
	/** Link event types */
	private static const AVATAR_LINK_EVENT		: String = "avatar";
	private static const ITEM_LINK_EVENT		: String = "item";
	private static const CHANNEL_LINK_EVENT		: String = "channel";
	
	/** Max chat width */
	private static const MAX_CHAT_WIDTH			: int = 450;
	private static const TABS_MARGIN			: int = 5;
	private static const TAB_LINE_HEIGHT		: int = 25;
	
	/** Colors */
	private static const OWN_COLOR				: uint = 0x006699;
	private static const CHAT_COLOR				: uint = 0x666666;
	private static const ADMIN_COLOR			: uint = 0x990000;
	private static const COMMAND_COLOR			: uint = 0x006666;
	private static const SUCCESS_COLOR			: uint = 0x009900;
	private static const ERROR_COLOR			: uint = 0xFF0000;
	private static const LINK_COLOR				: uint = 0xFF6633;
	
	/** Commands map */
	private static const COMMANDS_MAP : Object = { 
		"add"		: new CommandConfig( AddFriendByNameCommand, [ "friendName" ] ), 
		"who"		: new CommandConfig( QueryAvatarProfile, [ QueryAvatarProfile.AVATAR_NAME ] )
	};
	
	/** History text area */
	public var historyTextAreaDO 			: TextArea;
	
	/** Text input */
	public var textInputDO 					: TextInput;
	
	/** Submit button */
	public var submitButtonDO 				: Button;
	
	/** Last private message sender */
	private var _lastPrivateMessageFrom 	: String = "";
	
	/** Commands to ignore */
	private var commandsToIgnore 			: Array = [ "trade" ];
	
	/** Chat server manager */
	protected var chatServerManager			: ChatServerManager;
	
	/** Awway from keyboard? */
	protected var awayFromKeyboard			: Boolean;
	
	/** Current room */
	protected var currentChannel			: Object;
	
	/** Local room */
	protected var localRoom					: Room;
	
	/** Admin room */
	protected var adminRoom					: Room;
	
	/** Buttons container */
	protected var buttonsContainerDO		: Sprite = new Sprite();
	
	/** Rooms to buttons */
	protected var channelsToButtons			: Dictionary = new Dictionary( true );
	
	/** Buttons to rooms */
	protected var buttonsToChannels			: Dictionary = new Dictionary( true );
	
	/** Rooms history */
	protected var channelsHistory			: Dictionary = new Dictionary(true);
	
	/** Channels */
	protected var channels					: Array = [];
	
	/** Removed channels */
	protected var removedChannels			: Array = [];
	
	/**
	 * (Constructor)
	 * - Returns a new Chat instance
	 * @param	parent
	 */
	public function Chat( parent : DisplayObjectContainer = null ) {
		// constructor code
		super( null, _( "Chat" ) );
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function initialize() : void {
		
		this.addChild( this.buttonsContainerDO );
		this.buttonsContainerDO.x = 15;
		this.buttonsContainerDO.y = 35;
		
		this.chatServerManager = ChatServerManager.getInstance();
		this.chatServerManager.setConnectionCredentials( "213.190.49.139:9899", "ChatZone", CHAT_USER_NAME_PREFIX + MyManager.instance.avatar.name );
		this.chatServerManager.connect();		
		
		//listen for certain events to allow the application to flow, and to support chatting 
		EsManager.instance.es.engine.addEventListener( MessageType.PublicMessageEvent.name, onPublicMessageEvent );
		EsManager.instance.es.engine.addEventListener( MessageType.PrivateMessageEvent.name, onPrivateMessageEvent );
		
		this.chatServerManager.getEngine().addEventListener( MessageType.PublicMessageEvent.name, onPublicMessageEvent );
		this.chatServerManager.getEngine().addEventListener( MessageType.PrivateMessageEvent.name, onPrivateMessageEvent );
		this.chatServerManager.getEngine().addEventListener( MessageType.LoginResponse.name, onChatServerManagerLogin );
		
		this.localRoom = EsManager.instance.room;
		EsManager.instance.es.engine.addEventListener(MessageType.JoinRoomEvent.name, this.onJoinRoom );
		EsManager.instance.es.engine.addEventListener(MessageType.LeaveRoomEvent.name, this.onLeaveRoom );
		this.chatServerManager.getEngine().addEventListener(MessageType.JoinRoomEvent.name, this.onJoinRoom );
		this.chatServerManager.getEngine().addEventListener(MessageType.LeaveRoomEvent.name, this.onLeaveRoom );
		
		DmWindowManager.instance.chat = this;
		
		this.textInputDO.addEventListener( ComponentEvent.ENTER, this.onEnterKeyDown );
		this.submitButtonDO.addEventListener( MouseEvent.CLICK, this.onEnterKeyDown );
		
		this.historyTextAreaDO.textField.addEventListener( TextEvent.LINK, this.onHistoryLinkClick );
		
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function postInitialize () : void {
		this.addChannel( EsManager.instance.room, true );
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function destroy() : void {
		visible = false;
	}
	
	/**
	 *	On key down
	 */
	protected function onKeyDown( event : KeyboardEvent ) : void {
		if ( event.keyCode != Keyboard.ENTER ) {
			event.stopPropagation();
		}
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function getInitialPosition() : Point {
		return new Point( this.stage.stageWidth - width, this.stage.stageHeight - height );
	}
	
	private function isChannelOpened ( channel : Object ) : Boolean {
		return ( this.channels.indexOf( channel ) >= 0 );
	}
	
	private function addChannel ( channel : Object, open : Boolean = false ) : void {
		
		if ( this.channels.indexOf( channel ) == -1 ) {
			this.channels.push( channel );
			if ( open ) {
				this.setCurrentChannel( channel );
			}
			this.redrawTabs();
		} else {
			if ( open ) {
				this.focusToChannel( channel );
			}
			return;
		}
		
	}
	
	private function removeChannel ( channel : Object ) : void {
		
		if ( channel is Room ) {
			
			var room : Room = channel as Room;
			
			var lrr : LeaveRoomRequest = new LeaveRoomRequest();
			lrr.zoneId = room.zoneId;
			lrr.roomId = room.id;
			
			this.chatServerManager.getEngine().send( lrr );
			
		} else {
			this.removeChannelTab( channel );
		}
		
	}
	
	private function removeChannelTab ( channel : Object ) : void {
		var channelIndex : int = this.channels.indexOf( channel );
		ArrayUtil.removeElementByEquality( this.channels, channel );
		this.removedChannels.push( channel );
		
		if ( channelIndex > 0 ) {
			this.focusToChannel( this.channels[ channelIndex - 1 ] );
		} else {
			this.focusToChannel( this.channels[ channelIndex ] );
		}
		
		this.redrawTabs();		
	}
	
	private function redrawTabs () : void {
		
		var buttonDO : Button;
		
		var channel : Object;
		
		var lastX : Number = 0;
		
		var lastY : Number = 0;
		
		for each( channel in this.removedChannels ) {
			buttonDO = this.channelsToButtons[ channel ];
			delete this.channelsToButtons[ channel ];
			delete this.buttonsToChannels[ buttonDO ];
			this.buttonsContainerDO.removeChild( buttonDO );
		}
		
		this.removedChannels.length = 0;
		
		for each( channel in this.channels ) {
			
			buttonDO = this.channelsToButtons[ channel ]
			
			if ( !buttonDO ) {
				buttonDO = new Button();
				this.buttonsContainerDO.addChild( buttonDO );
				if ( channel is Room ) {
					buttonDO.label = "#" + Room(  channel ).name;
				} else {
					buttonDO.label = "#" + this.removeUserNamePrefix( User(  channel ).userName );
				}
				
				// select
				buttonDO.toggle = true;
				
				if ( this.currentChannel == channel ) {
					buttonDO.selected = true;
					buttonDO.enabled = false;
				} else {
					buttonDO.emphasized = true;
				}
				
				buttonDO.drawNow();
				buttonDO.width = buttonDO.textField.textWidth + 14;
				buttonDO.addEventListener( MouseEvent.CLICK, this.onChannelButtonClick );
				
				this.channelsToButtons[ channel ] 	= buttonDO;
				this.buttonsToChannels[ buttonDO ] 	= channel;
				
				this.loadChannelHistory( channel );
				
			}
			
			if ( ( buttonDO.width + lastX + TABS_MARGIN ) > MAX_CHAT_WIDTH ) {
				lastX = 0;
				lastY += TAB_LINE_HEIGHT;
			}
			
			buttonDO.x = lastX;
			buttonDO.y = lastY;
			lastX += TABS_MARGIN + buttonDO.width;
			
		}
		
		this.historyTextAreaDO.y 	= this.buttonsContainerDO.height + TABS_MARGIN + 35;
		
		this.textInputDO.y 			= 
		this.submitButtonDO.y 		= this.historyTextAreaDO.y + TABS_MARGIN + this.historyTextAreaDO.height;
		
		this.redraw();
		
		this.y = this.getInitialPosition().y;
		
	}
	
	private function setCurrentChannel ( channel : Object ) : void {
		
		var buttonDO : Button;
		
		if ( this.currentChannel && ( this.currentChannel != channel ) ) {
			buttonDO = this.channelsToButtons[ this.currentChannel ];
			if ( buttonDO ) {
				buttonDO.selected = false;
				buttonDO.enabled = true;
			}
		}
		
		this.currentChannel = channel;
		
	}
	
	/**
	 * Fired when the client receives a public chat message from the server. Add the message tot he history field.
	 */
	private function onPublicMessageEvent( event : PublicMessageEvent ) : void {
		var color : uint = this.isUserMe( event.userName ) ? OWN_COLOR : CHAT_COLOR;
		
		if ( ( event.roomId == this.adminRoom.id ) && ( event.zoneId == this.adminRoom.zoneId ) ) {
			this.addMessageToHistory( this.currentChannel, ADMIN_COLOR, _( "ADMINISTRATOR" ), event.message );
		} else {
			this.addMessageToHistory( this.getRoomById( event.zoneId, event.roomId ), color, this.removeUserNamePrefix( event.userName ), event.message );
		}
		
	}
	
	private function isUserMe ( userName : String ) : Boolean {
		return MyManager.instance.avatar.name == this.removeUserNamePrefix( userName );
	}
	
	private function removeUserNamePrefix ( username : String ) : String {
		if ( username.indexOf( CHAT_USER_NAME_PREFIX ) == 0 ) {
			return username.slice( CHAT_USER_NAME_PREFIX.length );
		}
		return username;
	}
	
	/**
	 * current room is local?
	 */
	protected function isCurrentRoomLocal () : Boolean {
		return this.currentChannel == this.localRoom;
	}
	
	/**
	 *	On local room join
	 */
	protected function onLocalRoomJoin () : void {
		this.localRoom = EsManager.instance.room;
	}
	
	/**
	 *	On join room
	 */
	protected function onJoinRoom ( event : JoinRoomEvent ) : void {
		
		var room : Room = this.getRoomById( event.zoneId, event.roomId );
		
		if ( room.name != ADMIN_ROOM_NAME ) {
			this.addChannel( this.getRoomById( event.zoneId, event.roomId ), true );
		} else {
			this.adminRoom = room;
		}
		
	}
	
	/**
	 * Insert text to input
	 */
	public function insertTextToInput ( text : String ) : void {
		this.textInputDO.text += text;
	}
	
	public function tradeItem ( id : int, label : String ) : void {
		this.textInputDO.text = __("#{I sell }<a color='#" + LINK_COLOR + "' href='event:" + ITEM_LINK_EVENT + EVENT_NAME_POSTFIX + id + "'>&lt;<u>" + label + "</u>&gt;</a>");
		this.sendMessage();
	}
	
	/**
	 *	On channel button click
	 */
	protected function onChannelButtonClick ( event : MouseEvent ) : void {
		this.focusToChannel( this.buttonsToChannels[ event.target ] );
	}
	
	/**
	 * Focus to channel
	 */
	protected function focusToChannel ( channel : Object ) : void {	
		
		var buttonDO : Button = this.channelsToButtons[ channel ];
		
		this.setCurrentChannel( channel );
		
		buttonDO.selected = true;
		buttonDO.enabled = false;
		buttonDO.emphasized = false;
		
		this.loadChannelHistory( this.currentChannel );
		
	}
	
	protected function loadChannelHistory ( channel : Object ) : void {
		if ( this.channelsHistory[ channel ] ) {
			this.historyTextAreaDO.htmlText = this.channelsHistory[ channel ];
		} else {
			this.historyTextAreaDO.htmlText = "";
		}
		
	}
	
	/**
	 *	On chat server manager login
	 */
	protected function onChatServerManagerLogin ( event : LoginResponse ) : void {
		this.chatServerManager.joinRoom( ADMIN_ROOM_NAME );
	}
	
	/**
	 *	On history link click
	 */
	protected function onHistoryLinkClick ( event : TextEvent ) : void {
		
		var eventData : Object = EVENT_NAME_MATCHER.exec( event.text );
		
		trace( "[dm.game.windows.chat.Chat.onHistoryLinkClick] eventData : " + JSON.stringify( eventData, null, 4 ) );
		
		var eventType 	: String = eventData.eventType;
		var eventText	: String = eventData.text;
		
		switch (eventType) {
			
			case AVATAR_LINK_EVENT:
				this.openPrivateChannel( eventText );
				break;
				
			case CHANNEL_LINK_EVENT:
				var args : Array = eventText.split("|");
				trace( "[dm.game.windows.chat.Chat.onHistoryLinkClick] args : " + JSON.stringify( args, null, 4 ) );
				this.addChannel( this.getRoomById( parseInt( args[0] ), parseInt( args[1] ) ), true );
				break;
				
			default:
				break;
			
		}
		
	}
	
	/**
	 *	On leave room
	 */
	protected function onLeaveRoom ( event : LeaveRoomEvent ) : void {
		var room : Room = this.getRoomById( event.zoneId, event.roomId );
		this.removeChannelTab( room );
	}
	
	public function openPrivateChannel ( userName : String ) : void {
		
		var user : User = this.getUserByName( userName );
		
		if ( !user ) {
			Alert.show( _("User is not online now!"), _("Chat") );
			return;
		}
		
		this.addChannel( user, true );
		
	}
	
	/**
	 * Gets the room by id of the specified id.
	 */
	public function getRoomById ( zoneId : int, roomId : int ) : Room {
		
		if ( ( this.localRoom.id == roomId ) && ( this.localRoom.zoneId == zoneId ) ) {
			return this.localRoom;
		} else {
			return this.chatServerManager.getServer().managerHelper.zoneManager.zoneById( zoneId ).roomById( roomId );
		}
		
	}
	
	public function getUserByName ( name : String ) : User {
		var retVal : User = this.chatServerManager.getServer().managerHelper.userManager.userByName( name );
		if ( !retVal ) {
			retVal = EsManager.instance.es.managerHelper.userManager.userByName( this.removeUserNamePrefix( name ) );
		}
		return retVal;
	}
	
	/**
	 * On private message event
	 */
	private function onPrivateMessageEvent( event : PrivateMessageEvent ) : void {
		
		var input : String = StringUtils.trimToEmpty( this.textInputDO.text );
		
		// for ignoring system trade messages. See dm.game.windows.trade.TradeManager
		if ( input.charAt( 0 ) == "/" ) {
			var cmd : String = String( input.split( " " )[ 0 ] ).substr( 1 );
			
			if ( commandsToIgnore.indexOf( cmd ) > -1 ) {
				return;
			}
		}
		
		/*
		if ( event.userName != MyManager.instance.avatar.name ) {
			_lastPrivateMessageFrom = event.userName;
		}
		
		*/
		
		var user : User = this.getUserByName( event.userName );
		
		if ( !this.isChannelOpened( user ) ) {
			this.addChannel( user, false );
		}
		
		var color : uint = user.isMe ? OWN_COLOR : CHAT_COLOR;
		
		this.addMessageToHistory( user, color, user.userName, event.message );
			
		if ( this.awayFromKeyboard ) {
			this.sendPrivateMessage( this.removeUserNamePrefix( event.userName ), _("User is away from keyboard!") );
		}		
		
	}
	
	/**
	 * Called when the 'send' button is clicked or the enter key is used.
	 */
	private function sendMessage() : void {
		
		var input : String = StringUtils.trimToEmpty( this.textInputDO.text );
		
		if ( input == "" ) {
			return;
		}
		
		// TODO: make this stuff in OOP way
		
		if ( input.charAt( 0 ) == "/" ) {
			var cmd : String = String( input.split( " " )[ 0 ] ).substr( 1 );
			var msg : String = input.replace( "/" + cmd + " ", "" );
			
			var commandTokens : Array = msg.split( " " );
			
			this.awayFromKeyboard = false;
			
			if ( COMMANDS_MAP[ cmd ] ) {
				
				var commandConfig : CommandConfig           = COMMANDS_MAP[ cmd ];
				var commandInstance : ParameterizedCommand  = new commandConfig.clazz() as ParameterizedCommand;
				
				commandInstance.setParams( CommandConfig.inputTokensToParams( commandTokens, commandConfig.paramsOrder ), this.outputCommandResult );
				commandInstance.execute();
				
			} else {
				
				switch ( cmd ) {
					
					case "trade": 
						var username : String = String( input.split( " " )[ 1 ] );
						trace( "Chat: Starting trade with '" + username + "'." );
						TradeManager.instance.sendTradeRequest( username );
						break;
					case "home": 
						var avatarId : String = ( input.split( " " )[ 1 ] ) ? String( input.split( " " )[ 1 ] ) : String( MyManager.instance.avatar.id );
						EsManager.instance.joinRoom( EsManager.HOME_ROOM_NAME + '@' + avatarId );
						
						/*
						   if (avatarId)
						   EsManager.instance.joinRoom(EsManager.HOME_ROOM_NAME + '@' + avatarId);
						   else
						   EsManager.instance.joinRoom(EsManager.HOME_ROOM_NAME + '@' + MyManager.instance.avatar.id);
						 */
						
						break;
					
					case "afk":
						this.awayFromKeyboard = true;
						break;
					
					case "admin":
						this.sendGlobalMessage( commandTokens.join( " " ) );
						break;
					
					case "j":
					case "join":
						this.chatServerManager.joinRoom( commandTokens[0] );
						break;
					
					case "l":
					case "leave":
						if ( this.currentChannel == this.localRoom ) {
							this.outputCommandResult( _("You can\'t leave this channel!") );
						} else {
							this.removeChannel( this.currentChannel );
						}
						break;
					
					case "invite":
						this.inviteUserToChannel( commandTokens[0] );
						break;
						
					default: 
						sendPrivateMessage( cmd, msg );
						break;
				}
				
			}
			
			this.addMessageToHistory( this.currentChannel, SUCCESS_COLOR, MyManager.instance.username, input, true );
			
		} else {
			
			if ( ( this.currentChannel is Room )  ) {
				this.sendPublicMessage( input );
			} else {
				this.sendPrivateMessage( User( this.currentChannel ).userName, input );
			}
			
		}
		
		this.textInputDO.text = "";
		
		// var amfphp : AMFPHP = new AMFPHP().xcall( "dm.SocialCapital.messageSent", MyManager.instance.avatar.id );
	}
	
	private function addMessageToHistory ( channel : Object, color : uint, user : String, message : String, system : Boolean = false ) : void {
		
		var formatedMessage : String;
		
		if ( system ) {
			formatedMessage = sprintf( SYSTEM_LINE_TEMPLATE, color, this.getTimeString(), user, message );
		} else {
			formatedMessage = sprintf( CHAT_LINE_TEMPLATE, color, this.getTimeString(), user, user, message );
		}
		
		
		if ( !this.channelsHistory[ channel ] ) {
			this.channelsHistory[ channel ] = "";
		}
		
		this.channelsHistory[ channel ] += formatedMessage;
		
		if ( this.currentChannel == channel ) {
			this.historyTextAreaDO.htmlText += formatedMessage;
			this.historyTextAreaDO.verticalScrollPosition = this.historyTextAreaDO.maxVerticalScrollPosition;
		}
		
	}
	
	private function inviteUserToChannel ( userName : String ) : void {
		
		var user : User = this.getUserByName( userName );
		
		if ( !( this.currentChannel is Room ) ) {
			this.outputCommandResult( _("You\'re not in channel!"), true );
			return;
		}
		
		if ( this.currentChannel == this.localRoom ) {
			this.outputCommandResult( _("You can\'t invite users to this channel!"), true );
			return;
		}
		
		if ( user ) {
			this.sendPrivateMessage( userName, __("#{I invite you to channel} ") + "<a href='event:" + CHANNEL_LINK_EVENT + EVENT_NAME_POSTFIX + Room( this.currentChannel ).zoneId + "|" + Room( this.currentChannel ).id + "'><u>" + Room( this.currentChannel ).name + "</u></a>" )
		} else {
			this.outputCommandResult( _("User is not online or name is incorrect!"), true );
		}
		
	}
	
	private function sendGlobalMessage ( message : String ) {
		
		if ( !MyManager.instance.amIAdmin() ) {
			this.outputCommandResult( _("You don\'t have enought rights to send global message!"), true );
			return;
		}
		
		var pmr : PublicMessageRequest = new PublicMessageRequest();
		pmr.roomId = this.adminRoom.id;
		pmr.zoneId = this.adminRoom.zoneId;
		pmr.message = message;		
		
		this.chatServerManager.getEngine().send( pmr );
		
	}
	
	/**
	 * Send public message
	 */
	private function sendPublicMessage ( message : String ) : void {
		
		if ( this.isCurrentRoomLocal() ) {
			var pmr : PublicMessageRequest = new PublicMessageRequest();
			pmr.roomId = this.currentChannel.id;
			pmr.zoneId = this.currentChannel.zoneId;
			pmr.message = message;
			EsManager.instance.es.engine.send( pmr );		
		} else {
			this.chatServerManager.sendPublicMessage( message, this.currentChannel as Room );
		}
		
	}
	
	private function outputCommandResult( result : String, error : Boolean = false ) : void {
		var color : uint = error ? ERROR_COLOR : SUCCESS_COLOR;
		if ( result ) {
			this.historyTextAreaDO.htmlText += sprintf( SYSTEM_LINE_TEMPLATE, color, this.getTimeString(), "CHAT", result );  // "<font color=\"#" + color + "\">" + result + "</font><br>";
		}
	}
	
	/**
	 * Gets the time string
	 */
	private function getTimeString () : String {
		var date : Date = new Date();
		return sprintf( "%02d:%02d:%02d", date.getHours(), date.getMinutes(), date.getSeconds() );
	}
	
	private function sendPrivateMessage( username : String, msg : String ) : void {
		var pm : PrivateMessageRequest = new PrivateMessageRequest();
		pm.userNames = [ username ];
		pm.message = msg;
		EsManager.instance.es.engine.send( pm );
	}
	
	private function onEnterKeyDown( event : Event ) : void {
		if ( StringUtils.trimToEmpty( this.textInputDO.text ).length > 0 ) {
			this.sendMessage();
		}
	}

}

}
