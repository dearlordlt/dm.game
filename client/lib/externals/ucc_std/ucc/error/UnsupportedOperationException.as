package ucc.error {
  
/**
 * Thrown to indicate that the requested operation is not supported.
 *
 * @version $Id: UnsupportedOperationException.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class UnsupportedOperationException extends Exception {

	/**
	 * Constructs an UnsupportedOperationException with the specified
	 * detail message.
	 *
	 * @param message the detail message
	 */		
	function UnsupportedOperationException( message : String = "" ) {
		super( message );
	}

}

}