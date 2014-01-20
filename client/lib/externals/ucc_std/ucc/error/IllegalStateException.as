package ucc.error {
  
/**
 * Signals that a method has been invoked at an illegal or
 * inappropriate time.  In other words, the Flash environment or
 * Flash application is not in an appropriate state for the requested
 * operation.
 * 
 * @version $Id: IllegalStateException.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class IllegalStateException extends Exception {
    
    /**
     * Constructs a <code>NullPointerException</code> with the specified 
     * detail message. 
     *
     * @param message   the detail message.
     */
    function IllegalStateException( message : String = "" ) {
		super( message );
    }
	
}

}