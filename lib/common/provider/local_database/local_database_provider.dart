import 'package:sps/local_database/local_database.dart';
import 'package:sps/local_database/tables/local_database_tables.dart';

class DatabaseProvider {
  static final DatabaseProvider _instance = DatabaseProvider._internal();
  static AppDatabase? _database;

  DatabaseProvider._internal();

  factory DatabaseProvider() {
    return _instance;
  }

  Future<AppDatabase> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<AppDatabase> _initDatabase() async {
    final database =
        await $FloorAppDatabase.databaseBuilder(LocalDataBase.dataBase).build();
    return database;
  }
}
