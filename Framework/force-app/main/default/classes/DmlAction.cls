/**
* @File Name : DmlAction.cls
* @Description : This class is inherits the IDmlAction interface and implement utility methods for 
*                executing  DML actions.
* @Author : Wilco
* @Last Modified By : Wilco
* @Last Modified On : November 22, 2024
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | November 22, 2024 |   | Initial Version
**/
public without sharing class DmlAction implements IDmlAction {
    
    /**
	 * Method to set for creating new sObject records.
	 *
	 * @param records A list of sObject records for creation.
	 */
    public static void createRecords(List<sObject> listRecords){
        Database.insert(listRecords, false);
    }

    
    /**
	 * Method to set for creating new sObject record.
	 *
	 * @param record An sObject record for creation.
	 */
    public static void createRecord(sObject record){
        Database.insert(record, false);
    }

    /**
	 * Method to set for modifying the sObject records.
	 *
	 * @param records A list of sObject records for updation.
	 */
    public static void updateRecords(List<sObject> listRecords){
        Database.update(listRecords, false);
    }

    /**
	 * Method to set for modifying the sObject record.
	 *
	 * @param record An sObject record for updation.
	 */
    public static void updateRecord(sObject record){
        Database.update(record, false);
    }

}