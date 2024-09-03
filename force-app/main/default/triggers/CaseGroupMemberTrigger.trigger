// trigger CaseGroupMemberTrigger on Case_Group_Member__c (after insert, after update, after delete) {
    //     System.debug('Trigger CaseGroupMemberTrigger started.');
    //     if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        //         System.debug('inside trigger is update or is insert');
        //         for (Case_Group_Member__c member : Trigger.new) {
            //             System.debug('member: ' + JSON.serializePretty(member));
            //             System.debug('member id: ' + member.Case_Group__c);
            //             CaseGroupService.shareCaseGroupWithMembers(member.Case_Group__c, member.Contact__c);
            //             // CaseGroupSharingService.shareCasesWithGroupMembers(member.Case_Group__c); // Share cases with members
            //             CaseGroupSharingService.shareCasesWithGroupMember(member); // Share cases with members
        //         }
    //     }
    //     if (Trigger.isAfter && Trigger.isDelete) {
        //         System.debug('inside trigger is delete');
        //         for (Case_Group_Member__c member : Trigger.old) {
            //             CaseGroupService.shareCaseGroupWithMembers(member.Case_Group__c, member.Contact__c);
            //             CaseGroupSharingService.removeCaseGroupSharesForMember(member); // Remove shared cases with members
        //         }
    //     }
// }

trigger CaseGroupMemberTrigger on Case_Group_Member__c (
    after delete, after insert, after update, before delete, before insert, before update)
{
    fflib_SObjectDomain.triggerHandler(CaseGroupMembersTriggerHandler.class);
}