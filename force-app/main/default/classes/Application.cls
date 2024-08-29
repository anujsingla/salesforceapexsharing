public class Application {
    // Configure and create the ServiceFactory for this Application
    public static final fflib_Application.ServiceFactory Service =
        new fflib_Application.ServiceFactory(
    new Map<Type, Type> {
        ICaseGroupsService.class => CaseGroupsServiceImpl.class
    });
    
    // Configure and create the SelectorFactory for this Application
    public static final fflib_Application.SelectorFactory Selector =
        new fflib_Application.SelectorFactory(
    new Map<SObjectType, Type> {
        Contact.SObjectType => ContactsSelector.class,
        User.SObjectType => UsersSelector.class,
        AccountTeamMember.SObjectType => AccountTeamMembersSelector.class
            
    });
    
    // Configure and create the DomainFactory for this Application
    public static final fflib_Application.DomainFactory Domain =
        new fflib_Application.DomainFactory(
        Application.Selector,
    new Map<SObjectType, Type> {
        Contact.SObjectType => Contacts.Constructor.class,
        Case_Group_Member__c.SObjectType => CaseGroupMembers.Constructor.class,
        AccountTeamMember.SObjectType => AccountTeamMembers.Constructor.class
    });
    
    // Configure and create the UnitOfWorkFactory for this Application
    public static final fflib_Application.UnitOfWorkFactory UnitOfWork =
        new fflib_Application.UnitOfWorkFactory(
    new List<SObjectType> {
        Contact.SObjectType,
        Case_Group_Member__c.SObjectType,
        AccountTeamMember.SObjectType
    });
}