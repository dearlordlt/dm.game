package ucc.operation.util  {
	import ucc.operation.Operation;
	import ucc.operation.OperationEvent;
	import ucc.util.ArrayUtil;
	import flash.utils.Dictionary;
	
/**
 * Operation monitor utility for operations management
 * TODO: add atoremoval from monitor on operation finished.
 * @version $Id: OperationMonitor.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class OperationMonitor {
	
	/** Operations */
	private static var operations		: Dictionary = new Dictionary( true );
	
	/** Operation keys dictionary (dictionary keys are operations themselves) */
	private static var operationKeys	: Dictionary = new Dictionary( true );
	
	/**
	 * Register operation for monitoring
	 * @param	operation
	 * @param	key	any object except false, null, undefined
	 */
	public static function monitorOperation ( operation : Operation, key : * ) : void {
		assert( operation && key );
		
		// check if operations isn't already registered with different key
		OperationMonitor.stopMonitoringOperation( operation );
		
		if ( !OperationMonitor.operations[ key ] ) {
			OperationMonitor.operations[ key ] = [];
		}
		
		OperationMonitor.operations[ key ].push( operation );
		OperationMonitor.operationKeys[ operation ] = key;
		
		operation.addEventListener( OperationEvent.COMPLETE, OperationMonitor.onOperationCompleted );
		operation.addEventListener( OperationEvent.STOP, OperationMonitor.onOperationCompleted );
		
	}
	
	/**
	 * Stop minitoring operation
	 * @param	operation
	 */
	public static function stopMonitoringOperation ( operation : Operation ) : void {
		assert( operation );
		
		var key : * ;
		
		if ( !OperationMonitor.isMonitoring( operation ) ) {
			return;
		} else {
			key = OperationMonitor.operationKeys[ operation ];
		}
		
		if ( OperationMonitor.operations[ key ] && ( OperationMonitor.operations[ key ].indexOf( operation ) > -1 ) ) {
			ArrayUtil.removeElementByReference( OperationMonitor.operations[ key ], operation );
			operation.removeEventListener( OperationEvent.COMPLETE, OperationMonitor.onOperationCompleted );
			operation.removeEventListener( OperationEvent.STOP, OperationMonitor.onOperationCompleted );
			delete OperationMonitor.operationKeys[ operation ];
		}
	}
	
	/**
	 * Get monitored operations by key
	 * @param	key
	 * @return	array of operations associated with provided key or empty array if key doesn't exist
	 */
	public static function getOperationsByKey ( key : * ) : Array {
		return OperationMonitor.operations[ key ] ? OperationMonitor.operations[ key ].concat() : [];
	}
	
	/**
	 * Get operation key
	 * @param	operation
	 * @return	operation key if operation is monitored. Else undefined is returned
	 */
	public static function getOperationKey ( operation : Operation ) : * {
		return OperationMonitor.operationKeys[ operation ];
	}
	
	/**
	 * Is operation monitored?
	 * @param	operation
	 * @return	true if monitoring
	 */
	public static function isMonitoring ( operation : Operation ) : Boolean {
		return OperationMonitor.operationKeys[ operation ] != undefined;
	}
	
	/**
	 * On operation completed
	 * Clean up from operation monitor
	 */
	protected static function onOperationCompleted ( event : OperationEvent ) : void {
		OperationMonitor.stopMonitoringOperation( event.target as Operation );
	}
	
}
	
}