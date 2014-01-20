package com.electrotank.electroserver5.examples.database;

import com.electrotank.electroserver5.extensions.BasePlugin;
import com.electrotank.electroserver5.extensions.api.value.EsObject;
import com.electrotank.electroserver5.extensions.api.value.EsObjectRO;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DatabaseJDBCPlugin extends BasePlugin {

    public static final String ERROR = "error";
    public static final String RESULTS = "results";
    public static final String POOLNAME = "poolname";
    public static final String DATATYPE = "type";
    public static final String COLUMN = "col";
    public static final String VALUE = "value";
    private String poolname;

    @Override
    public void init(EsObjectRO parameters) {

        poolname = parameters.getString(POOLNAME);
        getApi().getLogger().debug("using database pool: " + poolname);

    }

    /**
     * Executes any valid read only SQL query on the database, returning a
     * ResultSet.
     *
     * WARNING: Don't use this with any String that comes from a client because
     * it would run the risk of an SQL injection attack.
     *
     * @param query valid SQL query
     * @return ResultSet from the query, as an EsObject
     */
    public EsObject doQuery(String query) throws SQLException {
        getApi().getLogger().debug("Query called with string: " + query);
        EsObject resultSetObj = new EsObject();
        Connection con = null;
        try {
            EsObject esDB = new EsObject();
            esDB.setString(POOLNAME, poolname);

            con = (Connection) getApi().acquireManagedObject("ManagedConnectionPool", esDB);
//            getApi().getLogger().debug("Connection established");
            Statement stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
//            getApi().getLogger().debug("Statement built");
            ResultSet answer = null;
            answer = stmt.executeQuery(query);
//            getApi().getLogger().debug("Query executed");
            if (answer != null) {
                resultSetObj = resultSetToEsObject(answer);
            }
        } catch (SQLException ex) {
            getApi().getLogger().debug("SQL exception: " + ex.getMessage());
            Logger.getLogger(DatabaseJDBCPlugin.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            if (con != null) {
                con.close();
            }
            return resultSetObj;
        }
    }

    /**
     * Inserts a row into a database table. The EsObject[] parameters contains
     * the data to be inserted, with each column value stored as a separate
     * EsObject. Each EsObject will have one variable named DATATYPE with
     * integer value of java.sql.Types.INTEGER, java.sql.Types.VARCHAR,
     * java.sql.Types.DOUBLE or java.sql.Types.BOOLEAN. It will have a second
     * variable named COLUMN, with the name of the column. The third variable is
     * named VALUE, with the value to be stored in that column.
     *
     * WARNING: If a String parameter comes from a client it needs to be
     * validated before being used here or it would run the risk of an SQL
     * injection attack.
     *
     * @param tableName name of the database table
     * @param obj EsObject[] containing the data for the row to be inserted
     * @return true for successful insertion
     */
    public boolean insertRow(String tableName, EsObject[] parameters) throws SQLException {

        EsObject esDB = new EsObject();
        esDB.setString(POOLNAME, poolname);
        Connection con = null;

        String insertString = buildInsertString(tableName, parameters);
        if (insertString == null) {
            return false;
        }

        try {
            con = (Connection) getApi().acquireManagedObject("ManagedConnectionPool", esDB);
            Statement stmt = con.createStatement();
            int rows = stmt.executeUpdate(insertString);
            if (con != null) {
                con.close();
            }
            return rows > 0;
        } catch (Exception exception) {
            getApi().getLogger().debug("Error attempting to insert: " + insertString);
            if (con != null) {
                con.close();
            }
            return false;
        }
    }

    /**
     * Updates a single field of a row in a database. Each EsObject (key, field)
     * will have one variable named DATATYPE with integer value of
     * java.sql.Types.INTEGER, java.sql.Types.VARCHAR, java.sql.Types.DOUBLE or
     * java.sql.Types.BOOLEAN. It will have a second variable named COLUMN, with
     * the name of the column. The third variable is named VALUE, with the value
     * of that column (current value for the key, value to be stored for the
     * field).
     *
     * WARNING: If a String parameter comes from a client it needs to be
     * validated before being used here or it would run the risk of an SQL
     * injection attack.
     *
     * @param tableName name of the table
     * @param key EsObject used to identify the row(s) to update
     * @param field EsObject giving the value to store in the field
     * @return true if no errors occurred
     */
    public boolean updateField(String tableName, EsObject key, EsObject field) throws SQLException {
        ResultSet resultSet = null;
        Connection con = null;
        try {
            EsObject esDB = new EsObject();
            esDB.setString(POOLNAME, poolname);
            con = (Connection) getApi().acquireManagedObject("ManagedConnectionPool", esDB);
            Statement stmt = con.createStatement(ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_UPDATABLE);

            String keyName = key.getString(COLUMN);
            String keyValue = getValueString(key);
            String fieldName = field.getString(COLUMN);
            String query = "select " + keyName + ", " + fieldName + " from " + tableName
                    + " where " + keyName + " = " + keyValue;
            resultSet = stmt.executeQuery(query);
            while (resultSet.next()) {
                int fieldType = field.getInteger(DATATYPE);
                switch (fieldType) {
                    case Types.INTEGER:
                        resultSet.updateInt(fieldName, field.getInteger(VALUE));
                        break;
                    case Types.VARCHAR:
                        resultSet.updateString(fieldName, field.getString(VALUE));
                        break;
                    case Types.DOUBLE:
                        resultSet.updateDouble(fieldName, field.getDouble(VALUE));
                        break;
                    case Types.BOOLEAN:
                        resultSet.updateBoolean(fieldName, field.getBoolean(VALUE));
                        break;
                    // there are lots more possible Types we could add here
                }
                resultSet.updateRow();
            }
            if (con != null) {
                con.close();
            }
            return true;
        } catch (Exception ex) {
            try {
                if (resultSet != null) {
                    resultSet.cancelRowUpdates();
                }
                if (con != null) {
                    con.close();
                }
                return false;
            } catch (Exception ex1) {
                if (con != null) {
                    con.close();
                }
                return false;
            }
        }
    }

    /**
     * Executes any valid SQL command on the database.
     *
     * WARNING: Don't use this with any String that comes from a client because
     * it would run the risk of an SQL injection attack.
     *
     * @param sqlCommand
     * @return true if no errors occurred
     */
    public boolean executeSQL(String sqlCommand) throws SQLException {
        EsObject esDB = new EsObject();
        esDB.setString(POOLNAME, poolname);
        Connection con = null;
        try {
            con = (Connection) getApi().acquireManagedObject("ManagedConnectionPool", esDB);
            Statement stmt = con.createStatement();
            stmt.execute(sqlCommand);
            if (con != null) {
                con.close();
            }
            return true;
        } catch (Exception exception) {
            getApi().getLogger().debug("Error attempting to execute SQL: " + sqlCommand);
            if (con != null) {
                con.close();
            }
            return false;
        }
    }

    private String getValueString(EsObject obj) {
        String valueString = "";
        int columnType = obj.getInteger(DATATYPE);
        switch (columnType) {
            case Types.INTEGER:
                valueString += obj.getInteger(VALUE);
                break;
            case Types.VARCHAR:
                valueString += "'" + obj.getString(VALUE) + "'";
                break;
            case Types.DOUBLE:
                valueString += obj.getDouble(VALUE);
                break;
            case Types.BOOLEAN:
                valueString += obj.getBoolean(VALUE);
                break;
            // there are lots more possible Types we could add here
            }
        return valueString;
    }

    private String buildInsertString(String tableName, EsObject[] parameters) {
        String insertString = "insert into " + tableName;
        String columnString = " (";
        String valueString = " (";

        for (int i = 0; i < parameters.length; i++) {
            if (i > 0) {
                columnString += ", ";
                valueString += ", ";
            }
            try {
                EsObject obj = parameters[i];
                String thisCol = obj.getString(COLUMN);
                columnString += thisCol;
                valueString += getValueString(obj);
            } catch (Exception exception) {
                getApi().getLogger().debug("Error reading column " + i);
                return null;
            }
        }
        insertString += columnString + ") values " + valueString + ")";
        return insertString;
    }

    /**
     * Converts a ResultSet to an EsObject containing an array of EsObjects, one
     * for each row of the ResultSet.
     *
     * @param resultSet ResultSet from a query
     * @return EsObject with the data from the ResultSet
     */
    private EsObject resultSetToEsObject(ResultSet resultSet) {
        EsObject obj = new EsObject();
        Vector<EsObject> list = new Vector<EsObject>();
        try {
            ResultSetMetaData metadata = resultSet.getMetaData();
            int numColumns = metadata.getColumnCount();
            while (resultSet.next()) {
                EsObject thisObj = new EsObject();
                for (int i = 1; i <= numColumns; i++) {
                    String columnName = metadata.getColumnName(i);
                    int columnType = metadata.getColumnType(i);
                    switch (columnType) {
                        case Types.INTEGER:
                            thisObj.setInteger(columnName, resultSet.getInt(i));
                            break;
                        case Types.VARCHAR:
                            thisObj.setString(columnName, resultSet.getString(i));
                            break;
                        case Types.DOUBLE:
                            thisObj.setDouble(columnName, resultSet.getDouble(i));
                            break;
                        case Types.BOOLEAN:
                            thisObj.setBoolean(columnName, resultSet.getBoolean(i));
                            break;
                        // there are lots more possible Types we could add here
                    }
                }
                list.add(thisObj);
            }
            EsObject[] array = new EsObject[list.size()];
            array = list.toArray(array);
            obj.setEsObjectArray(RESULTS, array);
        } catch (SQLException ex) {
            getApi().getLogger().debug("Error trying to read the ResultSet.");
            obj.setString(ERROR, "Error trying to read the ResultSet.");
        }
        return obj;
    }
}
