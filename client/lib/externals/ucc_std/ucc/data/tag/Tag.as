package ucc.data.tag  {
	
/**
 * Tag VO
 *
 * @version $Id: Tag.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class Tag {
	
	/** Tags by id */
	internal static var tagsById		: Object = { };
	
	/** Name */
	public var name 				: String = "";
	
	/** Id */
	public var id 					: Number;
	
	/** Icon (needed for UI components)*/
	public var icon					: * = null;
	
	/** Tag kind */
	protected var tagKind			: TagKind;
	
	/**
	 * Get tag by id
	 */
	public static function getTagById ( id : Number ) : Tag {
		return tagsById[id];
	}
	
	/**
	 * Create tag (or retrun existing one)
	 */
	public static function create ( id : Number = NaN, name : String = null, tagKind : TagKind = null ) : Tag {
		if ( tagsById[id] ) {
			return tagsById[id];
		} else {
			var tag : Tag = new Tag( id, name, tagKind );
			return tag;
		}
	}
	
	/**
	 * Class constructor
	 */
	public function Tag ( id : Number = NaN, name : String = null, tagKind : TagKind = null ) {
		this.id 		= id;
		this.name 		= name;
		this.tagKind 	= tagKind;
		if ( tagsById[id] ) {
			trace( "[ucc.data.tag.Tag.Tag] : overriding registered tag with " + this.toString() );
		}
		
		tagsById[ id ] = this;
		
	}
	
	/**
	 * Get tag kind
	 */
	public function getKind () : TagKind {
		return this.tagKind;
	}
	
	/**
	 * Set tag kind
	 */
	internal function setKind ( tagKind : TagKind ) : void {
		this.tagKind = tagKind;
	}
	
	/**
	 * Get name
	 */
	public function get label () : String {
		return _(this.name);
	}
	
	public function toString () : String {
		return "object [Tag id=" + this.id + ", name=" + this.name + ", localizedName=" + this.label + ", kind=" + this.tagKind ? this.tagKind.getName() : "#NONE#" + "]";
	}
	
}
	
}