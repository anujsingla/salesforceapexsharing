// trigger CaseGroupTrigger on Case_Group__c (after insert) {
    //     CaseGroupHelper.addMembersToCaseGroup(Trigger.new);
// }

trigger CaseGroupTrigger on Case_Group__c (
    after delete, after insert, after update, before delete, before insert, before update)
{
    // Creates Domain class instance and calls apprpoprite overideable methods according to Trigger state
    fflib_SObjectDomain.triggerHandler(CaseGroupTriggerHandler.class);
}