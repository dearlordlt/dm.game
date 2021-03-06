package ucc.util  {
	
import flash.net.ObjectEncoding;
import flash.net.registerClassAlias;
import ucc.error.IllegalArgumentException;
import flash.utils.ByteArray;
import flash.utils.describeType;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;
	
/**
 * Object utilities
 *
 * @version $Id: ObjectUtil.as 4 2013-02-10 10:02:56Z rytis.alekna $
 */
public final class ObjectUtil {
	
	/** Class structore cache */
	private static const classStructureCache 	: Object = {};
	
	/**  */
	private static const objectDescriptionCache	: Object = { };
	
	/** Double column */
	public static const DOUBLE_COLUMN			: String = "::";
	
	/** Dot */
	public static const DOT						: String = ".";
		
	/** STRING */
	public static const STRING 					: String = "String";
		
	/** NUMBER */
	public static const NUMBER 					: String = "Number";
		
	/** INT */
	public static const INT 					: String = "int";
		
	/** UINT */
	public static const UINT 					: String = "uint";
		
	/** BOOLEAN */
	public static const BOOLEAN 				: String = "Boolean";
		
	/** XML_CLASS_NAME */
	public static const XML_CLASS_NAME 			: String = "XML";
		
	/** XML_LIST_CLASS_NAME */
	public static const XML_LIST_CLASS_NAME 	: String = "XMLList";
		
	/** FUNCTION */
	public static const FUNCTION 				: String = "Function";
		
	/** ARRAY */
	public static const ARRAY 					: String = "Array";
		
	/** OBJECT */
	public static const OBJECT 					: String = "Object";
	
	/** VECTOR */
	public static const VECTOR					: String = "__AS3__.vec::Vector";
	
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
		var classNameParts : Array = getQualifiedClassName( object ).split( DOUBLE_COLUMN );
		return classNameParts.length > 1 ? classNameParts[1] : classNameParts[0];
	}
	
	/**
	 * Get fully qualified class name. Same as flash.utils.getQualifiedClassName() but without double collumn (::)
	 * @param	object
	 * @return	fully qualified class name
	 */
	public static function getFullyQualifiedClassName ( object : * ) : String {
		return getQualifiedClassName( object ).replace( DOUBLE_COLUMN, DOT );
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
	 * Converts a plain vanilla object to be an instance of the class
	 * passed as the second variable.  This is not a recursive function
	 * and will only work for the first level of nesting.  When you have
	 * deeply nested objects, you first need to convert the nested
	 * objects to class instances, and then convert the top level object.
	 *
	 * TODO: This method can be improved by making it recursive.  This would be
	 * done by looking at the typeInfo returned from describeType and determining
	 * which properties represent custom classes.  Those classes would then
	 * be registerClassAlias'd using getDefinititonByName to get a reference,
	 * and then objectToInstance would be called on those properties to complete
	 * the recursive algorithm.
	 * http://www.darronschall.com/weblog/archives/000247.cfm
	 *
	 * @author Darron Schall
	 *
	 * @param object The plain object that should be converted
	 * @param clazz The type to convert the object to
	 */
	public static function toInstance(object:Object, clazz:Class):* {
		var bytes:ByteArray = new ByteArray();
		bytes.objectEncoding = ObjectEncoding.AMF0;

		// Find the objects and byetArray.writeObject them, adding in the
		// class configuration variable name -- essentially, we're constructing
		// an AMF packet here that contains the class information so that
		// we can simplly byteArray.readObject the sucker for the translation

		// Write out the bytes of the original object
		var objBytes:ByteArray = new ByteArray();
		objBytes.objectEncoding = ObjectEncoding.AMF0;
		objBytes.writeObject(object);

		// Register all of the classes so they can be decoded via AMF
		var typeInfo:XML = describeType(clazz);
		var fullyQualifiedName:String = typeInfo.@name.toString().replace(/::/, ".");
		registerClassAlias(fullyQualifiedName, clazz);

		// Write the new object information starting with the class information
		var len:int = fullyQualifiedName.length;
		bytes.writeByte(0x10); // 0x10 is AMF0 for "typed object (class instance)"
		bytes.writeUTF(fullyQualifiedName);
		// After the class name is set up, write the rest of the object
		bytes.writeBytes(objBytes, 1);

		// Read in the object with the class property added and return that
		bytes.position = 0;

		// This generates some ReferenceErrors of the object being passed in
		// has properties that aren't in the class instance, and generates TypeErrors
		// when property values cannot be converted to correct values (such as false
		// being the value, when it needs to be a Date instead).  However, these
		// errors are not thrown at runtime (and only appear in trace ouput when
		// debugging), so a try/catch block isn't necessary.  I'm not sure if this
		// classifies as a bug or not... but I wanted to explain why if you debug
		// you might seem some TypeError or ReferenceError items appear.
		var result:* = bytes.readObject();
		return result;
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
		
		var clazz 		: Class;
		var className	: String;
		var i 			: int = 0;
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
			
			// clazz = ObjectUtil.getClass( object );
			
			className = getQualifiedClassName( object );
			
			if ( className.indexOf( VECTOR ) == 0 ) {
				className = ARRAY;
			}
			
			switch ( className ) {
				
				case STRING:
					addToRetVal( currentIndent + name + " : " + ObjectUtil.getClassName( object ) + " = \"" + object + "\"" );
				break;
				
				case NUMBER :
				case INT:
				case UINT	:
				case BOOLEAN:
					addToRetVal( currentIndent + name + " : " + ObjectUtil.getClassName( object ) + " = " + object );
				break;
				
				case XML_CLASS_NAME	:
					object.prettyPrinting = true;
				case XML_LIST_CLASS_NAME :
					addToRetVal( currentIndent + name + " : " + ObjectUtil.getClassName( object ) + " = " + object );
				break;
				
				case FUNCTION :
					addToRetVal( currentIndent + name + " : " + ObjectUtil.getClassName( object ) + " = " + object );
				break;
				
				case ARRAY  :
					addToRetVal( currentIndent + name + " : " + ObjectUtil.getClassName( object ) + " = [" );
					for ( i = 0; i < object.length; i++) {
						retVal += ( ObjectUtil.stringify( object[i], String(i), maxDepth - 1, indent, currentIndent + indent ) );
					}
					addToRetVal( currentIndent + "]" );
				break;
				
				case OBJECT :
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
							try {
								if ( object[ String( item.@name ) ] ) {
									retVal += ( ObjectUtil.stringify( object[ String( item.@name ) ], String( item.@name ), maxDepth - 1, indent, currentIndent + indent ) );
								} else {
									addToRetVal( currentIndent + indent + item.@name + " : " + String( item.@type ) + " = " + object[ String( item.@name ) ] );
								}
							} catch ( error : TypeError ) {
								addToRetVal( currentIndent + indent + item.@name + " : " + String( item.@type ) + " = null" );
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