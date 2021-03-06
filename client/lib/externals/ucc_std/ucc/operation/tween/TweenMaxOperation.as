package ucc.operation.tween  {
	import ucc.operation.AbstractOperation;
	import ucc.operation.OperationState;
	import com.greensock.events.TweenEvent;
	import com.greensock.TweenMax;
	
/**
 * Tween max wrapper
 *
 * @version $Id: TweenMaxOperation.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class TweenMaxOperation extends AbstractOperation {
	
	/** Arguments for tween max */
	protected var target			: Object;
	protected var duration			:Number;
	protected var vars				:Object;
	
	/** Internal tween max instance */
	protected var tweenMax			: TweenMax;
	
	/**
	 * Class constructor
	 */
	public function TweenMaxOperation ( target : Object, duration : Number, vars : Object ) {
		this.vars = vars;
		this.target = target;
		this.duration = duration;
		
	}
	
	override public function start() : void  {
		
		this.setProgress( 0 );
		this.setState( OperationState.RUNNING );
		this.tweenMax = new TweenMax( this.target, this.duration, this.vars );
		this.tweenMax.addEventListener( TweenEvent.COMPLETE, this.onTweenMaxComplete );
		
	}
	
	/**
	 * @inheritDoc
	 */
	override public function stop() : void  {
		this.tweenMax.pause();
		this.setState( OperationState.STOPPED );
	}
	
	/**
	 * @inheritDoc
	 */
	override public function pause() : void  {
		this.tweenMax.pause();
		this.setState( OperationState.PAUSED );
	}
	
	/**
	 * @inheritDoc
	 */
	override public function resume() : void  {
		
		if ( this.tweenMax.paused && this.getState() == OperationState.PAUSED ) {
			this.tweenMax.resume();
		}
		this.setState( OperationState.RUNNING );
		
	}
	
	/**
	 * On tween max complete
	 */
	protected function onTweenMaxComplete ( event : TweenEvent ) : void {
		this.tweenMax.removeEventListener( TweenEvent.COMPLETE, this.onTweenMaxComplete );
		this.setProgress( 1 );
		this.setState( OperationState.COMPLETED );
	}
	
}
	
}