/**
* @File Name : CEConstants.cls
* @Description : This class is used to have constant values.
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
public without sharing class CEConstants {
    // String constant
    public static final String STATUS_ACTIVE = 'Active';
    public static final String PICKLIST_ALERT = 'Alert'; 
    public static final String PICKLIST_TERMINATE = 'Terminate Event';
    public static final String PERMISSIONSET_DESIGNATED = 'Capacity Emergency REMC User - Designated';
    public static final String USERTYPE_STANDARD = 'Standard';
    public static final String STATUS_INACTIVE = 'Inactive';  
    public static final String OBJ_CEEVENT = 'CEEvent__c';  
    public static final String OBJ_CEMEMBERLOAD = 'CEMemberLoad__c';
    public static final String OBJ_CEDIRECTIVE = 'CEDirective__c';
    public static final String OBJ_CEMEMBERRESPONSE = 'CEMemberResponse__c';
    public static final String OBJ_CEHISTORY = 'CEHistory__c';
    public static final String OBJ_CEUSER = 'User';
    public static final String OBJ_CEUSERPERMISSIONASSIGNMENT = 'PermissionSetAssignment';
    public static final String FLD_DIRECTIVESTEP = 'DirectiveStep__c';     
    public static final String FUNC_CREATEEVENT = 'CreateEvent';
    public static final String FUNC_GETLATESTDIRECTIVE = 'GetLatestDirective';
    public static final String FUNC_GETMEMBERRESPONSE = 'GetMemberResponse';
    public static final String FUNC_GETHISTORY = 'GetHistory';
    public static final String FUNC_GETUSERDETAILS = 'GetUserDetails';
    public static final String FUNC_GETUSERPERMISSIONASSIGNMENTSTD = 'GetUserPermissionAssignmentSTD';
    public static final String FUNC_GETUSERPERMISSIONASSIGNMENT = 'GetUserPermissionAssignment';
    public static final String FUNC_GETREMCCURTAILMENTRECORD = 'GetREMCCurtailmentRecord';
    public static final String MSG_NOFIELDSFOUND = 'No fields configured for retrieval.';
    public static final String QPARAM_USERID = 'userId';
    public static final String QPARAM_MEMBERCODE = 'memberCode';


  
    // Integer constant
    public static final Integer MAX_USERS = 100;
    
    // Boolean constant
    public static final Boolean IS_FEATURE_ENABLED = true;
    
    // Example of a constant representing an API endpoint
    public static final String API_ENDPOINT = 'https://api.example.com/v1/';
    
    // Example of a constant array
    public static final List<String> SUPPORTED_LANGUAGES = new List<String>{'en', 'es', 'fr', 'de'};
    
}