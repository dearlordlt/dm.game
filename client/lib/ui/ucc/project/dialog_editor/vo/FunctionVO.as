package ucc.project.dialog_editor.vo {

/**
 * Function VO
 * @version $Id: FunctionVO.as 38 2013-02-27 02:29:58Z rytis.alekna $
 */
public class FunctionVO extends SaveableVO {
	
	public var id		: Number;
	
	public var label	: String;
	
	public var params	: Array = [];
	
	public var icon		: * ;
	
	/**
	 * Class constructor
	 */
	public function FunctionVO() {
		
	}
	
	/**
	 * Make cleaned from ids clone
	 * @return	dublicate
	 */
	public function cleanDuplicate () : FunctionVO {
		
		var data : FunctionVO = this;
		
		var retVal : FunctionVO = new FunctionVO();
	
		retVal.label	= data.label;
		
		for each( var item : FunctionParam in  data.params ) {
			retVal.params.push( item.cleanDuplicate() );
		}
		
		return retVal;		
	}
	
	/**
	 * Factory method
	 */
	public static function create ( data : Object ) : FunctionVO {
	
		var retVal : FunctionVO = new FunctionVO();
	
		retVal.id		= data.id;
		retVal.label	= data.label;
		
		for each( var item : Object in  data.params ) {
			retVal.params.push( FunctionParam.create( item ) );
		}
		
		return retVal;
	
	}
	
}

}