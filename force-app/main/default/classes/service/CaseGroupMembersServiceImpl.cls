public with sharing class CaseGroupMembersServiceImpl implements ICaseGroupMembersService {
    public void shareCaseGroupWithMembers(List<Case_Group_Member__c> members) {
        System.debug('CaseGroupMembersServiceImpl shareCaseGroupWithMembers: members' + JSON.serializePretty(members));
        
        // Early exit if the input list is empty
        if (members.isEmpty()) {
            return;
        }
        
        Map<Id, List<Case_Group_Member__c>> caseGroupMembersMap = new Map<Id, List<Case_Group_Member__c>>();
        Set<Id> contactIds = new Set<Id>();
        Set<Id> caseGroupIdsWithNoAccess = new Set<Id>();
        Map<Id, Id> caseGroupUserIdMap = new Map<Id, Id>();
        
        for (Case_Group_Member__c member : members) {
            if (!caseGroupMembersMap.containsKey(member.Case_Group__c)) {
                caseGroupMembersMap.put(member.Case_Group__c, new List<Case_Group_Member__c>());
            }
            caseGroupMembersMap.get(member.Case_Group__c).add(member);
            contactIds.add(member.Contact__c);
        }
        
        IUsersSelector userSelector = UsersSelector.newInstance();
        Map<Id, User> contactIdToUserMap = userSelector.mapContactIdToUser(userSelector.getUsersByContactIds(contactIds));
        
        System.debug('CaseGroupMembersServiceImpl shareCaseGroupWithMembers: contactIdToUserMap' + JSON.serializePretty(contactIdToUserMap));
        
        List<Case_Group__Share> sharesToInsert = new List<Case_Group__Share>();
        
        for (Id caseGroupId : caseGroupMembersMap.keySet()) {
            List<Case_Group_Member__c> groupMembers = caseGroupMembersMap.get(caseGroupId);
            
            for (Case_Group_Member__c member : groupMembers) {
                User relatedUser = contactIdToUserMap.get(member.Contact__c);
                
                if (relatedUser != null) {
                    if (member.AccessLevel__c == 'NoAccess') {
                        caseGroupUserIdMap.put(caseGroupId, relatedUser.Id);
                    } else {
                        Case_Group__Share caseGroupShare = new Case_Group__Share();
                        caseGroupShare.ParentId = caseGroupId;
                        caseGroupShare.UserOrGroupId = relatedUser.Id;
                        caseGroupShare.AccessLevel = (member.AccessLevel__c == 'Read/Write') ? 'Edit' : 'Read';
                        caseGroupShare.RowCause = Schema.Case_Group__Share.RowCause.Manual;
                        sharesToInsert.add(caseGroupShare);
                    }
                }
            }
        }
        System.debug('CaseGroupMembersServiceImpl shareCaseGroupWithMembers: caseGroupUserIdMap' + JSON.serializePretty(caseGroupUserIdMap));
        
        // Now perform the SOQL query outside the loop to retrieve the shares to delete
        ICaseGroupSharesSelector caseGroupSharesSelector = CaseGroupSharesSelector.newInstance();
        List<Case_Group__Share> sharesToDelete = caseGroupSharesSelector.getCaseGroupShareByParentIdsAndUserIds(caseGroupUserIdMap.keySet(), new Set<Id>(caseGroupUserIdMap.values()));
        // List<Case_Group__Share> sharesToDelete = getSharesToDelete(caseGroupUserIdMap);
        System.debug('CaseGroupMembers shareCaseGroupWithMembers: sharesToDelete' + JSON.serializePretty(sharesToDelete));
        System.debug('CaseGroupMembers shareCaseGroupWithMembers: sharesToInsert' + JSON.serializePretty(sharesToInsert));
        
        fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();
        
        if (!sharesToDelete.isEmpty()) {
            uow.registerDeleted(sharesToDelete);
        }
        
        if (!sharesToInsert.isEmpty()) {
            uow.registerNew(sharesToInsert);
        }
        uow.commitWork();
    }
}