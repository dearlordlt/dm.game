package   {
	
/**
 * Ignore. A special type to use instead of null
 *
 * @version $Id: ignore.as 5 2013-02-11 10:30:16Z rytis.alekna $
 */
public function get ignore () : Ignore {
	return Ignore.getInstance();
}
	
}

final class Ignore {
	
	/** IGNORE */
	private static const IGNORE : String = "ignore";
	
	/**
	 * Class constructor
	 */
	public function Ignore ( singletonAtractor : SingletonAtractor ) {
		if ( !singletonAtractor ) {
			throw new Error("You can create instances of this class!");
		}
	}
	
	/** Singleton instance */
	private static var instance : Ignore;
	
	/**
	 * Get singleton instance of class
	 * @return 	singleton instance	Ignore
	 */
	internal static function getInstance (  ) : Ignore {
		return Ignore.instance ? Ignore.instance : ( Ignore.instance = new Ignore( new SingletonAtractor() ) );
	}
	
	public function toString () : String {
		return IGNORE;
	}
	
	public static function toString () : String {
		return IGNORE;
	}
	
}

final class SingletonAtractor {}