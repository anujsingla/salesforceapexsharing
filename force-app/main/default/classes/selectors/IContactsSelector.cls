public interface IContactsSelector extends fflib_ISObjectSelector
{
    List<Contact> getContactsByIds(Set<Id> contactIds);
    List<Contact> getContactsRelatedToAccount(Set<Id> accountIds);
    
    Map<Id, Contact> mapContactIdToContact(List<Contact> contacts);
}