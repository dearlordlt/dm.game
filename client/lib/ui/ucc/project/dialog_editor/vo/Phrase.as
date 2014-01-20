package ucc.project.dialog_editor.vo {

/**
 * Phrase VO
 * @version $Id: Phrase.as 65 2013-03-12 13:25:05Z rytis.alekna $
 */
public class Phrase extends SaveableVO {
	
	public static const ROOT_PARENT_ID		: Number	= 0;
	public static const ORPHAN_PARENT_ID	: Number 	= NaN;
	
	public var id					: Number;
	
	public var dialog_id			: Number;
	
	public var parent_id			: Number;
	
	public var priority				: Number;
	
	/** me or npc */
	public var subject				: String;
	
	public var x_y					: String = "";
	
	public var text					: String = "";
	
	public var created_date			: String;
	
	public var created_by			: Number;
	
	public var last_modified_date	: String;
	
	public var last_modified_by		: Number;
	
	public var functions			: Array = [];
	
	public var conditions			: Array = [];
	
	public var deletedFunctions		: Array = [];
	
	public var deletedConditions	: Array = [];
	
	/** Is root node? */
	public var root					: Boolean = false;
	
	/**
	 * Class constructor
	 */
	public function Phrase() {
		
	}
	
	/**
	 * Make cleaned from ids clone
	 * @return	dublicate
	 */
	public function cleanDuplicate () : Phrase {
		var data : Phrase = this;
		
		var retVal : Phrase = new Phrase();
		
		// TODO: maybe reparenting
		retVal.parent_id = data.parent_id
		
		retVal.priority	= data.priority;
		retVal.subject = data.subject;
		retVal.x_y = data.x_y;
		retVal.text	= data.text;
		
		for each( var functionVO : FunctionVO in data.functions ) {
			retVal.functions.push( functionVO.cleanDuplicate() );
		}
		
		for each( var condition : Condition in data.conditions ) {
			retVal.conditions.push( condition.cleanDuplicate() );
		}
		
		return retVal;		
	}	
	
	/**
	 * Factory method
	 */
	public static function create ( data : Object ) : Phrase {
	
		var retVal : Phrase = new Phrase();
		
		retVal.id = data.id;
		
		retVal.dialog_id = data.dialog_id;
		
		retVal.parent_id = data.parent_id;
		
		retVal.priority	= data.priority;
		
		retVal.subject = data.subject;
		
		retVal.x_y = data.x_y;
		
		retVal.text	= data.text;
		
		retVal.created_date	= data.created_date;
		
		retVal.created_by = data.created_by;
		
		retVal.last_modified_date = data.last_modified_date;
		
		retVal.last_modified_by	= data.last_modified_by;
		
		for each( var functionVO : Object in data.functions ) {
			retVal.functions.push( FunctionVO.create( functionVO ) );
		}
		
		for each( var condition : Object in data.conditions ) {
			retVal.conditions.push( Condition.create( condition ) );
		}
		
		return retVal;
	
	}
	
}

}