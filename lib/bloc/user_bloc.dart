import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_details/bloc/user_event.dart';
import 'package:user_details/bloc/user_state.dart';
import 'package:user_details/models/user_model.dart';
import 'package:user_details/repo/user_repo.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepo userRepo;
  List<User> _allUsers = [];
  UserBloc(this.userRepo) : super(UserInitial()) {
    on<LoadUser>((event, emit) async {
      emit(UserLoading());
      try {
        final users = await userRepo.fetchUser();
        users.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
        _allUsers = users;

        emit(UserLoaded(users: users));
      } catch (e) {
        try {
          final users = await userRepo.fetchUsersFromDb();
          if (users.isNotEmpty) {
            _allUsers = users;
            emit(UserLoaded(users: _allUsers));
          } else {
            emit(UserError(error: 'No internet and no cached data available.'));
          }
        } catch (dbError) {
          emit(UserError(error: 'Failed to load offline data: $dbError'));
        }
      }
    });
    on<SearchUsers>((event, emit) {
      if (state is! UserLoaded) return;
      final query = event.searchQuery.toLowerCase();
      final filteredList = query.isEmpty
          ? _allUsers
          : _allUsers
                .where((u) => u.name.toLowerCase().contains(query))
                .toList();
      emit(UserLoaded(users: filteredList));
    });
  }
}
