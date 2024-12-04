// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  PatientDao? _patientDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `patients` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `phone` TEXT NOT NULL, `address` TEXT NOT NULL, `unionTemporaryCode` TEXT, `treatmentRegimen` TEXT, `tbType` TEXT, `patientId` INTEGER NOT NULL, `volunteerId` INTEGER NOT NULL, `dotsStartDate` TEXT, `dotsEndDate` TEXT, `treatmentOutcome` TEXT, `treatmentOutcomeDate` TEXT, `dotsPatientType` TEXT, `actualTreatmentStartDate` TEXT, `type` TEXT, `remark` TEXT)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  PatientDao get patientDao {
    return _patientDaoInstance ??= _$PatientDao(database, changeListener);
  }
}

class _$PatientDao extends PatientDao {
  _$PatientDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _patientInsertionAdapter = InsertionAdapter(
            database,
            'patients',
            (Patient item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'phone': item.phone,
                  'address': item.address,
                  'unionTemporaryCode': item.unionTemporaryCode,
                  'treatmentRegimen': item.treatmentRegimen,
                  'tbType': item.tbType,
                  'patientId': item.patientId,
                  'volunteerId': item.volunteerId,
                  'dotsStartDate': item.dotsStartDate,
                  'dotsEndDate': item.dotsEndDate,
                  'treatmentOutcome': item.treatmentOutcome,
                  'treatmentOutcomeDate': item.treatmentOutcomeDate,
                  'dotsPatientType': item.dotsPatientType,
                  'actualTreatmentStartDate': item.actualTreatmentStartDate,
                  'type': item.type,
                  'remark': item.remark
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Patient> _patientInsertionAdapter;

  @override
  Future<List<Patient>> findAllLocalPatients() async {
    return _queryAdapter.queryList('SELECT * FROM patients',
        mapper: (Map<String, Object?> row) => Patient(
            row['name'] as String,
            row['phone'] as String,
            row['address'] as String,
            row['unionTemporaryCode'] as String?,
            row['treatmentRegimen'] as String?,
            row['tbType'] as String?,
            row['patientId'] as int,
            row['volunteerId'] as int,
            row['dotsStartDate'] as String?,
            row['dotsEndDate'] as String?,
            row['treatmentOutcome'] as String?,
            row['treatmentOutcomeDate'] as String?,
            row['dotsPatientType'] as String?,
            row['actualTreatmentStartDate'] as String?,
            row['type'] as String?,
            row['remark'] as String?,
            id: row['id'] as int?));
  }

  @override
  Future<Patient?> findLocalPatientById(int id) async {
    return _queryAdapter.query('SELECT * FROM patients WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Patient(
            row['name'] as String,
            row['phone'] as String,
            row['address'] as String,
            row['unionTemporaryCode'] as String?,
            row['treatmentRegimen'] as String?,
            row['tbType'] as String?,
            row['patientId'] as int,
            row['volunteerId'] as int,
            row['dotsStartDate'] as String?,
            row['dotsEndDate'] as String?,
            row['treatmentOutcome'] as String?,
            row['treatmentOutcomeDate'] as String?,
            row['dotsPatientType'] as String?,
            row['actualTreatmentStartDate'] as String?,
            row['type'] as String?,
            row['remark'] as String?,
            id: row['id'] as int?),
        arguments: [id]);
  }

  @override
  Future<void> deleteAllLocalPatients() async {
    await _queryAdapter.queryNoReturn('DELETE FROM patients');
  }

  @override
  Future<void> insertLocalPatients(List<Patient> patients) async {
    await _patientInsertionAdapter.insertList(
        patients, OnConflictStrategy.replace);
  }

  @override
  Future<int> insertLocalPatient(Patient patient) {
    return _patientInsertionAdapter.insertAndReturnId(
        patient, OnConflictStrategy.replace);
  }
}
