public with sharing class AccountTeamMembers extends fflib_SObjects
    implements IAccountTeamMembers
{
    public static IAccountTeamMembers newInstance(List<AccountTeamMember> recordList)
    {
        return (IAccountTeamMembers) Application.Domain.newInstance(recordList);
    }
    
    public AccountTeamMembers(List<AccountTeamMember> sObjectList)
    {
        super(sObjectList, Schema.AccountTeamMember.SObjectType);
    }
    
    public List<AccountTeamMember> getAccountTeamMembers()
    {
        return (List<AccountTeamMember>) getRecords();
    }
    
    // Method to create Account Team Member records
    public List<AccountTeamMember> createAccountTeamMembers(List<Contact> adminContacts, String teamMemberRole) {
        List<AccountTeamMember> accountTeamMembers = new List<AccountTeamMember>();
        
        System.debug('AccountTeamMembers domain class createAccountTeamMembers admincontacts: ' + JSON.serializePretty(adminContacts));
        
        Set<Id> contactIds = new Set<Id>();
        Set<Id> accountIds = new Set<Id>();
        for (Contact contact : adminContacts) {
            contactIds.add(contact.Id);
            accountIds.add(contact.AccountId);
        }
        
        IAccountTeamMembersSelector accountTeamMemberSelector = AccountTeamMembersSelector.newInstance();
        List<AccountTeamMember> existingTeamMembers = accountTeamMemberSelector.getAccountTeamMembersByAccountIdsAndContactIds(accountIds, contactIds);
        
        System.debug('AccountTeamMembers domain class existingTeamMembers: ' + JSON.serializePretty(existingTeamMembers));
        
        Map<Id, Set<Id>> existingAccountTeamMap = new Map<Id, Set<Id>>();
        for (AccountTeamMember member : existingTeamMembers) {
            if (!existingAccountTeamMap.containsKey(member.AccountId)) {
                existingAccountTeamMap.put(member.AccountId, new Set<Id>());
            }
            existingAccountTeamMap.get(member.AccountId).add(member.UserId);
        }
        
        IUsersSelector userSelector = UsersSelector.newInstance();
        Map<Id, User> contactIdToUserMap = userSelector.mapContactIdToUser(userSelector.getUsersByContactIds(contactIds));
        
        System.debug('AccountTeamMembers domain class contactIdToUserMap: ' + JSON.serializePretty(contactIdToUserMap));
        for (Contact contact : adminContacts) {
            User communityUser = contactIdToUserMap.get(contact.Id);
            System.debug('AccountTeamMembers domain class communityUser: ' + JSON.serializePretty(communityUser));
            if (communityUser != null) {
                if (!existingAccountTeamMap.containsKey(contact.AccountId) ||
                !existingAccountTeamMap.get(contact.AccountId).contains(communityUser.Id)) {
                    AccountTeamMember accountTeamMember = new AccountTeamMember();
                    accountTeamMember.AccountId = contact.AccountId;
                    accountTeamMember.UserId = communityUser.Id;
                    accountTeamMember.TeamMemberRole = String.isNotBlank(teamMemberRole) ? teamMemberRole : 'Partner Manager';
                    accountTeamMember.AccountAccessLevel = 'Edit'; // Read/Write access for Account
                    accountTeamMember.CaseAccessLevel = 'Edit'; // Read/Write access for Cases
                    accountTeamMembers.add(accountTeamMember);
                }
            }
        }
        System.debug('AccountTeamMembers domain class accountTeamMembers: ' + JSON.serializePretty(accountTeamMembers));
        return accountTeamMembers;
    }
    
    public class Constructor implements fflib_IDomainConstructor
    {
        public fflib_SObjects construct(List<Object> objectList)
        {
            return new AccountTeamMembers((List<SObject>) objectList);
        }
    }
}