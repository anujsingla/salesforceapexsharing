public with sharing class CaseGroupController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        return [SELECT Id, Name FROM Account];
    }

    @AuraEnabled(cacheable=true)
    public static List<Account> getCaseGroupsByAccount(Id accountId) {
        return null;
    }
}
