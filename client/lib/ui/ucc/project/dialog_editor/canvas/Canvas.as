package ucc.project.dialog_editor.canvas {
	
import flash.display.MovieClip;
import flash.display.Sprite;
	
/**
 * Canvas
 * 
 * @version $Id: Canvas.as 50 2013-03-04 07:47:35Z rytis.alekna $
 */
public class Canvas extends Sprite {
	
	/** Drawing layer */
	public var drawingLayerDO		: MovieClip;

	/** Nodes layer */
	public var nodesLayerDO			: MovieClip;

	/** Joints layer */
	public var jointsLayerDO		: MovieClip;	
	
	/** Drag layer */
	public var dragLayerDO			: MovieClip;
	
	/**
	 * Class constructor
	 */
	public function Canvas () {
		
	}
	
	/**
	 * Update
	 */
	public function update () : void {
		this.dragLayerDO.width = this.width;
		this.dragLayerDO.height = this.height;
	}
	
}

}