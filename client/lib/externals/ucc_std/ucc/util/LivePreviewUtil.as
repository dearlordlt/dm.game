package ucc.util {
import flash.display.DisplayObject;
import flash.display.Stage;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.external.ExternalInterface;
import flash.utils.getDefinitionByName;

/**
 * Live preview util. Refactored from fl.livepreview.LivePreview simplifies component creation
 *
 * @version $Id: LivePreviewUtil.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class LivePreviewUtil {
	
	/** Single display object instance. there can't be more */
	private static var myInstance : DisplayObject;
	
	/** Stage reference */
	private static var stage : Stage;
	
	/** Size setting function */
	protected static var sizeSettingFunction : Function;
	
	/**
	 * Initialize live preview support
	 * @param	instance
	 * @param	stage
	 */
	public static function init( instance : DisplayObject, stage : Stage, sizeSettingFunction : Function = null ) : void {
		LivePreviewUtil.sizeSettingFunction = sizeSettingFunction;
		
		if ( !instance || !stage ) {
			throw new Error( "Instance and stage must be not null!" );
		}
		
		LivePreviewUtil.myInstance = instance;
		LivePreviewUtil.stage = stage;
		
		// register external interfaces
		if ( ExternalInterface.available ) {
			
			// check if not in browser
			try {
				ExternalInterface.call( "function () { return fl.trace }" );
			} catch ( error : Error ) {
				trace( "[ucc.util.LivePreviewUtil.init] : not live preview!" );
				return;
			}
			
			// init Stage
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			// resize our one and only child
			onResize( stage.width, stage.height );
			
			ExternalInterface.addCallback( "onResize", onResize );
			ExternalInterface.addCallback( "onUpdate", onUpdate );
		}
	
		// LivePreviewUtil.instance ? LivePreviewUtil.instance : ( LivePreviewUtil.instance = new LivePreviewUtil() );
	}
	
	/**
	 * Resizes the component instance on the Stage to the specified
	 * dimensions, either by calling a user-defined method, or by
	 * separately setting the <code>width</code> and <code>height</code>
	 * properties.
	 *
	 * <p>This method is called by Flash Player.</p>
	 *
	 * @param width The new width for the <code>myInstance</code> instance.
	 * @param height The new height for the <code>myInstance</code> instance.
	 */
	private static function onResize( width : Number, height : Number ) : void {
		var setSizeFn : Function = null;
		
		if ( sizeSettingFunction != null ) {
			setSizeFn = sizeSettingFunction;
		} else {
			try {
				setSizeFn = myInstance[ "setSize" ];
			} catch ( error : Error ) {
				setSizeFn = null;
			}
		}
		
		if ( setSizeFn != null ) {
			setSizeFn( width, height );
		} else {
			myInstance.width = width;
			myInstance.height = height;
		}
	}
	
	/**
	 * Updates the properties of the component instance.
	 * This method is called by Flash Player when there
	 * is a change in the value of a property. This method
	 * updates all component properties, whether or not
	 * they were changed.
	 *
	 * @param updateArray An array of parameter names and values.
	 */
	private static function onUpdate( ... updateArray : Array ) : void {
		for ( var i : int = 0; i + 1 < updateArray.length; i += 2 ) {
			try {
				var name : String = String( updateArray[ i ] );
				var value : * = updateArray[ i + 1 ];
				if ( typeof value == "object" && value.__treatAsCollectionSpecialSauce__ ) {
					updateCollection( value, name );
				} else {
					myInstance[ name ] = value;
				}
			} catch ( error : Error ) {
				
			}
		}
	}
	
	/**
	 * @private
	 */
	private static function updateCollection( collDesc : Object, index : String ) : void {
		// load classes, create object
		var CollectionClass : Class = Class( getDefinitionByName( collDesc.collectionClass ) );
		var CollectionItemClass : Class = Class( getDefinitionByName( collDesc.collectionItemClass ) );
		var collObj : Object = new CollectionClass();
		
		// iterate through array, populating collObj
		for ( var i : int = 0; i < collDesc.collectionArray.length; i++ ) {
			var itemObj : Object = new CollectionItemClass();
			var collProp : Object = collDesc.collectionArray[ i ];
			for ( var j : *in collProp ) {
				itemObj[ j ] = collProp[ j ];
			}
			collObj.addItem( itemObj );
		}
		
		// set the property
		myInstance[ index ] = ( collObj as CollectionClass );
	}
}

}