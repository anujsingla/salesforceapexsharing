public class CaseGroupMembersTriggerHandler extends fflib_SObjectDomain
{
    public CaseGroupMembersTriggerHandler(List<Case_Group__c> sObjectList)
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
        // System.debug('CaseGroupMembersTriggerHandler onAfterInsert' + JSON.serializePretty(this.records));
        CaseGroupMembersService.shareCaseGroupWithMembers(this.records);
    }
    
    public override void onAfterDelete()
    {
        // deleteMembersToCaseGroup();
    }
    
    public class Constructor implements fflib_SObjectDomain.IConstructable
    {
        public fflib_SObjectDomain construct(List<SObject> sObjectList)
        {
            return new CaseGroupMembersTriggerHandler(sObjectList);
        }
    }
}