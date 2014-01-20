package dm.game.conditions {
	
/**
 * Condition prototype
 * @version $id$
 */
public interface Condition {
	
	/**
	 * Execute condition
	 */
	function execute () : void;
	
	/**
	 * Sets params
	 * @param	params
	 * @param	onResult callback
	 */
	function setParams ( params : Array, onResult : Function ) : void;
	
	
	/**
	 * get param by name
	 * @param	name
	 * @return	value
	 */
	function getParamValueByLabel( name : String ) : * ;	
	
}
	
}