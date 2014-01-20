package dm.game.windows.chat  {
	
/**
 * Command config VO
 *
 * @version $Id: CommandConfig.as 205 2013-08-29 07:02:08Z rytis.alekna $
 */
internal class CommandConfig {
	
	/** REST. Add this prefix before param name to get all tokens till end. Later params are ignored */
	public static const REST : String = "__rest__";
	
	public var clazz 		: Class;
	
	public var paramsOrder	: Array;
		
	/**
	 * Class constructor
	 */
	public function CommandConfig ( clazz : Class, paramsOrder : Array ) {
		this.clazz 			= clazz;
		this.paramsOrder 	= paramsOrder;
	}
	
	/**
	 * Input tokens to params
	 * @param	tokens
	 * @param	config
	 * @return
	 */
	public static function inputTokensToParams ( tokens : Array, config : Array = null ) : Array {
		
		var retVal : Array = [];
		
		if ( !config || ( config.length == 0 ) ) {
			return retVal;
		}
		
		for ( var i : int = 0; i < config.length; i++ ) {
			
			if ( tokens[i] ) {
				
				var param : Object = { };
				param.label = config[i];
				
				if ( config[i].indexOf( REST ) == 0 ) {
					
					// retVal = retVal.concat( config.slice( i ) );
					param.value = config.slice( i ).join( " " );
					retVal.push( param );
					break;
					
				} else {
					param.value = tokens[i];
					retVal.push( param );
				}
				
				
			}
			
		}
		
		return retVal;
		
	}	
	
}
	
}