public interface ICaseSharesSelector extends fflib_ISObjectSelector
{
    // List<Case_Group__Share> getCaseGroupShareByParentIdsAndUserIds(Set<Id> parentIds, Set<Id> userOrGroupIds);
    List<CaseShare> getCaseShareByContactIdsAndCaseIds(Set<Id> contactIds, Set<Id> caseIds);
    List<CaseShare> getCaseGroupShareByParentIdsAndUserIds(Set<Id> parentIds, Set<Id> userOrGroupIds);
}