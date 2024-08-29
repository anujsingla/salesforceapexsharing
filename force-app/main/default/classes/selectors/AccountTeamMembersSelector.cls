public class AccountTeamMembersSelector extends fflib_SObjectSelector implements IAccountTeamMembersSelector {
    
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            AccountTeamMember.AccountId,
            AccountTeamMember.UserId
        };
    }
    public static AccountTeamMembersSelector newInstance()
    {
        return (AccountTeamMembersSelector) Application.Selector.newInstance(AccountTeamMember.SObjectType);
    }
    
    public Schema.SObjectType getSObjectType()
    {
        return AccountTeamMember.SObjectType;
    }
    
    public List<AccountTeamMember> getAccountTeamMembersByAccountIdsAndContactIds(Set<Id> accountIds, Set<Id> contactIds) {
        if (accountIds.isEmpty() || contactIds.isEmpty()) {
            return new List<AccountTeamMember>();
        }
        
        IUsersSelector userSelector = UsersSelector.newInstance();
        Map<Id, User> contactIdToUserMap = userSelector.mapUserIdToUser(userSelector.getUsersByContactIds(contactIds));
        Set<Id> userIds = new Set<Id>(contactIdToUserMap.keySet());
        
        fflib_QueryFactory qf = newQueryFactory();
        qf.setCondition('AccountId IN :accountIds');
        qf.setCondition('UserId IN :userIds');
        
        return (List<AccountTeamMember>) Database.query(qf.toSOQL());
    }
}