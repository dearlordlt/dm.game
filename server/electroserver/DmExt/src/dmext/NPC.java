/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package dmext;

import com.electrotank.electroserver5.extensions.api.value.EsObject;
import com.electrotank.electroserver5.extensions.api.value.RoomValue;
import java.util.Timer;
import java.util.TimerTask;

/**
 *
 * @author Zenia
 */
public class NPC {

    public static final String ON_MOVEMENT_START = "onMovementStart";
    public static final String ON_MOVEMENT_STOP = "onMovementStop";
    public static final String ON_PLAY_ANIMATION = "onPlayAnimation";
    public static final String ON_WAIT = "onWait";
    private int _entityId;
    private String _label;
    private int _charatcterType;
    private RoomValue _room;
    private Timer _timer;
    private int _x;
    private int _y;
    private int _z;
    private int _rotationX;
    private int _rotationY;
    private int _rotationZ;
    private NpcTask[] _routine;
    private int _currentTaskIndex;
    private double _framerate = 60 * 0.4;
    private int _moveSpeed = 300;

    public NPC(int entityId, String label, int characterType, NpcTask[] routine, RoomValue room) {
        _entityId = entityId;
        _label = label;
        _charatcterType = characterType;
        _routine = routine;
        _room = room;
    }

    public void startRoutine() {
        if (_routine.length > 0) {
            _currentTaskIndex = -1;
            nextTask();
        }
    }

    public void nextTask() {
        _currentTaskIndex++;
        if (_currentTaskIndex >= _routine.length) {
            _currentTaskIndex = 0;
        }
        doTask(_routine[_currentTaskIndex]);
    }

    public void doTask(NpcTask task) {
        switch (task.getLabel()) {
            case "playAnimation":
                playAnimation(task.getParams().get("label"));
                break;
            case "goTo":
                goTo(Integer.parseInt(task.getParams().get("x")), Integer.parseInt(task.getParams().get("y")), Integer.parseInt(task.getParams().get("z")));
                break;
            case "wait":
                wait(Integer.parseInt(task.getParams().get("duration")));
                break;

            default:
                nextTask();
                break;
        }
    }

    public void playAnimation(String label) {
        EsObject animation = NpcManager.getInstance().getAnimation(label, _charatcterType);
        if (animation == null) {
            nextTask();
            return;
        }
        NpcManager.getInstance().dispatchNpcEvent(ON_PLAY_ANIMATION, this, animation);
        long time = (long) ((animation.getInteger("end_frame") - animation.getInteger("start_frame")) / _framerate);

        _timer = new Timer();
        _timer.schedule(new TimerTask() {
            @Override
            public void run() {
                _timer.cancel();
                nextTask();
            }
        }, (int) time * 1000);
    }

    public void goTo(final int destX, final int destY, final int destZ) {
        final NPC npc = this;


        long distance = (long) Math.sqrt(Math.pow(destX - _x, 2) + Math.pow(destY - _y, 2) + Math.pow(destZ - _z, 2));
        long time = distance / (_moveSpeed);

        EsObject destination = new EsObject();
        destination.setInteger("x", destX);
        destination.setInteger("y", destY);
        destination.setInteger("z", destZ);
        destination.setInteger("time", (int) time);

        NpcManager.getInstance().dispatchNpcEvent(ON_MOVEMENT_START, npc, destination);

        // in seconds

        NpcManager.getInstance().dispatchMessage(this, "goTo command { current coords: (" + _x + ", " + _z + "), dest coords: (" + destX + ", " + destZ + ")}");
        NpcManager.getInstance().dispatchMessage(this, "goTo command { travel distance: " + distance + ", travel time: " + time + "}");

        _timer = new Timer();
        _timer.schedule(new TimerTask() {
            @Override
            public void run() {
                _x = destX;
                _y = destY;
                _z = destZ;
                NpcManager.getInstance().dispatchNpcEvent(ON_MOVEMENT_STOP, npc, null);
                _timer.cancel();
                nextTask();
            }
        }, (int) time * 1000);
    }

    public void wait(int duration) {
        NpcManager.getInstance().dispatchNpcEvent(ON_WAIT, this, null);

        _timer = new Timer();
        _timer.schedule(new TimerTask() {
            @Override
            public void run() {
                _timer.cancel();
                nextTask();
            }
        }, (int) duration * 1000);
    }

    public void setPosition(int x, int y, int z, int rotationX, int rotationY, int rotationZ) {
        _x = x;
        _y = y;
        _z = z;
        _rotationX = rotationX;
        _rotationY = rotationY;
        _rotationZ = rotationZ;
    }

    public EsObject getPosition() {
        EsObject position = new EsObject();
        position.setInteger("x", _x);
        position.setInteger("y", _y);
        position.setInteger("z", _z);
        position.setInteger("rotationX", _rotationX);
        position.setInteger("rotationY", _rotationY);
        position.setInteger("rotationZ", _rotationZ);
        return position;
    }

    public String getLabel() {
        return _label;
    }

    public RoomValue getRoom() {
        return _room;
    }

    public int getEntityId() {
        return _entityId;
    }

    public void destroy() {
        if (_timer != null) {
            _timer.cancel();
            _timer = null;
        }
    }
}
