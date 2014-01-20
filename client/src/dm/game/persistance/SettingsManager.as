package dm.game.persistance  {
	
/**
 * Settings manager
 *
 * @version $Id: SettingsManager.as 2 2013-01-03 09:37:22Z rytis.alekna $
 */
public class SettingsManager {
	
	/** Local store name */
	public static const DM			: String = "dm";
	
	/** Singleton instance */
	private static var instance 	: SettingsManager;
	
	/** Key value store */
	protected var keyValueStore		: KeyValueStore;
	
	/**
	 * Get singleton instance of class
	 * @return 	singleton instance	SettingsManager
	 */
	public static function getInstance () : SettingsManager {
		return SettingsManager.instance ? SettingsManager.instance : ( SettingsManager.instance = new SettingsManager() );
	}
	
	/**
	 * Class constructor
	 */
	public function SettingsManager () {
		this.keyValueStore = new LocalKeyValueStore( DM )
	}
	
	/**
	 * Get store
	 */
	public function getStore () : KeyValueStore {
		return this.keyValueStore;
	}
	
}
	
}