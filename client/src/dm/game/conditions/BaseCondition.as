package dm.game.conditions {

/**
 * 
 * @version $Id: BaseCondition.as 192 2013-07-25 18:49:46Z rytis.alekna $
 */
public class BaseCondition implements Condition {
	
	/** LABEL */
	public static const LABEL 			: String = "label";
	
	/** params */
	protected var params 				: Object = {};

	/** On result callback */
	protected var onResult 				: Function;	
	
	/**
	 * (Constructor)
	 * - Returns a new BaseCondition instance
	 */
	public function BaseCondition() {
		
	}
	
	/**
	 *	Executes.
	 */
	public function execute () : void {
		
	}
	
	
	/**
	 *	Set params
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