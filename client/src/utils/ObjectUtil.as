package utils  {
	
import ucc.error.IllegalArgumentException;
import flash.utils.ByteArray;
import flash.utils.describeType;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;
	
/**
 * Object utilities
 *
 * @version $Id: ObjectUtil.as 10 2013-01-31 07:30:45Z rytis.alekna $
 * @deprecated	use ucc.util.ObjectUtil
 */
public final class ObjectUtil {
	
	/** Class structore cache */
	private static const classStructureCache 	: Object = {};
	
	/**  */
	private static const objectDescriptionCache	: Object = {};
	
	/**
	 * Get object class
	 * 
	 * @param	object to get class of
	 * @return	object class
	 */
	public static function getClass( object : * ) : Class {
		return getDefinitionByName( getQualifiedClassName( object ) ) as Class;
	}
	
	/**
	 * Get class name, without package
	 * 
	 * @param	object to get class name of
	 * @return	class name
	 */
	public static function getClassName( object : * ) : String {
		var classNameParts : Array = getQualifiedClassName( object ).split( "::" );
		return classNameParts.length > 1 ? classNameParts[1] : classNameParts[0];
	}
	
	/**
	 * Are objects equal?
	 * @param	object1
	 * @param	object2
	 * @return	true if objects are identical
	 */
	public static function areObjectsEqual ( object1 : Object, object2 : Object ) : Boolean {
		
		var byteArray1 : ByteArray = new ByteArray();
		byteArray1.writeObject( object1 );
		byteArray1.position = 0;
		
		var byteArray2 : ByteArray = new ByteArray();
		byteArray2.writeObject( object2 );
		byteArray2.position = 0;
		
		return ( byteArray1.readUTFBytes( byteArray1.bytesAvailable ) ==  byteArray2.readUTFBytes( byteArray2.bytesAvailable ) );
		
	}
	
	/**
	 * Stringify an object
	 * @param	object			any object
	 * @param	name			optional name for object (if not specified, class name is taken)
	 * @param	maxDepth		max depth levels to trace
	 * @param	indent			string segment for indenting
	 * @param	currentIndent	current indend string
	 */
	public static function stringify ( object : * , name : * = "", maxDepth : int = 8, indent : String = "\t", currentIndent : String = "" ) : String {
		
		var retVal : String = "";
		
		function addToRetVal( value : * ) : void {
			retVal += value + "\n";
		}
		
		if ( maxDepth < 0 ) {
			return retVal;
		}
		
		var clazz : Class;
		var i : int = 0;
		var structure : XMLList;
		// string iterator for for..in loops
		var n : String;
		
		// iterator for for..each loops
		var item : * ;
		
		if ( name.length == 0 ) {
			if ( object != null ) {
				if ( object is Class ) {
					name = "class " + ObjectUtil.getClassName( object );
				} else {
					name = "object " + ObjectUtil.getClassName( object );
				}
				
			}
		}
		
		if ( object != null ) {
			
			clazz = ObjectUtil.getClass( object );
			
			switch ( clazz ) {
				
				case String :
					addToRetVal( currentIndent + name + " : " + ObjectUtil.getClassName( object ) + " = \"" + object + "\"" );
				break;
				
				case Number :
				case int	:
				case uint	:
				case Boolean:
					addToRetVal( currentIndent + name + " : " + ObjectUtil.getClassName( object ) + " = " + object );
				break;
				
				case XML	:
					object.prettyPrinting = true;
				case XMLList :
					addToRetVal( currentIndent + name + " : " + ObjectUtil.getClassName( object ) + " = " + object );
				break;
				
				case Function :
					addToRetVal( currentIndent + name + " : " + ObjectUtil.getClassName( object ) + " = " + object );
				break;
				
				case Array  :
					addToRetVal( currentIndent + name + " : " + ObjectUtil.getClassName( object ) + " = [" );
					for ( i = 0; i < object.length; i++) {
						retVal += ( ObjectUtil.stringify( object[i], String(i), maxDepth - 1, indent, currentIndent + indent ) );
					}
					addToRetVal( currentIndent + "]" );
				break;
				
				case Object :
					addToRetVal( currentIndent + name + " : " + ObjectUtil.getClassName( object ) + " = {" );
					for ( n in object ) {
						retVal += ( ObjectUtil.stringify( object[n], n, maxDepth - 1, indent, currentIndent + indent ) );
					}
					addToRetVal( currentIndent + "}" );
				break;
				
				default :
					structure = getClassStructureForObject( object ).fields as XMLList;
					
					// if object has any visible members
					if ( structure.length() > 0 ) {
						
						addToRetVal( currentIndent + name + " : " + ObjectUtil.getClassName( object ) + " = {" );
						
						for each( item in structure ) {
							if ( object[ String( item.@name ) ] ) {
								retVal += ( ObjectUtil.stringify( object[ String( item.@name ) ], String( item.@name ), maxDepth - 1, indent, currentIndent + indent ) );
							} else {
								addToRetVal( currentIndent + indent + item.@name + " : " + String( item.@type ) + " = " + object[ String( item.@name ) ] );
							}
						}
						
						addToRetVal( currentIndent + "}" );
					
					// if no visible members - use objects toString method
					} else {
						addToRetVal( currentIndent + name + " : " + ObjectUtil.getClassName( object ) + " = " + String( object ) );
					}
				break;
				
			}			
			
		} else {
			addToRetVal( currentIndent + name + " : " + ObjectUtil.getClassName( object ) + " = " + object );
		}
		
		

		
		return retVal;
		
	}
	
	/**
	 * Utility method for retrieving and caching class structure description
	 * @param	object for which 
	 * @return
	 */
	private static function getClassStructureForObject ( object : * ) : Object {
		
		var classDescription : XML = ObjectUtil.getObjectDescription( object );
		
		var retVal : Object = { };
		
		var fields : XMLList = new XMLList( classDescription.constant );
		fields += XMLList( classDescription.variable );
		fields += XMLList( classDescription.accessor.(@access != "writeonly" && @name != "prototype") );
		retVal.fields = fields;
		
		return retVal;
	}
	
	/**
	 * Get object XML description. Works same like flash.utils.describeType function, except, all results are cached for performance improvement
	 * @param	object
	 * @return	XML description on object
	 */
	public static function getObjectDescription ( object : * ) : XML {
		
		var className : String = getQualifiedClassName( object );
		
		var instance : Boolean  = ( object is Class );
		
		if ( ObjectUtil.objectDescriptionCache[ instance + className ] ) {
			return ( ObjectUtil.objectDescriptionCache[ instance + className ] as XML ).copy()
		} else {
			return ObjectUtil.objectDescriptionCache[ instance + className ] = describeType( object );
		}
		
	}
	
	/**
	 * Has object specified property? This method is diferent from Object.hasOwnProperty, because it accepts QNmae as name specifier
	 * @param	object
	 * @param	name (String or QNmae)
	 * @return	true if has
	 */
	public static function hasProperty ( object : Object, name : * ) : Boolean {
		
		if ( !object || !name ) {
			throw new IllegalArgumentException( "Context must be specified!" );
		}
		
		if ( !( name is String ) || !( name is QName ) ) {
			throw new IllegalArgumentException( "Name must be a String or QName!" );
		}
		
		if ( name is String ) {
			return object.hasOwnProperty( name );
		} else {
			
			var available : Boolean;
			
			try {
				var v:* = object[name];
				available = true;
			} catch (e : Error) {
				
			}
			
			return available;
			
		}
		
	}
	
	/**
	 *	Clone object
	 */
	public static function clone ( object : Object) : * {
		var byteArray : ByteArray = new ByteArray();
		byteArray.writeObject(object);
		byteArray.position = 0;
		return byteArray.readObject();
	}	
	
}
	
}