package dm.game.windows.chooseavatar {

import dm.game.windows.alert.Alert;
import dm.game.windows.confirm.Confirm;
import dm.game.windows.DmWindow;
import fl.controls.List;
import fl.controls.Button;
import dm.game.managers.MyManager;
import fl.events.ComponentEvent;
import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.events.MouseEvent;
import net.richardlord.ash.signals.Signal1;
import utils.AMFPHP;

/**
 * Choose avatar window
 * @version $Id: ChooseAvatar.as 28 2013-02-21 15:32:33Z rytis.alekna $
 */
public class ChooseAvatar extends DmWindow {
	
	/** List */
	public var listDO					: List;
	
	/** Select avatar button */
	public var selectAvatarButtonDO 	: Button;
	
	/** New avatar button */
	public var newAvatarButtonDO 		: Button;
	
	/** Delete avatar button */
	public var deleteAvatarButtonDO 	: Button;
	
	/** Avatar selected signal */
	public var avatarSelectedSignal 	: Signal1 = new Signal1( Object );
	
	/**
	 * Class constructor
	 */
	public function ChooseAvatar( parent : DisplayObjectContainer ) {
		super( parent, _("Choose avatar") );
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function initialize() : void {
		
		for each ( var avatar : Object in MyManager.instance.availableAvatars ) {
			listDO.addItem({ label: avatar.name, avatar: avatar } );
		}
		listDO.selectedIndex = 0;
		
		this.selectAvatarButtonDO.addEventListener( MouseEvent.CLICK, this.onSelectAvatarButtonClick );
		this.deleteAvatarButtonDO.addEventListener( MouseEvent.CLICK, this.onDeleteAvatarButtonClick );
		this.newAvatarButtonDO.addEventListener( MouseEvent.CLICK, this.onNewAvatarButtonClick );
		
		this.listDO.addEventListener( ComponentEvent.ENTER, this.onSelectAvatarButtonClick );
		
		this.listDO.setFocus();
		
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function isCloseable() : Boolean {
		return false;
	}
	
	/**
	 * On delete avatar button click
	 */
	private function onDeleteAvatarButtonClick( e : MouseEvent ) : void {
		Confirm.show( _("Do you really want to delete selected avatar?"), _("Confirm avatar deletion"), this.onDeleteConfirmed );
	}
	
	/**
	 * On delete confirmed
	 */
	private function onDeleteConfirmed():void {
		var amfphp:AMFPHP = new AMFPHP( this.onAvatarDeleted );
		amfphp.xcall("dm.Avatar.deactivateAvatar", listDO.selectedItem.avatar.id);
	}	
	
	/**
	 * On avatar deleted
	 */
	protected function onAvatarDeleted() : void {
		Alert.show( _("Avatar succesfully deleted!") );
		listDO.removeItemAt( listDO.selectedIndex );
		listDO.selectedIndex = 0;
	}
	
	/**
	 * On select avatar button click
	 */
	private function onSelectAvatarButtonClick( e : Event ) : void {
		avatarSelectedSignal.dispatch( listDO.selectedItem.avatar );
		destroy();
	}
	
	/**
	 * On new avatar button click
	 */
	private function onNewAvatarButtonClick( e : MouseEvent ) : void {
		avatarSelectedSignal.dispatch( null );
		destroy();
	}
	
	/**
	 * Destroy
	 */
	override public function destroy() : void {
		avatarSelectedSignal.removeAll();
		super.destroy();
	}

}

}