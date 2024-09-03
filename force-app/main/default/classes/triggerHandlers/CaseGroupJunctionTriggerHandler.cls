public class CaseGroupJunctionTriggerHandler extends fflib_SObjectDomain
{
    public CaseGroupJunctionTriggerHandler(List<Case_Group_Junction__c> sObjectList)
    {
        // Domain classes are initialised with lists to enforce bulkification throughout
        super(sObjectList);
    }
    
    public override void onApplyDefaults()
    {
        // Apply defaults to CaseGroupMembersTriggerHandler
    }
    
    public override void onValidate()
    {
        // Validate CaseGroupMembersTriggerHandler
    }
    
    public override void onValidate(Map<Id,SObject> existingRecords)
    {
        // Validate changes to CaseGroupMembersTriggerHandler
    }
    
    public override void onAfterInsert()
    {
        System.debug('CaseGroupJunctionTriggerHandler onAfterInsert' + JSON.serializePretty(this.records));
        // Set<Id> caseGroupIds = new Set<Id>();
        // for (Case_Group_Junction__c junction : this.records) {
            //     caseGroupIds.add(junction.Case_Group__c);
        // }
        CaseGroupJunctionsService.shareCasesWithGroupMembersFromJunction(this.records);
    }
    
    public override void onAfterDelete()
    {
        // deleteMembersToCaseGroup();
    }
    
    public class Constructor implements fflib_SObjectDomain.IConstructable
    {
        public fflib_SObjectDomain construct(List<SObject> sObjectList)
        {
            return new CaseGroupJunctionTriggerHandler(sObjectList);
        }
    }
}