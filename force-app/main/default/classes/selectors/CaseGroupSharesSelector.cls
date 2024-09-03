public class CaseGroupSharesSelector extends fflib_SObjectSelector implements ICaseGroupSharesSelector {
    
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            Case_Group__Share.Id
        };
    }
    public static ICaseGroupSharesSelector newInstance()
    {
        return (ICaseGroupSharesSelector) Application.Selector.newInstance(Case_Group__Share.SObjectType);
    }
    
    public Schema.SObjectType getSObjectType()
    {
        return Case_Group__Share.SObjectType;
    }
    
    public List<Case_Group__Share> getCaseGroupShareByParentIdsAndUserIds(Set<Id> parentIds, Set<Id> userOrGroupIds) {
        
        if (parentIds.isEmpty() || userOrGroupIds.isEmpty()) {
            return new List<Case_Group__Share>();
        }
        
        fflib_QueryFactory qf = newQueryFactory();
        qf.setCondition('ParentId IN :parentIds');
        qf.setCondition('UserOrGroupId IN :userOrGroupIds');
        System.debug('CaseGroupSharesSelector getCaseGroupShareByParentIdsAndUserIds: qf ' + qf.toSOQL());
        
        return Database.query(qf.toSOQL());
    }
}