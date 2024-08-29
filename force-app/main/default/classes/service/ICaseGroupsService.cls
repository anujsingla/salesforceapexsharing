public interface ICaseGroupsService
{
    void addMembersToCaseGroup(List<Case_Group__c> caseGroups);
    void addAdminContactUsersAsAccountTeamMember(List<Contact> adminContacts);
}