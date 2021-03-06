package ucc.operation {
	import flash.events.IEventDispatcher;
	
/**
 * Operation
 * @version $Id: Operation.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public interface Operation extends IEventDispatcher {
	
	/**
	 * Start
	 */
	function start () : void;
	
	/**
	 * Stop
	 */
	function stop () : void;
	
	/**
	 * Pause
	 */
	function pause () : void;
	
	/**
	 * Resume
	 */
	function resume () : void;
	
	/**
	 * Get progress
	 * @return current progress
	 */
	function getProgress () : Number;
	
	/**
	 * Get state
	 * @return	current state
	 */
	function getState () : OperationState;
	
	/**
	 * Set operation key for making operation managable by OperationMonitor
	 * @param	key
	 * @return	reference to self
	 */
	function setKey ( key : * ) : Operation;
	
	/**
	 * Get operation key
	 * @return	operation key
	 */
	function getKey () : * ;
	
	/**
	 * Set literal name for operation to be hold within operation
	 * @param	name
	 */
	function setName ( name : String ) : Operation;
	
	/**
	 * Get name
	 * @return
	 */
	function getName () : String;
	
	/**
	 * Add listener. Works same like #addEventListener, except that it return reference to operation
	 * @param	type
	 * @param	listener
	 * @param	useCapture
	 * @param	priority
	 * @param	useWeakReference
	 * @return
	 */
	function addListener (type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true ) : Operation;
	
	/**
	 * Remove listener. Works same like #removeEventListener, except that it return reference to operation
	 * @param	type
	 * @param	listener
	 * @param	useCapture
	 * @return
	 */
	function removeListener (type:String, listener:Function, useCapture:Boolean = false) : Operation;
	
}
	
}