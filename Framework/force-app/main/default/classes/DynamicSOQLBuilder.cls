/**
* @File Name : DynamicSOQLBuilder.cls
* @Description : This class is inherits the IDynamicSOQL interface and implement utility methods for 
*                constructing and executing  dynamic SOQL queries.
* @Author : Wilco
* @Last Modified By : Wilco
* @Last Modified On : November 22, 2024
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | November 22, 2024 |   | Initial Version
**/
public without sharing class DynamicSOQLBuilder implements IDynamicSOQL {
    private static String sObjectType;
    private static List<String> fields = new List<String>();
    private static List<String> conditions = new List<String>();
    private static List<String> orderByFieldsRecordLimit = new List<String>();
    private static Map<String, Object> bindVars = new Map<String, Object>();
    
    /**
     * Method is to set a sObjecttype for building SOQL query.
     * 
     * @param objectType The Salesforce object type (e.g., 'Account', 'Contact')
     */
    public static void setObjectType(String objectType) {
        sObjectType = objectType;
    }
    
    /**
     * Method is to append field api for building SOQL query.
     * 
     * @param fieldName The field api name to select in the query.
     */
    public static void addField(String fieldName) {
        fields.add(fieldName);
    }

    /**
     * Method is to check the list has data or not.
     * 
     * @return boolean true if the list field is not empty.
     */
    public static boolean hasFields() {
        return !fields.isEmpty()? true : false;
    }
    
    /**
     * Method is to utilize for adding condition check for building SOQL query.
     * 
     * @param condition The field api name to declare in the query where clause.
     */
    public static void addCondition(String condition) {
        conditions.add(condition);
    }

    /**
     * Method is to utilize for adding condition check for building SOQL query.
     * 
     * @param condition The field api name to declare in the query where clause.
     */
    public static void bindVariable(String key, object value) {
        bindVars.put(key, value);
    }

    /**
     * Method is to utilize for adding order by clause for building SOQL query.
     * 
     * @param field The field api name to declare in the query .
     * @param order The string value is used to order the records asc,desc in the query .
     */
    public static void addOrderBy(String orderByFieldsandRecordLimit) {
        orderByFieldsRecordLimit.add(orderByFieldsandRecordLimit);
    }

    /**
     * Method is to utilize for adding order by clause for building SOQL query.
     * 
     * @param field The field api name to declare in the query .
     * @param order The string value is used to order the records asc,desc in the query .
     */
    public static void addOrderBy(String field, String order) {        
    }
    
    /**
     * Executes a dynamic SOQL query and returns a list of sObjects.
     *
     * @param queryString The queryString param is used to execute the dynamic query.
     * @return List<sObject> A list of sObjects that match the query results.
     */
    public static List<SObject> executeQuery(String queryString) { 
        List<SObject> results = new List<SObject>();
        if(!bindVars.isEmpty()){
            results = Database.queryWithBinds(queryString, bindVars, AccessLevel.SYSTEM_MODE);
        }else{
            results = Database.query(queryString);
        } 
        return results;
    }

    /**
     * Executes a dynamic SOQL query and returns a list of sObjects.
     *  
     * @return List<sObject> A list of sObjects that match the query results.
     */
    public static List<SObject> executeQuery() {
        String query = getQuery();
        List<SObject> results = executeQuery(query);
        return results;
    }
    
    /**
     * Builds a dynamic SOQL query based on the provided object type and fields.
     *    
     * @return String The constructed SOQL query string.
     */
    public static String getQuery() {
        // Start building the query
        String query = 'SELECT ' + String.join(fields, ', ') + ' FROM ' + sObjectType;
        
        // Append conditions if they exist
        if (!conditions.isEmpty()) {
            query += ' WHERE ' + String.join(conditions, ' AND ');
        }
        
        // Append ORDER BY clause if any
        if (!orderByFieldsRecordLimit.isEmpty()) {
            query += ' ORDER BY '+String.join(orderByFieldsRecordLimit, ', ');
        }
        system.debug(LoggingLevel.debug, query);
        return query;
    }

     /**
     * Method is used to clear all collection variables.
     *    
     */
    public static void clearUtilsVars() {
        fields.clear();
        conditions.clear();
        orderByFieldsRecordLimit.clear();
        bindVars.clear();
    }

}