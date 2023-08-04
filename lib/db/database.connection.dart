import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseConnection {
  Future<Database> setDatabase() async {
    var path = join(await getDatabasesPath(), 'fresApp_db');
    await deleteDatabase(path);
    var database =
        await openDatabase(path, version: 1, onCreate: _createDatabase);
    return database;
  }

  Future<void> _createDatabase(Database database, int version) async {
    String sqlPayment =
        "CREATE TABLE payment (id TEXT PRIMARY KEY, agent TEXT, contract TEXT, amount REAL, paymentDate TEXT);";
    await database.execute(sqlPayment);

    String sqlContract =
        "CREATE TABLE contract(reference TEXT PRIMARY KEY, offer TEXT, clientName TEXT,)";
    await database.execute(sqlContract);

    String sqlClient =
        "CREATE TABLE client(id TEXT, reference INTEGER PRIMARY KEY, firstName TEXT, lastName TEXT, village TEXT, phoneNumber TEXT);";
    await database.execute(sqlClient);

    String sqlUser =
        "CREATE TABLE user(id TEXT PRIMARY KEY, email TEXT, phoneNumber TEXT, password TEXT, firstName TEXT, lastName TEXT);";
    await database.execute(sqlUser);
  }
}
