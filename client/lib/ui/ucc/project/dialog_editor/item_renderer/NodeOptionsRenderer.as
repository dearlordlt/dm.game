package ucc.project.dialog_editor.item_renderer {
	import fl.controls.ComboBox;
	import fl.controls.listClasses.ICellRenderer;
	import fl.controls.listClasses.ListData;
	

/**
 * 
 * @version $Id: NodeOptionsRenderer.as 31 2013-02-25 10:11:00Z rytis.alekna $
 */
public class NodeOptionsRenderer extends ComboBox implements ICellRenderer {
	
	public function NodeOptionsRenderer() {
		super();
			
	}
	
	// 
	// Implementation of methods defined by interface fl.controls.listClasses.ICellRenderer 
	// 
	
	public function set x ( value : Number ) : void {
		_x = value;
	}
	
	public function set y ( value : Number ) : void {
		_y = value;
	}
	
	
	/**
	 *	
	 */
	public function setSize (param0 : Number ,  param1 : Number ) : void {
		
	}
	
	public function set data ( value : Object ) : void {
		_data = value;
	}
	
	public function set selected ( value : Boolean ) : void {
		_selected = value;
	}
	
	public function set listData ( value : ListData ) : void {
		_listData = value;
	}
	
	public function get listData () : ListData {
		return _listData;
	}
	
	public function get data () : Object {
		return _data;
	}
	
	public function get selected () : Boolean {
		return _selected;
	}
	
	
	/**
	 *	
	 */
	public function setMouseState (param0 : String ) : void {
		
	}
	
}

}