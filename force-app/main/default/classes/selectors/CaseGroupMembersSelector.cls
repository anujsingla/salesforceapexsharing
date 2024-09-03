public class CaseGroupMembersSelector extends fflib_SObjectSelector implements ICaseGroupMembersSelector {
    
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            Case_Group_Member__c.AccessLevel__c,
            Case_Group_Member__c.Contact__r.Name,
            Case_Group_Member__c.Contact__r.Id,
            Case_Group_Member__c.Case_Group__c,
            Case_Group_Member__c.Contact__c
        };
    }
    public static ICaseGroupMembersSelector newInstance()
    {
        return (ICaseGroupMembersSelector) Application.Selector.newInstance(Case_Group_Member__c.SObjectType);
    }
    
    public Schema.SObjectType getSObjectType()
    {
        return Case_Group_Member__c.SObjectType;
    }
    
    public List<Case_Group_Member__c> getCaseGroupMembersByGroupId(Set<Id> caseGroupIds) {
        if (caseGroupIds.isEmpty()) {
            return new List<Case_Group_Member__c>();
        }
        
        fflib_QueryFactory qf = newQueryFactory();
        qf.setCondition('Case_Group__c IN :caseGroupIds');
        
        return Database.query(qf.toSOQL());
    }
}