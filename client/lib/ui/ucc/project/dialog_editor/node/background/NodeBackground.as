package ucc.project.dialog_editor.node.background {
	
import flash.display.MovieClip;
import flash.display.Sprite;
	
/**
 * Node background
 * 
 * @version $Id: NodeBackground.as 67 2013-03-13 09:28:11Z rytis.alekna $
 */
public class NodeBackground extends Sprite {
	
	/** Valid node background */
	public var validNodeBackgroundDO		: MovieClip;

	/** Invalid node background */
	public var invalidNodeBackgroundDO		: MovieClip;

	/** Pc node background */
	public var pcNodeBackgroundDO			: MovieClip;

	/** Npc node background */
	public var npcNodeBackgroundDO			: MovieClip;	
	
	/** None assigned node background */
	public var noneAssignedNodeBackgroundDO	: MovieClip;	
	
	/** Selected node background */
	public var selectedNodeBackgroundDO		: MovieClip;
	
	/** Root node background */
	public var rootNodeBackgroundDO			: MovieClip;
	
	/** All backgrounds */
	protected var allBackgrounds			: Array;
	
	/**
	 * Class constructor
	 */
	public function NodeBackground () {
		this.validNodeBackgroundDO.visible 		= 
		this.invalidNodeBackgroundDO.visible 	=
		this.pcNodeBackgroundDO.visible			=
		this.selectedNodeBackgroundDO.visible	=
		this.rootNodeBackgroundDO.visible		=
		this.npcNodeBackgroundDO.visible		= false;
		
		this.allBackgrounds = [ this.validNodeBackgroundDO, this.invalidNodeBackgroundDO, this.pcNodeBackgroundDO, this.npcNodeBackgroundDO, this.noneAssignedNodeBackgroundDO, this.selectedNodeBackgroundDO, this.rootNodeBackgroundDO ];
		
	}
	
	/**
	 * Show if node is valid for connection
	 */
	public function showValidation ( validate : Boolean ) : void {
		this.invalidNodeBackgroundDO.visible = !( this.validNodeBackgroundDO.visible = validate );
	}
	
	/**
	 * Hide validation outline
	 */
	public function hideValidation () : void {
		this.invalidNodeBackgroundDO.visible = this.validNodeBackgroundDO.visible = false;
	}
	
	/**
	 * Selected node view
	 */
	public function select () : void {
		this.selectedNodeBackgroundDO.visible = true;
	}
	
	/**
	 * Deselected node
	 */
	public function deselect () : void {
		this.selectedNodeBackgroundDO.visible = false;
	}
	
	/**
	 * Set to npc
	 */
	public function setToNpc () : void {
		this.noneAssignedNodeBackgroundDO.visible = this.pcNodeBackgroundDO.visible = this.rootNodeBackgroundDO.visible = !( this.npcNodeBackgroundDO.visible = true );
	}
	
	/**
	 * Set to pc
	 */
	public function setToPc () : void {
		this.noneAssignedNodeBackgroundDO.visible = this.npcNodeBackgroundDO.visible = this.rootNodeBackgroundDO.visible = !( this.pcNodeBackgroundDO.visible = true );
	}
	
	/**
	 * Set to none
	 */
	public function setToNone () : void {
		this.npcNodeBackgroundDO.visible = this.pcNodeBackgroundDO.visible = this.rootNodeBackgroundDO.visible = !( this.noneAssignedNodeBackgroundDO.visible = true );
	}
	
	/**
	 * Set to root
	 */
	public function setToRoot () : void {
		trace( "[ucc.project.dialog_editor.node.background.NodeBackground.setToRoot()]" );
		this.npcNodeBackgroundDO.visible = this.pcNodeBackgroundDO.visible = this.noneAssignedNodeBackgroundDO.visible = !( this.rootNodeBackgroundDO.visible = true );
	}
	
	/**
	 * Overide this setter for 9 grid scaling
	 */
	public override function set width ( value : Number ) : void {
		for each( var item : MovieClip in this.allBackgrounds ) {
			item.width = value;
		}
	}
	
	/**
	 * Overide this setter for 9 grid scaling
	 */
	public override function set height ( value : Number ) : void {
		for each( var item : MovieClip in this.allBackgrounds ) {
			item.height = value;
		}
	}
	
}

}