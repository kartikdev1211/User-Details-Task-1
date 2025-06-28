import 'package:user_details/data/db_provider.dart';
import 'package:user_details/models/user_model.dart';
import 'package:user_details/repo/user_repo.dart';

class LocalRepo{
  final db=DBProvider();
  final data=UserRepo();
  Future<List<User>> getUsers()async{
    if(await db.isEmpty()){
      final remote=await data.fetchUser();
      await db.insertUsers(remote);
    }
    return db.getUser();
  }
}