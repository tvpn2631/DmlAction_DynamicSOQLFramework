/**
* @File Name : CECreateEventandDirective.cls
* @Description : This class is used to create event, event directives and 
*                also reterive latest event information.
* @Author : Wilco
* @Last Modified By : Wilco
* @Last Modified On : November 27, 2024
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | November 27, 2024 |   | Initial Version
**/
public without sharing class CECreateEventandDirective {
    
    public static List<CEEvent__c> listEventRecords = new List<CEEvent__c>();
    public static List<CEDirective__c> listDirectiveRecords = new List<CEDirective__c>();

    /**
	 * Method to check the active event exist.
	 *
	 * @return boolean true if found the active event.
	 */
    @AuraEnabled
    public static List<CEEvent__c> getActiveEvent(){
       listEventRecords = CEUtils.getDetails(CEConstants.OBJ_CEEVENT, CEConstants.FUNC_CREATEEVENT);
       if(!listEventRecords.isEmpty()){
        return listEventRecords;
       }
       return null;
    }

    /**
	 * Method is used to create new event.
	 *
	 */
    @AuraEnabled
    public static void createEvent(Boolean isDrill){
        CEEvent__c event = new CEEvent__c();
        event.Drill__c = isDrill;
        event.Status__c = CEConstants.STATUS_ACTIVE;
        DmlAction.createRecord(event);
        
    }

    /**
	 * Method  is to fetch the active event directive.
	 *
	 * @return list if found the active event directive.
	 */
    @AuraEnabled
    public static List<CEDirective__c> getLastEventDirective(){
        listDirectiveRecords = CEUtils.getDetails(CEConstants.OBJ_CEDIRECTIVE, CEConstants.FUNC_GETLATESTDIRECTIVE);
       if(!listDirectiveRecords.isEmpty()){            
            return listDirectiveRecords;
            
       }
       return null;
        
    }

    /**
	 * Method  is to fetch the member response data.
	 *
	 * @return list if found the member response.
	 */
    @AuraEnabled
    public static List<CEMemberResponse__c> getMemberResponse(){
        List<CEMemberResponse__c>  listMemberResponse = CEUtils.getDetails(CEConstants.OBJ_CEMEMBERRESPONSE, CEConstants.FUNC_GETMEMBERRESPONSE);
       if(!listMemberResponse.isEmpty()){            
            return listMemberResponse;
            
       }
       return null;
        
    }

     /**
	 * Method  is to fetch the member response data.
	 *
	 * @return list if found the member response.
	 */
    @AuraEnabled
    public static List<CEHistory__c> getHistory(){
        List<CEHistory__c>  listHistory = CEUtils.getDetails(CEConstants.OBJ_CEHISTORY, CEConstants.FUNC_GETHISTORY);
       if(!listHistory.isEmpty()){            
            return listHistory;
            
       }
       return null;
        
    }

    /**
	 * Method is to create new event directive record.
	 *
	 * @return string if new active event directive is created.
	 */
    @AuraEnabled
    public static String createEventDirective(String ceEventId, String ceDirectiveId, String ceCurtailmentAmount, String ceDirectiveStep){
        CEDirective__c directiveRec = new CEDirective__c();        
        directiveRec.CurtailmentRequired__c = decimal.valueOf(ceCurtailmentAmount);
        system.debug(LoggingLevel.debug, ' ceDirectiveId '+ ceDirectiveId);
        if(String.isNotBlank(ceDirectiveId)){
            directiveRec.Id = ceDirectiveId;
            DmlAction.updateRecord(directiveRec);            
        }else{
            system.debug(LoggingLevel.debug, ceEventId);
            if(ceDirectiveStep == CEConstants.PICKLIST_TERMINATE){
                CEEventDirectiveHandler.handleTerminateEventNew(ceEventId);
            }
            directiveRec.Status__c = ceDirectiveStep == CEConstants.PICKLIST_TERMINATE ? CEConstants.STATUS_INACTIVE: CEConstants.STATUS_ACTIVE;            
            directiveRec.CEEvent__c = ceEventId;
            directiveRec.DirectiveStep__c = ceDirectiveStep;
            CEEventDirectiveHandler.handleNewEventDirective();
            DmlAction.createRecord(directiveRec);                    
        }
        if(ceDirectiveStep == 'Event Step 5 EEA3'){
            CEEventDirectiveHandler.calculateCurtailmentRequiredValue(directiveRec);
        }
        return '';
    }
   
    
    /**
	 * Method is to return picklist option.
	 *    
	 * @return list of string if found .
	 */	
    @AuraEnabled(cacheable=true)
    public static List<String> getPicklistValues() {
        return CEUtils.getPicklistValues(CEConstants.OBJ_CEDIRECTIVE, CEConstants.FLD_DIRECTIVESTEP);
    }


     /**
	 * Method is to return current user details.
	 *    
	 * @return user details if found .
	 */	
    @AuraEnabled
    public static List<User> getCurrentUserDetails() {
        CEUtils.bindVars.put('userId', UserInfo.getUserId());
        List<User> listUser = CEUtils.getDetails(CEConstants.OBJ_CEUSER, CEConstants.FUNC_GETUSERDETAILS);
        if(!listUser.isEmpty()){
            return listUser;
        }
        return null;
    }

     /**
	 * Method is to return current user details.
	 *    
	 * @return user details if found .
	 */	
    @AuraEnabled
    public static List<PermissionSetAssignment> getCurrentUserPermissionDetails() {
        String conditionParam = UserInfo.getUserType() == CEConstants.USERTYPE_STANDARD ? CEConstants.FUNC_GETUSERPERMISSIONASSIGNMENTSTD : CEConstants.FUNC_GETUSERPERMISSIONASSIGNMENT;
        CEUtils.bindVars.put(CEConstants.QPARAM_USERID, UserInfo.getUserId()); 
        List<PermissionSetAssignment> listUserPermissionAssignment = CEUtils.getDetails(CEConstants.OBJ_CEUSERPERMISSIONASSIGNMENT, CEConstants.FUNC_GETUSERPERMISSIONASSIGNMENT);
        if(!listUserPermissionAssignment.isEmpty()){
            return listUserPermissionAssignment;
        }
        return null;
    }

    /**
	 * Method is to return current user details.
	 *    
	 * @return user details if found .
	 */	
    @AuraEnabled
    public static List<CEMemberResponse__c> getREMCCurtailmentRecord() {
        List<PermissionSetAssignment> listUserPermissionAssignment = getCurrentUserPermissionDetails();
        System.debug(LoggingLevel.debug,'listUserPermissionAssignment '+listUserPermissionAssignment);
        if(!listUserPermissionAssignment.isEmpty() && listUserPermissionAssignment[0].PermissionSet.Label == CEConstants.PERMISSIONSET_DESIGNATED){            
            System.debug(LoggingLevel.debug,'CEUtils '+CEUtils.bindVars);
            CEUtils.bindVars.put(CEConstants.QPARAM_MEMBERCODE, listUserPermissionAssignment[0].Assignee.Contact.Account.REMC_Abbreviation__c);
            List<CEMemberResponse__c> listMemberResponse = CEUtils.getDetails(CEConstants.OBJ_CEMEMBERRESPONSE, CEConstants.FUNC_GETREMCCURTAILMENTRECORD);
            System.debug('listMemberResponse '+listMemberResponse);
            if(!listMemberResponse.isEmpty()){
                return listMemberResponse;
            }
        }
        return null;
    }


    /**
	 * Method is to create new event directive record.
	 *
	 * @return string if new active event directive is created.
	 */
    @AuraEnabled
    public static String updateREMCMemberResponse(String ceMemberResponseId, String ceCurtailmentAmount){
        CEMemberResponse__c memberResponse = new CEMemberResponse__c();  
        memberResponse.Id = ceMemberResponseId;
        memberResponse.CurtailmentAchieved__c = decimal.valueOf(ceCurtailmentAmount);
        system.debug(LoggingLevel.debug, ' memberResponse '+ memberResponse);
        DmlAction.updateRecord(memberResponse);            
        
        return '';
    }
}