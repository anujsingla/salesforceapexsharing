public interface IContacts extends fflib_ISObjects
{
    List<Contact> getContacts();
    List<Contact> getAdminContacts(List<Contact> contacts);
    List<Contact> getNonAdminContacts(List<Contact> contacts);
    // void setDescription(String description);
    // void updateOpportunityActivity();
}