package ucc.error {
  
/**
 * Thrown to indicate that a method has been passed an illegal or 
 * inappropriate argument.
 * 
 * @version $Id: IllegalArgumentException.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class IllegalArgumentException extends Exception {

	/**
	 * Constructs a <code>NullPointerException</code> with the specified 
	 * detail message. 
	 *
	 * @param message   the detail message.
	 */
	function IllegalArgumentException( message : String = "" ) {
		super( message );
	}

}

}