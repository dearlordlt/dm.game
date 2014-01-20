package   {
	
	/**
	 * Java like assert function.
	 *
	 * @version $Id: assert.as 2 2013-01-04 10:56:02Z rytis.alekna $
	 */
	public function assert ( expression : *, message : String = "" ) : void {
		
		// CONFIG::ASSERT {
			if ( !expression ) {
				throw new AssertionError( message );
			}
		// }
		
	}
	
}
import ucc.error.Exception;

class AssertionError extends Exception {
	
	/**
	 * Class constructor
	 */
	public function AssertionError ( message : String ) {
		super( message );
	}
	
}