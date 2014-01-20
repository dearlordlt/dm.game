package dm.game.functions {
	
/**
 * 
 * @author Rytis Alekna
 * @version $id$
 */
public interface ParameterizedCommand extends Command {
	
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