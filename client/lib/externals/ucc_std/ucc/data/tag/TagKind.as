package ucc.data.tag  {
	import fl.data.DataProvider;
	import flash.errors.IllegalOperationError;
	import ucc.error.IllegalArgumentException;
	
/**
 * Tag kind. It is a collection of associated tags. 
 * It is used to query an array of raw tag ids and return a Tag of that kind if any is matching.
 *
 * @version $Id: TagKind.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class TagKind {
	
	/** Tags */
	protected var tags		: Array = [];
	
	/** Name of kind */
	protected var name 		: String = "";
	
	/**
	 * Get tag kind by tag id
	 */
	public static function getTagKindByTagId ( id : Number ) : TagKind {
		
		var tag : Tag = Tag.getTagById( id );
		if ( tag ) {
			return tag.getKind();
		} else {
			return null;
		}
		
	}
	
	/**
	 * Class constructor
	 */
	public function TagKind ( name : String, ... tags ) {
		
		this.name = name;
		
		if ( ( tags.length == 1 ) && !( tags[0] is Tag ) ) {
			this.parseObjectIntoTags( tags[0] );
		} else {
			for each( var tag : Tag in tags ) {
				tag.setKind( this );
			}
			this.tags = tags;
		}
	}
	
	/**
	 * Parse raw object into tags
	 */
	public function parseObjectIntoTags ( object : Object ) : void {
		for ( var id : String in object ) {
			this.tags.push( Tag.create( parseInt( id ), object[id], this ) );
		}
	}
	
	/**
	 * Get tag(s) of this kind from a given array.
	 */
	public function getTagsOfThisKind ( givenTags : Array ) : Vector.<Tag> {
		
		if ( !givenTags ) {
			throw new Error( "ucc.data.tag.TagKind.getTagOfThisKind() : given tags must be not null!" );
		}
		
		var retVal : Vector.<Tag> = new Vector.<Tag>();
		
		for each( var tag : Tag in givenTags ) {
			if ( tag.getKind() == this ) {
				retVal.push( tag );
			}
		}
		
		return retVal;
		
	}
	
	/**
	 * Get dat provider from tags
	 */
	public function toDataProvider () : DataProvider {
		return new DataProvider( this.tags.concat() );
	}
	
	/**
	 * Get tags
	 */
	public function getTags () : Array {
		return this.tags.concat();
	}
	
	/**
	 * Get kind name
	 */
	public function getName () : String {
		return this.name;
	}
	
}
	
}