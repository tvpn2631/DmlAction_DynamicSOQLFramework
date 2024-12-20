/**
* @File Name : IDmlAction.cls
* @Description : This interface class is a method signature for DML Actions.
* @Author : Wilco
* @Last Modified By : Wilco
* @Last Modified On : November 22, 2024
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | November 22, 2024 |   | Initial Version
**/
public interface IDmlAction {
    /**
	 * Method to set for creating new sObject records.
	 *
	 * @param records A list of sObject records for creation.
	 */
    void createRecords(List<sObject> records);

    /**
	 * Method to set for creating new sObject records.
	 *
	 * @param record An sObject record for creation.
	 */
    void createRecord(sObject record);

    /**
	 * Method to set for modifying the sObject records.
	 *
	 * @param records A list of sObject records for updation.
	 */
    void updateRecords(List<sObject> records);

    /**
	 * Method to set for modifying the sObject records.
	 *
	 * @param record An sObject record for updation.
	 */
    void updateRecord(sObject record);
}