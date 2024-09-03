public with sharing class CaseGroupJunctionsServiceImpl implements ICaseGroupJunctionsService {
    public void shareCasesWithGroupMembersFromJunction(List<Case_Group_Junction__c> caseGroupJunctions) {
        System.debug('CaseGroupJunctionsServiceImpl shareCasesWithGroupMembersFromJunctionTrigger: ' + JSON.serializePretty(caseGroupJunctions));
        // Early exit if the list is empty
        if (caseGroupJunctions.isEmpty()) {
            return;
        }
        Set<Id> caseGroupIds = new Set<Id>();
        for (Case_Group_Junction__c junction : caseGroupJunctions) {
            caseGroupIds.add(junction.Case_Group__c);
        }
        
        // Fetch members of the Case Groups
        ICaseGroupMembersSelector caseGroupMemberSelector = CaseGroupMembersSelector.newInstance();
        List<Case_Group_Member__c> casegroupMembers = caseGroupMemberSelector.getCaseGroupMembersByGroupId(caseGroupIds);
        System.debug('CaseGroupJunctionsServiceImpl shareCasesWithGroupMembersFromJunction casegroupMembers: ' + JSON.serializePretty(casegroupMembers));
        
        // Early exit if no members are found
        if (caseGroupMembers.isEmpty()) {
            return;
        }
        
        // Collect all unique Contact IDs from members
        Set<Id> memberContactIds = new Set<Id>();
        for (Case_Group_Member__c member : casegroupMembers) {
            memberContactIds.add(member.Contact__c);
        }
        
        // Fetch related User and Contact data
        IUsersSelector userSelector = UsersSelector.newInstance();
        Map<Id, User> contactIdToUserMap = userSelector.mapContactIdToUser(userSelector.getUsersByContactIds(memberContactIds));
        
        IContactsSelector contactsSelector = ContactsSelector.newInstance();
        Map<Id, Contact> contactIdContactMap = contactsSelector.mapContactIdToContact(contactsSelector.getContactsByIds(memberContactIds));
        
        // Map to store CaseGroup IDs to their associated Case IDs
        Map<Id, List<Id>> caseGroupToCaseIdsMap = new Map<Id, List<Id>>();
        for (Case_Group_Junction__c junction : caseGroupJunctions) {
            if (!caseGroupToCaseIdsMap.containsKey(junction.Case_Group__c)) {
                caseGroupToCaseIdsMap.put(junction.Case_Group__c, new List<Id>());
            }
            caseGroupToCaseIdsMap.get(junction.Case_Group__c).add(junction.Case__c);
        }
        
        // Prepare CaseShare records to be inserted
        List<CaseShare> caseSharesToInsert = new List<CaseShare>();
        for (Case_Group_Member__c member : casegroupMembers) {
            Contact contact = contactIdContactMap.get(member.Contact__c);
            
            // Skip if the contact is an admin because we will add admin as a
            // account team member .
            if (contact != null && contact.Is_Admin__c) {
                continue;
            }
            
            // Proceed only if the member has Read or Read/Write access
            if (member.AccessLevel__c == 'Read/Write' || member.AccessLevel__c == 'Read') {
                User user = contactIdToUserMap.get(member.Contact__c);
                if (user != null) {
                    List<Id> caseIds = caseGroupToCaseIdsMap.get(member.Case_Group__c);
                    
                    for (Id caseId : caseIds) {
                        CaseShare caseShare = new CaseShare();
                        caseShare.CaseId = caseId;
                        caseShare.UserOrGroupId = user.Id;
                        caseShare.CaseAccessLevel = (member.AccessLevel__c == 'Read/Write') ? 'Edit' : 'Read';
                        caseShare.RowCause = Schema.CaseShare.RowCause.Manual;
                        caseSharesToInsert.add(caseShare);
                    }
                }
            }
        }
        System.debug('CaseGroupJunctionsServiceImpl shareCasesWithGroupMembersFromJunctionTrigger caseSharesToInsert: ' + JSON.serializePretty(caseSharesToInsert));
        
        // Insert the sharing records
        if (!caseSharesToInsert.isEmpty()) {
            fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();
            
            uow.registerNew(caseSharesToInsert);
            uow.commitWork();
        }
    }
}