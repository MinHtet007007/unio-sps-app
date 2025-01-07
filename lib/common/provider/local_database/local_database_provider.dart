import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sps/local_database/local_database.dart';
import 'package:sps/local_database/tables/local_database_tables.dart';

class LocalDatabase {
  static final LocalDatabase _instance = LocalDatabase._internal();
  static AppDatabase? _database;

  LocalDatabase._internal();

  factory LocalDatabase() {
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

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}

final localDatabaseProvider = Provider<LocalDatabase>((ref) {
  return LocalDatabase();
});
