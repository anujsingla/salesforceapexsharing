public interface ICaseGroupMembers extends fflib_ISObjects
{
    List<Case_Group_Member__c> createCaseGroupMembers(Map<Id, Id> caseGroupToAccountMap, List<Contact> contacts);
}