public with sharing class CaseGroupsService {
    public static void addMembersToCaseGroup(List<Case_Group__c> caseGroups)
    {
        service().addMembersToCaseGroup(caseGroups);
    }
    
    private static ICaseGroupsService service()
    {
        return (ICaseGroupsService) Application.Service.newInstance(ICaseGroupsService.class);
    }
}