package dm.game.windows.ui {
	
/**
 * Prototype for skin support
 * @author Rytis Alekna
 * @version $Id: IWindowFrame.as 138 2013-05-24 14:49:58Z rytis.alekna $
 */
public interface IWindowFrame {
	
	function draw ( width : Number, height : Number ) : void;
	
	function setTitle ( title : String ) : void;
	
	function getTitle () : String;
	
}
	
}