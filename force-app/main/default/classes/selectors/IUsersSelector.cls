public interface IUsersSelector extends fflib_ISObjectSelector
{
    List<User> getUsersByContactIds(Set<Id> contactIds);
    Map<Id, User> mapUserIdToUser(List<User> users);
    Map<Id, User> mapContactIdToUser(List<User> users);
}