public with sharing class CaseGroupHelper {
    public static void addMembersToCaseGroup(List<Case_Group__c> caseGroups) {
        // Set to hold the account IDs
        Set<Id> accountIds = new Set<Id>();
        
        // Map to hold the Case Group ID and associated Account ID
        Map<Id, Id> caseGroupToAccountMap = new Map<Id, Id>();
        
        // Loop through the Case Groups and populate the account IDs set and map
        for (Case_Group__c caseGroup : caseGroups) {
            accountIds.add(caseGroup.Account__c);
            caseGroupToAccountMap.put(caseGroup.Id, caseGroup.Account__c);
        }
        
        // Query all contacts related to the accounts
        List<Contact> contacts = [SELECT Id, AccountId, Is_Admin__c FROM Contact WHERE AccountId IN :accountIds];
        
        // List to hold Case Group Member records to be created
        List<Case_Group_Member__c> caseGroupMembers = new List<Case_Group_Member__c>();
        
        // Loop through the contacts and create Case Group Member records
        for (Contact contact : contacts) {
            Id caseGroupId = getCaseGroupIdForAccount(caseGroupToAccountMap, contact.AccountId);
            Case_Group_Member__c caseGroupMember = new Case_Group_Member__c();
            caseGroupMember.Case_Group__c = caseGroupId;
            caseGroupMember.Contact__c = contact.Id;
            caseGroupMember.AccessLevel__c = contact.Is_Admin__c ? 'Read/Write' : 'NoAccess';
            caseGroupMembers.add(caseGroupMember);
        }
        
        // Insert the Case Group Member records
        if (!caseGroupMembers.isEmpty()) {
            try {
                insert caseGroupMembers;
                System.debug('Successfully inserted case group members');
            } catch (Exception e) {
                System.debug('Failed to insert case group memebers ' + ' - ' + e.getMessage());
            }
        }
    }
    
    // Helper method to get the Case Group ID for a given Account ID
    private static Id getCaseGroupIdForAccount(Map<Id, Id> caseGroupToAccountMap, Id accountId) {
        for (Id caseGroupId : caseGroupToAccountMap.keySet()) {
            if (caseGroupToAccountMap.get(caseGroupId) == accountId) {
                return caseGroupId;
            }
        }
        return null;
    }
}