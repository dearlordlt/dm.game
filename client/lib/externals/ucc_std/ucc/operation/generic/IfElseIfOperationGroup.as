package ucc.operation.generic  {
	import ucc.error.IllegalArgumentException;
	import ucc.error.IllegalStateException;
	import ucc.operation.Operation;
	import ucc.operation.OperationGroup;
	import ucc.util.ArrayUtil;
	import ucc.util.ObjectUtil;
	
/**
 * If-Else-If operaition group
 *
 * @version $Id: IfElseIfOperationGroup.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class IfElseIfOperationGroup extends AbstractOperationGroup {
	
	/** NONE  */
	public static const NONE	: String = "none";
	
	/** IF  */
	public static const IF		: String = "if";
	
	/** ELSE  */
	public static const ELSE	: String = "else";
	
	/** ELSEIF  */
	public static const ELSEIF	: String = "elseif";
	
	/** Last condition */
	protected var lastCondition	: String = NONE;
	
	/** Decision tree */
	protected var decisionTree	: Array = [];
	
	/**
	 * Class constructor
	 */
	public function IfElseIfOperationGroup ( ... conditions ) {
		
		if ( conditions.length > 0 ) {
			this.if_.apply( null, conditions );
		}
		
	}
	
	/**
	 * Init
	 */
	protected function init () : void {
		
	}
	
	/**
	 * If statement
	 * @param	... conditions
	 * @return
	 */
	public function if_ ( ... conditions ) : IfElseIfOperationGroup {
		
		if ( this.lastCondition != NONE ) {
			throw new IllegalStateException( "Can\'t use IF statement more than once!" );
		}
		
		if ( ArrayUtil.getCommonLengthOfArrays.apply( null, conditions ) == 0 ) {
			throw new IllegalArgumentException( "You must provide at least one condition!" );
		}
		
		this.decisionTree.push( new Statement( conditions ) )
		
		return this;
		
	}
	
	
	public function endIf () : IfElseIfOperationGroup {
		
	}
	
	
	/**
	 * Process OR conditions and return result
	 * @param	conditions
	 * @param	is OR condition?
	 * @return	result
	 */
	protected function processConditions ( conditions : Array, or : Boolean = true ) : Boolean {
		
		var condition 			: * ;
		
		var retVal 				: Boolean;
		
		for ( var i : int = 0; i < conditions.length; i++ ) {
			
			condition = conditions[i];
			
			switch ( typeof condition ) {
				
				case "array"	:
					retVal = this.processConditions( condition, false );
					break;
				
				case "boolean"	:
					retVal = condition;
					break;
				
				case "object"	:
					
					if ( condition is Class ) {
						
						try {
							retVal = condition.getResult()
							break;
						} catch ( error : Error ) {}
						
						try {
							retVal = ( new condition() ).getResult()
							break;
						} catch ( error : Error ) {}
						
						retVal = false;
						
					} else if ( ( condition as Object ).hasOwnProperty("getResult") ) {
						try {
							retVal = condition.getResult();
						} catch ( error : Error ) {
							retVal = false;
						}
						
					} else {
						retVal = Boolean( condition );
					}
					
					break;
					
				default:
					retVal = Boolean( condition );
					break;
			}
			
			if ( !or && !retVal ) {
				return false;
			}
			
		}
		
		return retVal;
		
	}

	/**
	 *	@inheritDoc
	 */
	public override function addOperation ( operation : Operation ,  progressWeight : Number  = 1 ) : OperationGroup {
		return this.getCurrentNode().addOperation(operation, progressWeight);
	}
	
	/**
	 * Get current decision node
	 */
	protected function getCurrentNode () : OperationGroup {
		
		if ( this.decisionTree.length == 0 ) {
			this.if_( true );
			trace( "[ucc.operation.generic.IfElseIfOperationGroup.getCurrentNode] : Not condition provided - IF condition will evaluate to true!" );
		}
		
		return Statement( this.decisionTree[ this.decisionTree.length - 1 ] ).getOperation();
		
	}
	
}
	
}
import ucc.operation.OperationGroup;

/**
 * Internal class stement
 */
class Statement {
	
	/** Operation group */
	private var operation		: OperationGroup = new SequentialOperationGroup();
	
	/** Conditions */
	protected var conditions	: Array;
	
	/**
	 * Class constructor
	 */
	public function Statement ( conditions : Array ) {
		this.conditions = conditions;
	}
	
	/**
	 * Get operation
	 */
	public function getOperation () : OperationGroup {
		return this.operation;
	}
	
	/**
	 * Get conditions
	 * @return	array of conditions
	 */
	public function getConditions () : Array {
		return this.conditions
	}
	
}