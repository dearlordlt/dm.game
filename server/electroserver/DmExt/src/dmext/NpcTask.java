/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package dmext;

import java.util.HashMap;

/**
 *
 * @author Zenia
 */
public class NpcTask {
    
    private String _label;
    private HashMap<String, String> _params = new HashMap<>();
    
    public NpcTask(String label, HashMap params) {
        this._label = label;
        _params = params;
    }

    /**
     * @return the _label
     */
    public String getLabel() {
        return _label;
    }

    public void setLabel(String label) {
        this._label = label;
    }

    public HashMap<String, String> getParams() {
        return _params;
    }
    
}
