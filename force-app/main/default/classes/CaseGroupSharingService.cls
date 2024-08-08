public with sharing class CaseGroupSharingService {
    public static void removeCaseSharingFromJunctionTrigger(Case_Group_Junction__c junction) {
        List<CaseShare> caseShares = [SELECT Id, CaseId FROM CaseShare WHERE CaseId = :junction.Case__c AND RowCause = :Schema.CaseShare.RowCause.Manual];
        // Delete existing shares
        System.debug('caseShares delete: ' + JSON.serializePretty(caseShares));
        if (!caseShares.isEmpty()) {
            try {
                delete caseShares;
                System.debug('Successfully deleted Case Group with User:');
            } catch (Exception e) {
                System.debug('Failed to delete Case Group with User: ' + ' - ' + e.getMessage());
            }
        }
    }
    public static void shareCasesWithGroupMembersFromJunctionTrigger(Set<Id> caseGroupIds) {
        // Get the members of the Case Groups with Read/Write or Read access
        List<Case_Group_Member__c> members = [SELECT Contact__c, AccessLevel__c, Case_Group__c, Contact__r.Name FROM Case_Group_Member__c WHERE Case_Group__c IN :caseGroupIds AND AccessLevel__c IN ('Read/Write', 'Read')];
        
        System.debug('member: ' + JSON.serializePretty(members));
        for (Case_Group_Member__c member : members) {
            shareCasesWithGroupMember(member);
        }
        
    }
    public static void shareCasesWithGroupMember(Case_Group_Member__c member) {
        // Get the cases associated with the Case Group
        List<Case_Group_Junction__c> caseGroupJunctions = [SELECT Case__c 
                                                           FROM Case_Group_Junction__c 
                                                           WHERE Case_Group__c = :member.Case_Group__c];
        
        System.debug('caseGroupJunctions: ' + JSON.serializePretty(caseGroupJunctions));
        
        // Get existing shares for the member's contact
        List<CaseShare> existingShares = [SELECT Id, CaseId 
                                          FROM CaseShare 
                                          WHERE UserOrGroupId IN (SELECT Id FROM User WHERE ContactId = :member.Contact__c)
                                          AND CaseId IN (SELECT Case__c FROM Case_Group_Junction__c WHERE Case_Group__c = :member.Case_Group__c)
                                          AND RowCause = :Schema.CaseShare.RowCause.Manual];
        Set<Id> existingCaseIds = new Set<Id>();
        for (CaseShare share : existingShares) {
            existingCaseIds.add(share.CaseId);
        }
        System.debug('existingCaseIds: ' + JSON.serializePretty(existingCaseIds));
        
        
        List<CaseShare> caseShares = new List<CaseShare>();
        
        if (member.AccessLevel__c == 'Read/Write' || member.AccessLevel__c == 'Read') {
            // Loop through cases and create sharing records if not already shared
            for (Case_Group_Junction__c caseGroupJunction : caseGroupJunctions) {
                if (!existingCaseIds.contains(caseGroupJunction.Case__c)) {
                    List<User> users = [SELECT Id FROM User WHERE ContactId = :member.Contact__c LIMIT 1];
                    if (!users.isEmpty()) {
                        Id userId = users[0].Id;
                        CaseShare caseShare = new CaseShare();
                        caseShare.CaseId = caseGroupJunction.Case__c;
                        caseShare.UserOrGroupId = userId;
                        caseShare.CaseAccessLevel = (member.AccessLevel__c == 'Read/Write') ? 'Edit' : 'Read';
                        caseShare.RowCause = Schema.CaseShare.RowCause.Manual;
                        caseShares.add(caseShare);
                    }
                }
            }
        }
        else if (member.AccessLevel__c == 'NoAccess') {
            removeCaseGroupSharesForMember(member);
        }
        
        System.debug('caseShares: ' + JSON.serializePretty(caseShares));
        
        // Insert the sharing records
        if (!caseShares.isEmpty()) {
            
            try {
                insert caseShares;
                System.debug('Successfully shared Case Group with User: ' + member.Contact__r.Name);
            } catch (Exception e) {
                System.debug('Failed to share Case Group with User: ' + member.Contact__r.Name + ' - ' + e.getMessage());
            }
        }
    }
    
    public static void removeCaseGroupSharesForMember(Case_Group_Member__c member) {
        // Get the cases associated with the Case Group
        List<Case_Group_Junction__c> caseGroupJunctions = [SELECT Case__c 
                                                           FROM Case_Group_Junction__c 
                                                           WHERE Case_Group__c = :member.Case_Group__c];
        
        Set<Id> caseIds = new Set<Id>();
        for (Case_Group_Junction__c caseGroupJunction : caseGroupJunctions) {
            caseIds.add(caseGroupJunction.Case__c);
        }
        System.debug('caseIds delete: ' + JSON.serializePretty(caseIds));
        // Get existing shares for the member's contact
        List<CaseShare> caseShares = [SELECT Id 
                                      FROM CaseShare 
                                      WHERE UserOrGroupId IN (SELECT Id FROM User WHERE ContactId = :member.Contact__c)
                                      AND CaseId IN :caseIds
                                      AND RowCause = :Schema.CaseShare.RowCause.Manual];
        
        // Delete existing shares
        System.debug('caseShares delete: ' + JSON.serializePretty(caseShares));
        if (!caseShares.isEmpty()) {
            try {
                delete caseShares;
                System.debug('Successfully deleted Case Group with User: ' + member.Contact__r.Name);
            } catch (Exception e) {
                System.debug('Failed to delete Case Group with User: ' + member.Contact__r.Name + ' - ' + e.getMessage());
            }
        }
    }
}