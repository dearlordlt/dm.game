package ucc.util {

/**
 * Delegate method and supply params
 *
 * @version $Id: Delegate.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class Delegate {
	
	/**
	 * Create delegate. Call arguments will be concated wtih suplied argument to delegate creation function.
	 * @param	handler
	 * @param	... args
	 * @return	delegated function
	 */
	public static function create( handler : Function, ... args ) : Function {
		return function( ... innerArgs ) : * {
			return handler.apply( this, innerArgs.concat( args ) );
		}
	}
	
	/**
	 * Create delegate. Call arguments will be concated wtih suplied argument to delegate creation function. Unlike #create method, user suplied arguments will be apssed before call arguments
	 * @param	handler
	 * @param	... args
	 * @return	delegated function
	 */
	public static function createWithUserArgsPriority( handler : Function, ... args ) : Function {
		return function( ... innerArgs ) : * {
			return handler.apply( this, args.concat( innerArgs ) );
		}
	}
	
	/**
	 * Create delegate but ignoring outer call params (eg.: event will not passed to handler - only given atgs)
	 * @param	handler
	 * @param	... args
	 * @return	delegated function
	 */
	public static function createWithCallArgsIgnore ( handler : Function, ... args ) : Function {
		return function( ... innerArgs ) : * {
			return handler.apply( this, args );
		}
	}
	
	
	
}

}