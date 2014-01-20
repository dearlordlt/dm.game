package dm.game.windows.ui.stepper {
	
import dm.builder.interfaces.MyStepper;
import fl.controls.Button;
import flash.display.Sprite;
import flash.events.MouseEvent;
import net.richardlord.ash.signals.Signal1;
import ucc.util.MathUtil;
	
/**
 * Simple stepper
 * 
 * @version $Id: SimpleStepper.as 128 2013-05-22 08:15:58Z rytis.alekna $
 */
public class SimpleStepper extends Sprite {
	
	/** Previous button */
	public var previousButtonDO		: Button;

	/** Next button */
	public var nextButtonDO			: Button;	
	
	/** Value */
	protected var _value			: int;
	
	/** Minimum */
	protected var _minimum			: int = 0;
	
	/** Maximum */
	protected var _maximum			: int = 5;	
	
	/** Change signal */
	protected var _changeSignal		: Signal1 = new Signal1(SimpleStepper);	
	/**
	 * Class constructor
	 */
	public function SimpleStepper () {
		this.init();
	}
	
	/**
	 * Initializes this instance.
	 */
	protected function init () : void {
		this.previousButtonDO.addEventListener( MouseEvent.CLICK, this.onPreviousButtonClick );
		this.nextButtonDO.addEventListener( MouseEvent.CLICK, this.onNextButtonClick );
		
	}
	
	/**
	 *	On previous button click.
	 */
	protected function onPreviousButtonClick ( event : MouseEvent) : void {
		this.value--;
		changeSignal.dispatch(this);
	}
	
	/**
	 *	On next button click.
	 */
	protected function onNextButtonClick ( event : MouseEvent) : void {
		this.value++;
		changeSignal.dispatch(this);
	}
	
	public function get value():int {
		return _value;
	}
	
	public function set value(value:int):void {
		
		this._value = MathUtil.normalize( value, this.minimum, this.maximum );
		
		this.nextButtonDO.enabled = (_value != _maximum);
		this.previousButtonDO.enabled = (_value != _minimum);
		
	}
	
	public function get minimum():int {
		return _minimum;
	}
	
	public function set minimum(value:int):void {
		_minimum = value;
		if (_value < _minimum) {
			this.value = value;
		}
	}
	
	public function get maximum():int {
		return _maximum;
	}
	
	public function set maximum(value:int):void {
		_maximum = value;
		if (_value > _maximum) {
			this.value = value;
		}
	}
	
	public function get changeSignal () : Signal1 {
		return _changeSignal;
	}
	
	
}

}