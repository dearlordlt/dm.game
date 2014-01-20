package dm.game.windows.register {
	import dm.game.data.service.UserService;
	import dm.game.managers.MyManager;
	import dm.game.windows.alert.Alert;
	import dm.game.windows.DmWindow;
	import fl.controls.Button;
	import fl.controls.CheckBox;
	import fl.controls.ComboBox;
	import fl.controls.TextInput;	
	import flash.events.MouseEvent;
	import ucc.util.StringUtil;
	import org.as3commons.lang.ArrayUtils;
	import org.as3commons.lang.StringBuffer;
	import org.as3commons.lang.StringUtils;
	import ucc.ui.dataview.DataViewBuilder;
	import ucc.util.DisplayObjectUtil;

/**
 * 
 * @version $Id: UserInfoUpdateWindow.as 207 2013-09-04 14:31:08Z rytis.alekna $
 */
public class UserInfoUpdateWindow extends DmWindow {
	
	/** Fuield name matcher */
	private static const fieldNameMatcher		: RegExp = /^(?P<field>[a-zA-Z0-9]*)TextInputDO$/;
	
	/** Register button */
	public var saveButtonDO						: Button;

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
	 * (Constructor)
	 * - Returns a new UserInfoUpdateWindow instance
	 */
	public function UserInfoUpdateWindow() {
		super( null, _("User info") );
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function initialize (  ) : void {
		
		this.saveButtonDO.addEventListener( MouseEvent.CLICK, this.onSaveButtonClick );
		new DataViewBuilder( this.schoolComboBoxDO.dropdown, this.schoolComboBoxDO )
			.createColumn( "title", _("Title") )
			.setService( UserService.getAllSchools() )
			.refresh();		
		
	}
	
	/**
	 *	On save button click
	 */
	protected function onSaveButtonClick ( event : MouseEvent) : void {
		
		var textInputs : Array = DisplayObjectUtil.getChildrenByType( this, TextInput );
		
		textInputs = ArrayUtils.removeAllItemsEquality( textInputs, [ this.classTextInputDO, this.emailTextInputDO ] );
		
		var errorOutput : StringBuffer = new StringBuffer();
		
		for each( var item : TextInput in textInputs ) {
			if ( StringUtils.trimToNull( item.text ) == null ) {
				var fieldName : String = fieldNameMatcher.exec( item.name ).field;
				errorOutput.append( _( StringUtil.cammelCaseToSentence( fieldName ) ) + " " + _("must be not empty!") + "\n" );
			}
		}		
		
		if ( errorOutput.toString().length > 0 ) {
			Alert.show( errorOutput.toString(), _("Register") );
			return;
		}
		
		if ( StringUtils.trimToNull( this.emailTextInputDO.text ) && !StringUtil.isEmail( StringUtils.trim( this.emailTextInputDO.text ) ) ) {
			Alert.show( _("Provided email is invalid!") );
			return;
		}		
		
		UserService.setUserInfo( 
			MyManager.instance.id, 
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
	
	/**
	 *	@inheritDoc
	 */
	public override function isCloseable (  ) : Boolean {
		return false;
	}
	
	/**
	 *	On user info set
	 */
	protected function onUserInfoSet ( response : Object ) : void {
		Alert.show( _( "Information successfuly updated." ) );
		this.destroy();
	}
	
}

}