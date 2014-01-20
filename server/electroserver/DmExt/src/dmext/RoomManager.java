package dmext;

import com.electrotank.electroserver5.entities.RoomVariable;
import com.electrotank.electroserver5.examples.database.DatabaseJDBCPlugin;
import com.electrotank.electroserver5.extensions.api.PluginApi;
import com.electrotank.electroserver5.extensions.api.RoomResponse;
import com.electrotank.electroserver5.extensions.api.value.EsObject;
import com.electrotank.electroserver5.extensions.api.value.RoomConfiguration;
import com.electrotank.electroserver5.extensions.api.value.UserConfig;
import java.sql.SQLException;

/**
 *
 * @author Vartotojas
 */
public class RoomManager {

    private PluginApi _api;
    private DatabaseJDBCPlugin databasePlugin;

    public RoomManager(PluginApi api) {
        _api = api;
        databasePlugin = (DatabaseJDBCPlugin) _api.getServerPlugin("DatabaseJDBCPlugin");
    }

    public void createRoom(String roomName, String username) {
        if (roomName != null && roomName.length() > 0) {
            _api.getLogger().debug("RoomManager.createRoom()");

            /*            
            EsObject[] roomObjectArray = null;

            try {
                int mapId = getQueryRows("SELECT * FROM rooms WHERE name='" + roomName + "';")[0].getInteger("map_id");
                roomObjectArray = getQueryRows("SELECT * FROM objects2maps WHERE map_id=" + mapId + ";");
                _api.getLogger().debug("RoomManager.createRoom(): Found " + roomObjectArray.length + " objects for map.");
            } catch (SQLException ex) {
                _api.getLogger().debug("SQLException for requested query: " + ex.getSQLState());
            }
            */

            RoomConfiguration roomConfiguration = new RoomConfiguration();
            roomConfiguration.setName(roomName);

            /*            
            RoomVariable roomObjectsVar = new RoomVariable();
            roomObjectsVar.setName("roomObjects");
            roomObjectsVar.setLocked(false);
            roomObjectsVar.setPersistent(true);

            EsObject value = new EsObject();
            if (roomObjectArray != null) {
                value.setEsObjectArray("roomObjects", roomObjectArray);
                roomObjectsVar.setValue(value);
            }

            roomConfiguration.addVariable(roomObjectsVar);
            */
            
            UserConfig[] users = new UserConfig[1];
            UserConfig userConfig = new UserConfig();
            userConfig.setUserName(username);
            userConfig.setReceivingRoomVariableUpdates(true);
            users[0] = userConfig;

            RoomResponse roomResponse = _api.createRoomInNamedZone(roomName, true, roomConfiguration, users);

            _api.getLogger().debug("RoomManager.createRoom(): " + _api.getRoomVariables(roomResponse.getZoneId(), roomResponse.getRoomId()).size() + " variables created.");
        } else {
            Utils.sendErrorToUser(_api, username, "joinRoomRequest: property 'roomName' wasn't found on requestParameters.");
        }
    }

    public EsObject[] getQueryRows(String query) throws SQLException {
        EsObject rs = databasePlugin.doQuery(query);
        return rs.getEsObjectArray("results");
    }
}