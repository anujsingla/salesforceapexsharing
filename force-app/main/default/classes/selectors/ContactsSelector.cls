public class ContactsSelector extends fflib_SObjectSelector implements IContactsSelector {
    
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            Contact.Id,
            Contact.AccountId,
            Contact.Is_Admin__c,
            Contact.FirstName,
            Contact.LastName
        };
    }
    public static IContactsSelector newInstance()
    {
        return (IContactsSelector) Application.Selector.newInstance(Contact.SObjectType);
    }
    
    public Schema.SObjectType getSObjectType()
    {
        return Contact.SObjectType;
    }
    
    public List<Contact> getContactsRelatedToAccount(Set<Id> accountIds) {
        System.debug('ContactsSelector getContactsRelatedToAccount: accountIds' + JSON.serializePretty(accountIds));
        
        if (accountIds.isEmpty()) {
            return new List<Contact>();
        }
        
        fflib_QueryFactory qf = newQueryFactory();
        qf.setCondition('AccountId IN :accountIds');
        System.debug('ContactsSelector getContactsRelatedToAccount: qf ' + qf.toSOQL());
        
        return Database.query(qf.toSOQL());
    }
    
    public List<Contact> getContactsByIds(Set<Id> contactIds) {
        System.debug('ContactsSelector getContactsByIds: contactIds' + JSON.serializePretty(contactIds));
        
        if (contactIds.isEmpty()) {
            return new List<Contact>();
        }
        
        fflib_QueryFactory qf = newQueryFactory();
        qf.setCondition('Id IN :contactIds');
        System.debug('ContactsSelector getContactsByIds: qf ' + qf.toSOQL());
        
        return Database.query(qf.toSOQL());
    }
    
    public Map<Id, Contact> mapContactIdToContact(List<Contact> contacts) {
        Map<Id, Contact> contactIdToContactMap = new Map<Id, Contact>();
        
        for (Contact contact : contacts) {
            if (contact.Id != null) {
                contactIdToContactMap.put(contact.Id, contact);
            }
        }
        
        System.debug('UsersSelector mapContactIdToUser: mapContactIdToContact ' + JSON.serializePretty(contactIdToContactMap));
        return contactIdToContactMap;
    }
}