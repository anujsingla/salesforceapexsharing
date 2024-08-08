public with sharing class CaseGroupService {
    public static void shareCaseGroupWithMembers(Id caseGroupId, Id contactId) {
        // Get the members of the Case Group
        List<Case_Group_Member__c> members = [SELECT Contact__r.Name, AccessLevel__c, Contact__r.Id FROM Case_Group_Member__c WHERE Case_Group__c = :caseGroupId AND Contact__c = :contactId];
        // System.debug('Members: ' + JSON.serializePretty(members));
        // Loop through members and create sharing records
        for (Case_Group_Member__c member : members) {
            // System.debug('inside for: ' + JSON.serializePretty(member));
            // Create sharing records based on access level
            // System.debug('inside for before if' + member.AccessLevel__c);
            List<User> users = [SELECT Id FROM User WHERE ContactId = :member.Contact__r.Id LIMIT 1];
            if (users.size() > 0) {
                Id userId = users[0].Id;
                // System.debug('UserId: ' + userId);
                if (member.AccessLevel__c == 'NoAccess') {
                    List<Case_Group__Share> sharesToDelete = [SELECT Id FROM Case_Group__Share WHERE ParentId = :caseGroupId AND UserOrGroupId = :userId];
                    if (!sharesToDelete.isEmpty()) {
                        delete sharesToDelete;
                        System.debug('Removed sharing for User: ' + userId + ', Contact: ' + member.Contact__r.Name);
                    }
                }
                if (member.AccessLevel__c != 'NoAccess') {
                    // System.debug('inside for after if');
                    Case_Group__Share caseGroupShare = new Case_Group__Share();
                    caseGroupShare.ParentId = caseGroupId;
                    caseGroupShare.UserOrGroupId = userId;
                    caseGroupShare.AccessLevel = (member.AccessLevel__c == 'Read/Write') ? 'Edit' : 'Read';
                    caseGroupShare.RowCause = Schema.Case_Group__Share.RowCause.Manual;
                    System.debug('inside for before try');
                    try {
                        insert caseGroupShare;
                        System.debug('Successfully shared Case Group with User: ' + member.Contact__r.Name);
                    } catch (Exception e) {
                        System.debug('Failed to share Case Group with User: ' + member.Contact__r.Name + ' - ' + e.getMessage());
                    }
                }
            }
        }
    }
}