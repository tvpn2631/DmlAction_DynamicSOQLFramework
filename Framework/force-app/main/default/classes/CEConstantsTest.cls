/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
public class CEConstantsTest {
    @isTest
    static void testConstants() {
        // String constants
        System.assertEquals('Active', CEConstants.STATUS_ACTIVE);
        System.assertEquals('Alert', CEConstants.PICKLIST_ALERT);
        System.assertEquals('Terminate Event', CEConstants.PICKLIST_TERMINATE);
        System.assertEquals('Inactive', CEConstants.STATUS_INACTIVE);
        System.assertEquals('CEEvent__c', CEConstants.OBJ_CEEVENT);
        System.assertEquals('CEMemberLoad__c', CEConstants.OBJ_CEMEMBERLOAD);
        System.assertEquals('CEDirective__c', CEConstants.OBJ_CEDIRECTIVE);
        System.assertEquals('CEMemberResponse__c', CEConstants.OBJ_CEMEMBERRESPONSE);
        System.assertEquals('CEHistory__c', CEConstants.OBJ_CEHISTORY);
        System.assertEquals('User', CEConstants.OBJ_CEUSER);
        System.assertEquals('PermissionSetAssignment', CEConstants.OBJ_CEUSERPERMISSIONASSIGNMENT);
        System.assertEquals('DirectiveStep__c', CEConstants.FLD_DIRECTIVESTEP);
        System.assertEquals('CreateEvent', CEConstants.FUNC_CREATEEVENT);
        System.assertEquals('GetLatestDirective', CEConstants.FUNC_GETLATESTDIRECTIVE);
        System.assertEquals('GetMemberResponse', CEConstants.FUNC_GETMEMBERRESPONSE);
        System.assertEquals('GetHistory', CEConstants.FUNC_GETHISTORY);
        System.assertEquals('GetUserDetails', CEConstants.FUNC_GETUSERDETAILS);
        System.assertEquals('GetUserPermissionAssignment', CEConstants.FUNC_GETUSERPERMISSIONASSIGNMENT);
        System.assertEquals('No fields configured for retrieval.', CEConstants.MSG_NOFIELDSFOUND);

        // Integer constant
        System.assertEquals(100, CEConstants.MAX_USERS);

        // Boolean constant
        System.assertEquals(true, CEConstants.IS_FEATURE_ENABLED);

        // String constant representing an API endpoint
        System.assertEquals('https://api.example.com/v1/', CEConstants.API_ENDPOINT);

        // List constant
        List<String> expectedLanguages = new List<String>{'en', 'es', 'fr', 'de'};
        System.assertEquals(expectedLanguages, CEConstants.SUPPORTED_LANGUAGES);
    }
}