package dm.game.windows.menu {
	
import dm.game.data.service.AvatarService;
import dm.game.managers.MyManager;
import dm.game.windows.Tooltip;
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.text.TextField;
import ucc.data.service.AmfPhpClient;
import ucc.data.service.RemoteMethodCall;
import ucc.util.Delegate;
import ucc.util.sprintf;
	
/**
 * Central pannel
 * 
 * @version $Id: CentralPanel.as 112 2013-05-06 05:55:58Z rytis.alekna $
 */
public class CentralPanel {
	
	/** aspects */
	protected var aspects 				: Vector.<LabelAndTitle>;
	
	/** Loaded stats number */
	protected var statsLoadedNum		: int;
	
	/** Stats fields */
	protected var statsFields	: Object = {
		"a.muzika.progress" : new LabelAndTitle( "a.muzika.progress", "Muzika",1 ),
		"a.ekologija.progress" : new LabelAndTitle( "a.ekologija.progress", "Ekologija",2 ),
		"a.daile.progress" : new LabelAndTitle( "a.daile.progress", "Dailė",3 ),
		"a.patycios.progress" : new LabelAndTitle( "a.patycios.progress", "Patyčios",4 ),
		"a.tachnologijos.progress" : new LabelAndTitle( "a.tachnologijos.progress", "Technologijos",5 )
	};
	
	/** centralPanelView */
	protected var centralPanelView 		: DisplayObjectContainer;
	
	/**
	 * Class constructor
	 */
	public function CentralPanel ( centralPanelView : DisplayObjectContainer ) {
		this.centralPanelView = centralPanelView;
		this.init();
	}
	
	/**
	 * Init
	 */
	protected function init () : void {
		
		this.onStatsChanged();
		
		
		AmfPhpClient.getInstance().addCallObserver( this.onStatsChanged, "dm.Avatar.modifyVar", MyManager.instance.avatar.id, "a.muzika.progress" );
		AmfPhpClient.getInstance().addCallObserver( this.onStatsChanged, "dm.Avatar.modifyVar", MyManager.instance.avatar.id, "a.ekologija.progress" );
		AmfPhpClient.getInstance().addCallObserver( this.onStatsChanged, "dm.Avatar.modifyVar", MyManager.instance.avatar.id, "a.daile.progress" );
		AmfPhpClient.getInstance().addCallObserver( this.onStatsChanged, "dm.Avatar.modifyVar", MyManager.instance.avatar.id, "a.patycios.progress" );
		AmfPhpClient.getInstance().addCallObserver( this.onStatsChanged, "dm.Avatar.modifyVar", MyManager.instance.avatar.id, "a.tachnologijos.progress" );
	}
	
	/**
	 * On stats changed. Executed when there is a call to remote method to change var
	 */
	protected function onStatsChanged ( remoteMethodCall : RemoteMethodCall = null ) : void {
		AvatarService.getStats( MyManager.instance.avatar.id )
			.addResponders( this.onStatsLoaded )
			.call();
	}
	
	/**
	 * On stats loaded
	 */
	protected function onStatsLoaded ( response : Array ) : void {
		
		var barDO		: *;
		
		var max : Number = 0;
		
		for each( var item : Object in response ) {
			max = Math.max( max, item.value );
		}
		
		for ( var i : int = 0; i < response.length; i++ ) {
			
			var labelAndTitle : LabelAndTitle = this.statsFields[ response[i].label ];
			
			barDO = this.centralPanelView.getChildByName( sprintf( "progressbar%d", labelAndTitle.index ) ) as StatisticsProgressBar;
			
			barDO.setProgress( response[i].value / max );
			
			new Tooltip( barDO, labelAndTitle.title + ": " + response[i].value );
			
		}
		
	}
	
}

}

class LabelAndTitle {
	
/** index */
public var index : int;
	
	/** title */
	public var title : String;
		
	/** label */
	public var label : String;
	
	/**
	 * Class constructor
	 */
	public function LabelAndTitle ( label : String, title : String, index : int ) {
		this.index = index;
		this.title = title;
		this.label = label;
	}
	
}