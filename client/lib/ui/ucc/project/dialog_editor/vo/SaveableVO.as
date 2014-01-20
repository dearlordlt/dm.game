package ucc.project.dialog_editor.vo {

/**
 * 
 * @version $Id: SaveableVO.as 38 2013-02-27 02:29:58Z rytis.alekna $
 */
public class SaveableVO implements Saveable {
	
	/** Saved? */
	public var saved	: Boolean;
	
	/**
	 * Class constructor
	 */
	public function SaveableVO() {
		
	}
	
	/**
	 *	Is VO saved?
	 */
	public function isSaved () : Boolean {
		return this.saved;
	}
	
	
	/**
	 *	Abstract save
	 */
	public function save () : void {
		// TODO: implement
	}
	
}

}