/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package dmext;

import com.electrotank.electroserver5.extensions.api.PluginApi;
import com.electrotank.electroserver5.extensions.api.value.EsObject;
import com.electrotank.electroserver5.extensions.api.value.RoomValue;
import com.electrotank.electroserver5.extensions.api.value.UserConfig;

/**
 *
 * @author Vartotojas
 */
public class Utils {

    public static void addUserToRoom(PluginApi api, String username, RoomValue roomValue) {
        UserConfig userConfig = new UserConfig();
        userConfig.setUserName(username);
        userConfig.setReceivingRoomVariableUpdates(true);
        UserConfig[] userConfigs = new UserConfig[1];
        userConfigs[0] = userConfig;
        api.addUsersToRoom(roomValue.getZoneId(), roomValue.getRoomId(), "", userConfigs);
    }

    public static void sendErrorToUser(PluginApi api, String username, String message) {
        EsObject errorMessage = new EsObject();
        errorMessage.setString("type", "error");
        errorMessage.setString("message", message);
        api.sendPluginMessageToUser(username, errorMessage);
    }
}
