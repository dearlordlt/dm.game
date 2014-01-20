package ucc.operation  {
	import ucc.error.IllegalArgumentException;
	import ucc.error.IllegalStateException;
	import ucc.error.UnsupportedOperationException;
	import ucc.operation.Operation;
	import ucc.operation.OperationState;
	import ucc.operation.util.OperationMonitor;
	import ucc.util.DoubleKeyDictionary;
	import ucc.util.MathUtil;
	import ucc.util.ObjectUtil;
	import ucc.util.StringUtil;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
/**
 * Abstract operation
 *
 * @version $Id: AbstractOperation.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class AbstractOperation extends EventDispatcher implements Operation {
	
	/** Cached progress event */
	private static const PROGRESS_EVENT	: OperationEvent = new OperationEvent( OperationEvent.PROGRESS );
	
	/** Opearation state transition table */
	private static const OPERATION_STATE_TRANSITION_TABLE	: DoubleKeyDictionary = new DoubleKeyDictionary( 
		[
			[ OperationState.RUNNING, OperationState.IDLE, OperationEvent.START ],
			[ OperationState.RUNNING, OperationState.PAUSED, OperationEvent.RESUME ],
			[ OperationState.RUNNING, [ OperationState.COMPLETED, OperationState.FAILED, OperationState.STOPPED ], OperationEvent.START ],
			[ OperationState.FAILED, OperationState.RUNNING, OperationEvent.FAIL ],
			[ OperationState.COMPLETED, OperationState.RUNNING, OperationEvent.COMPLETE ],
			[ OperationState.PAUSED, OperationState.RUNNING, OperationEvent.PAUSE ],
			[ OperationState.PAUSING, OperationState.RUNNING, OperationEvent.PAUSING ],
			[ OperationState.STOPPED, OperationState.PAUSING, OperationEvent.STOP ],
			[ OperationState.STOPPED, OperationState.RUNNING, OperationEvent.STOP ],
			
			// for LiveOperation group
			[ OperationState.IDLE, [ OperationState.STOPPED, OperationState.COMPLETED, OperationState.FAILED, OperationState.RUNNING ], OperationEvent.IDLE ]
			
		], 
	true );
	
	/** Current progress */
	protected var progress			: Number = 0;
	
	/** Operation state */
	protected var state				: OperationState = OperationState.IDLE;
	
	/** Dispatch progress */
	protected var dispatchProgress	: Boolean = true;
	
	// TODO: remove
	protected var uuid				: String = StringUtil.random( 5 );
	
	/** Name of operation */
	protected var name 				: String = "";
	
	/** Progress event */
	protected var progressEvent		: OperationEvent = new OperationEvent( OperationEvent.PROGRESS );
	
	/**
	 * Class constructor
	 */
	public function AbstractOperation () {
	}
	
	/** 
	 *	@inheritDoc 
	 */
	public function start():void {
		throw new UnsupportedOperationException( "Not implemented" );
	}
	
	/** 
	 *	@inheritDoc 
	 */
	public function stop():void {
		throw new UnsupportedOperationException( "Not implemented" );
	}
	
	/** 
	 *	@inheritDoc 
	 */
	public function pause():void {
		throw new UnsupportedOperationException( "Not implemented" );
	}
	
	/** 
	 *	@inheritDoc 
	 */
	public function resume():void {
		throw new UnsupportedOperationException( "Not implemented" );
	}
	
	/** 
	 *	@inheritDoc 
	 */
	public function getProgress () : Number {
		return this.progress;
	}
	
	/** 
	 *	@inheritDoc 
	 */
	public function getState():OperationState {
		return this.state;
	}
	
	/**
	 * Set progress (0-1)
	 */
	protected function setProgress ( progress : Number ) : void {
		this.progress = MathUtil.normalize( progress, 0, 1 );
		if ( this.dispatchProgress ) {
			this.dispatchEvent( new OperationEvent( OperationEvent.PROGRESS ) );
		}
	}
	
	/**
	 * Set operation state
	 * @param	state	new operation state
	 * @throws	IllegalStateException	if state can't be set
	 */
	protected function setState ( state : OperationState ) : void {
		
		if ( this.state != state ) {
			
			var eventType : String = AbstractOperation.OPERATION_STATE_TRANSITION_TABLE.getValue( state, this.state );
			
			if ( !eventType ) {
				throw new IllegalStateException( "Can't set state " + state.toString() + " from state " + this.state.toString() + "!" );
			}
			
			// if ( this.state == OperationState. )
			
			this.state = state;
			this.dispatchEvent( new OperationEvent( eventType ) );
			
		}
		
	}
	
	/** 
	 *	@inheritDoc 
	 */
	public function setKey( key : * ):Operation {
		OperationMonitor.monitorOperation( this, key );
		return this;
	}
	
	/** 
	 *	@inheritDoc 
	 */
	public function getKey():* {
		return OperationMonitor.getOperationKey( this );
	}
	
	
	/** 
	 *	@inheritDoc 
	 */
	public function addListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true):Operation {
		this.addEventListener.apply( null, arguments );
		return this;
	}
	
	/** 
	 *	@inheritDoc
	 */
	public function removeListener(type:String, listener:Function, useCapture:Boolean = false):Operation {
		this.removeEventListener.apply( null, arguments );
		return this;
	}
	
	/**
	 * To string
	 * @return
	 */
	override public function toString() : String {
		return "[object " + ObjectUtil.getClassName( this ) + "] uuid: " + this.uuid + ( ( name.length > 0 ) ? (", name: " + this.name ) : "" );
		
	}
	
	/**
	 *	@inheritDoc
	 */
	public function setName (name : String ) : Operation {
		this.name = name;
		return this;
	}
	
	/**
	 *	@inheritDoc
	 */
	public function getName () : String {
		return this.name;
	}
	
}
	
}