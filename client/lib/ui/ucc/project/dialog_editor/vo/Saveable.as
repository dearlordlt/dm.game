package ucc.project.dialog_editor.vo {
	
/**
 * Saveable VO prototype
 * @version $Id: Saveable.as 138 2013-05-24 14:49:58Z rytis.alekna $
 */
public interface Saveable {
	
	/**
	 * Is saved?
	 * @return
	 */
	function isSaved () : Boolean;
	
	/**
	 * Save VO
	 */
	function save () : void;
	
}
	
}