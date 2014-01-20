package ucc.project.dialog_editor.node {
	
import flash.display.Sprite;
import flash.geom.Point;
import ucc.util.MathUtil;
	
/**
 * Joint view
 * 
 * @version $Id: JointView.as 123 2013-05-13 07:08:24Z rytis.alekna $
 */
public class JointView extends Sprite {
	
	public static const OFFSET	: Number = 20;
	
	/** Start */
	protected var startNode		: NodeView;
	
	/** End */
	protected var endNode		: NodeView;
	
	/**
	 * Class constructor
	 */
	public function JointView () {
		
		
	}
	
	public function setStartNodeView ( nodeView : NodeView ) : void {
		this.startNode = nodeView;
		this.startNode.addJoint( this );
		this.update();
	}
	
	public function setEndNodeView ( nodeView : NodeView ) : void {
		this.endNode = nodeView;
		this.endNode.addJoint( this );
		this.update();
	}	
	
	public function getStartNodeView () : NodeView {
		return this.startNode;
	}
	
	public function getEndNodeView () : NodeView {
		return this.endNode;
	}
	
	/**
	 * Update joint position
	 */
	public function update () : void {
		if ( this.startNode && this.endNode ) {
			this.graphics.clear();
			var startPosition 	: Point = new Point( this.startNode.x + OFFSET, this.startNode.y + OFFSET );
			var endPosition		: Point = new Point( this.endNode.x + OFFSET, this.endNode.y + OFFSET );
			this.x = startPosition.x;
			this.y = startPosition.y;
			
			var diff : Point = endPosition.subtract( startPosition );
			
			this.graphics.lineStyle( 4, 0x666666 );
			this.graphics.moveTo( 0, 0 );
			this.graphics.lineTo( diff.x, diff.y );
			
		}
	}
	
	/**
	 * Destroy joint
	 */
	public function destroy () : void {
		
		this.endNode.getPhrase().parent_id = -1;
		this.endNode.removeJoint( this );
		this.startNode.removeJoint( this );
		
		this.graphics.clear();
		
		if ( this.parent ) {
			this.parent.removeChild( this );
		}
		
	}
	
}

}