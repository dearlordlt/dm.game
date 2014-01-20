package ucc.project.dialog_editor.vo {

/**
 * 
 * @version $Id: ConditionParam.as 38 2013-02-27 02:29:58Z rytis.alekna $
 */
public class ConditionParam extends SaveableVO {
	
	public var id			: Number;
	
	public var value		: String;
	
	public var label		: String;
	
	public var condition_id	: Number;	
	
	public var icon			: * ;
	
	/**
	 * Class constructor
	 */
	public function ConditionParam() {
		
	}
	
	/**
	 * Make cleaned from ids clone
	 * @return	dublicate
	 */
	public function cleanDuplicate () : ConditionParam {
		var data : ConditionParam = this;
		
		var retVal : ConditionParam = new ConditionParam();
	
		retVal.value		= data.value;
		retVal.label		= data.label;
		
		return retVal;		
	}	
	
	/**
	 * Factory method
	 */
	public static function create ( data : Object ) : ConditionParam {
	
		var retVal : ConditionParam = new ConditionParam();
	
		retVal.id			= data.id;
		retVal.value		= data.value;
		retVal.label		= data.label;
		retVal.condition_id	= data.condition_id;
		
		return retVal;
	
	}
	
}

}