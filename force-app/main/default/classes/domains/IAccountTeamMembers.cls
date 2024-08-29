public interface IAccountTeamMembers extends fflib_ISObjects
{
    List<AccountTeamMember> createAccountTeamMembers(List<Contact> adminContacts, String teamMemberRole);
}