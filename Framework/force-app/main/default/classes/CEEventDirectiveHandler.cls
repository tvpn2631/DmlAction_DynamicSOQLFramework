/**
* @File Name : CEEventDirectiveHandler.cls
* @Description :    * The CEEventDirectiveHandler class manages event directives and related operations.
                    * This class includes methods to handle new event directives, process directives after events,
                    * calculate curtailment required values, determine if the current date is in the summer period,
                    * and handle the termination of events. It ensures that directives and events are updated
                    * appropriately based on their status and the current date.
                    
                    * Methods:
                    * - handleNewEventDirective: Updates the status and end time of active directives.
                    * - processAfterEvents: Sets the isRecursive flag based on directive steps.
                    * - calculateCurtailmentRequiredValue: Calculates curtailment values for directives.
                    * - isCurrentDateSummer: Checks if the current date is within the summer period.
                    * - handleTerminateEventNew: Updates the status and end time of an event.
                    * This class is designed to be used in scenarios where event directives need to be managed
                    * efficiently, ensuring accurate updates and calculations based on business logic.

* @Author : Wilco
* @Last Modified By : Wilco
* @Last Modified On : 
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 |  |   | Initial Version
**/

public class CEEventDirectiveHandler {

    public static Boolean isRecursive = false;
        
        /**
        * Handles the new event directive by updating the status and end time of active directives.
        * This method retrieves all active directives, sets their end time to the current system time,
        * changes their status to inactive, and updates the records in the database.
        **/
        public static void handleNewEventDirective() {
            Set<Id> newDirectiveIds = new Set<Id>();
        
            List<CEDirective__c> activeDirectives = [SELECT Id, EndTime__c, Status__c 
                                                     FROM CEDirective__c 
                                                     WHERE Status__c = 'Active' 
                                                     ];    
            for (CEDirective__c dir: activeDirectives) {
                dir.EndTime__c = System.now();
                dir.Status__c = CEConstants.STATUS_INACTIVE;
            }    
            if (!activeDirectives.isEmpty()) {
                DmlAction.updateRecords(activeDirectives);
            }
        }   
        
        /**
         * Processes the given list of directives after events.
         * This method checks if the first directive in the list has a specific directive step.
         * If the directive step matches 'Event Step 5 EEA3', it sets the isRecursive flag to true.
        **/
        public static void processAfterEvents(List<CEDirective__c> directives) {
            if(directives[0].DirectiveStep__c == 'Event Step 5 EEA3'){
                CEEventDirectiveHandler.isRecursive = true;                
            }              
        } 

        /**
         * Calculates the curtailment required value for a given directive.
         * This method processes member load and response records to calculate the curtailment required
         * based on whether the current date is in summer or winter. It updates or creates member response
         * records with the calculated curtailment values.
        **/    
        public static void calculateCurtailmentRequiredValue(CEDirective__c directive) {
    
            List<CEMemberResponse__c> responsesToProcess = new List<CEMemberResponse__c>();
            Map<Id, CEMemberResponse__c> mapMemberResponses = new map<Id, CEMemberResponse__c>();
            List<CEMemberLoad__c> listMemberLoad = new List<CEMemberLoad__c>();
            Map<Id, CEMemberLoad__c> mapMemberLoad = new Map<Id, CEMemberLoad__c>();
            MemberLoadCalculation__c summation = MemberLoadCalculation__c.getOrgDefaults();
            Decimal sumTotalSummer = summation != null ? summation.SumTotalSummer__c : 0;
            Decimal sumTotalWinter = summation != null ? summation.SumTotalWinter__c : 0;
    
            // Determine if the current date is in summer or winter
            Boolean isSummer = isCurrentDateSummer();
            Boolean isWinter = !isSummer;
            System.debug(LoggingLevel.DEBUG,' record id '+ directive);
            // If no directives match the condition, exit the method
            if (directive == null) {
                return;
            }    
            
            for(CEMemberLoad__c memLoad : [SELECT Id, MemberSystem__c, WinterLoadKWh__c, SummerLoadKWh__c, 
                                            Active__c, PercentOnHELBA__c, MemberAccount__c, MemberAccount__r.Name 
                                            FROM CEMemberLoad__c 
                                            WHERE Active__c = true Order By MemberSystem__c]){
                 mapMemberLoad.put(memLoad.MemberAccount__c, memLoad);    
            }            
            System.debug(LoggingLevel.DEBUG,' mapMemberLoad '+  mapMemberLoad);
            
            for(CEMemberResponse__c memResponse : [Select Id, MemberCoop__c, MemberCoop__r.REMC_Abbreviation__c, CurtailmentRequired__c from CEMemberResponse__c where CEDirective__c =: directive.Id and CEDirective__r.DirectiveStep__c = 'Event Step 5 EEA3' and CEDirective__r.Status__c = 'Active' order by Createddate desc, MemberCoop__r.REMC_Abbreviation__c asc limit 18]){
                mapMemberResponses.put(memResponse.MemberCoop__c, memResponse);
            }    
            
                for (Id recId : mapMemberLoad.keyset()) {
                    CEMemberLoad__c memberLoadRec = mapMemberLoad.get(recId);
                    CEMemberResponse__c response = mapMemberResponses.containsKey(recId)? mapMemberResponses.get(recId) : new CEMemberResponse__c();
                   
                    if(response.Id == null){
                        response.CEDirective__c = directive.Id;
                        response.MemberCoop__c = memberLoadRec.MemberAccount__c;
                    }
                    
                    if (isSummer) {
                        if (memberLoadRec.SummerLoadKWh__c != null && directive.CurtailmentRequired__c != null && sumTotalSummer != 0) {
                            response.CurtailmentRequired__c = (memberLoadRec.SummerLoadKWh__c * (memberLoadRec.PercentOnHELBA__c != null ? memberLoadRec.PercentOnHELBA__c : 0) * directive.CurtailmentRequired__c) / sumTotalSummer;
                            response.CurtailmentRequired__c = response.CurtailmentRequired__c.setScale(2);
                        } else {
                            response.CurtailmentRequired__c = 0;
                        }
                    } else if (isWinter) {
                        if (memberLoadRec.WinterLoadKWh__c != null && directive.CurtailmentRequired__c != null && sumTotalWinter != 0) {
                            response.CurtailmentRequired__c = (memberLoadRec.WinterLoadKWh__c * (memberLoadRec.PercentOnHELBA__c != null ? memberLoadRec.PercentOnHELBA__c : 0) * directive.CurtailmentRequired__c) / sumTotalWinter;
                            response.CurtailmentRequired__c = response.CurtailmentRequired__c.setScale(2);
                        } else {
                            response.CurtailmentRequired__c = 0;
                        }
                    }        
                    responsesToProcess.add(response);          
                }
          
            System.debug(LoggingLevel.DEBUG,' 18 records '+responsesToProcess);
            if(!mapMemberResponses.isEmpty()){
                DmlAction.updateRecords(responsesToProcess);
            }else if (!responsesToProcess.isEmpty()) {
                DmlAction.createRecords(responsesToProcess);
            }
        }

        /**
         * Determines if the current date falls within the summer period.         * 
         * This method checks if today's date is within the defined summer period (April 16 to November 15)
         * or the winter period (November 16 to April 15 of the following year).
         * It returns true if the date is within the summer period, and false otherwise.
         */        
        public static Boolean isCurrentDateSummer() {
            Date today = Date.today();
            Integer currentYear = today.year();            
            Date summerStart = Date.newInstance(currentYear, 4, 16);
            Date summerEnd = Date.newInstance(currentYear, 11, 15);
            Date winterStart = Date.newInstance(currentYear, 11, 16);
            Date winterEnd = Date.newInstance(currentYear + 1, 4, 15);
        
            if ((today >= summerStart && today <= summerEnd) || (today >= winterStart && today <= winterEnd)) {
                return today >= summerStart && today <= summerEnd;
            }
            return false;
        }
        
        /**
         * Handles the termination of an event by updating its status and end time.         * 
         * This method takes an event Id, retrieves the corresponding event record, sets its end time to the current system time,
         * changes its status to inactive, and updates the record in the database.
         */        
        public static void handleTerminateEventNew(Id eventId) {  
            system.debug(LoggingLevel.debug, eventId);
            if (eventId != null) {            
                CEEvent__c relatedEvent = new CEEvent__c();
                relatedEvent.id = eventId;               
                relatedEvent.EndTime__c = System.now();
                relatedEvent.Status__c = CEConstants.STATUS_INACTIVE;   
                DmlAction.updateRecord(relatedEvent); 
                system.debug(LoggingLevel.debug, relatedEvent);
            }
        }
}