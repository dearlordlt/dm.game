package dm.game.windows.actions {
	import dm.game.functions.FunctionExecutor;
	import dm.game.systems.InteractionSystem;
	import dm.game.windows.DmWindow;
	import dm.game.windows.Tooltip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import org.as3commons.lang.ClassUtils;
	import ucc.util.ObjectUtil;
	
[Single]
/**
 * Interactions window
 * @version $Id: ActionsWindow.as 215 2013-09-29 14:28:49Z rytis.alekna $
 */
public class ActionsWindow extends DmWindow {
	
	/** Icons container */
	protected var iconsContainerDO			: Sprite = new Sprite();
	
	/** interactions */
	protected var interactions : Array;
	
	/**
	 * (Constructor)
	 * - Returns a new ActionsWindow instance
	 */
	public function ActionsWindow() {
		super( null, _("Actions") );
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function initialize () : void {
		
		this.addChild( this.iconsContainerDO );
		this.iconsContainerDO.x = 15;
		this.iconsContainerDO.y = 35;
		
		InteractionSystem.instance.availableInteractionsChangeSignal.add( this.onAvailableInteractionsChange );
		
	}
	
	/**
	 *	On available interactions change
	 */
	protected function onAvailableInteractionsChange ( interactions : Array ) : void {
		
		this.interactions = interactions;
		
		this.iconsContainerDO.removeChildren();
		
		var icon : DisplayObject;
		
		var item : Object;
		
		for ( var i : int = 0; i < interactions.length; i++ ) {
			
			item = interactions[i];
			
			if ( item["interaction"] ) {
				icon = ClassUtils.newInstance( ClassUtils.forName( "dm.game.windows.actions.InteractionIcon" ) );
			} else {
				icon = ClassUtils.newInstance( ClassUtils.forName( "dm.game.windows.actions.AvatarIcon" ) );
			}
			
			this.iconsContainerDO.addChild( icon );
			icon.x = i * 20;
			icon.name = String(i);
			icon.addEventListener( MouseEvent.CLICK, this.onIconClick );
			Tooltip.setTooltip( icon, item["label"] );
			
		}
		
		this.redraw();
		
	}
	
	/**
	 *	On icon click
	 */
	protected function onIconClick ( event : MouseEvent ) : void {
		var item : Object = this.interactions[ parseInt( ( event.target as DisplayObject ).name ) ];
		
		if ( item["interaction"] ) {
			var functionExecutor : FunctionExecutor = new FunctionExecutor();
			functionExecutor.executeFunctions( item["interaction"].functions );
		}
		
		
	}
	
	
	/**
	 *	@inheritDoc
	 */
	public override function getInitialPosition () : Point {
		return new Point( ( this.stage.stageWidth - width ) / 2, this.stage.stageHeight - 100);
	}
	
	
	/**
	 *	@inheritDoc
	 */
	public override function isCloseable () : Boolean {
		return false;
	}
	
}

}