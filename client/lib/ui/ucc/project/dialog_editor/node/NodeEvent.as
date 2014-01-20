package ucc.project.dialog_editor.node {
	
import flash.events.Event;
	
/**
 * Node event
 * 
 * @version $Id: NodeEvent.as 31 2013-02-25 10:11:00Z rytis.alekna $
 */
public class NodeEvent extends Event {
	
	/** Selected event */
	public static const SELECTED 		: String = "ucc.project.dialog_editor.node.NodeEvent.SEECTED";
	
	/** DESELECTED event */
	public static const DESELECTED 		: String = "ucc.project.dialog_editor.node.NodeEvent.DESELECTED";
	
	/** Node view */
	public var nodeView					: NodeView;
	
	/**
	 * Constructor
	 */
	public function NodeEvent( type : String, nodeView : NodeView ) { 
		this.nodeView = nodeView;
		super( type, true, false );
	} 
	
	/**
	 *	@inheritDoc
	 */
	public override function clone () : Event {
		return new NodeEvent( this.type, this.nodeView );
	}
	
}

}