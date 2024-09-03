public class CaseSharesSelector extends fflib_SObjectSelector implements ICaseSharesSelector {
    
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            CaseShare.Id,
            CaseShare.CaseId,
            CaseShare.UserOrGroupId
        };
    }
    public static ICaseSharesSelector newInstance()
    {
        return (ICaseSharesSelector) Application.Selector.newInstance(CaseShare.SObjectType);
    }
    
    public Schema.SObjectType getSObjectType()
    {
        return CaseShare.SObjectType;
    }
    
    public List<CaseShare> getCaseShareByContactIdsAndCaseIds(Set<Id> contactIds, Set<Id> caseIds) {
        
        if (contactIds.isEmpty() || caseIds.isEmpty()) {
            return new List<CaseShare>();
        }
        
        IUsersSelector userSelector = UsersSelector.newInstance();
        Set<Id> userIds = userSelector.getUserIds(userSelector.getUsersByContactIds(contactIds));
        String rowCause = Schema.CaseShare.RowCause.Manual;
        fflib_QueryFactory qf = newQueryFactory();
        qf.setCondition('UserOrGroupId IN :userIds');
        qf.setCondition('CaseId IN :caseIds');
        qf.setCondition('RowCause = :rowCause');
        System.debug('CaseSharesSelector getCaseShareByContactIdsAndCaseIds: qf ' + qf.toSOQL());
        
        return Database.query(qf.toSOQL());
    }
    
    public List<CaseShare> getCaseGroupShareByParentIdsAndUserIds(Set<Id> parentIds, Set<Id> userOrGroupIds) {
        
        if (parentIds.isEmpty() || userOrGroupIds.isEmpty()) {
            return new List<CaseShare>();
        }
        
        fflib_QueryFactory qf = newQueryFactory();
        qf.setCondition('ParentId IN :parentIds');
        qf.setCondition('UserOrGroupId IN :userOrGroupIds');
        System.debug('CaseSharesSelector getCaseGroupShareByParentIdsAndUserIds: qf ' + qf.toSOQL());
        
        return Database.query(qf.toSOQL());
    }
}