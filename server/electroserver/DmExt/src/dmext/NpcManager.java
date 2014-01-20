/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package dmext;

import com.electrotank.electroserver5.examples.database.DatabaseJDBCPlugin;
import com.electrotank.electroserver5.extensions.api.value.EsObject;
import com.electrotank.electroserver5.extensions.api.value.RoomValue;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

/**
 *
 * @author Zenia
 */
public class NpcManager {

    private static NpcManager instance = null;
    private DatabaseJDBCPlugin _databasePlugin;
    public ArrayList<NPC> npcs = new ArrayList<>();
    private EsObject[] _animations;

    private NpcManager() {
        // Exists only to defeat instantiation.        
    }

    public static NpcManager getInstance() {
        if (instance == null) {
            instance = new NpcManager();
        }
        return instance;
    }

    public void getRoomNpcs(String roomName) throws SQLException {
        EsObject[] roomInfos = getQueryRows("SELECT * FROM rooms WHERE label='" + roomName + "';");
        EsObject roomInfo;
        if (roomInfos.length > 0) {
            roomInfo = roomInfos[0];
        } else {
            return;
        }

        int mapId = roomInfo.getInteger("map_id");
        EsObject[] npcInfos = getQueryRows("SELECT * FROM npc WHERE id IN (SELECT component_id FROM components_to_entities WHERE component_type='NPC' AND entity_id IN (SELECT entity_id FROM entities_to_maps WHERE map_id=" + mapId + "));");
        if (npcInfos.length == 0) {
            _databasePlugin.getApi().getLogger().debug("NpcManager: Room '" + roomName + "' doesn't have any NPC.");
            return;
        }


        for (EsObject npcInfo : npcInfos) {
            EsObject[] result;

            _databasePlugin.getApi().getLogger().debug("NpcManager: Getting NPC entity.");
            result = getQueryRows("SELECT * FROM entities WHERE id IN (SELECT entity_id FROM components_to_entities WHERE component_type='NPC' AND component_id=" + npcInfo.getInteger("id") + ") AND id IN (SELECT entity_id FROM entities_to_maps WHERE map_id=" + mapId + ");");
            EsObject entityInfo;
            if (result.length == 0) {
                _databasePlugin.getApi().getLogger().debug("NpcManager: NPC component doesn't have entity.");
                continue;
            } else {
                entityInfo = result[0];
            }

            _databasePlugin.getApi().getLogger().debug("NpcManager: Getting entity initial position.");
            result = getQueryRows("SELECT * FROM entities_to_maps WHERE entity_id=" + entityInfo.getInteger("id") + " AND map_id=" + mapId + ";");
            EsObject position;
            if (result.length == 0) {
                _databasePlugin.getApi().getLogger().debug("NpcManager: Entity doesn't have initial position.");
                continue;
            } else {
                position = result[0];
            }

            _databasePlugin.getApi().getLogger().debug("NpcManager: Getting entity skin.");
            result = getQueryRows("SELECT * FROM skin3d WHERE id IN (SELECT component_id FROM components_to_entities WHERE entity_id=" + entityInfo.getInteger("id") + " AND component_type='Skin3D');");
            EsObject skin;
            if (result.length == 0) {
                _databasePlugin.getApi().getLogger().debug("NpcManager: Entity doesn't have skin.");
                continue;
            } else {
                skin = result[0];
            }
            
            /* Integer.parseInt("") kidaet exception, poetomu zdes' etot dibil'nyj kostyl' */
            int characterType;
            characterType = (skin.getString("subtype").equals("")) ? 0 : Integer.parseInt(skin.getString("subtype"));
            
            _databasePlugin.getApi().getLogger().debug("NpcManager: Got entity skin - label '" + skin.getString("label") + "' and character type '" + skin.getString("subtype") + "'.");

            EsObject[] commands = getQueryRows("SELECT * FROM npc_commands WHERE npc_id=" + npcInfo.getInteger("id") + " ORDER BY queue;");
            ArrayList<NpcTask> routine = new ArrayList<>();
            for (EsObject commandInfo : commands) {
                EsObject[] paramInfos = getQueryRows("SELECT * FROM npc_command_params WHERE command_id=" + commandInfo.getInteger("id") + ";");
                HashMap<String, String> params = new HashMap();
                for (EsObject param : paramInfos) {
                    params.put(param.getString("label"), param.getString("value"));
                }
                NpcTask npcTask = new NpcTask(commandInfo.getString("label"), params);
                routine.add(npcTask);
            }
            RoomValue room = _databasePlugin.getApi().getRooms("MoonWorld", roomName).iterator().next();            

            NPC npc = new NPC(entityInfo.getInteger("id"), npcInfo.getString("label"), characterType, routine.toArray(new NpcTask[routine.size()]), room);
            npc.setPosition(position.getInteger("x"), position.getInteger("y"), position.getInteger("z"), position.getInteger("rotationX"), position.getInteger("rotationY"), position.getInteger("rotationZ"));
            npcs.add(npc);
            _databasePlugin.getApi().getLogger().debug("NpcManager: New NPC created: " + npcInfo.getString("label"));
            npc.startRoutine();
        }
    }

    public void onRoomDestroyed(RoomValue room) {
        Iterator<NPC> npcIterator = npcs.iterator();
        while (npcIterator.hasNext()) {
            NPC npc = npcIterator.next();
            if (npc.getRoom().getRoomId() == room.getRoomId()) {
                npcIterator.remove();
                npc.destroy();
            }
        }
    }

    public void dispatchNpcEvent(String event, NPC npc, EsObject params) {
        EsObject message;

        switch (event) {
            case NPC.ON_MOVEMENT_START:
                _databasePlugin.getApi().getLogger().debug("NpcManager: NPC " + npc.getLabel() + " started movement.");
                message = new EsObject();
                message.setString("npcEvent", NPC.ON_MOVEMENT_START);
                message.setInteger("entityId", npc.getEntityId());
                message.setEsObject("position", npc.getPosition());
                message.setEsObject("destination", params);
                _databasePlugin.getApi().sendPluginMessageToRoom(npc.getRoom().getZoneId(), npc.getRoom().getRoomId(), message);
                break;

            case NPC.ON_MOVEMENT_STOP:
                _databasePlugin.getApi().getLogger().debug("NpcManager: NPC " + npc.getLabel() + " reached destination.");
                break;

            case NPC.ON_PLAY_ANIMATION:
                _databasePlugin.getApi().getLogger().debug("NpcManager: NPC " + npc.getLabel() + " started animation.");
                message = new EsObject();
                message.setString("npcEvent", NPC.ON_PLAY_ANIMATION);
                message.setInteger("entityId", npc.getEntityId());
                message.setString("label", params.getString("label"));
                _databasePlugin.getApi().sendPluginMessageToRoom(npc.getRoom().getZoneId(), npc.getRoom().getRoomId(), message);
                break;

            case NPC.ON_WAIT:
                _databasePlugin.getApi().getLogger().debug("NpcManager: NPC " + npc.getLabel() + " started animation.");
                message = new EsObject();
                message.setString("npcEvent", NPC.ON_WAIT);
                message.setInteger("entityId", npc.getEntityId());
                _databasePlugin.getApi().sendPluginMessageToRoom(npc.getRoom().getZoneId(), npc.getRoom().getRoomId(), message);
                break;

        }
    }

    public void dispatchMessage(NPC npc, String msg) {
        _databasePlugin.getApi().getLogger().debug("NpcManager: NPC " + npc.getLabel() + " message - '" + msg + "'.");
    }

    public void updateNpcPosition(NPC npc) {
        _databasePlugin.getApi().sendPluginMessageToRoom(npc.getRoom().getZoneId(), npc.getRoom().getRoomId(), new EsObject());
    }

    public EsObject[] getQueryRows(String query) throws SQLException {
        EsObject rs = _databasePlugin.doQuery(query);
        return rs.getEsObjectArray("results");
    }

    public EsObject getAnimation(String label, int characterType) {
        for (EsObject animation : _animations) {
            if (animation.getString("label").equals(label) && animation.getInteger("character_type_id") == characterType) {
                return animation;
            }
        }
        _databasePlugin.getApi().getLogger().debug("NpcManager: Animation " + label + " wasn't found for character type '" + characterType + "'.");
        return null;
    }

    public void setDatabasePlugin(DatabaseJDBCPlugin databasePlugin) {
        _databasePlugin = databasePlugin;
        try {
            _animations = getQueryRows("SELECT * FROM animations;");
        } catch (SQLException ex) {
            _databasePlugin.getApi().getLogger().debug("NpcManager: Error while getting animations: " + ex.getMessage());
        }
    }
}
