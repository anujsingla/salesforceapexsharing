public interface IAccountTeamMembersSelector extends fflib_ISObjectSelector
{
    List<AccountTeamMember> getAccountTeamMembersByAccountIdsAndContactIds(Set<Id> accountIds, Set<Id> contactIds);
}