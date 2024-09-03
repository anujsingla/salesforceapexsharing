public interface ICaseGroupSharesSelector extends fflib_ISObjectSelector
{
    List<Case_Group__Share> getCaseGroupShareByParentIdsAndUserIds(Set<Id> parentIds, Set<Id> userOrGroupIds);
}