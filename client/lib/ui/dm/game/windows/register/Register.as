package dm.game.windows.register {

import com.bit101.components.InputText;
import com.bit101.components.PushButton;
import dm.builder.interfaces.BuilderLabel;
import dm.builder.interfaces.BuilderWindow;
import dm.builder.interfaces.WindowManager;
import dm.game.data.service.UserService;
import dm.game.windows.alert.Alert;
import dm.game.windows.DmWindow;
import fl.controls.Button;
import fl.controls.CheckBox;
import fl.controls.ComboBox;
import fl.controls.TextInput;
import flash.display.DisplayObjectContainer;
import flash.events.MouseEvent;
import org.as3commons.lang.ArrayUtils;
import org.as3commons.lang.Assert;
import org.as3commons.lang.StringBuffer;
import org.as3commons.lang.StringUtils;
import ucc.ui.dataview.DataViewBuilder;
import ucc.util.DisplayObjectUtil;
import ucc.util.StringUtil;
import utils.AMFPHP;

/**
 * Register window
 * @version $Id: Register.as 207 2013-09-04 14:31:08Z rytis.alekna $
 */
public class Register extends DmWindow {
	
	/** Fuield name matcher */
	private static const fieldNameMatcher		: RegExp = /^(?P<field>[a-zA-Z0-9]*)TextInputDO$)/;
	
	/** Username text input */
	public var usernameTextInputDO				: TextInput;

	/** Password text input */
	public var passwordTextInputDO				: TextInput;

	/** Retype password text input */
	public var retypePasswordTextInputDO		: TextInput;

	/** Register button */
	public var registerButtonDO					: Button;

	/** Name text input */
	public var nameTextInputDO					: TextInput;

	/** Surname text input */
	public var surnameTextInputDO				: TextInput;

	/** Class text input */
	public var classTextInputDO					: TextInput;

	/** Email text input */
	public var emailTextInputDO					: TextInput;
	
	/** City text input */
	public var cityTextInputDO					: TextInput;
	
	/** School combo box */
	public var schoolComboBoxDO					: ComboBox;
	
	/** Is parent checkbox */
	public var parentCheckBoxDO					: CheckBox;
	
	/**
	 * Class constructor
	 */
	public function Register( parent : DisplayObjectContainer = null ) {
		super( parent, _("Register") );
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function draw () : void {
		super.draw();
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function initialize () : void {
		this.registerButtonDO.addEventListener( MouseEvent.CLICK, this.onRegisterButtonClick );
		new DataViewBuilder( this.schoolComboBoxDO.dropdown, this.schoolComboBoxDO )
			.createColumn( "title", _("Title") )
			.setService( UserService.getAllSchools() )
			.refresh();
	}
	
	/**
	 * On register button click
	 */
	private function onRegisterButtonClick( e : MouseEvent ) : void {
		
		var textInputs : Array = DisplayObjectUtil.getChildrenByType( this, TextInput );
		
		textInputs = ArrayUtils.removeAllItemsEquality( textInputs, [ this.classTextInputDO, this.emailTextInputDO ] );
		
		var errorOutput : StringBuffer = new StringBuffer();
		
		for each( var item : TextInput in textInputs ) {
			if ( !StringUtils.trimToNull( item.text ) ) {
				var fieldName : String = fieldNameMatcher.exec( item.name ).field;
				errorOutput.append( _( StringUtil.cammelCaseToSentence( fieldName ) ) + " " + _("must be not empty!") + "\n" );
			}
		}		
		
		if ( errorOutput.toString().length > 0 ) {
			Alert.show( errorOutput.toString(), _("Register") );
			return;
		}
		
		if ( ( this.usernameTextInputDO.text.length < 4 )  ) {
			Alert.show( _("Your user name must be at least 4 characters long!") );
			return;
		}
		
		if ( ( this.passwordTextInputDO.text.length < 6 ) ) {
			Alert.show( _("Your password must be at least 6 character long!") );
			return;
		}
		
		if ( this.passwordTextInputDO.text != this.retypePasswordTextInputDO.text ) {
			Alert.show( _("Your passwords doesn't match!") );
			return;
		}
		
		if ( StringUtils.trimToNull( this.emailTextInputDO.text ) && !StringUtil.isEmail( StringUtils.trim( this.emailTextInputDO.text ) ) ) {
			Alert.show( _("Provided email is invalid!") );
			return;
		}
		
		UserService.register( usernameTextInputDO.text, passwordTextInputDO.text, false )
			.addResponders( this.onRegister, this.onRegisterFailed )
			.call();
		
	}
	
	private function onRegister( response : Object ) : void {
		
		UserService.setUserInfo( 
			response.id, 
			StringUtils.trim( this.nameTextInputDO.text ), 
			StringUtils.trim( this.surnameTextInputDO.text ), 
			StringUtils.trim( this.emailTextInputDO.text ), 
			this.schoolComboBoxDO.selectedItem.id, 
			StringUtils.trim( this.classTextInputDO.text ),
			StringUtils.trim( this.cityTextInputDO.text ),
			this.parentCheckBoxDO.selected
		)
		.addResponders( this.onUserInfoSet )
		.call()
		
	}
	
	protected function onRegisterFailed( response : Object ) : void {
		Alert.show( _( "Username already exists! Choose another one." ) );
	}
	
	/**
	 *	On user info set
	 */
	protected function onUserInfoSet ( response : Object ) : void {
		Alert.show( _( "Registration successful! You can now login using name and password provided." ) );
		this.destroy();
	}

}

}