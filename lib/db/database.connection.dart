import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseConnection {
  Future<Database> setDatabase() async {
    //var directory = await getApplicationDocumentsDirectory();
    //var path = join(directory.path, 'db_crud');
    var path = join(await getDatabasesPath(), 'db_crud');
    await deleteDatabase(path);
    var database =
        await openDatabase(path, version: 1, onCreate: _createDatabase);
    return database;
  }

  Future<void> _createDatabase(Database database, int version) async {
    String sqlRecensement =
        "CREATE TABLE encaissement (id INTEGER PRIMARY KEY, nomClient TEXT, prenomClient TEXT, numeroCompteur TEXT, montantClient REAL, sexeClient TEXT, telephoneClient TEXT, dateEncaissement TEXT, matriculeAgent TEXT);";
    await database.execute(sqlRecensement);

    // String sqlLogin =
    //     "CREATE TABLE users(id INTEGER PRIMARY KEY, username TEXT, password TEXT);";
    // await database.execute(sqlLogin);

    String sqlContrat =
        "CREATE TABLE contrat(id INTEGER PRIMARY KEY, reference TEXT, type TEXT, startDate TEXT, endDate TEXT, offer TEXT, status TEXT, clientId TEXT);";
    await database.execute(sqlContrat);
  }
}
