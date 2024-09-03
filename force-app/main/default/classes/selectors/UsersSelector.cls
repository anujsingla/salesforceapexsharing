public class UsersSelector extends fflib_SObjectSelector implements IUsersSelector {
    
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            User.Id,
            User.ContactId,
            User.Email,
            User.UserName,
            User.Name,
            User.IsActive
        };
    }
    public static IUsersSelector newInstance()
    {
        return (IUsersSelector) Application.Selector.newInstance(User.SObjectType);
    }
    
    public Schema.SObjectType getSObjectType()
    {
        return User.SObjectType;
    }
    
    public List<User> getUsersByContactIds(Set<Id> contactIds) {
        System.debug('UsersSelector getUsersByContactIds: contactIds' + JSON.serializePretty(contactIds));
        if (contactIds.isEmpty()) {
            return new List<User>();
        }
        
        fflib_QueryFactory qf = newQueryFactory();
        qf.setCondition('ContactId IN :contactIds');
        System.debug('UsersSelector getUsersByContactIds: qf ' + qf.toSOQL());
        List<User> users = Database.query(qf.toSOQL());
        System.debug('UsersSelector getUsersByContactIds: users' + JSON.serializePretty(users));
        
        return users;
    }
    
    public Map<Id, User> mapUserIdToUser(List<User> users) {
        Map<Id, User> userIdToUserMap = new Map<Id, User>();
        
        for (User user : users) {
            userIdToUserMap.put(user.Id, user);
        }
        
        System.debug('UsersSelector mapUserIdToUser: userIdToUserMap ' + JSON.serializePretty(userIdToUserMap));
        return userIdToUserMap;
    }
    
    public Map<Id, User> mapContactIdToUser(List<User> users) {
        Map<Id, User> contactIdToUserMap = new Map<Id, User>();
        
        for (User user : users) {
            if (user.ContactId != null) {
                contactIdToUserMap.put(user.ContactId, user);
            }
        }
        
        System.debug('UsersSelector mapContactIdToUser: contactIdToUserMap ' + JSON.serializePretty(contactIdToUserMap));
        return contactIdToUserMap;
    }
    
    public Set<Id> getUserIds(List<User> users) {
        Set<Id> userIds = new Set<Id>();
        
        for (User user : users) {
            userIds.add(user.Id);
        }
        
        System.debug('UsersSelector mapContactIdToUser: getUserIds ' + JSON.serializePretty(userIds));
        return userIds;
    }
}