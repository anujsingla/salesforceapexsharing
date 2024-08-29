public with sharing class CaseGroupMembers extends fflib_SObjects
    implements ICaseGroupMembers, fflib_IDomain
{
    public static ICaseGroupMembers newInstance(List<Case_Group_Member__c> recordList)
    {
        return (ICaseGroupMembers) Application.Domain.newInstance(recordList);
    }
    
    public CaseGroupMembers(List<Case_Group_Member__c> caseGroupMembers)
    {
        super(caseGroupMembers);
    }
    
    public List<Case_Group_Member__c> getCaseGroupMembers()
    {
        return (List<Case_Group_Member__c>) getRecords();
    }
    
    // Method to create Case Group Member records
    public static List<Case_Group_Member__c> createCaseGroupMembers(Map<Id, Id> caseGroupToAccountMap, List<Contact> contacts) {
        List<Case_Group_Member__c> caseGroupMembers = new List<Case_Group_Member__c>();
        
        for (Contact contact : contacts) {
            Id caseGroupId = getCaseGroupIdForAccount(caseGroupToAccountMap, contact.AccountId);
            if (caseGroupId != null) {
                Case_Group_Member__c caseGroupMember = new Case_Group_Member__c();
                caseGroupMember.Case_Group__c = caseGroupId;
                caseGroupMember.Contact__c = contact.Id;
                caseGroupMember.AccessLevel__c = contact.Is_Admin__c ? 'Read/Write' : 'NoAccess';
                caseGroupMembers.add(caseGroupMember);
            }
        }
        
        return caseGroupMembers;
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
    
    public class Constructor implements fflib_IDomainConstructor
    {
        public fflib_IDomain construct(List<Object> sObjectList)
        {
            return new CaseGroupMembers((List<Case_Group_Member__c>)sObjectList);
        }
    }
}