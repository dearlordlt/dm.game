package dm.game.windows.inventory {

import dm.game.data.service.AvatarService;
import dm.game.data.service.ItemsService;
import dm.game.functions.FunctionExecutor;
import dm.game.managers.MyManager;
import dm.game.windows.chat.Chat;
import dm.game.windows.DmWindow;
import dm.game.windows.finance.FinanceReportWindow;
import dm.game.windows.shop.Shop;
import dm.game.windows.trade.Trade;
import dm.game.windows.trade.TradeManager;
import fl.controls.Button;
import fl.controls.Label;
import fl.controls.TileList;
import fl.events.ListEvent;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.ui.Keyboard;
import flash.ui.Mouse;
import org.as3commons.lang.ClassUtils;
import org.as3commons.lang.StringUtils;
import ucc.ui.dataview.DataViewBuilder;
import ucc.ui.window.WindowsManager;
import utils.AMFPHP;

/**
 *
 * @version $Id: Inventory.as 215 2013-09-29 14:28:49Z rytis.alekna $
 */
[Single]
[Updatable]
public class Inventory extends DmWindow {
	
	/** Items tile list */
	public var itemsTileListDO		: TileList;
	
	public var useButtonDO 			: Button;
	
	public var sellButtonDO 		: Button;
	
	public var tradeButtonDO 		: Button;
	
	public var useInChatButtonDO	: Button;
	
	public var financeReportButtonDO: Button;
	
	public var moneyLabelDO 		: Label;
	
	/** Item label */
	public var itemLabelDO			: Label;	
	
	private var _items 				: Array = new Array();
	
	private var selectedItem 		: Object;
	
	private var avatarId 			: int;
	
	protected var dataViewBuilder	: DataViewBuilder;
	
	public function Inventory( parent : DisplayObjectContainer, avatarId : int ) {
		this.avatarId = avatarId;
		super( parent, _( "Inventory" ) );
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function initialize() : void {
		
		this.itemsTileListDO.sourceFunction = InventoryItem.getItemIcon;
		this.itemsTileListDO.addEventListener(ListEvent.ITEM_CLICK, this.onItemClick );
		this.itemsTileListDO.addEventListener( ListEvent.ITEM_ROLL_OVER, this.onListItemRollOver );
		this.dataViewBuilder = ( new DataViewBuilder( this.itemsTileListDO ) )
			.setService( ItemsService.getAvatarItems( this.avatarId ) );
			
		this.refreshAvatarItems();
		
		useButtonDO.addEventListener( MouseEvent.CLICK, onUseButtonClick );
		sellButtonDO.addEventListener( MouseEvent.CLICK, onSellButtonClick );
		tradeButtonDO.addEventListener( MouseEvent.CLICK, onTradeButtonClick );
		this.useInChatButtonDO.addEventListener( MouseEvent.CLICK, this.onUseInChatButtonClick );
		// refreshAvatarItems();
		
		this.financeReportButtonDO.addEventListener( MouseEvent.CLICK, this.onFinanceReportButtonClick );
		
		WindowsManager.getInstance().windowCreatedSignal.add( onWindowCreated );
		WindowsManager.getInstance().windowClosedSignal.add( onWindowClosed );
		
		TradeManager.instance.tradeConcludeSignal.add( onTradeConclude );
	}
	
	private function onCurrentMoney( response : Object ) : void {
		moneyLabelDO.text = _( "Money" ) + ": " + int( response.value );
	}
	
	private function onWindowCreated( windowClass : Class ) : void {
		if ( windowClass is Trade && selectedItem ) {
			tradeButtonDO.enabled = true;
		}
		
		if ( windowClass is Shop && selectedItem ) {
			if ( Boolean( int( selectedItem.is_sellable ) ) ) {
				if ( Boolean( int( Shop( WindowsManager.getInstance().getWindowByClass( Shop ) ).shopData.is_buying ) ) ) {
					sellButtonDO.enabled = true;
				}
			}
		}
	}
	
	private function onWindowClosed( windowClass : Class ) : void {
		if ( windowClass == Trade )
			tradeButtonDO.enabled = false;
		
		if ( windowClass == Shop )
			sellButtonDO.enabled = false;
	}
	
	private function onTradeButtonClick( event : MouseEvent ) : void {
		Trade( WindowsManager.getInstance().getWindowByClass( Trade ) ).addItemToMyGrid( selectedItem );
		this.itemsTileListDO.removeItem( selectedItem );
		selectedItem = null;
	}
	
	private function onSellButtonClick( event : MouseEvent ) : void {
		var shopId : int = Shop( WindowsManager.getInstance().getWindowByClass( Shop ) ).shopData.id;
		ItemsService.sellItem( avatarId, shopId, selectedItem.i2a_id )
			.addResponders( this.onSell )
			.call();
		
	}
	
	private function onSell( response : Object ) : void {
		refreshAvatarItems();
	}
	
	private function onUseButtonClick( event : MouseEvent ) : void {
		if ( selectedItem && selectedItem.number_of_uses != -1 ) { // if number_of_uses == -1, item is unusable
			useItem( selectedItem );
		}
	}
	
	private function onTradeConclude() : void {
		refreshAvatarItems();
	}
	
	public function refreshAvatarItems() : void {
		
		this.dataViewBuilder.refresh();
		
		AvatarService.getVar( avatarId, "money" )
			.addResponders( this.onCurrentMoney )
			.call();
	}
	
	private function onItemClick( event : ListEvent ) : void {
		selectedItem = event.item;
		
		this.useInChatButtonDO.enabled = true;
		useButtonDO.enabled = true;
		
		if ( WindowsManager.getInstance().getWindowByClass( Trade ) ) {
			tradeButtonDO.enabled = true;
		}
		
		sellButtonDO.enabled = false;
		
		if ( Boolean( int( selectedItem.is_sellable ) ) ) {
			if ( WindowsManager.getInstance().getWindowByClass( Shop ) ) {
				if ( Boolean( int( Shop( WindowsManager.getInstance().getWindowByClass( Shop ) ).shopData.is_buying ) ) ) {
					sellButtonDO.enabled = true;
				}
			}
		}
		
	}
	
	private function onUseInChatButtonClick ( event : MouseEvent ) : void {
		var chat : Chat = WindowsManager.getInstance().getWindowByClass( Chat ) as Chat;
		chat.tradeItem( selectedItem.id, selectedItem.label );
	}
	
	private function useItem( itemData : Object ) : void {
		if ( itemData.available ) {
			ItemsService.useItem( itemData.i2a_id )
				.addResponders( onItemUsed )
				.call();
		}
		
		function onItemUsed() : void {
			var funcExecutor : FunctionExecutor = new FunctionExecutor();
			funcExecutor.executeFunctions( itemData.functions );
			refreshAvatarItems();
		}
	}
	
	public function enableItem( i2aId : int ) : void {
		
		trace( "[dm.game.windows.inventory.Inventory.enableItem] i2aId : " + i2aId );
		
		/*
		for each ( var item : InventoryItem in itemGrid.items ) {
			if ( item.data.i2a_id == i2aId ) {
				item.visible = true;
			}
		}
		*/
		
	}
	
	/**
	 *	On list item roll over
	 */
	protected function onListItemRollOver ( event : ListEvent) : void {
		this.itemLabelDO.text = event.item.label;
	}
	
	/**
	 *	On finance report button click
	 */
	protected function onFinanceReportButtonClick ( event : MouseEvent) : void {
		new FinanceReportWindow( null, MyManager.instance.avatarId );
	}
	
}

}