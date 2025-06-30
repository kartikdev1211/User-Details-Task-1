import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/user_model.dart';

class DBHelper {
  static Database? _db;

  Future<Database> get database async {
    return _db ??= await initDb();
  }

  Future<Database> initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'user.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY,
        name TEXT,
        username TEXT,
        email TEXT,
        phone TEXT,
        website TEXT,
        address TEXT,
        company TEXT
      )
    ''');
      },
    );
  }

  Future<void> insertUsers(List<User> users) async {
    final db = await database;
    for (var user in users) {
      await db.insert(
        'users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<User>> getUsers() async {
    final db = await database;
    final result = await db.query('users', orderBy: 'name ASC');
    return result.map((e) => User.fromMap(e)).toList();
  }

  Future<void> clearUsers() async {
    final db = await database;
    await db.delete('users');
  }
}
