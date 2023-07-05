import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  DatabaseHelper.internal();

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'my_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');
  }

  Future<int> createUser(String username, String password) async {
    final db = await this.db;
    final user = {
      'username': username,
      'password': password,
    };
    return await db.insert('users', user);
  }

  Future<bool> authenticateUser(String username, String password) async {
    final db = await this.db;
    final result = await db.rawQuery('''
      SELECT COUNT(*) as count FROM users WHERE username = ? AND password = ?
    ''', [username, password]);

    return result.isNotEmpty && result.first['count'] == 1;
  }
}
