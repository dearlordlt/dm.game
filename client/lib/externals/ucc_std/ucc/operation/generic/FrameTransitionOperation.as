package ucc.operation.generic  {
	import ucc.data.event.FrameImpulse;
	import ucc.error.IllegalArgumentException;
	import ucc.operation.AbstractOperation;
	import ucc.operation.OperationState;
	import ucc.util.DisplayObjectUtil;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
/**
 * Frame transition operation
 *
 * @version $Id: FrameTransitionOperation.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class FrameTransitionOperation extends AbstractOperation {
	
	/** Forward direction */
	public static const BOTH	 			: int = 0;
	
	/** Forward direction */
	public static const FORWARD	 			: int = 1;
	
	/** Backward direction */
	public static const BACKWARD 			: int = 2;
	
	/** Targets registry */
	private static const targetsRegistry	: Dictionary = new Dictionary();
	
	/** Target movie */
	private var targetDO 					: MovieClip;
	
	/** Make transition go round if start and end are same? */
	// TODO: implement and test
	protected var round 					: Boolean;
	
	/** Inital target (MovieClip or Function closure) */
	private var initialTarget	: * ;
	
	/** From frame */
	private var fromFrame 		: String;
	
	/** To frame */
	private var toFrame 		: String;
	
	/** Jump frame (when frame transition is only forward or backward) */
	private var jumpFrame		: String;
	
	/** Allowed direction */
	private var allowedDirection: int;
	
	/** From frame number */
	private var fromFrameNumber	: Number;
	
	/** To frame number */
	private var toFrameNumber	: Number;
	
	/** Jump frame number */
	private var jumpFrameNumber	: Number;
	
	/** Transition length in frames */
	private var transitionLength: Number;
	
	/** Current transition position */
	private var currentPosition	: int = 0;
	
	/**
	 * Class constructor
	 * @param	targetDO	Movie clip on method closure that returns MovieClip
	 * @param	fromFrame
	 * @param	toFrame
	 * @param	allowedDirection
	 * @param	name
	 */
	public function FrameTransitionOperation ( targetDO : * , fromFrame : * = ":current", toFrame : * = ":total", allowedDirection : int = 0, round : Boolean = false ) {
		
		this.init( targetDO, fromFrame, toFrame, allowedDirection, round );
		
	}
	
	/**
	 * Initialize instance. Alternative to constructor
	 * @param	targetDO	Movie clip on method closure that returns MovieClip
	 * @param	fromFrame
	 * @param	toFrame
	 * @param	allowedDirection
	 * @param	round		if start and end frames are same, should animation turn around?
	 */
	public function init ( targetDO : * , fromFrame : * = ":current", toFrame : * = ":total", allowedDirection : int = 0, round : Boolean = false ) : void {
		
		if ( ( targetDO == null ) ) {
			throw new IllegalArgumentException( "targetDO must be specified!" )
		} else if ( !( targetDO is MovieClip ) && !( targetDO is Function ) ) {
			throw new IllegalArgumentException( "targetDO must be MovieClip or Function!" )
		}
		
		this.initialTarget 		= targetDO;
		this.fromFrame			= fromFrame;
		this.toFrame 			= toFrame;
		this.allowedDirection 	= allowedDirection;
		this.round 				= round;
		
		if ( this.allowedDirection == FORWARD ) {
			this.jumpFrame = ":total";
		} else if ( this.allowedDirection == BACKWARD ) {
			this.jumpFrame = ":1";
		}
	}
	
	/**
	 * Start task
	 */
	override public function start() : void {
		
		this.setState( OperationState.RUNNING );
		
		this.setProgress( 0 );
		
		if ( this.initialTarget is MovieClip ) {
			this.targetDO = this.initialTarget;
		} else {
			
			this.targetDO = this.initialTarget();
			if ( !this.targetDO ) {
				throw new IllegalArgumentException( "Specified method closure for targetDO doesn\'t return a valid target MovieClip" );
			}
			
		}
		
		if ( targetsRegistry[this.targetDO] ) {
			trace( "[ucc.operation.generic.FrameTransitionOperation.start] : attempting to override " + FrameTransitionOperation( targetsRegistry[this.targetDO] ).toString() );
			FrameTransitionOperation( targetsRegistry[this.targetDO] ).stop();
			targetsRegistry[this.targetDO] = this;
		}
		
		this.fromFrameNumber	= DisplayObjectUtil.getFrameNumber( this.targetDO, this.fromFrame );
		this.toFrameNumber		= DisplayObjectUtil.getFrameNumber( this.targetDO, this.toFrame );
		
		if ( this.jumpFrame ) {
			if ( ( ( this.allowedDirection == FORWARD ) && ( this.fromFrameNumber > this.toFrameNumber ) ) ||
				 ( ( this.allowedDirection == BACKWARD ) && ( this.fromFrameNumber < this.toFrameNumber ) ) ) {
				
				this.jumpFrameNumber = DisplayObjectUtil.getFrameNumber( this.targetDO, this.jumpFrame );
				
				// calculate transition length with jump frame
				if ( this.allowedDirection == FORWARD ) {
					this.transitionLength = this.jumpFrameNumber - this.fromFrameNumber + this.toFrameNumber;
				} else {
					this.transitionLength = this.fromFrameNumber + ( this.targetDO.totalFrames - this.toFrameNumber );
				}
				
			}
		}
		
		if ( !this.transitionLength ) {
			this.transitionLength = Math.abs( this.fromFrameNumber - this.toFrameNumber );
		}
		
		FrameImpulse.getInstance().addEventListener( Event.ENTER_FRAME, this.onRunningEnterFrame );
		
		// Go forward - play
		if ( this.fromFrameNumber < this.toFrameNumber ) {
			this.targetDO.gotoAndPlay( fromFrameNumber );
		// Go backward - stop	
		} else {
			this.targetDO.gotoAndStop( fromFrameNumber );
		}
		
	}
	
	/**
	 * Stop
	 */
	override public function stop() : void {
		
		// Stop all stuff
		this.targetDO.stop();
		FrameImpulse.getInstance().removeEventListener( Event.ENTER_FRAME, this.onRunningEnterFrame );
		
		delete targetsRegistry[this.targetDO];
		
		// Set state
		this.setState( OperationState.STOPPED );
	}
	
	
	/**
	 *	@inheritDoc
	 */
	public override function pause () : void {
		
		// Stop all stuff
		this.targetDO.stop();
		FrameImpulse.getInstance().removeEventListener( Event.ENTER_FRAME, this.onRunningEnterFrame );
		
		delete targetsRegistry[this.targetDO];
		
		this.setState( OperationState.PAUSED );
		
	}
	
	
	/**
	 *	@inheritDoc
	 */
	public override function resume () : void {
		
		FrameImpulse.getInstance().addEventListener( Event.ENTER_FRAME, this.onRunningEnterFrame );
		// start immediately
		// this.onRunningEnterFrame(null);
		
		targetsRegistry[this.targetDO] = this;
		
		this.setState( OperationState.RUNNING );
		
	}
	
	/**
	 * On running enter frame
	 * 
	 * @param	event
	 */
	private function onRunningEnterFrame( event : Event ) : void {
		
		//	this.currentPosition++;
		
		// Complete
		if( ( this.targetDO.currentFrame == this.toFrameNumber ) && !this.round ) {
			
			FrameImpulse.getInstance().removeEventListener( Event.ENTER_FRAME, this.onRunningEnterFrame );
			this.targetDO.stop();
			
			this.setProgress( 1 );
			
			this.setState( OperationState.COMPLETED );
			
			delete targetsRegistry[this.targetDO];
			
		} else {
			
			this.round = false;
			
			if ( this.allowedDirection == BOTH || !this.jumpFrameNumber ) {
				// If going back
				if ( this.targetDO.currentFrame > this.toFrameNumber ) {
					this.currentPosition++;
					this.targetDO.prevFrame();
				} else if ( this.targetDO.currentFrame < this.toFrameNumber ) {
					this.currentPosition++;
				}
			} else if ( this.allowedDirection == BACKWARD ) {
				if ( this.targetDO.currentFrame == this.jumpFrameNumber ) {
					this.currentPosition++;
					this.targetDO.gotoAndStop( this.targetDO.totalFrames );
				} else {
					this.currentPosition++;
					this.targetDO.prevFrame();
				}
			} else if ( this.allowedDirection == FORWARD ) {
				if ( this.targetDO.currentFrame == this.jumpFrameNumber ) {
					this.currentPosition++;
					this.targetDO.gotoAndPlay( 1 );
				}				
			} 
			
			this.setProgress( this.currentPosition / this.transitionLength );
			
		}
		
	}
	
	/**
	 * Dispose
	 */
	public function dispose () : void {
		this.targetDO = null;
		this.jumpFrame = null;
		this.jumpFrameNumber = NaN;
		this.fromFrame = null;
		this.fromFrameNumber = NaN;
		this.toFrame = null;
		this.toFrameNumber = NaN;
		this.allowedDirection = 0;
		this.transitionLength = NaN;
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function toString () : String {
		return super.toString() + " from: " + this.fromFrame + ", to: " + this.toFrame + ( targetDO ? (", targetDO: " + this.targetDO + ", targetName: " + this.targetDO.name ) : "" );
	}
	
}
	
}