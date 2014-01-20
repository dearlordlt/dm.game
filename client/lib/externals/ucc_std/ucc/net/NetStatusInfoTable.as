package ucc.net  {
	import flash.utils.describeType;
	import flash.errors.IllegalOperationError;
	
/**
 * Net status info table
 *
 * @version $Id: NetStatusInfoTable.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class NetStatusInfoTable {
	
	/** Singleton instance */
	private static var instance : NetStatusInfoTable;
	
	/**
	 * Get singleton instance of class
	 * @return 	singleton instance	NetStatusInfoTable
	 */
	public static function getInstance () : NetStatusInfoTable {
		return NetStatusInfoTable.instance ? NetStatusInfoTable.instance : ( NetStatusInfoTable.instance = new NetStatusInfoTable( new SingletonAttractor() ) );
	}
	
	/** Net status infos */
	private var netStatusInfos : Object = {};
	
	/**
	 * Class constructor
	 */
	public function NetStatusInfoTable ( singletonAttractor : SingletonAttractor ) {
		if ( !singletonAttractor ) {
			throw new IllegalOperationError( "class ucc.net.NetStatusInfoTable is Singleton!" );
		}
		
		// collect all constant to library
		var describedType : XMLList = describeType( NetStatusInfo ).constant.(@type == "ucc.net::NetStatusInfo" );
		
		var proccessed : int;
		
		for each ( var node : XML in describedType ) {
			this.netStatusInfos[ NetStatusInfo( NetStatusInfo[node.@name.toString()] ).code ] = NetStatusInfo[node.@name.toString()];
		}
		
	}
	
	/** Add net status to table */
	public function addNetStatusInfo( netStatusInfo : NetStatusInfo ) : void {
		this.netStatusInfos[ netStatusInfo.code ] = netStatusInfo;
	}
	
	/**
	 * Get net status info
	 */
	public function getNetStatusByCode( code : String ) : NetStatusInfo {
		return this.netStatusInfos[ code ];
	}

}
	
}

class SingletonAttractor {}