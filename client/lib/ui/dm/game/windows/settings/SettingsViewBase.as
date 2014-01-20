package dm.game.windows.settings {
	
	import fl.controls.Slider;
	import fl.controls.Button;
	import fl.controls.Label;
	import flash.display.Sprite;
	
/**
 * Settings vie base
 * 
 * @version $Id: SettingsViewBase.as 69 2013-03-15 12:30:24Z rytis.alekna $
 */
public class SettingsViewBase extends Sprite {
	
	/** Antialiasing slider */
	public var antialiasingSlider		: Slider;

	/** Save settings button */
	public var saveSettingsButtonDO		: Button;

	/** Anti aliasing label */
	public var antiAliasingLabelDO		: Label;

	/** Max framerate slider */
	public var maxFramerateSlider		: Slider;

	/** Fps label */
	public var fpsLabelDO				: Label;

	/** Cancel changes button */
	public var cancelChangesButtonDO	: Button;

	/** Close button */
	public var closeButtonDO			: Button;	
	
}

}