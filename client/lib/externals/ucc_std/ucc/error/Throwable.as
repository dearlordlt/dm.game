package ucc.error {
	
import flash.utils.getQualifiedClassName;
  
/**
 * The <code>Throwable</code> class is the superclass of all errors and
 * exceptions in the ActionScript language. Only objects that are instances of this
 * class (or one of its subclasses) are thrown by the Flash Virtual Machine or
 * can be thrown by the ActionScript <code>throw</code> statement. Similarly, only
 * this class or one of its subclasses can be the argument type in a
 * <code>catch</code> clause.
 * 
 * <p>Instances of one subclass <code>Exception</code>, are conventionally 
 * used to indicate that exceptional situations have occurred. 
 * Typically, these instances are freshly created in the context of 
 * the exceptional situation so as to include relevant 
 * information (such as stack trace data).
 * 
 * @version $Id: Throwable.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class Throwable extends Error {

	/**
	 * Constructor 
	 * 
	 * @param	message exceptional situation description
	 */
	function Throwable( message : String ) {
		super( message );
	}

	/**
	 * Get exceptional situation description
	 * 
	 * @return exceptional situation description
	 */
	public function getMessage() : String {
		return message;	
	}

	/**
	 * Get throwable class name
	 * 
	 * @return throwable class name
	 */
	public function getName() : String {
		return getQualifiedClassName( this );
	}
	
}

}