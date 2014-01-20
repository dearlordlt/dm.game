package dm.game.functions.commands {
	
	import dm.game.functions.BaseExecutable;
	import dm.game.managers.MyManager;
	import dm.game.windows.inventory.Inventory;
	import dm.game.windows.minimap.Minimap;
	import dm.game.windows.shop.Shop;
	import ucc.ui.window.WindowsManager;
	import utils.AMFPHP;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class OpenShopCommand extends BaseExecutable {
		
		public override function execute():void {
			var shopId:int = int(getParamValueByLabel("shopId"));
			var shop:Shop = WindowsManager.getInstance().createWindow(Shop, null, [shopId]) as Shop;
			var inventory:Inventory = WindowsManager.getInstance().createWindow(Inventory, null, [MyManager.instance.avatar.id]) as Inventory;
			shop.x = shop.stage.stageWidth * 0.5 - (shop.width + inventory.width + 5) * 0.5;
			inventory.x = shop.x + shop.width + 5;
			onResult(true);
		}

	}

}