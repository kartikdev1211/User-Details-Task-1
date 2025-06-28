import 'package:sqflite/sqflite.dart';
import 'package:user_details/models/user_model.dart';
import 'package:path/path.dart';
class DBProvider{
  static Database? db;
  static const table="users";
  Future<Database> get database async{
    db??=await _init();
    return db!;
  }
  Future<Database> _init() async {
    final path = join(await getDatabasesPath(), 'users.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE $table (
            id INTEGER PRIMARY KEY,
            name TEXT,
            username TEXT,
            email TEXT,
            phone TEXT,
            website TEXT,
            address TEXT,   -- JSON string
            company TEXT    -- JSON string
          )
        ''');
      },
    );
  }
  Future<void> insertUsers(List<User> users)async{
    final db=await database;
    final batch=db.batch();
    for(var u in users){
      batch.insert(table, u.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);

    }
    await batch.commit(noResult: true);
  }
  Future<List<User>> getUser()async{
    final db=await database;
    final row=await db.query(table,orderBy: 'name ASC');
    return row.map(User.fromMap).toList();
  }
  Future<bool> isEmpty()async=>(await (await database).query(table,limit: 1)).isEmpty;
}