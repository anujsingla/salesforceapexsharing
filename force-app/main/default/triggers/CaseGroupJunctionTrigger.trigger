trigger CaseGroupJunctionTrigger on Case_Group_Junction__c (after insert, after update, after delete) {
    Set<Id> caseGroupIds = new Set<Id>();

    if (Trigger.isAfter) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            for (Case_Group_Junction__c junction : Trigger.new) {
                caseGroupIds.add(junction.Case_Group__c);
            }
            CaseGroupSharingService.shareCasesWithGroupMembersFromJunctionTrigger(caseGroupIds);
        } else if (Trigger.isDelete) {
            for (Case_Group_Junction__c junction : Trigger.old) {
                // System.debug('junction: ' + JSON.serializePretty(junction));
                // caseGroupIds.add(junction.Case_Group__c);
                CaseGroupSharingService.removeCaseSharingFromJunctionTrigger(junction);
            }
        }
    }
}