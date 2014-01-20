package dm.game.windows.login {

import com.bit101.components.InputText;
import com.bit101.components.PushButton;
import dm.builder.interfaces.BuilderLabel;
import dm.builder.interfaces.BuilderWindow;
import dm.builder.interfaces.WindowManager;
import dm.game.data.service.UserService;
import dm.game.Main;
import dm.game.managers.MyManager;
import dm.game.windows.alert.Alert;
import dm.game.windows.confirm.Confirm;
import dm.game.windows.DmLabel;
import dm.game.windows.DmWindow;
import dm.game.windows.prompt.Prompt;
import dm.game.windows.register.Register;
import dm.game.windows.register.UserInfoUpdateWindow;
import dm.game.windows.Tooltip;
import fl.controls.Button;
import fl.controls.CheckBox;
import fl.controls.TextInput;
import fl.events.ComponentEvent;
import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.ui.Keyboard;
import net.richardlord.ash.signals.Signal0;
import ucc.ui.window.WindowEvent;
import ucc.util.Delegate;
import utils.AMFPHP;

/**
 * Login window
 * @version $Id: Login.as 170 2013-06-25 07:24:51Z zenia.sorocan $
 */
[Single]
public class Login extends DmWindow {
	
	/** User name text input */
	public var userNameTextInputDO		: TextInput;

	/** Password text input */
	public var passwordTextInputDO		: TextInput;

	/** Login button */
	public var loginButtonDO			: Button;

	/** Register button */
	public var registerButtonDO			: Button;
	
	/** Moddle login checkbox */
	public var moodleLoginCheckBoxDO	: CheckBox;
	
	/** Login signal */
	public var loginSignal 				: Signal0 = new Signal0();
	
	public function Login( parent : DisplayObjectContainer ) {
		super( parent, _("Login") );
	}
	
	
	/**
	 *	@inheritDoc
	 */
	public override function draw () : void {
		super.draw();
		Tooltip.setTooltip( this.moodleLoginCheckBoxDO, _("Login by using your Moodle account") );
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function isCloseable () : Boolean {
		return false;
	}
	
	/**
	 * @inheritDoc
	 */
	override public function initialize() : void {
		this.loginButtonDO.addEventListener( MouseEvent.CLICK, onLoginButtonClick );
		this.registerButtonDO.addEventListener( MouseEvent.CLICK, onRegisterButtonClick );
		this.loginButtonDO.addEventListener( ComponentEvent.ENTER, this.onLoginButtonClick );
		this.userNameTextInputDO.addEventListener( ComponentEvent.ENTER, this.onLoginButtonClick );
		this.passwordTextInputDO.addEventListener( ComponentEvent.ENTER, this.onLoginButtonClick );
		this.userNameTextInputDO.tabIndex = 1;
		this.passwordTextInputDO.tabIndex = 2;
		this.loginButtonDO.tabIndex = 3;
		this.registerButtonDO.tabIndex = 4;
		// trace( "[dm.game.windows.login.Login.initialize] this.userNameTextInputDO.getFocus() : " + this.userNameTextInputDO.getFocus() );
		
		this.addEventListener( Event.ADDED_TO_STAGE, this.onAddedToStage );
		
		
		
	}
	
	/**
	 * On added to stage
	 */
	protected function onAddedToStage ( event : Event ) : void {
		this.userNameTextInputDO.alwaysShowSelection = true;
		this.userNameTextInputDO.setFocus();
		this.userNameTextInputDO.drawFocus(true);
		this.userNameTextInputDO.setSelection(0, 0);
		
		this.removeEventListener( Event.ADDED_TO_STAGE, this.onAddedToStage );
		this.stage.addEventListener( KeyboardEvent.KEY_UP, this.onKeyDown );
	}
	
	/**
	 * On register  button click
	 */
	private function onRegisterButtonClick( e : MouseEvent ) : void {
		new Register();
	}
	
	/**
	 * On login button click
	 */
	private function onLoginButtonClick( e : Event ) : void {
		UserService.login( userNameTextInputDO.text, passwordTextInputDO.text, this.moodleLoginCheckBoxDO.selected )
			.addResponders( this.onLogin, this.onLoginFailed )
			.call();
	}
	
	/**
	 * On login success
	 */
	private function onLogin( response : Object ) : void {
		MyManager.instance.id = response.id;
		MyManager.instance.username = response.username;
		MyManager.instance.availableAvatars = response.avatars;
		MyManager.instance.isAdmin = ( response.isadmin == "Y" );
		MyManager.instance.school = response.school;
		
		loginSignal.dispatch();
		destroy();		
		
	}
	
	protected function onLoginFailed( response : Object ) : void {
		trace( "[dm.game.windows.login.Login.onLoginFailed] response : " + JSON.stringify( response, null, 4 ) );
		userNameTextInputDO.text = "";
		passwordTextInputDO.text = "";
		if ( response.errorCode && ( response.errorCode == 1 ) ) {
			Alert.show( _("Wrong username or password.") );
		}
		
	}
	
	/**
	 *	On key down
	 */
	protected function onKeyDown ( event : KeyboardEvent) : void {
		
		if ( event.ctrlKey ) {
			if ( ( event.keyCode == Keyboard.D ) ) {
				Confirm.show( _("Do you want to log into builder?"), _("Login"), Delegate.create( Main.getInstance().setBuilderMode, true ), Delegate.create( Main.getInstance().setBuilderMode, false ) )
			} else if ( ( event.keyCode == Keyboard.R ) ) {
				Prompt.show( _("Enter room name you want to log into"), _("Login"), Main.getInstance().getRoomToJoin(), Delegate.create( Main.getInstance().setRoomToJoin ) );
				// Confirm.show( _("Do you want to log into builder?"), _("Login"), Delegate.create( Main.getInstance().setBuilderMode, true ), Delegate.create( Main.getInstance().setBuilderMode, false ) )
			}
			
		}
		
	}
	
	override public function destroy() : void {
		loginSignal.removeAll();
		
		this.stage.removeEventListener( KeyboardEvent.KEY_UP, this.onKeyDown );
		this.loginButtonDO.removeEventListener( MouseEvent.CLICK, onLoginButtonClick );
		this.registerButtonDO.removeEventListener( MouseEvent.CLICK, onRegisterButtonClick );
		this.loginButtonDO.removeEventListener( ComponentEvent.ENTER, this.onLoginButtonClick );
		this.userNameTextInputDO.removeEventListener( ComponentEvent.ENTER, this.onLoginButtonClick );
		this.passwordTextInputDO.removeEventListener( ComponentEvent.ENTER, this.onLoginButtonClick );
		
		
		super.destroy();
	}

}

}