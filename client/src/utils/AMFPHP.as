package utils {
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;
	import ucc.data.service.AmfPhpClient;

	/**
	 * AmpPhpClient wrapper for backwards compatibility
	 * This wrapper reuses single NetConnection
	 * @author $Id: AMFPHP.as 52 2013-03-06 12:36:20Z zenia.sorocan $
	 */
	public class AMFPHP {
		
		/** On result callback */
		protected var result : Function;
		
		/** On fault callback */
		protected var fault : Function;
		
		/**
		 * Class constructor
		 * @param	result
		 * @param	fault
		 */
		public function AMFPHP( result : Function = null, fault : Function = null, supressNoFaultCallbackWarning : Boolean = true ){
			this.fault = fault;
			this.result = result;
			if ( ( fault == null ) && ( result != null ) ) {
				if ( !supressNoFaultCallbackWarning ) {
					trace( "[utils.AMFPHP.AMFPHP] : Warning! No fault callback defined. Using onResult callback for fault at " + ( new Error() ).getStackTrace() );
				}
				this.fault = result;
			}
		}
		
		/**
		 * Call service
		 */
		public function xcall( cmd:String, ...args ) : AMFPHP {
			AmfPhpClient.getInstance().callService( cmd, args, this.result, this.fault );
			return this;
		}
	}
}