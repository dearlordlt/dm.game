package dm.game.windows.inventory {
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.StringUtils;

/**
 * 
 * @version $Id: InventoryItem.as 215 2013-09-29 14:28:49Z rytis.alekna $
 */
public class InventoryItem {
		
	/** DM */
	private static const DM : String = "Dm";
	
	/**
	 * (Constructor)
	 * - Returns a new InventoryItem instance
	 */
	public function InventoryItem() {
		
	}
	
	public static function getItemIcon ( data : Object ) : Class {
		return ClassUtils.forName( DM + StringUtils.titleize( data.icon ) );
	}
	
}

}