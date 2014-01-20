package dm.game.functions {
	import org.as3commons.lang.ArrayUtils;
	import ucc.util.ArrayUtil;

/**
 * base executable implementation
 * @version $Id: BaseExecutable.as 142 2013-05-28 08:07:55Z rytis.alekna $
 */
public class BaseExecutable implements ParameterizedCommand {
		
	/** LABEL */
	public static const LABEL 			: String = "label";
	
	/** params */
	protected var params 				: Object = {};

	/** On result callback */
	protected var onResult 				: Function;
	
	/**
	 * Class constructor
	 */
	public function BaseExecutable() {
		
	}
	
	/**
	 *	executes this instace
	 */
	public function execute () : void {
		
	}
	
	/**
	 *	
	 */
	public function setParams ( params : Array ,  onResult : Function ) : void {
		this.onResult = onResult;
		
		for each( var item : Object in params) {
			this.params[ item.label ] = item.value;
		}
		
	}
	
	/**
	 *	Gets the ParamByName of the specified name.
	 */
	public function getParamValueByLabel ( name : String ) : * {
		return this.params[ name ];
	}
	
}

}