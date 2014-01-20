package ucc.operation.generic  {
	import ucc.data.event.FrameImpulse;
	import ucc.operation.AbstractOperation;
	import ucc.operation.OperationEvent;
	import ucc.operation.OperationState;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	
/**
 * Time delay operation
 * TODO: implement pause and resume functionality
 * @version $Id: TimeDelayOperation.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class TimeDelayOperation extends AbstractOperation {
	
	/** Detected total time */
	private var delay			: int;
	
	/** Time in miliseconds when timeout has to be complete */	
	protected var endTime 		: int;
	
	/** Strart time */
	protected var startTime		: int;
	
	/** Time left */
	protected var timeLeft		: int;
	
	/** Time elapsed */
	protected var timeElapsed	: int;
	
	/**
	 * Class constructor
	 * @param	delay	delay in miliseconds
	 */
	public function TimeDelayOperation ( delay : int ) {
		this.delay = delay;
	}
	
	/**
	 * Start operation
	 */
	override public function start() : void  {
		
		FrameImpulse.getInstance().addEventListener( Event.ENTER_FRAME, this.onEnterFrame );
		this.setState( OperationState.RUNNING )
		this.startTime = getTimer();
		this.endTime = this.startTime + this.delay;
		
	}
	
	/**
	 * Stop time delay operation
	 */
	override public function stop() : void  {
		FrameImpulse.getInstance().removeEventListener( Event.ENTER_FRAME, this.onEnterFrame );
		this.setState( OperationState.STOPPED );
	}
	
	
	/**
	 *	@inheritDoc
	 */
	public override function pause (  ) : void {
		
		this.timeLeft = this.endTime - getTimer();
		this.timeElapsed = getTimer() - this.startTime;
		FrameImpulse.getInstance().removeEventListener( Event.ENTER_FRAME, this.onEnterFrame );
		this.setState( OperationState.PAUSED );
		
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function resume (  ) : void {
		
		this.endTime = getTimer() + this.timeLeft;
		this.startTime = getTimer() - this.timeElapsed;
		FrameImpulse.getInstance().addEventListener( Event.ENTER_FRAME, this.onEnterFrame );
		this.setState( OperationState.RUNNING );
		
	}
	
	/**
	 * On enter frame event handler
	 * @param	event
	 */
	protected function onEnterFrame ( event : Event ) : void {
		
		var currentTimer : int = getTimer();
		this.setProgress( ( currentTimer - this.startTime ) / this.delay );
		if ( this.endTime <= currentTimer ) {
			FrameImpulse.getInstance().removeEventListener( Event.ENTER_FRAME, this.onEnterFrame );
			this.setState( OperationState.COMPLETED );
		}
	}
	
}
	
}