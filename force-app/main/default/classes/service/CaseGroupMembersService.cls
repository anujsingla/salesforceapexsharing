public with sharing class CaseGroupMembersService {
    public static void shareCaseGroupWithMembers(List<Case_Group_Member__c> members)
    {
        service().shareCaseGroupWithMembers(members);
    }
    
    private static ICaseGroupMembersService service()
    {
        return (ICaseGroupMembersService) Application.Service.newInstance(ICaseGroupMembersService.class);
    }
}