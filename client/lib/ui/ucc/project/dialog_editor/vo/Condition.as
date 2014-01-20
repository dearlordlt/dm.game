package ucc.project.dialog_editor.vo {

/**
 * Condition VO
 * @version $Id: Condition.as 38 2013-02-27 02:29:58Z rytis.alekna $
 */
public class Condition extends SaveableVO {
	
	public var id		: Number;
	
	public var label	: String;
	
	public var params	: Array = [];	
	
	public var icon		: * ;
	
	public function Condition() {
		
	}
	
	
	/**
	 * Make cleaned from ids clone
	 * @return	dublicate
	 */
	public function cleanDuplicate () : Condition {
		var data : Condition = this;
		
		var retVal : Condition = new Condition();
	
		retVal.label	= data.label;
		
		for each( var item : ConditionParam in  data.params ) {
			retVal.params.push( item.cleanDuplicate() );
		}
		
		return retVal;		
	}	
	
	/**
	 * Factory method
	 */
	public static function create ( data : Object ) : Condition {
	
		var retVal : Condition = new Condition();
	
		retVal.id		= data.id;
		retVal.label	= data.label;
		
		for each( var item : Object in  data.params ) {
			retVal.params.push( ConditionParam.create( item ) );
		}
		
		return retVal;
	}
	
}

}