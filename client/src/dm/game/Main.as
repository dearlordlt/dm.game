package dm.game {

import com.bit101.components.Style;
import com.electrotank.electroserver5.api.JoinRoomEvent;
import dm.builder.Builder;
import dm.builder.interfaces.BuilderMessage;
import dm.builder.interfaces.map.World3D;
import dm.builder.interfaces.WindowManager;
import dm.game.characterbuilder.CharacterBuilder;
import dm.game.components.InputController;
import dm.game.data.service.UserService;
import dm.game.managers.AnimationManager;
import dm.game.managers.EntityCreator;
import dm.game.managers.EntityManager;
import dm.game.managers.EsManager;
import dm.game.managers.MapManager;
import dm.game.managers.MyManager;
import dm.game.managers.NpcManager;
import dm.game.managers.UserManager;
import dm.game.routines.OnJoinRoomRoutine;
import dm.game.systems.AudioSystem;
import dm.game.systems.CameraManager;
import dm.game.systems.Element2DPlacementSystem;
import dm.game.systems.InputSystem;
import dm.game.systems.InteractionSystem;
import dm.game.systems.render.SkinFactory;
import dm.game.systems.RenderAndPhysicsSystem;
import dm.game.windows.chooseavatar.ChooseAvatar;
import dm.game.windows.DmWindowManager;
import dm.game.windows.inventory.Inventory;
import dm.game.windows.login.Login;
import fl.controls.Button;
import fl.controls.Label;
import fl.controls.List;
import fl.controls.SelectableList;
import fl.managers.StyleManager;
import flare.basic.Scene3D;
import flare.system.Input3D;
import flash.display.LoaderInfo;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.text.Font;
import flash.text.TextFormat;
import net.hires.debug.Stats;
import net.richardlord.ash.core.Entity;
import net.richardlord.ash.core.Game;
import ucc.data.service.AmfPhpClient;
import ucc.logging.client.MonsterDebuggerClient;
import ucc.logging.Logger;
import ucc.ui.window.WindowsManager;
import ucc.util.FlashVarsUtil;
import utils.Utils;

/**
 * Application entry
 *
 * Some terms overview:
 *
 * Abbreviation "Es" means Electro server
 *
 * World3D encapsulates Flare3D class Scene3D and provides base management routined like model loading and etc.
 * @author
 */

[SWF( width='1024',height='768',backgroundColor='#999999',frameRate='30' )]
public class Main extends Sprite {
	
	/** Singleton instance */
	private static var instance 		: Main;
	
	/** Service gateway url */
	private const GATEWAY_URL 			: String = "http://vds000004.hosto.lt/amfphp_dev/gateway.php";
	
	/** Electro server gateway url */
	private const ES_GATEWAY_URL 		: String = "213.190.49.139:9899";
	
	/** Core entity system manager */
	private var _game 					: Game;
	
	/** Render and physics system */
	private var _renderAndPhysics 		: RenderAndPhysicsSystem;
	
	/** World builder */
	private var _builder 				: Builder;
	
	/** Core 3D world */
	private var _world 					: World3D;
	
	/** Performance statistics view */
	private var stats 					: Stats;
	
	/** Camera manager */
	public static var cameraManager 	: CameraManager;
	
	/** Builder mode? */
	// private var builderMode 			: Boolean = CONFIG::BUILDER_MODE;
	private var builderMode 			: Boolean = true;
	
	/** Default room to join */
//<<<<<<< .mine
	// TODO: move to external settings
	// private var _roomToJoin 		: String = "LootTest";
	//private var _roomToJoin 		: String = "naujas-trinti";
	private var _roomToJoin 		: String = "patyciu";
	// private var _roomToJoin 		: String = "bug_02/04";
	// private var _roomToJoin 		: String = "mapo_bugas1";
	// private var _roomToJoin 		: String = "puciko_testai";
	// private var _roomToJoin 		: String = "sostine";
	// private var _roomToJoin 		: String = "maziausias_8/8/12";
//=======
	//private var _roomToJoin 		: String = CONFIG::ROOM; 
//>>>>>>> .r33
	
	/**
	 * Class constructor
	 */
	public function Main() : void {
		
		// setup singleton reference
		Main.instance = this;
		
		if ( stage ) {
			init();
		} else {
			addEventListener( Event.ADDED_TO_STAGE, init );
		}
		
	}
	
	/**
	 * Get singleton instance of class
	 * @return 	singleton instance	Main
	 */
	public static function getInstance() : Main {
		return Main.instance;
	}
	
	/**
	 * On display list initialized
	 */
	private function init( e : Event = null ) : void {
		
		// set up Monster debugger logger
		Logger.client = new MonsterDebuggerClient();
		
		removeEventListener( Event.ADDED_TO_STAGE, init );
		// entry point
		
		stage.align = StageAlign.TOP_LEFT;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		
		FlashVarsUtil.initialize( this.stage );
		
		this.setStyles();
		
		AmfPhpClient.getInstance().setCredentials( FlashVarsUtil.getParameter( "gatewayUrl", GATEWAY_URL ) as String );
		EsManager.instance.setConnectionCredentials( FlashVarsUtil.getParameter( "esGatewayUrl", ES_GATEWAY_URL ) as String );
		
		WindowsManager.getInstance().setDefaultParentContainer( this );
		
		DmWindowManager.instance.windowLayer = this;
		
		// initializing login view
		var login : Login = new Login( this );
		login.loginSignal.add( this.onLogin );
		
		// Adding performance statistics
		stats = new Stats();
		addChild( stats );
		stats.y = stage.stageHeight - stats.height;
		
		this._roomToJoin = FlashVarsUtil.getParameter( "room", this._roomToJoin );
		this.builderMode = FlashVarsUtil.getParameter( "builderMode", this.builderMode.toString() ) == "true";
	
	}
	
	private function setStyles () : void {
		
		// setting global UI style for minimal comps
		Style.setStyle( Style.DARK );		
		
		// label styles
		var dmLightFont	: Font = new dmLight();
		var labelTextFormat	: TextFormat = new TextFormat(dmLightFont.fontName, 12, 0xFFFFFF );
		StyleManager.setComponentStyle( Label, "textFormat", labelTextFormat );
		StyleManager.setComponentStyle( Button, "textFormat", new TextFormat( dmLightFont.fontName, 12, 0x6D6E70, true ) );
		StyleManager.setComponentStyle( List, "contentPadding", 2 );
		
	}
	
	/**
	 * Get World3D
	 */
	public function getWorld3D() : World3D {
		return this._world;
	}
	
	/**
	 * On login
	 */
	private function onLogin() : void {
		
		trace( "[dm.game.Main.onLogin] builderMode : " + builderMode );
		
		if ( builderMode ) {
			if ( MyManager.instance.amIAdmin() ) {
				this.onMapEditAllowed( 
					{ 
						map : [ "true", "true", "true", "true", "true", "true", "true", "true" ],
						map : [ "true", "true", "true", "true", "true", "true", "true", "true", "true" ],
						entity : [ "true", "true", "true", "true" ]
					} 
				);
				return;
			} else {
				UserService.getRoomBuilderPermissions( MyManager.instance.id, this.getCurrentRoomName() )
							.addResponders( this.onMapEditAllowed, this.onMapEditDenied )
							.call();
				return;
			}
		}
		
		// initializing game world (not builder)
		var characterBuilder : CharacterBuilder;
		
		if ( MyManager.instance.availableAvatars.length > 0 ) {
			var chooseAvatar : ChooseAvatar = new ChooseAvatar( this );
			chooseAvatar.avatarSelectedSignal.add( onAvatarSelected );
		} else {
			characterBuilder = new CharacterBuilder();
			addChild( characterBuilder );
			characterBuilder.avatarSavedSignal.add( onAvatarSaved );
		}
		
		// TODO: what the hell is this? Why internal functions?
		function onAvatarSelected( avatar : Object ) : void {
			if ( avatar == null ) {
				characterBuilder = new CharacterBuilder();
				addChild( characterBuilder );
				characterBuilder.avatarSavedSignal.add( onAvatarSaved );
			} else {
				onAvatarSaved( avatar );
			}
		}
		
		function onAvatarSaved( avatar : Object ) : void {
			if ( characterBuilder != null ) {
				characterBuilder.destroy();
			}
			MyManager.instance.avatar = avatar;
			initGameWorld();
			EsManager.instance.connect( null );
			EsManager.instance.esLoginSignal.add( onEsLogin );
		}
	
	}
	
	/**
	 * On map edit allowed
	 */
	protected function onMapEditAllowed ( response : Object ) : void {
		this.initGameWorld();
		this.enterBuilderMode( response );
	}
	
	/**
	 * On map edit denied
	 */
	protected function onMapEditDenied ( response : Boolean ) : void {
		new BuilderMessage( this, _( "Access denied!" ), _( "You don\'t have enought rights to enter builder mode!" ), this.onEnterBuilderModeFailedAlertBoxDismiss );
	}
	
	/**
	 * Show login form again if user fails to log into builder mode because he is not admin
	 */
	protected function onEnterBuilderModeFailedAlertBoxDismiss() : void {
		var login : Login = new Login( this );
		login.loginSignal.add( this.onLogin );
	}
	
	/**
	 * Game world is initialized here
	 */
	private function initGameWorld() : void {
		_world = new World3D( this );
		_game = new Game();
		
		EntityManager.instance.game = _game;
		EntityCreator.instance.scene = _world.scene;
		MapManager.instance.world = _world;
		AnimationManager.instance;
		NpcManager.instance.scene = _world.scene;
		
		SkinFactory.defaultScene = _world.scene;
		UserManager.instance;
		
		// Add new systems here
		
		_renderAndPhysics = new RenderAndPhysicsSystem( _world );
		_game.addSystem( _renderAndPhysics, 10 );
		
		CameraManager.instance.camera = _world.scene.camera;
		_game.addSystem( CameraManager.instance, 9 );
		
		_game.addSystem( new InputSystem, 7 );
		_game.addSystem( new Element2DPlacementSystem( this, _world.scene ), 8 );
		
		if ( !builderMode ) {
			_game.addSystem( new InteractionSystem( _world.scene ), 10 );
			_game.addSystem( new AudioSystem(), 11 );
		}
		
		//var speedTweaker:AvatarSpeedTweaker = new AvatarSpeedTweaker(this);
		
		_world.scene.addEventListener( Scene3D.UPDATE_EVENT, onSceneUpdate );
	}
	
	/**
	 * Get current room name
	 */
	public function getCurrentRoomName () : String {
		return this._roomToJoin;
	}
	
	/**
	 * Set current room name
	 */
	public function setCurrentRoomName ( value : String ) : void {
		this._roomToJoin = value;
	}
	
	/**
	 * On electro server login
	 */
	private function onEsLogin() : void {
		trace( "[dm.game.Main.onEsLogin] : Electro server login routine complete!" );
		EsManager.instance.esLoginSignal.remove( onEsLogin );
		EsManager.instance.joinRoom( _roomToJoin );
		EsManager.instance.esJoinRoomSignal.add( onEsJoinRoom );
	}
	
	private function onEsJoinRoom( e : JoinRoomEvent ) : void {
		trace( "[dm.game.Main.onEsJoinRoom] : Room joined!" );
		var onJoinRoomRoutine : OnJoinRoomRoutine = new OnJoinRoomRoutine( _world );
		onJoinRoomRoutine.execute();
	}
	
	private function onSceneUpdate( e : Event ) : void {
		_game.update( 1 / RenderAndPhysicsSystem.SCENE_FRAMERATE );
	
		// TODO: remove
	/*
	   if (Input3D.keyHit(Input3D.F1)) {
	   var test:TimeTest = new TimeTest(this, MyManager.instance.myCharacterEntity.get(InputController).avatarController);
	   test.test();
	 }*/
	}
	
	private function enterBuilderMode( permissions : Object ) : void {
		if ( _builder == null ) {
			for each ( var entity : Entity in EntityManager.instance.entities ) {
				if ( entity.has( InputController ) ) {
					EntityManager.instance.removeEntity( entity );
				}
			}
			_builder = new Builder( this, _world, _game, permissions );
		}
	}

}

}