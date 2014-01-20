package dm.game.windows.shop {

import dm.game.data.service.ItemsService;
import dm.game.data.service.ShopService;
import dm.game.managers.MyManager;
import dm.game.windows.alert.Alert;
import dm.game.windows.DmWindow;
import dm.game.windows.inventory.Inventory;
import dm.game.windows.inventory.InventoryItem;
import dm.game.windows.Tooltip;
import fl.controls.Button;
import fl.controls.Label;
import fl.controls.TileList;
import fl.data.DataProvider;
import fl.events.ListEvent;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.MouseEvent;
import ucc.ui.dataview.DataViewBuilder;
import ucc.ui.window.WindowsManager;
import utils.AMFPHP;

/**
 * 
 * @version $Id: Shop.as 214 2013-09-28 18:03:54Z rytis.alekna $
 */
public class Shop extends DmWindow {
	
	/** Items tile list */
	public var itemsTileListDO 		: TileList;
	
	/** Buy button */
	public var buyButtonDO 			: Button;
	
	/** Item label */
	public var itemLabelDO			: Label;
	
	private var _shopData 			: Object;
	
	private var shopId 				: int;
	
	/** Data view builder */
	protected var dataViewBuilder	: DataViewBuilder;
	
	/**
	 * (Constructor)
	 * - Returns a new Shop instance
	 * @param	parent
	 * @param	shopId
	 */
	public function Shop( parent : DisplayObjectContainer, shopId : int ) {
		this.shopId = shopId;
		
		super( parent, _("Shop") );
	}
	
	/**
	 * Initializes this instance.
	 */
	override public function initialize() : void {
		
		buyButtonDO.addEventListener( MouseEvent.CLICK, onBuyButtonClick );
		
		this.itemsTileListDO.sourceFunction = InventoryItem.getItemIcon;
		this.itemsTileListDO.labelFunction = this.itemLabelFunction;
		this.itemsTileListDO.addEventListener(ListEvent.ITEM_ROLL_OVER, this.onItemRollOver )
		this.itemsTileListDO.addEventListener(ListEvent.ITEM_CLICK, this.onListItemClick );
		
		ShopService.getShopById( this.shopId )
			.addResponders( this.onShopData )
			.call();
		
	}
	
	private function retrieveItemsFromShop ( shop : Object ) : Array {
		this._shopData = shop;
		return shop.items;
	}
	
	private function onBuyButtonClick( event : MouseEvent ) : void {
		this.buyItem( this.itemsTileListDO.selectedItem );
	}
	
	/**
	 * On shop data
	 */
	private function onShopData( response : Object ) : void {
		
		this._shopData = response;
		
		this.itemsTileListDO.dataProvider = new DataProvider( _shopData.items );
		
	}
	
	private function itemLabelFunction ( data : Object ) : String {
		return data.label + "\n[" + Number( data.price * ( 1 + this._shopData.sell_proc / 100 ) ).toPrecision( 2 ) + "/" + Number( data.price * ( 1 - this._shopData.buy_proc / 100 ) ).toPrecision( 2 ) + "]";
	}
	
	private function buyItem( item : Object ) : void {
		ItemsService.buyItem( MyManager.instance.avatar.id, _shopData.id, item.id )
			.addResponders( this.onBuySuccess, this.onBuyFail )
			.call()
	}
	
	private function onBuySuccess() : void {
		var inventory : Inventory = Inventory( WindowsManager.getInstance().getWindowByClass( Inventory ) );
		if ( inventory ) {
			inventory.refreshAvatarItems();
		}
	}
	
	private function onBuyFail () : void {
		Alert.show( _("Not enough money!"), _("Shop") );
	}
	
	/**
	 *	On item roll over
	 */
	protected function onItemRollOver ( event : ListEvent) : void {
		this.itemLabelDO.text = this.itemLabelFunction( event.item );
	}
	
	/**
	 *	On list item click
	 */
	protected function onListItemClick ( event : ListEvent) : void {
		this.buyButtonDO.enabled = true;
	}
	
	public function get shopData() : Object {
		return _shopData;
	}

}

}