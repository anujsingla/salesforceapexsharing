public interface ICaseGroupMembersSelector extends fflib_ISObjectSelector
{
    List<Case_Group_Member__c> getCaseGroupMembersByGroupId(Set<Id> caseGroupIds);
}