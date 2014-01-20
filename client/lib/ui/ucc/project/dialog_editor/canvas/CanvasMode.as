package ucc.project.dialog_editor.canvas {
	
/**
 * Canvas mode
 * 
 * @version $Id: CanvasMode.as 50 2013-03-04 07:47:35Z rytis.alekna $
 */
public class CanvasMode {

	/** Selector */
	public static const SELECTOR 		: CanvasMode = new CanvasMode( "SELECTOR" );
	
	/** CONNECTOR */
	public static const CONNECTOR		: CanvasMode = new  CanvasMode( "CONNECTOR" );
	
	/** Internal type */
	private var type : String;
	
	
	/**
	 * Constructor
	 */
	public function CanvasMode( type : String ) {
		this.type = type;
	}
	
	/**
	 * To string representation
	 */
	public function toString() : String {
		return this.type;
	}

}

}