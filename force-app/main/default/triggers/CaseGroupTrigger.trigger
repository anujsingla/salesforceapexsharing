// trigger CaseGroupTrigger on Case_Group__c (after insert) {
    //     CaseGroupHelper.addMembersToCaseGroup(Trigger.new);
// }

trigger CaseGroupTrigger on Case_Group__c (
    after delete, after insert, after update, before delete, before insert, before update)
{
    fflib_SObjectDomain.triggerHandler(CaseGroupTriggerHandler.class);
}