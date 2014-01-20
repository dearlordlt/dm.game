package ucc.project.dialog_editor.vo {
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import ucc.util.ArrayUtil;

/**
 * Dialog VO
 * @version $Id: Dialog.as 69 2013-03-15 12:30:24Z rytis.alekna $
 */
public class Dialog extends SaveableVO {
	
	/** Id */
	public var id						: Number;
	
	/** Name */
	public var name						: String = "";
	
	/** Phrases */
	public var phrases					: Array = [];
	
	/** Deleted phrases */
	public var deletedPhrases			: Array = [];
	
	/** Created by */
	public var created_by				: Number;
	
	/** Last updated by */
	public var last_modified_by			: Number;
	
	/** Created date */
	public var created_date				: String;
	
	/** Last modified date */
	public var last_modified_date		: String;
	
	/** Topic */
	public var topic					: String = "";
	
	/** Topic id */
	public var topic_id					: Number = 0;
	
	/** x and y coords of root node */
	public var x_y						: String = "";
	
	/**
	 * Class constructor
	 */
	public function Dialog() {
		
	}
	
	/**
	 * Make cleaned from ids clone
	 * @return	dublicate
	 */
	public function cleanDuplicate () : Dialog {
		
		var data : Dialog = this;
		
		var retVal : Dialog = new Dialog();
		
		// original to temporary ids table
		var temporalIdsTable	: Dictionary = new Dictionary();
		
		temporalIdsTable[ 0 ] = 0; // all unconnected nodes are root!
		temporalIdsTable[ -1 ] = -1; // minus one means that phrase doesn't have paren't but is NOT root (entrance) node. 
		// It's some kind of unconnected node
		
		retVal.x_y = this.x_y;
		
		retVal.topic_id = this.topic_id;
		
		// starting from -2 to negative
		var idsIterator		: int = -2;
		
		var duplicatePhrase	: Phrase;
		
		var phrase 			: Phrase;
		
		// here we swap original ids with temporal that will be switched back to "true" id during saving to DB
		for each( phrase in data.phrases ) {
			
			temporalIdsTable[ phrase.id ] = idsIterator;
			
			duplicatePhrase = phrase.cleanDuplicate();
			
			duplicatePhrase.id = idsIterator;
			
			retVal.phrases.push( duplicatePhrase );
			
			idsIterator--;
			
		}
		
		// and here we swap original parent_id with temporal ones
		for each( phrase in retVal.phrases ) {
			phrase.parent_id = temporalIdsTable[ phrase.parent_id ];
		}
		
		return retVal;		
	}
	
	/**
	 * Factory method
	 */
	public static function create ( data : Object ) : Dialog {
	
		var retVal : Dialog = new Dialog();
		
		retVal.id 							= data.id;
		retVal.name 						= data.name;
		retVal.x_y							= data.x_y;
		retVal.topic_id						= data.topic_id;
		retVal.topic						= data.topic;
		
		for each( var phrase : Object in data.phrases ) {
			retVal.phrases.push( Phrase.create( phrase ) );
		}
		
		return retVal;
	
	}
	
	public function toObject () : Object {
		var byteArray : ByteArray = new ByteArray();
		byteArray.writeObject( this );
		byteArray.position = 0;
		return byteArray.readObject();
	}
	
}

}