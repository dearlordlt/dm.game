package ucc.util  {
	
/**
 * Array matcher. Provided RegExp like functionality on comparing arrays
 *
 * @version $Id: ArrayMatcher.as 3 2013-01-31 07:31:58Z rytis.alekna $
 */
public class ArrayMatcher {
	
	/** Root stack */
	protected var root	
	
	
	/**
	 * 
	 * @param	expression
	 */
	public function ArrayMatcher ( expression : Object ) {
		
	}
	
	/** Match stack */
	protected function get stack () : Array {
		
	}
	
	/**
	 * Exis scope
	 * @return
	 */
	protected function exitScope () : ArrayMatcher {
		return this;
	}
	
	public function addArrayMatcher ( arrayMatcher : ArrayMatcher ) : ArrayMatcher {
		
		return this;
		
	}
	
	/**
	 * Add mask matcher
	 * @param	expression
	 * @return
	 */
	public function addStringMaskMatcher ( expression : String ) : ArrayMatcher {
		this.stack.push( new RegExp( "^" + mask.replace( "*", ".*" ).replace( "%", "[0-9]+" ) + "$" ) );
		return this;
	}
	
	/**
	 * Matches array
	 * @param	array
	 * @return	true if matches
	 */
	public function matches ( array ) : Boolean {
		return false;
	}
	
}
	
}