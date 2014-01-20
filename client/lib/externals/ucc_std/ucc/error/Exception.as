package ucc.error {
  
/**
 * The class <code>Exception</code> and its subclasses are a form of 
 * <code>Throwable</code> that indicates conditions that a reasonable 
 * application might want to catch.
 * 
 * @version $Id: Exception.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class Exception extends Throwable {

	/**
	 * Constructs a new exception with the specified detail message.
	 *
	 * @param   message   the detail message. The detail message is saved for 
	 *          later retrieval by the #getMessage() method.
	 */
	function Exception( message : String ) {
		super( message );
	}

}

}