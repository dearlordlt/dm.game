/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package dmext;

import com.electrotank.electroserver5.extensions.BaseRoomTrackingEventHandler;
import com.electrotank.electroserver5.extensions.api.value.RoomValue;
import java.sql.SQLException;

/**
 *
 * @author Zenia
 */
public class RoomEventHandler extends BaseRoomTrackingEventHandler{
    
    @Override
    public void roomCreated(RoomValue room) {
        getApi().getLogger().debug("DmExt.RoomEventHandler.roomCreated()");
        try {
            NpcManager.getInstance().getRoomNpcs(room.getRoomName());
        } catch (SQLException ex) {
            getApi().getLogger().debug(ex.getMessage());
        }
    }
    
    @Override
    public void roomDestroyed(RoomValue room) {
        getApi().getLogger().debug("DmExt.RoomEventHandler.roomDestroyed()");
        NpcManager.getInstance().onRoomDestroyed(room);
    }
    
}
