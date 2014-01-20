package ucc.util {
	
import fl.data.DataProvider;

/**
 *
 *
 * @version $Id: ArrayCollectionUtil.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class ArrayCollectionUtil {
	
	/**
	 * Convert ArrayCollection (or AMFPHP rowset) to fl.data.DataProvider
	 * @param	myArrayCollection
	 * @return
	 */
	public static function toDataProvider( myArrayCollection : Object ) : DataProvider {
		
		var values : Array = myArrayCollection.serverInfo.initialData;
		
		var category : Array = myArrayCollection.serverInfo.columnNames;
		
		var formedArray : Array = new Array();
		
		for ( var i : Number = 0; i < values.length; i++ ) {
			
			formedArray[ i ] = new Object();
			
			for ( var aIndex : *in category ) {
				
				formedArray[ i ][ category[ aIndex ] ] = values[ i ][ aIndex ];
				
			}
			
		}
		
		return new DataProvider( formedArray );
	
	}

}

}
