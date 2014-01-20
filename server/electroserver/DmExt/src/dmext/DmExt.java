/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package dmext;

import com.electrotank.electroserver5.examples.database.DatabaseJDBCPlugin;
import com.electrotank.electroserver5.extensions.BasePlugin;
import com.electrotank.electroserver5.extensions.api.value.EsObjectRO;

/**
 *
 * @author Vartotojas
 */
public class DmExt extends BasePlugin {

    private String ZONE_NAME = "MoonWorld";

    @Override
    public void init(EsObjectRO parameters) {
        getApi().getLogger().debug("DmExt.init()");
        NpcManager.getInstance().setDatabasePlugin((DatabaseJDBCPlugin) getApi().getServerPlugin("DatabaseJDBCPlugin"));
    }

    @Override
    public void request(String username, EsObjectRO requestParameters) {
        String action = requestParameters.getString("action");

        getApi().getLogger().debug("DmExt.request(): Action '" + action + "' called.");
        switch (action) {
            default:
                break;
        }

    }
}
