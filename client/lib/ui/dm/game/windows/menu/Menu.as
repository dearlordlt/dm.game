package dm.game.windows.menu {
	import dm.game.managers.MyManager;
	import dm.game.windows.avatar.AvatarProfile;
	import dm.game.windows.competition.BullyingCompetition;
	import dm.game.windows.dialogviewer.DialogViewer;
	import dm.game.windows.DmWindow;
	import dm.game.windows.DmWindowManager;
	import dm.game.windows.gallery.Gallery;
	import dm.game.windows.inventory.Inventory;
	import dm.game.windows.notification.NotificationsList;
	import dm.game.windows.quest.QuestsWindow;
	import dm.game.windows.score.ScoresWindow;
	import dm.game.windows.settings.SettingsView;
	import dm.game.windows.Tooltip;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import org.as3commons.lang.ClassUtils;
	import ucc.ui.window.WindowsManager;
	import ucc.util.DisplayObjectUtil;
	
	/**
	 * Menu view manager
	 * @version $Id: Menu.as 215 2013-09-29 14:28:49Z rytis.alekna $
	 */
	[Single]
	[Updatable]
	public class Menu extends DmWindow {
		
		/** Menu movie clip */
		private var _view: *;
		
		/** Menu button register */
		private var _buttons:Array;
		
		/** Mouse over menu? */
		private var _mouseOverMenu:Boolean = false;
		
		private const LEARN_CENTER_DIALOG_ID:int = 662;
		
		/** Singleton instance */
		private static var instance : Menu;
		
		/**
		 * Get singleton instance of class
		 * @return 	singleton instance	Menu
		 */
		public static function getInstance () : Menu {
			return Menu.instance;
		}
		
		/**
		 * Class constructor
		 */
		public function Menu() {
			Menu.instance = this;
			super( null, _("Menu") );
		}
		
		/**
		 * @inheritDoc
		 */
		public override function getInitialPosition () : Point {
			return new Point( 20, 20 );
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function postInitialize () : void {
			new CentralPanel( this.getView().getChildByName("centralPanel") as DisplayObjectContainer );
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function draw () : void {
			// don't call super method because we don't need our standard borders. We just need this window to be managed
			this._view = ClassUtils.newInstance( ClassUtils.forName( "dm.game.windows.menu.MenuView" ) );
			addChild(_view);
			this.setupListeners();
		}
		
		public function getView () : DisplayObjectContainer {
			return this._view;
		}
		
		/**
		 * Set up listeners
		 */
		private function setupListeners():void {
			
			_view.addEventListener(MouseEvent.ROLL_OVER, onMenuRollOver);
			_view.addEventListener(MouseEvent.ROLL_OUT, onMenuRollOut);
			
			_buttons = DisplayObjectUtil.getChildsByRegExp(this._view, /Button$/);
			
			for each (var button:MovieClip in _buttons) {
				button.stop();
				button.addEventListener(MouseEvent.ROLL_OVER, onBtnRollOver);
				button.addEventListener(MouseEvent.ROLL_OUT, onBtnRollOut);
			}
			
			_view.centralPanel.stop();
			for (var i:int = 1; i <= 5; i++) {
				_view.centralPanel["progressbar" + i].stop();
			}
			
			// TODO: create automatic menu functions assignment instead of manual and custom event handling
			
			_view.inventoriousButton.addEventListener(MouseEvent.CLICK, onInventoryButtonClick);
			Tooltip.setTooltip(_view.inventoriousButton, _("Inventor"));
			
			_view.chatButton.addEventListener(MouseEvent.CLICK, onChatButtonClick);
			Tooltip.setTooltip(_view.chatButton, _("Chat"));
			
			_view.settingsButton.addEventListener(MouseEvent.CLICK, this.onSettingsButtonClick);
			Tooltip.setTooltip(_view.settingsButton, _("Display options"));
			
			_view.qusetLogButton.addEventListener(MouseEvent.CLICK, this.onQusetButtonClick);
			Tooltip.setTooltip(_view.qusetLogButton, _("Notifications"));
			
			Tooltip.setTooltip(_view.helpCenterButton, _("Help center - locked"));
			
			Tooltip.setTooltip(_view.actionsButton, _("Quests"));
			_view.actionsButton.addEventListener(MouseEvent.CLICK, this.onActionsClick);
			
			Tooltip.setTooltip(_view.characterButton, _("My profile"));
			_view.characterButton.addEventListener( MouseEvent.CLICK, this.onCharacterButtonClick )
			
			_view.learnCenterButton.addEventListener(MouseEvent.CLICK, onLearnCenterButtonClick);
			Tooltip.setTooltip(_view.learnCenterButton, _("Learning center"));
			
			
			_view.socialButton.addEventListener(MouseEvent.CLICK, onSocialCenterButtonClick);
			Tooltip.setTooltip(_view.socialButton, _("Scores"));
			
			// scores button
			_view.mediaCenterButton.addEventListener(MouseEvent.CLICK, onMediaCenterButtonClick);
			Tooltip.setTooltip(_view.mediaCenterButton, _("Gallery"));
		
		}
		
		private function onLearnCenterButtonClick(e:MouseEvent):void 
		{
			var dialogViewer:DialogViewer = new DialogViewer(DmWindowManager.instance.windowLayer, LEARN_CENTER_DIALOG_ID);
		}
		
		/**
		 * On chat button click
		 */
		private function onChatButtonClick(e:MouseEvent):void {
			DmWindowManager.instance.chat.visible = !DmWindowManager.instance.chat.visible;
		}
		
		/**
		 * On inventory button click
		 */
		private function onInventoryButtonClick(e:MouseEvent):void {
			WindowsManager.getInstance().createWindow(Inventory, null, [MyManager.instance.avatar.id]);
		}
		
		/**
		 * On menu roll over
		 */
		private function onMenuRollOver(e:MouseEvent):void {
			_mouseOverMenu = true;
			_view.centralPanel.gotoAndStop(2);
			for each (var button:MovieClip in _buttons) {
				if (button.currentFrame == 1) {
					button.gotoAndStop(2);
				}
			}
		}
		
		/**
		 * On menu roll out
		 */
		private function onMenuRollOut(e:MouseEvent):void {
			_mouseOverMenu = false;
			_view.centralPanel.gotoAndStop(1);
			for each (var button:MovieClip in _buttons) {
				if (button.currentFrame == 2) {
					button.gotoAndStop(1);
				}
			}
		}
		
		/**
		 * On button roll over
		 */
		private function onBtnRollOver(e:MouseEvent):void {
			if (MovieClip(e.currentTarget).hasEventListener(MouseEvent.CLICK)) {
				MovieClip(e.currentTarget).gotoAndStop(3);
			}
		
		}
		
		/**
		 * On button roll out
		 */
		private function onBtnRollOut(e:MouseEvent):void {
			var frameNum:int = (_mouseOverMenu) ? 2 : 1;
			MovieClip(e.currentTarget).gotoAndStop(frameNum);
		}
		
		/**
		 *	On setting button click
		 */
		protected function onSettingsButtonClick(event:MouseEvent):void {
			new SettingsView(_view.parent);
		}
		
		/**
		 *	On quset button click
		 */
		protected function onQusetButtonClick(event:MouseEvent):void {
			WindowsManager.getInstance().createWindow( NotificationsList );
			// new BullyingCompetition(DmWindowManager.instance.windowLayer);
		}
		
		/**
		 *	On character button click
		 */
		protected function onCharacterButtonClick ( event : MouseEvent ) : void {
			new AvatarProfile();
		}
		
		/**
		 *	On actions click
		 */
		protected function onActionsClick ( event : MouseEvent) : void {
			new QuestsWindow();
		}
		
		/**
		 *	On media center button click
		 */
		protected function onMediaCenterButtonClick ( event : MouseEvent) : void {
			new Gallery( null, MyManager.instance.avatarId );
		}
		
		/**
		 *	On social center button click
		 */
		protected function onSocialCenterButtonClick ( event : MouseEvent) : void {
			new ScoresWindow();
		}
	
	}

}