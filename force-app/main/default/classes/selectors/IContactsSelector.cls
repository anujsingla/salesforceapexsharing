public interface IContactsSelector extends fflib_ISObjectSelector
{
    // Query all contacts related to the accounts
    List<Contact> getContactsRelatedToAccount(Set<Id> accountIds);
}