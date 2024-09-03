public with sharing class CaseGroupsServiceImpl implements ICaseGroupsService {
    public void addMembersToCaseGroup(List<Case_Group__c> caseGroups)
    {
        // System.debug('CaseGroupsServiceImpl addMembersToCaseGroup: ' + JSON.serializePretty(caseGroups));
        // Set to hold the account IDs
        Set<Id> accountIds = new Set<Id>();
        
        Map<Id, Id> caseGroupToAccountMap = new Map<Id, Id>();
        
        for (Case_Group__c caseGroup : caseGroups) {
            accountIds.add(caseGroup.Account__c);
            caseGroupToAccountMap.put(caseGroup.Id, caseGroup.Account__c);
        }
        // System.debug('CaseGroupsServiceImpl addMembersToCaseGroup accountids: ' + JSON.serializePretty(accountIds));
        IContactsSelector contactsSelector = ContactsSelector.newInstance();
        List<Contact> contacts = contactsSelector.getContactsRelatedToAccount(accountIds);
        // System.debug('CaseGroupsServiceImpl addMembersToCaseGroup list contacts: ' + JSON.serializePretty(contacts));
        
        IContacts domainContacts = (IContacts) Application.Domain.newInstance( contacts );
        // System.debug('CaseGroupsServiceImpl addMembersToCaseGroup list contacts domain: ' + JSON.serializePretty(domainContacts.getRecords()));
        
        // admin contact as account team member
        List<Contact> adminContacts = domainContacts.getAdminContacts(contacts);
        addAdminContactUsersAsAccountTeamMember(adminContacts);
        
        System.debug('CaseGroupsServiceImpl addMembersToCaseGroup list caseGroupToAccountMap: ' + JSON.serializePretty(caseGroupToAccountMap));
        List<Case_Group_Member__c> caseGroupMembers = CaseGroupMembers.createCaseGroupMembers(caseGroupToAccountMap, contacts);
        System.debug('CaseGroupsServiceImpl addMembersToCaseGroup list caseGroupMembers: ' + JSON.serializePretty(caseGroupMembers));
        
        
        fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();
        
        uow.registerNew(caseGroupMembers);
        uow.commitWork();
    }
    
    public void addAdminContactUsersAsAccountTeamMember(List<Contact> adminContacts) {
        System.debug('CaseGroupsServiceImpl addAdminContactUsersAsAccountTeamMember admin contacts before object creation: ' + JSON.serializePretty(adminContacts));
        if (adminContacts.isEmpty()) {
            return;
        }
        IAccountTeamMembers accountTeamMemberDomain = (IAccountTeamMembers) Application.Domain.newInstance( new List<AccountTeamMember>() );
        List<AccountTeamMember> accountTeamMembers = accountTeamMemberDomain.createAccountTeamMembers(adminContacts, 'Partner Manager');
        System.debug('CaseGroupsServiceImpl addAdminContactUsersAsAccountTeamMember account team members: ' + JSON.serializePretty(accountTeamMembers));
        
        fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();
        uow.registerNew(accountTeamMembers);
        uow.commitWork();
    }
}