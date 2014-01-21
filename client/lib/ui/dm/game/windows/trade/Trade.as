package dm.game.windows.trade {

import com.electrotank.electroserver5.api.EsObject;
import com.electrotank.electroserver5.api.MessageType;
import com.electrotank.electroserver5.api.PrivateMessageEvent;
import com.electrotank.electroserver5.api.PrivateMessageRequest;
import dm.game.data.service.AvatarService;
import dm.game.data.service.SocialCapitalService;
import dm.game.managers.EsManager;
import dm.game.managers.MyManager;
import dm.game.windows.confirm.Confirm;
import dm.game.windows.DmWindow;
import dm.game.windows.inventory.Inventory;
import dm.game.windows.inventory.InventoryItem;
import dm.game.windows.Tooltip;
import fl.controls.Button;
import fl.controls.TextInput;
import fl.controls.TileList;
import fl.events.ListEvent;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.Dictionary;
import ucc.ui.window.WindowsManager;
import ucc.util.ArrayUtil;
import utils.AMFPHP;

/**
 * Trade window
 * @version $Id$
 */
public class Trade extends DmWindow {
	
	public var partnersItemsTileListDO		: TileList;
	
	public var myItemsTileListDO			: TileList;
	
	public var partnersMoneyTextInputDO 	: TextInput;
	
	public var myMoneyTextInputDO 			: TextInput;
	
	public var acceptButtonDO 				: Button;
	
	public var declineButtonDO 				: Button;
	
	private var _currentMoney 				: int = 0;
	
	public function Trade( parent : DisplayObjectContainer = null ) {
		super( parent, _("Trade") );
	}
	
	override public function initialize() : void {
		
		TradeManager.instance.partnerItemRemoveSignal.add( onPartnerItemRemove );
		TradeManager.instance.partnerItemAddSignal.add( onPartnerItemAdd );
		TradeManager.instance.partnerMoneyChangeSignal.add( onPartnerMoneyChange );
		TradeManager.instance.tradeCancelSignal.add( onTradeCancel );
		TradeManager.instance.tradeConcludeSignal.add( onTradeConclude );
		
		this.myItemsTileListDO.sourceFunction = InventoryItem.getItemIcon;
		this.partnersItemsTileListDO.sourceFunction = InventoryItem.getItemIcon;
		
		this.myItemsTileListDO.addEventListener( ListEvent.ITEM_CLICK, onMyItemClick );
		
		closeButtonDO.addEventListener( MouseEvent.CLICK, onDeclineButtonClick );
		
		acceptButtonDO.addEventListener( MouseEvent.CLICK, onAcceptButtonClick );
		declineButtonDO.addEventListener( MouseEvent.CLICK, onDeclineButtonClick );
		
		myMoneyTextInputDO.addEventListener( Event.CHANGE, onMyMoneyChange );
		myMoneyTextInputDO.restrict = "0-9";
		partnersMoneyTextInputDO.enabled = false;
		
		myMoneyTextInputDO.enabled = false;
		
		AvatarService.getVar( MyManager.instance.avatar.id, "money" )
			.addResponders( onCurrentMoney )
			.call();
			
	}
	
	private function onCurrentMoney( response : Object ) : void {
		_currentMoney = response.value;
		myMoneyTextInputDO.enabled = true;
	}	
	
	private function onPartnerMoneyChange( money : String ) : void {
		partnersMoneyTextInputDO.text = money;
	}
	
	private function onMyMoneyChange( event : Event ) : void {
		if ( int( myMoneyTextInputDO.text ) > _currentMoney ) {
			myMoneyTextInputDO.text = String( _currentMoney );
		} else {
			myMoneyTextInputDO.text = String( int( myMoneyTextInputDO.text ) );
		}
		TradeManager.instance.broadcastMoneyChange( myMoneyTextInputDO.text );
	}
	
	private function onTradeConclude() : void {
		new Confirm( null, _("Have you been cheated?"), null, onCheated, onNotCheated );
		destroy();
	}
	
	private function onNotCheated() : void {
		// new AMFPHP().xcall( "dm.Stats.reportTradeCheating", MyManager.instance.avatar.id, TradeManager.instance.currentPartnerId, 0 );
	}
	
	private function onCheated() : void {
		SocialCapitalService.logInteraction( TradeManager.instance.currentPartnerId, MyManager.instance.avatar.id, SocialCapitalService.CHEAT )
			.call();
		// new AMFPHP().xcall( "dm.Stats.reportTradeCheating", MyManager.instance.avatar.id, TradeManager.instance.currentPartnerId, 1 );
	}
	
	private function onTradeCancel() : void {
		destroy();
	}
	
	private function onPartnerItemAdd( itemInfo : Object ) : void {
		addItemToPartnerGrid( itemInfo );
	}
	
	private function onPartnerItemRemove( i2aId : int ) : void {
		var itemToRemove : Object = ArrayUtil.getElementByPropertyValue( this.partnersItemsTileListDO.dataProvider.toArray(), "i2a_id", i2aId );
		this.partnersItemsTileListDO.removeItem( itemToRemove );
	}
	
	public function addItemToMyGrid( itemInfo : Object ) : void {
		this.myItemsTileListDO.addItem( itemInfo );
		TradeManager.instance.broadcastAddItemToLot( itemInfo.i2a_id );
	}
	
	private function addItemToPartnerGrid( itemInfo : Object ) : void {
		this.partnersItemsTileListDO.addItem( itemInfo );
	}
	
	private function onAcceptButtonClick( event : MouseEvent ) : void {
		
		var itemsToGetIds : Array = this.partnersItemsTileListDO.dataProvider.toArray().map( this.mapItemsIds );
		var itemsToGiveIds : Array = this.myItemsTileListDO.dataProvider.toArray().map( this.mapItemsIds );
		TradeManager.instance.broadcastConcludeDeal( itemsToGetIds, itemsToGiveIds, int( partnersMoneyTextInputDO.text ), int( myMoneyTextInputDO.text ) );
	}
	
	private function mapItemsIds ( item : Object, index : int, array : Array ) : int {
		return item.i2a_id;
	}
	
	private function onDeclineButtonClick( event : MouseEvent ) : void {
		TradeManager.instance.broadcastCancelDeal();
		destroy();
	}
	
	private function onMyItemClick( event : ListEvent ) : void {
		this.myItemsTileListDO.removeItem( event.item )
		
		if ( WindowsManager.getInstance().getWindowByClass( Inventory ) ) {
			Inventory( WindowsManager.getInstance().getWindowByClass( Inventory ) ).enableItem( event.item.i2a_id );
		}
		
		TradeManager.instance.broadcastRemoveItemFromLot( event.item.i2a_id );
	}
	
	override public function destroy() : void {
		TradeManager.instance.partnerItemRemoveSignal.remove( onPartnerItemRemove );
		TradeManager.instance.partnerItemAddSignal.remove( onPartnerItemAdd );
		TradeManager.instance.partnerMoneyChangeSignal.remove( onPartnerMoneyChange );
		TradeManager.instance.tradeCancelSignal.remove( onTradeCancel );
		TradeManager.instance.tradeConcludeSignal.remove( onTradeConclude );
		
		closeButtonDO.removeEventListener( MouseEvent.CLICK, onDeclineButtonClick );
		
		acceptButtonDO.removeEventListener( MouseEvent.CLICK, onAcceptButtonClick );
		declineButtonDO.removeEventListener( MouseEvent.CLICK, onDeclineButtonClick );
		
		myMoneyTextInputDO.addEventListener( Event.CHANGE, onMyMoneyChange );
		
		super.destroy();
	}

}

}