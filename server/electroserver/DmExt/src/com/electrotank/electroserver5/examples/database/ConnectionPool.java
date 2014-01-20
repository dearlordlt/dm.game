package com.electrotank.electroserver5.examples.database;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import snaq.db.ConnectionPoolManager;

import com.electrotank.electroserver5.extensions.ManagedObjectFactory;
import com.electrotank.electroserver5.extensions.ManagedObjectFactoryLifeCycle;
import com.electrotank.electroserver5.extensions.api.ManagedObjectFactoryApi;
import com.electrotank.electroserver5.extensions.api.value.EsObject;
import com.electrotank.electroserver5.extensions.api.value.EsObjectEntry;
import com.electrotank.electroserver5.extensions.api.value.EsObjectRO;

public class ConnectionPool implements ManagedObjectFactory, ManagedObjectFactoryLifeCycle {
    
    private static final int DEFAULT_TIMEOUT = 5000; // 5 second connection-delay timeout
    
    private ManagedObjectFactoryApi    api;
    private ConnectionPoolManager      manager        = null;
    private final Map<String, Integer> defaultTimeout = new HashMap<String, Integer>();

    public void init(EsObjectRO parameters) {
        Properties props = new Properties();

        // Get the list of drivers, failing if necessary
        props.put("drivers", (String) validateAndReturnEsObjectEntry(parameters, "drivers", "string"));

        // Handle the log file if they set it
        if(parameters.variableExists("logfile")) {
            props.put("logfile", parameters.getString("logfile"));
        }

        // Get the pools, fail if not set
        EsObject[] pools = (EsObject[]) validateAndReturnEsObjectEntry(parameters, "pools", "EsObject array");

        // Iterate over all the pools
        for (EsObject poolParms : pools) {

            String poolName = (String) validateAndReturnEsObjectEntry(poolParms, "poolname", "string");

            // Allow them to specify an optional timeout
            if(poolParms.variableExists("timeout")) {
                defaultTimeout.put(poolName, poolParms.getInteger("timeout"));
            }

            props.put(poolName + ".url", (String) validateAndReturnEsObjectEntry(poolParms, "url", "string"));
            props.put(poolName + ".user", (String) validateAndReturnEsObjectEntry(poolParms, "user", "string"));
            props.put(poolName + ".password", (String) validateAndReturnEsObjectEntry(poolParms, "password", "string"));

            // rip through all the entries and get the optional parameters
            for (EsObjectEntry entry : poolParms) {
                
                // Get the entry, 
                String name = entry.getName();
                if (name.equals("poolname") || name.equals("url") || name.equals("user") || name.equals("password") || name.equals("timeout")) {
                    continue;
                }

                // Add the entry to the properties object
                props.put(poolName + "." + entry.getName(), entry.getRawValue().toString());
            }
        }

        // Create a new instance of the ConnectionPoolManager using the properties we just set
        ConnectionPoolManager.createInstance(props);
        
        // Get a new instance of it for use later
        try {
            manager = ConnectionPoolManager.getInstance();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    public Object acquireObject(EsObjectRO parameters) {       
        
        // Get the pool name, ensuring they passed it in
        String poolName = (String) validateAndReturnEsObjectEntry(parameters, "poolname", "string");

        // Determine which timeout variable to use
        // If it's been passed in, use that
        int timeout;
        if (parameters.variableExists("timeout")) {
            timeout = parameters.getInteger("timeout");
            
        // If it's not been passed in
        } else {
            
            // If there is a global default for this pool
            if (defaultTimeout.containsKey(poolName)) {
                timeout = defaultTimeout.get(poolName);
                
                // Otherwise let's use the global default in general
            } else {
                timeout = DEFAULT_TIMEOUT; // default to the global timeout
            }
        }

        // Attempt to get the connection
        Connection connection = null;
        try {
            connection = manager.getConnection(poolName, timeout);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        
        // Return the connection
        return connection;
    }

    public ManagedObjectFactoryApi getApi() {
        return api;
    }

    public void releaseObject(Object object) {
        
        // Ensure we were given something
        if(object == null) {
            throw new RuntimeException("The supplied object is null!");
        }
        
        // Ensure it's the right type of object
        if(!(object instanceof Connection)) {
            throw new RuntimeException("The supplied object is not of type Connection!");
        }
        
        // Cast back to the connection object
        Connection connection = (Connection) object;
        
        // Due to the bahavior of this pool, we simply need to close it
        try {
            
            // Close if necessary
            if(!connection.isClosed()) {
                connection.close();
            }
            
        } catch (SQLException e) {
            throw new RuntimeException("Error closing connection!", e);
        }
    }

    public void setApi(ManagedObjectFactoryApi api) {
        this.api = api;
    }

    public void destroy() {
        
        // Clean up the manager by releasing all connection pool resources
        manager.release();
    }
    
    private Object validateAndReturnEsObjectEntry(EsObjectRO esObject, String parmName, String parmType) {
        Object results = null;
        if(!esObject.variableExists(parmName)) {
            throw new RuntimeException("The '" + parmName + "' " + parmType + " variable was not defined - it is required!");
        } else {
            results = esObject.getRawVariable(parmName);
        }
        return results;
    }

}
