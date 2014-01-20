package dm.game.windows.finance {
	import fl.controls.listClasses.CellRenderer;
	import flash.text.TextFormat;
	

/**
 * 
 * @version $Id: AmountCellRenderer.as 215 2013-09-29 14:28:49Z rytis.alekna $
 */
public class AmountCellRenderer extends CellRenderer {
	
	private static const MINUS_TEXT_FORMAT	: TextFormat = new TextFormat( null, null, 0x990000 );
	private static const PLUS_TEXT_FORMAT	: TextFormat = new TextFormat( null, null, 0x009900 );
		
	/** TEXT_FORMAT */
	public static const TEXT_FORMAT : String = "textFormat";
	
	/**
	 * (Constructor)
	 * - Returns a new AmountCellRenderer instance
	 */
	public function AmountCellRenderer() {
	}
	
	public override function set data ( value : Object ) : void {
		super.data = value;
		this.setStyle( TEXT_FORMAT, ( parseFloat( value.amount ) > 0 ) ? PLUS_TEXT_FORMAT : MINUS_TEXT_FORMAT );
	}
	
}

}