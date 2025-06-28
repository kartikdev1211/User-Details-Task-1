
abstract class UserEvent {}
class LoadUser extends UserEvent{}
class SearchUsers extends UserEvent{
  final String searchQuery;

  SearchUsers({required this.searchQuery});
}