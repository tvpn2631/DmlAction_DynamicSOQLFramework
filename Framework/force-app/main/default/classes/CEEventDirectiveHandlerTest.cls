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
public class CEEventDirectiveHandlerTest {
    @isTest
    static void testHandleNewEventDirective() {
        // Create a test CEEvent__c record with required fields
        CEEvent__c testEvent = new CEEvent__c();		
        insert testEvent;		     

        // Create test data for CEDirective__c with required fields
        List<CEDirective__c> directives = new List<CEDirective__c>();
        for (Integer i = 0; i < 5; i++) {
            directives.add(new CEDirective__c(
                CEEvent__c = testEvent.Id,
                Status__c = 'Active',
                EndTime__c = Datetime.valueOf('2024-12-16 13:57:36')
            ));
        }       
        insert directives;

        // Call the method to test
        Test.startTest();
        CEEventDirectiveHandler.handleNewEventDirective();
        Test.stopTest();

        // Verify the results
        directives = [SELECT Id, EndTime__c, Status__c FROM CEDirective__c WHERE Id IN :directives];
        for (CEDirective__c dir : directives) {
            System.assertEquals(CEConstants.STATUS_INACTIVE, dir.Status__c);
            System.assertNotEquals(null, dir.EndTime__c);
        }
    }

    @isTest
    static void testProcessAfterEvents() {
        // Create test data for CEDirective__c with required fields
        List<CEDirective__c> directives = new List<CEDirective__c>();
        directives.add(new CEDirective__c(
            DirectiveStep__c = 'Event Step 5 EEA3'
            // Populate other required fields here
        ));
        directives.add(new CEDirective__c(
            DirectiveStep__c = 'Other Step'
            // Populate other required fields here
        ));

        // Call the method to test
        Test.startTest();
        CEEventDirectiveHandler.processAfterEvents(directives);
        Test.stopTest();

        // Verify the results
        System.assertEquals(true, CEEventDirectiveHandler.isRecursive);
    }

    @isTest
    static void testCalculateCurtailmentRequiredValue() {
        // Create a test MemberLoadCalculation__c record with required fields
        MemberLoadCalculation__c summation = new MemberLoadCalculation__c(
            Name = '1',
            SumTotalSummer__c = 1000,
            SumTotalWinter__c = 2000
            // Populate other required fields here
        );
        insert summation;
		
        CEEvent__c testEvent = new CEEvent__c();
        insert testEvent;
        
        // Create a test CEDirective__c record with required fields
        CEDirective__c directive = new CEDirective__c(
            CEEvent__c = testEvent.Id,
            CurtailmentRequired__c = 10,
            DirectiveStep__c = 'Event Step 5 EEA3',
            Status__c = 'Active'            
        );
        insert directive;

        // Create test data for Account with required fields
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            accounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert accounts;

        // Create test data for CEMemberLoad__c with required fields
        List<CEMemberLoad__c> memberLoads = new List<CEMemberLoad__c>();
        for (Account acc : accounts) {
            memberLoads.add(new CEMemberLoad__c(
                Name = 'Test Name',
                WinterLoadKWh__c = 100,
                SummerLoadKWh__c = 200,
                Active__c = true,
                PercentOnHELBA__c = 0.5,
                MemberAccount__c = acc.Id
                // Populate other required fields here
            ));
        }
        insert memberLoads;

                // Create test data for CEMemberResponse__c with required fields
            List<CEMemberResponse__c> memberResponses = new List<CEMemberResponse__c>();
            for (CEMemberLoad__c load : memberLoads) {
                memberResponses.add(new CEMemberResponse__c(
                    MemberCoop__c = load.MemberAccount__c,
                    CEDirective__c = directive.Id,
                    CurtailmentRequired__c = 0
                    // Populate other required fields here
                ));
            }
        	insert memberResponses;

        // Call the method to test
        Test.startTest();
        CEEventDirectiveHandler.calculateCurtailmentRequiredValue(directive);
        Test.stopTest();

        // Verify the results
        memberResponses = [SELECT Id, CurtailmentRequired__c FROM CEMemberResponse__c WHERE CEDirective__c = :directive.Id];
        for (CEMemberResponse__c response : memberResponses) {
            System.assert(response.CurtailmentRequired__c != 0, 'CurtailmentRequired__c should be updated');
        }
    }
     @isTest
    static void testHandleTerminateEventNew() {
        // Create test data
        CEEvent__c event = new CEEvent__c();
        insert event;

        // Call the method
        Test.startTest();
        CEEventDirectiveHandler.handleTerminateEventNew(event.Id);
        Test.stopTest();

        // Verify the results
        CEEvent__c updatedEvent = [SELECT Id, EndTime__c, Status__c FROM CEEvent__c WHERE Id = :event.Id];
        System.assertEquals(CEConstants.STATUS_INACTIVE, updatedEvent.Status__c);
        System.assertNotEquals(null, updatedEvent.EndTime__c);
    }
}