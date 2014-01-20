package ucc.ui.style  {
	import fl.core.UIComponent;
	import fl.managers.StyleManager;
	import flash.utils.Dictionary;
	import org.as3commons.lang.ClassNotFoundError;
	import org.as3commons.lang.ClassUtils;
	import ucc.util.DoubleKeyDictionary;
	
/**
 * Dynamic style manager
 *
 * @version $Id: DynamicStyleManager.as 29 2013-05-07 12:36:02Z rytis.alekna $
 */
public class DynamicStyleManager {
	
	/** Classes to styles */
	private static var classesToStyles : DoubleKeyDictionary = new DoubleKeyDictionary( null, false, true );
	
	/** Class names to styles */
	private static var classNamesToStyles	: DoubleKeyDictionary = new DoubleKeyDictionary( null, false, true );
	
	/**
	 * Set component style
	 * @param	fully qualified class name
	 * @param	style
	 * @param	value
	 */
	public static function setComponentStyle ( className : String, style : String, value : * ) : void {
		
		var clazz : Class;
		
		try {
			
			clazz = ClassUtils.forName( className );
			if ( ClassUtils.isAssignableFrom( UIComponent, clazz ) ) {
				StyleManager.setComponentStyle( clazz, style, value );
			} else {
				classesToStyles.setValue( clazz, style, value );
			}
			
		} catch ( error : ClassNotFoundError ) {
			
			classNamesToStyles.setValue( className, style, value );
			
		}
		
	}
	
	/**
	 * Get style for class
	 * @param	clazz
	 * @param	style
	 * @return	style value
	 */
	public static function getStyleForClass ( clazz : Class, style : String ) : * {
		if ( classesToStyles.getValue( clazz, style ) ) {
			return classesToStyles.getValue( clazz, style );
		} else {
			var className : String = ClassUtils.getName( clazz );
			return classNamesToStyles.getValue( className, style );
		}
	}
	
	/**
	 * Get style for instance
	 * @param	instance
	 * @param	style
	 * @return
	 */
	public static function getStyleForInstance ( instance : Object, style : String ) : * {
		return getStyleForClass( ClassUtils.forInstance( instance ), style );
	}
	
}
	
}