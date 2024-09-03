public with sharing class CaseGroupJunctionsService {
    public static void shareCasesWithGroupMembersFromJunction(List<Case_Group_Junction__c> caseGroupJunction)
    {
        service().shareCasesWithGroupMembersFromJunction(caseGroupJunction);
    }
    
    private static ICaseGroupJunctionsService service()
    {
        return (ICaseGroupJunctionsService) Application.Service.newInstance(ICaseGroupJunctionsService.class);
    }
}