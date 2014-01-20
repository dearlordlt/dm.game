package dm.game.windows.avatar.tab {
	
import dm.game.managers.MyManager;
import dm.game.windows.avatar.tab.result.AchievementsTab;
import dm.game.windows.avatar.tab.result.ReputationTab;
import dm.game.windows.avatar.tab.result.SkillsTab;
import dm.game.windows.avatar.tab.result.VisitedCitiesTab;
import flash.display.Sprite;
import flash.geom.Point;
import ucc.ui.window.tab.TabManager;
import ucc.ui.window.tab.TabView;
	
/**
 * Results tab
 * 
 * @version $Id: ResultsTab.as 198 2013-07-29 23:05:53Z rytis.alekna $
 */
public class ResultsTab extends TabView {
	
	/** avatarId */
	protected var avatarId : Number;
	
	/**
	 * Class constructor
	 */
	public function ResultsTab ( avatarId : Number = NaN ) {
		
		if ( avatarId ) {
			this.avatarId = avatarId;
		} else {
			this.avatarId = MyManager.instance.avatar.id;
		}		
		
		( new TabManager( this, new Point( 15, 40 ) ) )
			.addTab( _("Skills"), SkillsTab, true, [this.avatarId] )
			.addTab( _("Reputation"), ReputationTab, true, [this.avatarId] )
			.addTab( _("Achievements"), AchievementsTab, true, [this.avatarId] )
			.addTab( _("Visited cities"), VisitedCitiesTab, true, [this.avatarId] )
			.draw()
			.openTab()
			
			//.addTab( _("Tasks"), SkillsTab )
			// .addTab( _("Social capital"), SkillsTab )
			
	}
	
}

}