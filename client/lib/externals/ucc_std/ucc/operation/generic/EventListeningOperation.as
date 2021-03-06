package ucc.operation.generic  {
	import ucc.operation.AbstractOperation;
	import ucc.operation.OperationState;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
/**
 * Listen for event. When event is fired, operation is completed
 *
 * @version $Id: EventListeningOperation.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class EventListeningOperation extends AbstractOperation {
	
	/** Event dispatcher */
	protected var eventDispatcher	: IEventDispatcher;
	
	/** Event type */
	protected var eventType			: String;
	
	/** Use capture */
	protected var useCapture 		: Boolean;
	
	/** Priority */
	protected var priority 			: int;
	
	/** Use weak reference */
	protected var useWeakReference : Boolean;
	
	/**
	 * Class constructor
	 */
	public function EventListeningOperation ( eventDispatcher : IEventDispatcher, eventType : String, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false ) {
		this.useWeakReference = useWeakReference;
		this.priority = priority;
		this.useCapture = useCapture;
		this.eventType = eventType;
		this.eventDispatcher = eventDispatcher;
	}
	
	/**
	 * @inheritDoc
	 */
	override public function start() : void  {
		this.setProgress( 0 );
		this.setState( OperationState.RUNNING );
		this.eventDispatcher.addEventListener( this.eventType, this.onEvent, this.useCapture, this.priority, this.useWeakReference );
	}
	
	/**
	 * handle event
	 * @param	event
	 */
	protected function onEvent ( event : Event ) : void {
		this.setProgress( 1 );
		this.setState( OperationState.COMPLETED );
		this.eventDispatcher.removeEventListener( this.eventType, this.onEvent, this.useCapture );
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function pause () : void {
		this.setState( OperationState.PAUSED );
		this.eventDispatcher.removeEventListener( this.eventType, this.onEvent, this.useCapture );
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function resume (  ) : void {
		this.setState( OperationState.RUNNING );
		this.eventDispatcher.addEventListener( this.eventType, this.onEvent, this.useCapture, this.priority, this.useWeakReference );
	}
	
	/**
	 * @inheritDoc
	 */
	override public function stop() : void  {
		this.setState( OperationState.STOPPED );
		this.eventDispatcher.removeEventListener( this.eventType, this.onEvent, this.useCapture );
	}
	
}
	
}