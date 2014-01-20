package ucc.operation.generic  {
	import ucc.data.event.FrameImpulse;
	import ucc.error.IllegalArgumentException;
	import ucc.operation.AbstractOperation;
	import ucc.operation.OperationState;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
/**
 * Sound play operation
 *
 * @version $Id: SoundPlayOperation.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class SoundPlayOperation extends AbstractOperation {
	
	/** Sound */
	protected var sound					: Sound;
	
	/** Start time */
	protected var startTime				: Number;
	
	/** Sound channel */
	protected var soundChannel			: SoundChannel;
	
	/** Sound transform */
	protected var soundTransform 		: SoundTransform;
	
	/** This last position */
	protected var lastPosition 			: int;
	
	/**
	 * Class constructor
	 * Loops are not supported.
	 */
	public function SoundPlayOperation ( sound : Sound, startTime : Number = 0, soundTransform : SoundTransform = null ) {
		
		if ( !sound ) {
			throw new IllegalArgumentException( "Sound instance must be provided!" );
		}
		
		this.sound = sound;
		this.soundTransform = soundTransform;
		this.startTime = startTime;
		
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function start () : void {
		
		this.setProgress( 0 );
		
		this.setState( OperationState.RUNNING );
		
		this.soundChannel = this.sound.play( this.startTime, 0, this.soundTransform );
		this.soundChannel.addEventListener( Event.SOUND_COMPLETE, this.onSoundComplete );
		
		FrameImpulse.getInstance().addEventListener( Event.ENTER_FRAME, this.onEnterFrame );
		
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function pause () : void {
		
		this.setState( OperationState.PAUSED );
		this.soundChannel.removeEventListener( Event.SOUND_COMPLETE, this.onSoundComplete );
		this.lastPosition = this.soundChannel.position;
		this.soundChannel.stop();
		this.soundChannel = null;
		
		FrameImpulse.getInstance().removeEventListener( Event.ENTER_FRAME, this.onEnterFrame );
		
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function resume () : void {
		
		this.setState( OperationState.RUNNING );
		
		this.soundChannel = this.sound.play( this.lastPosition, 0, this.soundTransform );
		this.soundChannel.addEventListener( Event.SOUND_COMPLETE, this.onSoundComplete );
		FrameImpulse.getInstance().addEventListener( Event.ENTER_FRAME, this.onEnterFrame );
		
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function stop () : void {
		
		this.setState( OperationState.STOPPED );
		
		this.soundChannel.stop();
		
		FrameImpulse.getInstance().removeEventListener( Event.ENTER_FRAME, this.onEnterFrame );
		this.soundChannel.removeEventListener( Event.SOUND_COMPLETE, this.onSoundComplete );
		this.soundChannel = null;
		this.sound = null;		
		
	}
	
	/**
	 *	On sound complete
	 */
	protected function onSoundComplete ( event : Event ) : void {
		
		this.setProgress( 1 );
		
		this.setState( OperationState.COMPLETED );
		
		FrameImpulse.getInstance().removeEventListener( Event.ENTER_FRAME, this.onEnterFrame );
		this.soundChannel.removeEventListener( Event.SOUND_COMPLETE, this.onSoundComplete );
		this.soundChannel = null;
		this.sound = null;
		
	}
	
	/**
	 * On enter frame
	 * Calculate progress
	 */
	protected function onEnterFrame ( event : Event ) : void {
		this.setProgress( this.soundChannel.position / this.sound.length );
	}
	
}
	
}