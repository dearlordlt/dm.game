package dm.builder.interfaces.tools.dialogeditor 
{
	/**
	 * ...
	 * @author Darius Dauskurdis dariusdxd@gmail.com
	 */
	
	//Jeigu beveik vienu metu iskvieciama ta pati funkcija, bet skirtingiems atvaizdavimams, tai gali susikirsti nes naudos ta pati responder,
	//Todel geriausia panaudoti skirtingas funkcijas, bet i ta pacia php funkcija
	//kaip pvz getAllDialogs ir getAllDialogsToCopy
	 
	import flash.net.NetConnection;
	import flash.net.Responder;
	 
	public class DataBase 
	{
		//public var gateway:String = "http://localhost/dialog_editor_new/amfphp/gateway.php";
		public var gateway:String;
		public var connection:NetConnection = new NetConnection;
		
		public function DataBase(gateway:String) {
			this.gateway = gateway;
			connection.connect(gateway);
		}
		
		public function getAllDialogs(function_name:Function):void {
			var responder:Responder = new Responder(function_name,onFault);
			connection.call("dm.DBQueries.readAllDialogs", responder);
		}
		
		public function getAllDialogsToCopy(function_name:Function):void {
			var responder:Responder = new Responder(function_name,onFault);
			connection.call("dm.DBQueries.readAllDialogs", responder);
		}

		public function filterAllDialogs(function_name:Function,params:Object):void {
			var responder:Responder = new Responder(function_name,onFault);
			connection.call("dm.DBQueries.readAllDialogs", responder, params);
		}
		
		public function getDialog(function_name:Function,id:Number):void {
			var responder:Responder = new Responder(function_name,onFault);
			connection.call("dm.DBQueries.readDialog", responder, id);
		}
		
		public function updateNodePosition(function_name:Function, id:Number, x:Number, y:Number, is_main:Boolean):void {
			var params:Object = {"id":id,"x":x,"y":y,"is_main":is_main}
			var responder:Responder = new Responder(function_name,onFault);
			connection.call("dm.DBQueries.updateNodePosition", responder, params);
		}
		
		public function addNodeToDatabase(function_name:Function,params:Object):void {
			var responder:Responder = new Responder(function_name,onFault);
			connection.call("dm.DBQueries.addNodeToDatabase", responder, params);
		}
		
		public function deleteNodeFromDatabase(function_name:Function,params:Object):void {
			var responder:Responder = new Responder(function_name,onFault);
			connection.call("dm.DBQueries.deleteNodeFromDatabase", responder, params);
		}
		
		public function getAllUsers(function_name:Function):void {
			var responder:Responder = new Responder(function_name,onFault);
			connection.call("dm.DBQueries.getAllUsers", responder);
		}
		
		public function getUserById(function_name:Function,params:Object):void {
			var responder:Responder = new Responder(function_name,onFault);
			connection.call("dm.DBQueries.getUserById", responder, params.user_id);
		}
		
		public function updateDialogInfo(function_name:Function, params:Object):void {
			var responder:Responder = new Responder(function_name, onFault);
			connection.call("dm.DBQueries.updateDialogInfo", responder, params);
		}
		
		public function updatePhraseInfo(function_name:Function, params:Object):void {
			var responder:Responder = new Responder(function_name,onFault);
			connection.call("dm.DBQueries.updatePhraseInfo", responder, params);
		}
		
		public function addDialog(function_name:Function,params:Object):void {
			var responder:Responder = new Responder(function_name,onFault);
			connection.call("dm.DBQueries.addDialog", responder, params);
		}
		
		public function onFault(fault:Object): void {
			var st:String = String(fault.description);
			trace(st);
		}
	}
}