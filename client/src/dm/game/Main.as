package dm.game {
	
	import com.bit101.components.Style;
	import com.electrotank.electroserver5.api.JoinRoomEvent;
	import dm.builder.Builder;
	import dm.builder.interfaces.map.World3D;
	import dm.builder.interfaces.tools.quest.QuestsManager;
	import dm.builder.interfaces.tools.ShopEditor;
	import dm.game.characterbuilder.CharacterBuilder;
	import dm.game.components.InputController;
	import dm.game.data.service.AvatarService;
	import dm.game.data.service.LangService;
	import dm.game.data.service.UserService;
	import dm.game.managers.AnimationManager;
	import dm.game.managers.EntityManager;
	import dm.game.managers.EsManager;
	import dm.game.managers.MapManager;
	import dm.game.managers.MyManager;
	import dm.game.managers.NpcManager;
	import dm.game.managers.UserManager;
	import dm.game.routines.OnJoinRoomRoutine;
	import dm.game.systems.AltSkinManager;
	import dm.game.systems.AudioSystem;
	import dm.game.systems.CameraManager;
	import dm.game.systems.Element2DPlacementSystem;
	import dm.game.systems.InputSystem;
	import dm.game.systems.InteractionSystem;
	import dm.game.systems.render.SkinFactory;
	import dm.game.systems.RenderAndPhysicsSystem;
	import dm.game.windows.chat.Chat;
	import dm.game.windows.chat.ChatServerManager;
	import dm.game.windows.chooseavatar.ChooseAvatar;
	import dm.game.windows.DmWindowManager;
	import dm.game.windows.intro.IntroVideoPlayer;
	import dm.game.windows.inventory.Inventory;
	import dm.game.windows.login.Login;
	import dm.game.windows.register.UserInfoUpdateWindow;
	import dm.game.windows.shop.Shop;
	import dm.game.windows.trade.TradeManager;
	import flare.basic.Scene3D;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import net.hires.debug.Stats;
	import net.richardlord.ash.core.Entity;
	import net.richardlord.ash.core.Game;
	import ucc.data.service.AmfPhpClient;
	import ucc.i18n.data.RowSetLocalizationData;
	import ucc.i18n.Localization;
	import ucc.i18n.LocalizationEvent;
	import ucc.logging.client.MonsterDebuggerClient;
	import ucc.logging.Logger;
	import ucc.project.dialog_editor.DialogEditor;
	import ucc.ui.skin.DmSkin;
	import ucc.ui.window.WindowEvent;
	import ucc.ui.window.WindowsManager;
	import ucc.util.FlashVarsUtil;
	
	/**
	 * Application entry
	 *
	 * Some terms overview:
	 *
	 * Abbreviation "Es" means Electro server
	 *
	 * World3D encapsulates Flare3D class Scene3D and provides base management routined like model loading and etc.
	 * @version $Id: Main.as 213 2013-09-27 15:34:47Z rytis.alekna $
	 */
	
	[SWF(width='1024',height='768',backgroundColor='#999999',frameRate='30')]
	
	public class Main extends Sprite {
		
		/** Singleton instance */
		private static var instance:Main;
		
		/** Service gateway url */
		private const GATEWAY_URL:String = "http://vds000004.hosto.lt/new_amfphp/Amfphp/";
		// private const GATEWAY_URL:String = "http://vds000004.hosto.lt/amfphp_dev/gateway.php";
		
		/** Electro server gateway url */
		private const ES_GATEWAY_URL:String = "213.190.49.139:9899";
		
		/** DEFAULT_SKIN */
		public static const DEFAULT_SKIN:String = CONFIG::SKIN;
		
		/** Stats enabled */
		public static const STATS_ENABLED : Boolean = CONFIG::STATS_ENABLED;
		
		/** Core entity system manager */
		private var _game:Game;
		
		/** Render and physics system */
		private var _renderAndPhysics:RenderAndPhysicsSystem;
		
		/** World builder */
		private var _builder:Builder;
		
		/** Core 3D world */
		private var _world:World3D;
		
		/** Performance statistics view */
		private var stats:Stats;
		
		private const CAMERA_DRAW_DISTANCE:int = 10000;
		
		/** Builder mode? */
		private var builderMode 			: Boolean = CONFIG::BUILDER_MODE;
		//private var builderMode:Boolean = false;
		
		///** Default room to join */
		private var _roomToJoin 			: String = CONFIG::ROOM;
		//private var _roomToJoin:String = "zzz";
		
		private var explicitRoom			: Boolean = CONFIG::EXPLICIT;
		
		
		
		/**
		 * Class constructor
		 */
		public function Main():void {
			
			// setup singleton reference
			Main.instance = this;
			
			if (stage) {
				init();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		
		}
		
		/**
		 * Get singleton instance of class
		 * @return 	singleton instance	Main
		 */
		public static function getInstance():Main {
			return Main.instance;
		}
		
		/**
		 * On display list initialized
		 */
		private function init(e:Event = null):void {
			
			// set up Monster debugger logger
			Logger.client = new MonsterDebuggerClient(this);
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			FlashVarsUtil.initialize(this.stage);
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onSkinsLoadComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onSkinsLoadError);
			
			var skin:String = FlashVarsUtil.getParameter("skin", DEFAULT_SKIN);
			
			loader.load(new URLRequest("components_" + skin + ".swf"), new LoaderContext(false, ApplicationDomain.currentDomain));
			
			this.setStyles();
			
			AmfPhpClient.getInstance().setCredentials(FlashVarsUtil.getParameter("gatewayUrl", GATEWAY_URL) as String);
			EsManager.instance.setConnectionCredentials(FlashVarsUtil.getParameter("esGatewayUrl", ES_GATEWAY_URL) as String);
			
			WindowsManager.getInstance().setDefaultParentContainer(this);
			
			DmWindowManager.instance.windowLayer = this;
			
			TradeManager.instance;
			
			Localization.getInstance().addEventListener(LocalizationEvent.UNTRANSLATED_STRING, this.onUntranslatedString);
			
			// Adding performance statistics
			
			if ( FlashVarsUtil.getParameter( "statsEnabled", STATS_ENABLED ) == "true" ) {
				stats = new Stats();
				addChild(stats);
				stats.y = stage.stageHeight - stats.height;
			}
			
			this.explicitRoom = FlashVarsUtil.getParameter("explicitRoom", this.explicitRoom);
			
			if ( this.explicitRoom ) {
				this._roomToJoin = FlashVarsUtil.getParameter("room", this._roomToJoin);
			} else {
				this._roomToJoin = null;
			}
			
			this.builderMode = FlashVarsUtil.getParameter("builderMode", this.builderMode.toString()) == "true";
		
		}
		
		private function setStyles():void {
			// setting global UI style for minimal comps
			Style.setStyle(Style.DARK);
		}
		
		/**
		 * On language data loaded
		 * @param	data
		 */
		protected function onLanguageDataLoaded(data:Object):void {
			Localization.getInstance().setLocalizationData(new RowSetLocalizationData(data, "lt", "en"));
			//Localization.getInstance().setLocalizationData(new RowSetLocalizationData(data, "en", "en"));
			
			// initializing login view
			
			// new AvatarProfile();
			
			// new QuestsManager();
			// remove return below
			// return;
			
			if (FlashVarsUtil.getParameter("auth", null)) {
				UserService.login(FlashVarsUtil.getParameter("auth", null), FlashVarsUtil.getParameter("p", null), true)
					.addResponders(this.onLoginSuccess, this.onLoginFail)
					.call();
			} else {
				var login:Login = new Login(this);
				login.loginSignal.add(this.onBeforeLogin);
			}
		
		}
		
		/**
		 * Get World3D
		 */
		public function getWorld3D():World3D {
			return this._world;
		}
		
		/**
		 * Before actual login check if user info is set
		 */
		private function onBeforeLogin () : void {
			// check if user info is set
			
			trace( "[dm.game.Main.onBeforeLogin()]" );
			
			UserService.isUserInfoSet( MyManager.instance.id )
				.addResponders( this.onUserInfoCheck, this.onUserInfoCheck )
				.call();			
		}
		
		/**
		 * On login
		 */
		private function onLogin():void {
			
			if (builderMode) {
				if (MyManager.instance.amIAdmin()) {
					this.onMapEditAllowed({map: ["true", "true", "true", "true", "true", "true", "true"], tools: ["true", "true", "true", "true", "true", "true", "true", "true", "true", "true", "true", "true", "true", "true", "true", "true", "true", "true", "true", "true", "true"], entity: ["true", "true", "true", "true"]});
					return;
				} else {
					UserService.getRoomBuilderPermissions(MyManager.instance.id, this.getCurrentRoomName()).addResponders(this.onMapEditAllowed, this.onMapEditDenied).call();
					return;
				}
			}
			
			// initializing game world (not builder)
			var characterBuilder:CharacterBuilder;
			
			if (MyManager.instance.availableAvatars.length > 0) {
				var chooseAvatar:ChooseAvatar = new ChooseAvatar(this);
				chooseAvatar.avatarSelectedSignal.add(onAvatarSelected);
			} else {
				characterBuilder = new CharacterBuilder();
				addChild(characterBuilder);
				characterBuilder.avatarSavedSignal.add(onAvatarSaved);
			}
			
			// TODO: what the hell is this? Why internal functions?
			function onAvatarSelected(avatar:Object):void {
				if (avatar == null) {
					characterBuilder = new CharacterBuilder();
					addChild(characterBuilder);
					characterBuilder.avatarSavedSignal.add(onAvatarSaved);
				} else {
					onAvatarSaved(avatar);
				}
			}
			
			function onAvatarSaved(avatar:Object):void {
				
				MyManager.instance.avatar = avatar;
				
				if (characterBuilder != null) {
					characterBuilder.destroy();
					
					// if comming from VDK don't show intro video
					if ( ( ["vdk", "bmc"] as Array ).indexOf( _roomToJoin ) == -1 ) {
						var videoPlayer:IntroVideoPlayer = new IntroVideoPlayer();
						videoPlayer.destroySignal.add(onIntroVideoComplete);
					} else {
						onIntroVideoComplete();
					}
				} else {
					onIntroVideoComplete();
				}
			
			}
		
		}
		
		public function setBuilderMode(value:Boolean):void {
			this.builderMode = value;
		}
		
		public function getBuilderMode():Boolean {
			return this.builderMode;
		}
		
		public function setRoomToJoin(room:String):void {
			this._roomToJoin = room;
		}
		
		public function getRoomToJoin():String {
			return this._roomToJoin;
		}
		
		/**
		 * Show intro video
		 */
		protected function onIntroVideoComplete(param:* = null):void {
			this.initGameWorld();
			EsManager.instance.connect(null);
			EsManager.instance.esLoginSignal.add(onEsLogin);
		}
		
		/**
		 * On map edit allowed
		 */
		protected function onMapEditAllowed(response:Object):void {
			this.initGameWorld();
			this.enterBuilderMode(response);
		}
		
		/**
		 * On map edit denied
		 */
		protected function onMapEditDenied(response:Boolean):void {
			new DialogEditor();
			// Alert.show(_("You don\'t have enought rights to enter builder mode!"), _("Access denied!"));
		}
		
		/**
		 * Show login form again if user fails to log into builder mode because he is not admin
		 */
		protected function onEnterBuilderModeFailedAlertBoxDismiss():void {
			var login:Login = new Login(this);
			login.loginSignal.add(this.onLogin);
		}
		
		/**
		 *	On login sucess (when loging in through external auth)
		 */
		protected function onLoginSuccess(response:Object):void {
			MyManager.instance.id = response.id;
			MyManager.instance.username = response.username;
			MyManager.instance.availableAvatars = response.avatars;
			MyManager.instance.isAdmin = (response.isadmin == "Y");
			MyManager.instance.school = response.school;
			
			this.onBeforeLogin();
			
		}
		
		/**
		 *	On login fail (when loging in through external auth)
		 */
		protected function onLoginFail():void {
			var login:Login = new Login(this);
			login.loginSignal.add(this.onLogin);
		}
		
		/**
		 *	On untranslated string
		 */
		protected function onUntranslatedString(event:LocalizationEvent):void {
			//trace("[dm.game.Main.onUntranslatedString] event.string : " + event.string);
			LangService.addNonDefinedString(event.string).call();
		}
		
		/**
		 *	On skins load complete
		 */
		protected function onSkinsLoadComplete(event:Event):void {
			
			// init styles
			(LoaderInfo(event.target).content as DmSkin).setStyles();
			
			LangService.getAllWords().addResponders(this.onLanguageDataLoaded).call();
		}
		
		/**
		 *	On skin load error
		 */
		protected function onSkinsLoadError(event:IOErrorEvent):void {
			
			// load defaut skin
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onSkinsLoadComplete);
			loader.load(new URLRequest("components_" + DEFAULT_SKIN + ".swf"), new LoaderContext(false, ApplicationDomain.currentDomain));
		
		}
		
		
		/**
		 *	On user info check
		 */
		protected function onUserInfoCheck ( response : Object ) : void {
			
			trace( "[dm.game.Main.onUserInfoCheck] response : " + JSON.stringify( response, null, 4 ) );
			
			if ( response ) {
				this.onLogin();
			} else {
				( new UserInfoUpdateWindow() ).addEventListener( WindowEvent.CLOSE, this.onOnUserInfoSet );
			}
		}
		
		/**
		 *	On on user info set
		 */
		protected function onOnUserInfoSet ( event : WindowEvent) : void {
			( event.target as IEventDispatcher ).removeEventListener( WindowEvent.CLOSE, this.onOnUserInfoSet );
			this.onLogin();
		}
		
		/**
		 * Game world is initialized here
		 */
		private function initGameWorld():void {
			_world = new World3D(this);
			_game = new Game();
			
			EntityManager.instance.game = _game;
			MapManager.instance.world = _world;
			AnimationManager.instance;
			
			SkinFactory.defaultScene = _world.scene;
			UserManager.instance;
			AltSkinManager.instance;
			
			// Add new systems here
			
			_renderAndPhysics = new RenderAndPhysicsSystem(_world);
			_game.addSystem(_renderAndPhysics, 10);
			
			CameraManager.instance.camera = _world.scene.camera;
			CameraManager.instance.camera.far = CAMERA_DRAW_DISTANCE;
			_game.addSystem(CameraManager.instance, 9);
			
			_game.addSystem(new InputSystem, 7);
			_game.addSystem(new Element2DPlacementSystem(this, _world.scene), 8);
			
			if (!builderMode) {
				NpcManager.instance.scene = _world.scene;
				_game.addSystem(InteractionSystem.instance, 10);
				_game.addSystem(new AudioSystem(), 11);
			}
			
			//var speedTweaker:AvatarSpeedTweaker = new AvatarSpeedTweaker(this);
			
			_world.scene.addEventListener(Scene3D.UPDATE_EVENT, onSceneUpdate);
		}
		
		/**
		 * Get current room name
		 */
		public function getCurrentRoomName():String {
			return this._roomToJoin;
		}
		
		/**
		 * Set current room name
		 */
		public function setCurrentRoomName(value:String):void {
			this._roomToJoin = value;
		}
		
		/**
		 * On electro server login
		 */
		private function onEsLogin():void {
			trace("[dm.game.Main.onEsLogin] : Electro server login routine complete!");
			EsManager.instance.esLoginSignal.remove(onEsLogin);
			EsManager.instance.esJoinRoomSignal.add(onEsJoinRoom);
			if ( this._roomToJoin ) {
				EsManager.instance.joinRoom(_roomToJoin);
			} else {
				AvatarService.getLastAvatarRoomLabel( MyManager.instance.avatar.id )
					.addResponders( this.onLastAvatarRoomLoaded )
					.call();
			}
			
		}
		
		private function onLastAvatarRoomLoaded ( response : String ) : void {
			this._roomToJoin = response;
			EsManager.instance.joinRoom(_roomToJoin);
		}
		
		private function onEsJoinRoom(e:JoinRoomEvent):void {
			trace("[dm.game.Main.onEsJoinRoom] : Room joined!");
			var onJoinRoomRoutine:OnJoinRoomRoutine = new OnJoinRoomRoutine(_world);
			onJoinRoomRoutine.execute();
		}
		
		private function onSceneUpdate(e:Event):void {
			_game.update(1 / RenderAndPhysicsSystem.SCENE_FRAMERATE);
		}
		
		private function enterBuilderMode(permissions:Object):void {
			if (_builder == null) {
				for each (var entity:Entity in EntityManager.instance.entities) {
					if (entity.has(InputController)) {
						EntityManager.instance.removeEntity(entity);
					}
				}
				_builder = new Builder( this, permissions);
				
				//WindowsManager.getInstance().createWindow(ShopEditor, null);	
				/*
				var shop:Shop = WindowsManager.getInstance().createWindow(Shop, null, [2]) as Shop;
				var inventory:Inventory = WindowsManager.getInstance().createWindow(Inventory, null, [1]) as Inventory;
				shop.x = stage.stageWidth * 0.5 - (shop.width + inventory.width + 5) * 0.5;
				inventory.x = shop.x + shop.width + 5;
				*/
				//WindowsManager.getInstance().createWindow(AlteringSkinManager, null);
					//new Trade(_builder);
			}
		}
	
	}

}
