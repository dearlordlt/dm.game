package dm.game.windows.trade {
	
	import com.electrotank.electroserver5.api.EsObject;
	import com.electrotank.electroserver5.api.MessageType;
	import com.electrotank.electroserver5.api.PrivateMessageEvent;
	import com.electrotank.electroserver5.api.PrivateMessageRequest;
	import dm.game.managers.EsManager;
	import dm.game.managers.MyManager;
	import dm.game.windows.alert.Alert;
	import dm.game.windows.confirm.Confirm;
	import dm.game.windows.DmWindowManager;
	import dm.game.windows.inventory.Inventory;
	import net.richardlord.ash.signals.Signal0;
	import net.richardlord.ash.signals.Signal1;
	import ucc.ui.window.WindowsManager;
	import utils.AMFPHP;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class TradeManager {
		
		private static var _instance:TradeManager;
		
		public var partnerItemRemoveSignal:Signal1 = new Signal1(int);
		public var partnerItemAddSignal:Signal1 = new Signal1(Object);
		public var partnerMoneyChangeSignal:Signal1 = new Signal1(String);
		public var tradeCancelSignal:Signal0 = new Signal0();
		public var tradeConcludeSignal:Signal0 = new Signal0();
		
		private var _currentPartnerName:String = "";
		private var _currentPartnerId:int = 0;
		
		private const TRADE_ADD_ITEM_TO_LOT:String = "/trade addItemToLot";
		private const TRADE_REMOVE_ITEM_FROM_LOT:String = "/trade removeItemFromLot";
		private const TRADE_CONCLUDE_DEAL:String = "/trade concludeDeal";
		private const TRADE_CANCEL_DEAL:String = "/trade cancelDeal";
		private const TRADE_REQUEST:String = "/trade request";
		private const TRADE_ACCEPT:String = "/trade accept";
		private const TRADE_DECLINE:String = "/trade deny";
		private const TRADE_MONEY_CHANGE:String = "/trade moneyChange";
		
		public function TradeManager() {
			EsManager.instance.es.engine.addEventListener(MessageType.PrivateMessageEvent.name, onPrivateMessageEvent);
		}
		
		public static function get instance():TradeManager {
			if (!_instance)
				_instance = new TradeManager();
			return _instance;
		}
		
		private function onPrivateMessageEvent(e:PrivateMessageEvent):void {
			trace("Trade: " + e.message);
			switch (e.message) {
				case TRADE_REQUEST: 
					setCurrentPartner(e.esObject.getInteger("id"), e.esObject.getString("name"));
					var confirm:Confirm = new Confirm(DmWindowManager.instance.windowLayer, _("Character") + " '" + _currentPartnerName + "' " + _("wants to trade. Do you agree?"), _("Trade request"), acceptTrade, declineTrade);
					break;
					
				case TRADE_ACCEPT:
					setCurrentPartner(e.esObject.getInteger("id"), e.esObject.getString("name"));
					WindowsManager.getInstance().createWindow(Inventory, null, [MyManager.instance.avatar.id]);
					new Trade(DmWindowManager.instance.windowLayer);
					break;
					
				case TRADE_DECLINE:
					new Alert(DmWindowManager.instance.windowLayer, _("Character") + " '" + e.esObject.getString("name") + "' " + _("doesn't want to trade with you."), _("Trade denied"));
					break;
				
				case TRADE_ADD_ITEM_TO_LOT: 
					var amfphp:AMFPHP = new AMFPHP(onItemInfo).xcall("dm.Item.getItemByI2aId", e.esObject.getInteger("i2aId"));
					break;
				
				case TRADE_REMOVE_ITEM_FROM_LOT: 
					partnerItemRemoveSignal.dispatch(e.esObject.getInteger("itemId"));
					break;
				
				case TRADE_CONCLUDE_DEAL: 
					tradeConcludeSignal.dispatch();
					new Alert(DmWindowManager.instance.windowLayer, _("Trade with character") + " '" + e.esObject.getString("name") + "' " + _("concluded."), _("Trade concluded"));
					break;
				
				case TRADE_CANCEL_DEAL: 
					tradeCancelSignal.dispatch();
					new Alert(DmWindowManager.instance.windowLayer, _("Character") + " '" + e.esObject.getString("name") + "' " + _("canceled trade."), _("Trade canceled"));
					break;
					
				case TRADE_MONEY_CHANGE:
					partnerMoneyChangeSignal.dispatch(e.esObject.getString("money"));
					break;
			}
		}
		
		private function declineTrade():void {
			var pm:PrivateMessageRequest = new PrivateMessageRequest();
			pm.userNames = [_currentPartnerName];
			var data:EsObject = new EsObject();
			data.setString("name", MyManager.instance.avatar.name);
			pm.message = TRADE_DECLINE;
			pm.esObject = data;
			EsManager.instance.es.engine.send(pm);
		}
		
		private function acceptTrade():void {
			var pm:PrivateMessageRequest = new PrivateMessageRequest();
			pm.userNames = [_currentPartnerName];
			var data:EsObject = new EsObject();
			data.setInteger("id", MyManager.instance.avatar.id);
			data.setString("name", MyManager.instance.avatar.name);
			pm.message = TRADE_ACCEPT;
			pm.esObject = data;
			EsManager.instance.es.engine.send(pm);
			
			WindowsManager.getInstance().createWindow(Inventory, null, [MyManager.instance.avatar.id]);
			new Trade(DmWindowManager.instance.windowLayer);
		}
		
		private function onItemInfo(response:Object):void {
			partnerItemAddSignal.dispatch(response);
		}
		
		public function sendTradeRequest(partnerName:String):void {
			var pm:PrivateMessageRequest = new PrivateMessageRequest();
			pm.userNames = [partnerName];
			var data:EsObject = new EsObject();
			data.setInteger("id", MyManager.instance.avatar.id);
			data.setString("name", MyManager.instance.avatar.name);
			pm.message = TRADE_REQUEST;
			pm.esObject = data;
			EsManager.instance.es.engine.send(pm);
		}
		
		public function broadcastRemoveItemFromLot(itemId:int):void {
			var pm:PrivateMessageRequest = new PrivateMessageRequest();
			pm.userNames = [_currentPartnerName];
			var data:EsObject = new EsObject();
			data.setInteger("itemId", itemId);
			pm.message = TRADE_REMOVE_ITEM_FROM_LOT;
			pm.esObject = data;
			EsManager.instance.es.engine.send(pm);
		}
		
		public function broadcastMoneyChange(money:String):void {
			var pm:PrivateMessageRequest = new PrivateMessageRequest();
			pm.userNames = [_currentPartnerName];
			var data:EsObject = new EsObject();
			data.setString("money", money);
			pm.message = TRADE_MONEY_CHANGE;
			pm.esObject = data;
			EsManager.instance.es.engine.send(pm);
		}
		
		public function broadcastAddItemToLot(itemId:int):void {
			var pm:PrivateMessageRequest = new PrivateMessageRequest();
			pm.userNames = [_currentPartnerName];
			var data:EsObject = new EsObject();
			data.setInteger("i2aId", itemId);
			pm.message = TRADE_ADD_ITEM_TO_LOT;
			pm.esObject = data;
			EsManager.instance.es.engine.send(pm);
		}
		
		public function broadcastConcludeDeal(itemsToGetIds:Array, itemsToGiveIds:Array, moneyToGet:int, moneyToGive:int):void {
			var pm:PrivateMessageRequest = new PrivateMessageRequest();
			pm.userNames = [_currentPartnerName];
			var data:EsObject = new EsObject();
			data.setString("name", MyManager.instance.avatar.name);
			pm.message = TRADE_CONCLUDE_DEAL;
			pm.esObject = data;
			EsManager.instance.es.engine.send(pm);
			
			var dealData:Object = {itemsToGetIds: itemsToGetIds, itemsToGiveIds: itemsToGiveIds, moneyToGet: moneyToGet, moneyToGive: moneyToGive};
			
			var amfphp:AMFPHP = new AMFPHP(onTradeConcluded).xcall("dm.Item.executeDeal", MyManager.instance.avatar.id, _currentPartnerId, dealData);
		}
		
		private function onTradeConcluded(response:Object):void {
			tradeConcludeSignal.dispatch();
		}
		
		public function broadcastCancelDeal():void {
			var pm:PrivateMessageRequest = new PrivateMessageRequest();
			pm.userNames = [_currentPartnerName];
			var data:EsObject = new EsObject();
			data.setString("name", MyManager.instance.avatar.name);
			pm.message = TRADE_CANCEL_DEAL;
			pm.esObject = data;
			EsManager.instance.es.engine.send(pm);
		}
		
		public function setCurrentPartner(id:int, name:String):void {
			_currentPartnerId = id;
			_currentPartnerName = name;
		}
		
		public function get currentPartnerName():String {
			return _currentPartnerName;
		}
		
		public function get currentPartnerId():int {
			return _currentPartnerId;
		}
	
	}

}