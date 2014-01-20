package ucc.operation.generic  {
	import ucc.error.IllegalArgumentException;
	import ucc.operation.AbstractOperation;
	import ucc.operation.OperationState;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
/**
 * Event providing operation.
 * Adds specified event listener for specified object and completes when event is fired. Event listener is automaticaly removed.
 *
 * @version $Id: EventProvidingOperation.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class EventProvidingOperation extends AbstractOperation {
	
	/** Event dispatcher */
	protected var eventDispatcher	: IEventDispatcher;
	
	/** Event type */
	protected var eventType			: String;
	
	/** Use capture */
	protected var useCapture 		: Boolean;
	
	/** Priority */
	protected var priority 			: int;
	
	/** Use weak reference */
	protected var useWeakReference  : Boolean;
	
	/** Listener function */
	protected var listener 			: Function;
	
	/**
	 * Class constructor
	 */
	public function EventProvidingOperation ( listener : Function, eventDispatcher : IEventDispatcher, eventType : String, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false ) {
		
		if ( !listener || !eventDispatcher || !eventType ) {
			throw new IllegalArgumentException( "Listener, event disptacher and event type must be not null!" );
		}
		
		this.listener 			= listener;
		this.useWeakReference 	= useWeakReference;
		this.priority 			= priority;
		this.useCapture 		= useCapture;
		this.eventType 			= eventType;
		this.eventDispatcher 	= eventDispatcher;
		
	}
	
	/**
	 * @inheritDoc
	 */
	override public function start() : void  {
		this.setProgress( 0 );
		this.eventDispatcher.addEventListener( this.eventType, this.onEvent, this.useCapture, this.priority, this.useWeakReference );
		this.eventDispatcher.addEventListener( this.eventType, this.listener, this.useCapture, this.priority, this.useWeakReference );
		this.setState( OperationState.RUNNING );
	}
	
	/**
	 * handle event
	 * @param	event
	 */
	protected function onEvent ( event : Event ) : void {
		this.setProgress( 1 );
		this.eventDispatcher.removeEventListener( this.eventType, this.onEvent, this.useCapture );
		this.eventDispatcher.removeEventListener( this.eventType, this.listener, this.useCapture );
		this.eventDispatcher = null;
		this.listener = null;
		this.setState( OperationState.COMPLETED );
		
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function pause () : void {
		this.setState( OperationState.PAUSED );
		this.eventDispatcher.removeEventListener( this.eventType, this.onEvent, this.useCapture );
		this.eventDispatcher.removeEventListener( this.eventType, this.listener, this.useCapture );
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function resume (  ) : void {
		this.setState( OperationState.RUNNING );
		this.eventDispatcher.addEventListener( this.eventType, this.onEvent, this.useCapture, this.priority, this.useWeakReference );
		this.eventDispatcher.addEventListener( this.eventType, this.listener, this.useCapture, this.priority, this.useWeakReference );
	}
	
	/**
	 * @inheritDoc
	 */
	override public function stop() : void  {
		this.setState( OperationState.STOPPED );
		this.eventDispatcher.removeEventListener( this.eventType, this.onEvent, this.useCapture );
		this.eventDispatcher.removeEventListener( this.eventType, this.listener, this.useCapture );
		this.eventDispatcher = null;
		this.listener = null;
	}	
	
}
	
}