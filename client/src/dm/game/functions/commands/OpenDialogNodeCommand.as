package dm.game.functions.commands {
	import dm.game.functions.BaseExecutable;
	import dm.game.windows.dialogviewer.DialogViewer;
	import ucc.logging.Logger;
	import ucc.ui.window.WindowsManager;
	

/**
 * 
 * @version $Id: OpenDialogNodeCommand.as 204 2013-08-27 08:53:09Z rytis.alekna $
 */
public class OpenDialogNodeCommand extends BaseExecutable {
		
	/** NODE_ID */
	public static const NODE_ID : String = "nodeId";
	
	/**
	 * (Constructor)
	 * - Returns a new OpenDialogNodeCommand instance
	 */
	public function OpenDialogNodeCommand() {
		
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function execute () : void {
		
		
		
		var dialogViewer : DialogViewer = WindowsManager.getInstance().getWindowByClass( DialogViewer ) as DialogViewer;
		
		trace( "[dm.game.functions.commands.OpenDialogNodeCommand.execute] dialogViewer : " + dialogViewer );
		
		try {
			dialogViewer.openExplicitNode( parseInt( this.getParamValueByLabel( NODE_ID ) ) );
			this.onResult( true );
		} catch ( error : Error ) {
			this.onResult( false );
			Logger.log( "Error occoured while opening dialog node", Logger.LEVEL_ERROR, this );
		}
		
		
	}
	
}

}