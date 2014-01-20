package ucc.data.remote  {
	
/**
 * Remove item VO
 *
 * @version $Id: RemoteItemVO.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class RemoteItemVO {
	
	/**
	 * You can oveeride it if you want to
	 */
	public function get label () : String {
		return null;
	}
	
	/**
	 * You can override it if you want
	 */
	public function get icon () : * {
		return null;
	}
	
}
	
}