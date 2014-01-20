package dm.game.functions.commands {
import dm.game.functions.BaseExecutable;
import dm.game.managers.EsManager;
import dm.game.managers.MyManager;
import dm.game.windows.host.HostsListWindow;
import ucc.ui.window.WindowsManager;

/**
 * Go home command
 * @version $Id$
 */
public class GoHomeCommand extends BaseExecutable {
	
	/** GUEST */
	public const GUEST : String = "guest";
	
	/**
	 * executes
	 */
	public override function execute() : void {
		if ( getParamValueByLabel( GUEST ) == "0" ) {
			EsManager.instance.joinRoom( EsManager.HOME_ROOM_NAME + '@' + MyManager.instance.avatar.id );
		} else {
			WindowsManager.getInstance().createWindow( HostsListWindow );
		}
	}

}

}