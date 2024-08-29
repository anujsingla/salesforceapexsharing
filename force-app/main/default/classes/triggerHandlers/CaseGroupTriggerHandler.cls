public class CaseGroupTriggerHandler extends fflib_SObjectDomain
{
    public CaseGroupTriggerHandler(List<Case_Group__c> sObjectList)
    {
        // Domain classes are initialised with lists to enforce bulkification throughout
        super(sObjectList);
    }
    
    public override void onApplyDefaults()
    {
        // Apply defaults to CaseGroupTriggerHandler
    }
    
    public override void onValidate()
    {
        // Validate CaseGroupTriggerHandler
    }
    
    public override void onValidate(Map<Id,SObject> existingRecords)
    {
        // Validate changes to CaseGroupTriggerHandler
    }
    
    public override void onAfterInsert()
    {
        addMembersToCaseGroup();
    }
    
    public override void onAfterDelete()
    {
        deleteMembersToCaseGroup();
    }
    
    private void addMembersToCaseGroup()
    {
        System.debug('addMembersToCaseGroup onAfterInsert trigger handler: ' + JSON.serializePretty(this.records));
        // Set<Id> accountIds =
        // 		Opportunities.newInstance(this.records)
        // 				.getAccountIds();
        
        // if (accountIds.isEmpty()) return;
        
        CaseGroupsService.addMembersToCaseGroup(this.records);
    }
    
    private void deleteMembersToCaseGroup()
    {
        System.debug('deleteMembersToCaseGroup onAfterDelete trigger handler: ' + JSON.serializePretty(this.records));
        // Set<Id> accountIds =
        // 		Opportunities.newInstance(this.records)
        // 				.getAccountIds();
        
        // if (accountIds.isEmpty()) return;
        
        // AccountsService.updateOpportunityActivity(accountIds);
    }
    
    public class Constructor implements fflib_SObjectDomain.IConstructable
    {
        public fflib_SObjectDomain construct(List<SObject> sObjectList)
        {
            return new CaseGroupTriggerHandler(sObjectList);
        }
    }
}