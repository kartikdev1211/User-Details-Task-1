import 'package:user_details/data/db_provider.dart';
import 'package:user_details/models/user_model.dart';
import 'package:user_details/repo/user_repo.dart';

class LocalRepo {
  final db = DBHelper();
  final data = UserRepo();
  Future<List<User>> getUser() async {
    final remote = await data.fetchUser();
    await db.insertUsers(remote);

    return db.getUsers();
  }
}
