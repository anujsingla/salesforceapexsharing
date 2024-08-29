public with sharing class Contacts extends fflib_SObjects
    implements IContacts
{
    public static IContacts newInstance(List<Contact> recordList)
    {
        return (IContacts) Application.Domain.newInstance(recordList);
    }
    
    public Contacts(List<Contact> sObjectList)
    {
        super(sObjectList, Schema.Contact.SObjectType);
    }
    
    public List<Contact> getContacts()
    {
        return (List<Contact>) getRecords();
    }
    
    public List<Contact> getAdminContacts(List<Contact> contacts)
    {
        List<Contact> adminContacts = new List<Contact>();
        
        // Iterate through the list of contacts to find admins
        for (Contact contact : contacts) {
            if (contact.Is_Admin__c) {
                adminContacts.add(contact);
            }
        }
        
        return adminContacts;
    }
    
    public List<Contact> getNonAdminContacts(List<Contact> contacts)
    {
        List<Contact> nonAdminContacts = new List<Contact>();
        
        // Iterate through the list of contacts to find non-admins
        for (Contact contact : contacts) {
            if (!contact.Is_Admin__c) {
                nonAdminContacts.add(contact);
            }
        }
        
        return nonAdminContacts;
    }
    
    public class Constructor implements fflib_IDomainConstructor
    {
        public fflib_SObjects construct(List<Object> objectList)
        {
            return new Contacts((List<SObject>) objectList);
        }
    }
}