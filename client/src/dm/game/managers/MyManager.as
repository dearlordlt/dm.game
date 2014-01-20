package dm.game.managers {

import com.electrotank.electroserver5.user.User;
import flare.core.Pivot3D;
import flash.events.TimerEvent;
import flash.utils.Timer;
import net.richardlord.ash.core.Entity;
import org.as3commons.lang.IllegalStateError;
import utils.AMFPHP;

/**
 * ...
 * @author zenia
 */
public class MyManager {
	
	private static var _instance : MyManager;
	
	private static var _usingGetInstance : Boolean = false;
	
	/** User id */
	public var id : int = 0;
	
	public var username : String = "";
	
	public var avatar : Object;
	
	public var availableAvatars : Array;
	
	public var myAvatarEntity : Entity;
	
	public var skin : Pivot3D;
	
	public var user : User;
	
	public var isAdmin : Boolean;
	
	public var school : Object;
	
	private var _positionUpdateTimer : Timer;
	
	public function MyManager() {
		if ( !_usingGetInstance ) {
			throw new Error( "Please use getInstance()." );
		}
		_positionUpdateTimer = new Timer( 5000 );
		_positionUpdateTimer.addEventListener( TimerEvent.TIMER, onPositionUpdateTimer );
	}
	
	public static function get instance() : MyManager {
		if ( _instance == null ) {
			_usingGetInstance = true;
			_instance = new MyManager();
			_usingGetInstance = false;
		}
		return _instance;
	}
	
	public function get avatarId () : int {
		if ( !this.avatar ) {
			throw new IllegalStateError("Avatar not selected!");
		}
		
		return this.avatar.id;
		
	}
	
	private function onPositionUpdateTimer( e : TimerEvent ) : void {
		if ( skin != null ) {
			var amfphp : AMFPHP = new AMFPHP();
			amfphp.xcall( "dm.Avatar.updateLastLocation", EsManager.instance.roomData.id, skin.x, skin.y, skin.z );
		}
	}
	
	/**
	 * Am I admin?
	 * @return
	 */
	public function amIAdmin() : Boolean {
		return this.isAdmin;
	}

}

}