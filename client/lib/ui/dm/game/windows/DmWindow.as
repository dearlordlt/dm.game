package dm.game.windows {
import dm.game.windows.ui.CloseButton;
import dm.game.windows.ui.IWindowFrame;
import dm.game.windows.ui.WindowFrame;
import fl.core.UIComponent;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.GradientType;
import flash.display.InteractiveObject;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.text.Font;
import flash.text.TextField;
import flash.text.TextFormat;
import net.richardlord.ash.signals.Signal1;
import org.as3commons.lang.ClassUtils;
import ucc.ui.window.NativeWindowBase;
import ucc.ui.window.WindowsManager;
import ucc.util.ClassUtil;
import ucc.util.DisplayObjectUtil;
import ucc.util.ObjectUtil;

/**
 * Dm window
 * @copy ucc.ui.window.NativeWindow
 * @copy ucc.ui.window.NativeWindowBase
 * @version $Id: DmWindow.as 164 2013-06-14 12:15:45Z rytis.alekna $
 */
public class DmWindow extends NativeWindowBase {
	
	/** Window margins */
	private static const MARGIN	: Number = 12;
	
	/** Window frame */
	protected var windowFrameDO		: DisplayObjectContainer;
	
	/** Close button */
	protected var closeButtonDO 	: DisplayObject;
	
	/** Active zone */
	protected var dragZoneDO		: SimpleButton;
	
	/** Destroy signal */
	protected var _destroySignal : Signal1 = new Signal1( DmWindow );
	
	/** minHeight */
	protected var minHeight : Number;
	
	/** minWidth */
	protected var minWidth : Number;
	
	/** label */
	protected var label : String;
	
	/**
	 * Constructor. ATTENTION: There and in other subclasses always assign constructor parameters to class members BEFORE calling constructor!
	 * @param	parent
	 * @param	label
	 * @param	w
	 * @param	h
	 */
	public function DmWindow( parent : DisplayObjectContainer = null, label : String = "", minWidth : Number = NaN, minHeight : Number = NaN ) {
		this.label = label;
		this.minWidth = minWidth;
		this.minHeight = minHeight;
		super( parent );
	}
	
	/**
	 * Draw GUI. This should be called only once. For redrawing call #redraw()
	 */
	override public function draw () : void {
		
		var bounds : Rectangle = this.getRect( this );		
		
		this.windowFrameDO = ClassUtils.newInstance( ClassUtils.forName( "dm.game.windows.ui.WindowFrame" ) ) as DisplayObjectContainer;
		
		this.addChildAt( this.windowFrameDO, 0 );
		
		if ( !this.isCloseable() ) {
			this.windowFrameDO.removeChild( this.windowFrameDO.getChildByName( "closeButtonDO" ) );
		} else {
			this.closeButtonDO = this.windowFrameDO.getChildByName( "closeButtonDO" );
			this.closeButtonDO.addEventListener( MouseEvent.CLICK, this.onCloseButtonClick );		
		}
		
		this.dragZoneDO = this.windowFrameDO.getChildByName( "dragZoneDO" ) as SimpleButton;
		
		if ( this.isDraggable() ) {
			this.dragZoneDO.addEventListener( MouseEvent.MOUSE_DOWN, this.onDragZoneMouseDown );
		} else {
			this.dragZoneDO.enabled = false;
		}
		
		this.redraw();
		this.setTitle( label );
		
	}
	
	/**
	 * Redraw
	 */
	public function redraw () : void {
		
		// temporary remove window frame to calculate actual occupied space
		this.removeChild( this.windowFrameDO );
		
		// a hook for calculating corrent bounds because UIComponents aren't rendered itself at this point
		
		var uiComponents : Array = DisplayObjectUtil.getDescendantsByType( this, UIComponent );
		for each( var item : UIComponent in uiComponents ) {
			try {
				item.validateNow();
			} catch ( error : Error ) {
				// disable this trace - it's useless for now
				// trace( "[dm.game.windows.DmWindow.redraw] error : " + error );
			}
			
		}
		
		
		var bounds : Rectangle = this.getRect( this );		
		
		if ( isNaN( this.minWidth ) && isNaN( this.minHeight ) ) {
			( this.windowFrameDO as IWindowFrame ).draw( bounds.right + MARGIN, bounds.bottom + MARGIN);
		} else {
			( this.windowFrameDO as IWindowFrame ).draw( Math.max( this.minWidth, bounds.right + MARGIN ), Math.max( this.minHeight, bounds.bottom + MARGIN ) );
		}
		
		
		// add back again
		this.addChildAt( this.windowFrameDO, 0 );
		
	}
	
	/**
	 * Set window title
	 */
	public function setTitle ( title : String ) : void {
		( this.windowFrameDO as IWindowFrame ).setTitle( title );
	}
	
	/**
	 * Get title
	 */
	public function getTitle () : String {
		return ( this.windowFrameDO as IWindowFrame ).getTitle();
	}
	
	/**
	 * On close button click
	 */
	private function onCloseButtonClick( e : MouseEvent ) : void {
		this.destroy();
	}
	
	/**
	 * On label mouse down
	 */
	private function onDragZoneMouseDown( e : MouseEvent ) : void {
		this.startDrag();
		e.currentTarget.addEventListener( MouseEvent.MOUSE_UP, this.onDragZoneMouseUp );
	}
	
	/**
	 * On label mouse up
	 */
	private function onDragZoneMouseUp( e : MouseEvent ) : void {
		this.stopDrag();
		e.currentTarget.removeEventListener( MouseEvent.MOUSE_UP, this.onDragZoneMouseUp );
	}
	
	
	/**
	 *	@inheritDoc
	 */
	final public override function showProgress ( message : String ,  title : String  = "Progress" ) : Function {
		return super.showProgress(message, title);
	}
	
	/**
	 * Destroy
	 */
	override public function destroy() : void {
		
		if ( this.isCloseable() ) {
			this.closeButtonDO.removeEventListener( MouseEvent.CLICK, this.onCloseButtonClick );
		}
		
		if ( this.isDraggable() ) {
			this.dragZoneDO.removeEventListener( MouseEvent.MOUSE_DOWN, this.onDragZoneMouseDown );
		}		
		
		this.destroySignal.dispatch( this );
		super.destroy();
	}
	
	/**
	 * Get destroy signal
	 */
	public function get destroySignal () : Signal1 {
		return this._destroySignal;
	}

}

}