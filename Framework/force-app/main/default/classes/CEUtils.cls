/**
* @File Name : CEUtils.cls
* @Description : This class is used to have common methods.
*
* @Author : Wilco
* @Last Modified By : Wilco
* @Last Modified On : November 27, 2024
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | November 27, 2024 |   | Initial Version
**/
public without sharing class CEUtils {
    
    public static Map<String, Object> bindVars = new Map<String, Object>();

    /**
	 * Method is to fetch list of records.
	 *
     * @param objectName the name of object for SOQL query
     * @param functionalityName the name of current functionality
     * 
	 * @return list of records if found.
	 */
    public static List<SObject> getDetails(String objectName, String functionalityName){
       
        List<SObject> records = new List<SObject>();

        DynamicSOQLBuilder.clearUtilsVars();
        
        // Check if there are not blank 
        if(String.isBlank(objectName) || String.isBlank(functionalityName)){
            return null;
        }

        // Retrieve custom metadata records for the specified object
        List<SOQLFieldConfig__mdt> configs = [
            SELECT FieldName__c 
            FROM SOQLFieldConfig__mdt 
            WHERE ObjectName__c = :objectName AND FunctionalityName__c = :functionalityName AND Queryable__c = true
        ];
        
        // Build the field list for the SOQL query       
        for (SOQLFieldConfig__mdt config : configs) {
            DynamicSOQLBuilder.addField(config.FieldName__c);
        }

        // Check if there are any fields to query
        if (!DynamicSOQLBuilder.hasFields()) {
            System.debug(LoggingLevel.DEBUG, CEConstants.MSG_NOFIELDSFOUND);
            return null;
        }
        
        // Retrieve custom metadata records for the specified object
        List<SOQLConditionConfig__mdt> conditionConfigs = [
            SELECT WhereClause__c  
            FROM SOQLConditionConfig__mdt 
            WHERE ObjectName__c = :objectName AND FunctionalityName__c = :functionalityName AND Queryable__c = true
        ];
        
        // Build the where clause condition list for the SOQL query       
        for (SOQLConditionConfig__mdt config : conditionConfigs) {
            DynamicSOQLBuilder.addCondition(config.WhereClause__c);
        }

         // Retrieve custom metadata records for the specified object
         List<SOQLOrderByandLimit__mdt> orderByLimitConfigs = [
            SELECT OrderByandLimit__c  
            FROM SOQLOrderByandLimit__mdt 
            WHERE ObjectName__c = :objectName AND FunctionalityName__c = :functionalityName AND Queryable__c = true
        ];
        
        // Build the where clause condition list for the SOQL query       
        for (SOQLOrderByandLimit__mdt config : orderByLimitConfigs) {
            DynamicSOQLBuilder.addOrderBy(config.OrderByandLimit__c);
        }
        
        if(orderByLimitConfigs.isEmpty()){            
            DynamicSOQLBuilder.addOrderBy('CreatedDate', 'asc');
        }
        
        DynamicSOQLBuilder.setObjectType(objectName);
        
        for(string key : bindVars.keySet()){
            DynamicSOQLBuilder.bindVariable(key, bindVars.get(key));
        }

        // Execute the dynamic SOQL query
        return records = DynamicSOQLBuilder.executeQuery();        
       
       
    }

    
    /**
	 * Method is to return picklist option.
	 *
     * @param objectName the name of object for SOQL query
     * @param fieldName the picklist api field name.
     * 
	 * @return list of string if found .
	 */	
	@AuraEnabled(cacheable=true)
    public static List<String> getPicklistValues(String objectName, String fieldName ) {
        List<String> picklistValues = new List<String>();
        
        // Create schema describe info for the object
        Schema.DescribeSObjectResult describeResult = Schema.getGlobalDescribe().get(objectName).getDescribe();
        // Get the field describe info for the specified field
        Schema.DescribeFieldResult fieldResult = describeResult.fields.getMap().get(fieldName).getDescribe();
        
        // Check if the field is a picklist and retrieve the values
        if (fieldResult.getType() == Schema.DisplayType.Picklist) {
            for (Schema.PicklistEntry entry : fieldResult.getPicklistValues()) {
                picklistValues.add(entry.getLabel());
            }
        }
        
        return picklistValues;
    }
    
}