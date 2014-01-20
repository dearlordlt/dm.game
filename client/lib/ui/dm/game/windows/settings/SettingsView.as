package dm.game.windows.settings 
{
import dm.game.Main;
import dm.game.persistance.SettingsManager;
import dm.game.windows.DmWindow;
import fl.events.SliderEvent;
import flash.display.DisplayObjectContainer;
import flash.events.MouseEvent;

/**
 * Settings view
 * @author Rytis
 */
public class SettingsView extends DmWindow {
	
	/** Antialiasing */
	public static const ANTIALIASING		: String = "antialiasing";
	
	/** Framerate */
	public static const FRAMERATE			: String = "framerate";
	
	/** Settings view base */
	protected var view						: SettingsViewBase;
	
	/**
	 * Class constructor
	 */
	public function SettingsView ( parentDO : DisplayObjectContainer ) {
		super( parentDO, _("Video settings"), 400, 150 );
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function initialize (  ) : void {
		this.loadSettings();
		
		// set up listeners
		this.view.saveSettingsButtonDO.addEventListener( MouseEvent.CLICK, this.saveSettings );
		this.view.antialiasingSlider.addEventListener( SliderEvent.CHANGE, this.onAntialiasingChange );
		this.view.maxFramerateSlider.addEventListener( SliderEvent.CHANGE, this.onFramerateChange );
		this.view.cancelChangesButtonDO.addEventListener( MouseEvent.CLICK, this.cancelChanges );
		this.view.closeButtonDO.addEventListener( MouseEvent.CLICK, this.onCloseButtonClick );		
		
	}
	
	/**
	 * Draw UI
	 */
	override public function draw () : void {
		
		// add to stage
		this.view = new SettingsViewBase();
		this.addChild( view );
		
		// move it away a little bit
		this.view.x = 40;
		this.view.y = 36;
		
		super.draw();
		
	}
	
	/**
	 * Load persisted settings if present
	 */
	protected function loadSettings () : void {
		
		// TODO: default values should be taken from somewhere else
		this.view.antialiasingSlider.value = SettingsManager.getInstance().getStore().getKeyValue( ANTIALIASING, 2 );
		this.view.maxFramerateSlider.value = SettingsManager.getInstance().getStore().getKeyValue( FRAMERATE, 60 );
		this.onAntialiasingChange( null );
		this.onFramerateChange( null );		
	}
	
	/**
	 * On antialising change
	 */
	protected function onAntialiasingChange ( event : SliderEvent ) : void {
		Main.getInstance().getWorld3D().scene.antialias = this.view.antialiasingSlider.value;
		this.view.antiAliasingLabelDO.text = __( "#{Antialiasing}: " + this.view.antialiasingSlider.value + "x" );
	}
	
	/**
	 *	On framerate change
	 */
	protected function onFramerateChange ( event : SliderEvent) : void {
		Main.getInstance().getWorld3D().scene.frameRate = this.view.maxFramerateSlider.value;
		this.view.fpsLabelDO.text = __( "#{Frames per second}: " + this.view.maxFramerateSlider.value + "#{fps}" );
	}
	
	/**
	 *	Save settings
	 */
	protected function saveSettings ( event : MouseEvent ) : void {
		
		// save antialiasing settings
		SettingsManager.getInstance().getStore().setKeyValue( ANTIALIASING, this.view.antialiasingSlider.value );
		
		// save framerate settings
		SettingsManager.getInstance().getStore().setKeyValue( FRAMERATE, this.view.maxFramerateSlider.value );
		
		this.destroy();
		
	}
	
	/**
	 *	Cancel changes
	 */
	protected function cancelChanges ( event : MouseEvent) : void {
		this.loadSettings();
	}
	
	/**
	 *	On close button click
	 */
	protected function onCloseButtonClick ( event : MouseEvent) : void {
		this.cancelChanges( null );
		this.destroy();
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function destroy (  ) : void {
		
		// remove all listeners
		this.view.saveSettingsButtonDO.removeEventListener( MouseEvent.CLICK, this.saveSettings );
		this.view.antialiasingSlider.removeEventListener( SliderEvent.CHANGE, this.onAntialiasingChange );
		this.view.maxFramerateSlider.removeEventListener( SliderEvent.CHANGE, this.onFramerateChange );
		this.view.cancelChangesButtonDO.removeEventListener( MouseEvent.CLICK, this.cancelChanges );
		this.view.closeButtonDO.removeEventListener( MouseEvent.CLICK, this.onCloseButtonClick );		
		
		super.destroy();
	}
	
}

}