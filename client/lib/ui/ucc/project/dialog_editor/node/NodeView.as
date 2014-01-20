package ucc.project.dialog_editor.node {
	
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import org.as3commons.lang.ArrayUtils;
import org.as3commons.lang.ClassUtils;
import ucc.project.dialog_editor.node.background.NodeBackground;
import ucc.project.dialog_editor.vo.Phrase;
	
/**
 * Node view
 * 
 * @version $Id: NodeView.as 68 2013-03-13 10:43:22Z rytis.alekna $
 */
public class NodeView extends Sprite {
	
	/** Phrase */
	protected var phrase			: Phrase;
	
	/** Phrase */
	public var phraseTF				: TextField;

	/** Background */
	public var backgroundDO			: NodeBackground;	
	
	/** Function icon */
	public var functionIconDO		: MovieClip;

	/** Condition icon */
	public var conditionIconDO		: MovieClip;	
	
	/** is selected? */
	protected var selected			: Boolean;
	
	/** Joints */
	protected var joints			: Array = [];
	
	/**
	 * Class constructor
	 */
	public function NodeView () {
		this.mouseChildren = false;
	}
	
	/**
	 * Get node
	 * @return	node (phrase)
	 */
	public function getPhrase () : Phrase {
		return this.phrase;
	}
	
	/**
	 * Set node
	 * @param	node
	 */
	public function setPhrase ( node : Phrase ) : void {
		
		this.phrase = node;
		
		this.phraseTF.text = this.phrase.text;
		
		// this.phraseTF.width = this.phraseTF.textWidth;
		
		this.conditionIconDO.visible = ( this.phrase.conditions.length > 0 );
		this.functionIconDO.visible = ( this.phrase.functions.length > 0 );
		
		if ( this.phrase.root ) {
			this.backgroundDO.setToRoot();
		} else {
			if ( this.phrase.subject == "me" ) {
				this.backgroundDO.setToPc();
			} else {
				this.backgroundDO.setToNpc();
			}
		}
		
	}
	
	/**
	 * Invalidate if phrase dat has changed
	 */
	public function invalidate () : void {
		if ( this.phrase ) {
			this.setPhrase( this.phrase );
		}
	}
	
	public function addJoint ( jointView : JointView ) : void {
		if ( this.joints.indexOf( jointView ) == -1 ) {
			this.joints.push( jointView );
		}
	}
	
	/**
	 * remove joint
	 */
	public function removeJoint ( jointView : JointView ) : void {
		ArrayUtils.removeItem( this.joints, jointView );
	}
	
	/**
	 * Get joints
	 */
	public function getJoints () : Array {
		return this.joints;
	}
	
	/**
	 * Set szoom level
	 * @param	zoomLevel
	 */
	public function setZoomLevel ( zoomLevel : int ) : void {
		if ( zoomLevel == 0 ) {
			// this.phraseTF.text = "";
			this.phraseTF.width = 1; // this.phraseTF.textWidth;
		} else if ( zoomLevel == 1 ) {
			this.phraseTF.multiline = false;
			this.phraseTF.width = 161;
			// this.phraseTF.text = this.phrase.text;
			this.phraseTF.height = 18;
		} else {
			this.phraseTF.multiline = true;
			this.phraseTF.autoSize = TextFieldAutoSize.LEFT;
			// this.phraseTF.text = this.phrase.text;
			this.phraseTF.height = this.phraseTF.textHeight;
		}
		
		this.draw();
		
	}
	
	/**
	 * Draw node
	 */
	protected function draw () : void {
		this.backgroundDO.width = Math.max( 40, this.phraseTF.width + 16 );
		this.backgroundDO.height = Math.max( 40, this.phraseTF.height + 22 );
	}
	
	/**
	 * Update joints
	 */
	public function updateJoints () : void {
		for each( var item : JointView in this.joints ) {
			item.update();
		}
	}
	
	/**
	 * Select
	 */
	public function select () : void {
		this.selected = true;
		this.parent.setChildIndex( this, this.parent.numChildren - 1 );
		this.backgroundDO.select();
		this.dispatchEvent( new NodeEvent( NodeEvent.SELECTED, this ) );
	}
	
	/**
	 * Deselect
	 */
	public function deselect () : void {
		if ( this.isSelected() ) {
			this.selected = false;
			this.backgroundDO.deselect();
			this.dispatchEvent( new NodeEvent( NodeEvent.DESELECTED, this ) );
		}
	}
	
	/**
	 * Is selected?
	 */
	public function isSelected () : Boolean {
		return this.selected;
	}
	
	public function setValid () : void {
		this.backgroundDO.validNodeBackgroundDO.visible = true;
		this.backgroundDO.invalidNodeBackgroundDO.visible = false;
	}
	
	public function setInvalid () : void {
		this.backgroundDO.validNodeBackgroundDO.visible = false;
		this.backgroundDO.invalidNodeBackgroundDO.visible = true;
	}
	
	public function setNeutral () : void {
		this.backgroundDO.validNodeBackgroundDO.visible = false;
		this.backgroundDO.invalidNodeBackgroundDO.visible = false;
	}
	
	
	
}

}