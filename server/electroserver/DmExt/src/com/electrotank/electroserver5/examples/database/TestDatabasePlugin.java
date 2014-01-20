package com.electrotank.electroserver5.examples.database;

import com.electrotank.electroserver5.extensions.BasePlugin;
import com.electrotank.electroserver5.extensions.api.PluginPrivateMessageResponse;
import com.electrotank.electroserver5.extensions.api.value.EsObject;
import com.electrotank.electroserver5.extensions.api.value.EsObjectRO;
import java.sql.SQLException;

/**
 * This plugin can be used to test that the DatabaseJDBCPlugin works correctly.
 * On a production application, you should NEVER include a request method that 
 * takes a query from a client, since that leaves your database open to SQL attacks.
 * 
 * You should also validate any strings in SQL that were created by clients, such as usernames, 
 * room names, zone names, etc. to avoid SQL injection attacks.
 * 
 * DatabaseJDBCPlugin must be a server level plugin.
 * 
 * To use this plugin to test without a client, it should also be a server level plugin.
 */
public class TestDatabasePlugin extends BasePlugin {

    public static final String QUERY = "query";
    private static final String TABLE_NAME = "users";
    private DatabaseJDBCPlugin databasePlugin;

    @Override
    public void init(EsObjectRO parameters) {
        getApi().getLogger().debug("TEST DATABSE PLUGIN");
        
        databasePlugin = (DatabaseJDBCPlugin) getApi().getServerPlugin("DatabaseJDBCPlugin");
        try {
            testQuery();
            //testInsert();
            //testDelete();
            //testUpdate();
        } catch (Exception e) {
            getApi().getLogger().debug("Error testing DatabasePlugin");
        }
    }

    @Override
    public void request(String username,
            EsObjectRO requestParameters) {
        getApi().getLogger().debug("TEST DATABSE PLUGIN QUERY: " + requestParameters.getString(QUERY));

        String query = requestParameters.getString(QUERY);
        if (query != null && query.length() > 0) {
            try {
                EsObject msg = databasePlugin.doQuery(query);
                PluginPrivateMessageResponse response = getApi().sendPluginMessageToUser(username, msg);
            } catch (SQLException ex) {
                getApi().getLogger().debug("SQLException for requested query: " + query);
            }
        }
    }
    
    private void parseFunctionXML() {
        
    }

    private void testQuery() throws SQLException {
        String query = "SELECT * FROM maps;";
        EsObject msg = databasePlugin.doQuery(query);
        String output = msg.toString();
        getApi().getLogger().debug(output);
    }

    private void testInsert() throws SQLException {
        EsObject[] array = new EsObject[2];
        EsObject name = new EsObject();
        name.setString(DatabaseJDBCPlugin.COLUMN, "username");
        name.setInteger(DatabaseJDBCPlugin.DATATYPE, java.sql.Types.VARCHAR);
        name.setString(DatabaseJDBCPlugin.VALUE, "athena");
        array[0] = name;

        EsObject password = new EsObject();
        password.setString(DatabaseJDBCPlugin.COLUMN, "password");
        password.setInteger(DatabaseJDBCPlugin.DATATYPE, java.sql.Types.VARCHAR);
        password.setString(DatabaseJDBCPlugin.VALUE, "passworda");
        array[1] = password;

        boolean result = databasePlugin.insertRow(TABLE_NAME, array);
        getApi().getLogger().debug("testInsert result = " + result);
        testQuery();
    }

    private void testDelete() throws SQLException {
        testQuery();
        String sql = "delete from " + TABLE_NAME + " where " +
                "username = 'athena'";
        boolean result = databasePlugin.executeSQL(sql);
        getApi().getLogger().debug("testDelete result = " + result);
        testQuery();
    }

    private void testUpdate() throws SQLException {
        testQuery();
        EsObject name = new EsObject();
        name.setString(DatabaseJDBCPlugin.COLUMN, "username");
        name.setInteger(DatabaseJDBCPlugin.DATATYPE, java.sql.Types.VARCHAR);
        name.setString(DatabaseJDBCPlugin.VALUE, "athena");

        EsObject newPassword = new EsObject();
        newPassword.setString(DatabaseJDBCPlugin.COLUMN, "password");
        newPassword.setInteger(DatabaseJDBCPlugin.DATATYPE, java.sql.Types.VARCHAR);
        newPassword.setString(DatabaseJDBCPlugin.VALUE, "NeWpAsS");

        boolean result = databasePlugin.updateField(TABLE_NAME, name, newPassword);
        getApi().getLogger().debug("testUpdate result = " + result);
        testQuery();
    }
}
