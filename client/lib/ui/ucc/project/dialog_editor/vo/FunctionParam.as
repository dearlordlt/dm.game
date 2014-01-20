package ucc.project.dialog_editor.vo {

/**
 * Function param VO
 * @version $Id: FunctionParam.as 38 2013-02-27 02:29:58Z rytis.alekna $
 */
public class FunctionParam extends SaveableVO {
	
	public var id			: Number;
	
	public var value		: String;
	
	public var label		: String;
	
	public var function_id	: Number;
	
	public var icon			: * ;
	
	/**
	 * Class constructor
	 */
	public function FunctionParam () {
		
	}
	
	/**
	 * Make cleaned from ids clone
	 * @return	dublicate
	 */
	public function cleanDuplicate () : FunctionParam {
		var data : FunctionParam = this;
		
		var retVal : FunctionParam = new FunctionParam();
		
		retVal.value		= data.value;
		retVal.label		= data.label;
		
		return retVal;		
	}	
	
	/**
	 * Factory method
	 */
	public static function create ( data : Object ) : FunctionParam {
	
		var retVal : FunctionParam = new FunctionParam();
		
		retVal.id			= data.id;
		retVal.value		= data.value;
		retVal.label		= data.label;
		retVal.function_id	= data.function_id;
		
		return retVal;
	
	}
	
}

}