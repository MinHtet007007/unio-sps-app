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

  SupportMonthDao? _supportMonthDaoInstance;

  ReceivePackageDao? _receivePackageDaoInstance;

  PatientPackageDao? _patientPackageDaoInstance;

  UserTownshipDao? _userTownshipDaoInstance;

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
            'CREATE TABLE IF NOT EXISTS `patients` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `remoteId` INTEGER, `year` TEXT NOT NULL, `spsStartDate` TEXT, `townshipId` INTEGER NOT NULL, `rrCode` TEXT, `drtbCode` TEXT NOT NULL, `spCode` TEXT NOT NULL, `uniqueId` TEXT, `name` TEXT NOT NULL, `age` INTEGER NOT NULL, `sex` TEXT NOT NULL, `diedBeforeTreatmentEnrollment` TEXT, `treatmentStartDate` TEXT, `treatmentRegimen` TEXT NOT NULL, `treatmentRegimenOther` TEXT, `patientAddress` TEXT NOT NULL, `patientPhoneNo` TEXT NOT NULL, `contactInfo` TEXT NOT NULL, `contactPhoneNo` TEXT NOT NULL, `primaryLanguage` TEXT NOT NULL, `secondaryLanguage` TEXT, `height` INTEGER NOT NULL, `weight` INTEGER NOT NULL, `bmi` INTEGER NOT NULL, `toStatus` TEXT, `toYear` INTEGER, `toDate` TEXT, `toRrCode` TEXT, `toDrtbCode` TEXT, `toUniqueId` TEXT, `toTownshipId` INTEGER, `outcome` TEXT, `remark` TEXT, `treatmentFinished` TEXT, `treatmentFinishedDate` TEXT, `outcomeDate` TEXT, `isReported` TEXT, `reportPeriod` TEXT, `currentTownshipId` INTEGER NOT NULL, `isSynced` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `patient_support_months` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `remoteId` INTEGER, `localPatientId` INTEGER NOT NULL, `remotePatientId` INTEGER, `patientName` TEXT NOT NULL, `townshipId` INTEGER NOT NULL, `date` TEXT NOT NULL, `month` INTEGER NOT NULL, `monthYear` TEXT NOT NULL, `height` INTEGER NOT NULL, `weight` INTEGER NOT NULL, `bmi` INTEGER NOT NULL, `planPackages` TEXT NOT NULL, `receivePackageStatus` TEXT NOT NULL, `reimbursementStatus` TEXT NOT NULL, `amount` INTEGER, `remark` TEXT, `supportMonthSignature` BLOB, `isSynced` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `patient_support_packages` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `remoteId` INTEGER, `localPatientSupportMonthId` INTEGER, `remotePatientPackageId` INTEGER, `localPatientPackageId` INTEGER, `amount` INTEGER NOT NULL, `patientPackageName` TEXT NOT NULL, `reimbursementMonth` INTEGER, `reimbursementMonthYear` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `patient_packages` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `remoteId` INTEGER, `localPatientId` INTEGER NOT NULL, `remotePatientId` INTEGER, `packageName` TEXT NOT NULL, `eligibleAmount` INTEGER NOT NULL, `updatedEligibleAmount` INTEGER, `remainingAmount` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `user_townships` (`id` INTEGER, `name` TEXT NOT NULL, `abbreviation` TEXT NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  PatientDao get patientDao {
    return _patientDaoInstance ??= _$PatientDao(database, changeListener);
  }

  @override
  SupportMonthDao get supportMonthDao {
    return _supportMonthDaoInstance ??=
        _$SupportMonthDao(database, changeListener);
  }

  @override
  ReceivePackageDao get receivePackageDao {
    return _receivePackageDaoInstance ??=
        _$ReceivePackageDao(database, changeListener);
  }

  @override
  PatientPackageDao get patientPackageDao {
    return _patientPackageDaoInstance ??=
        _$PatientPackageDao(database, changeListener);
  }

  @override
  UserTownshipDao get userTownshipDao {
    return _userTownshipDaoInstance ??=
        _$UserTownshipDao(database, changeListener);
  }
}

class _$PatientDao extends PatientDao {
  _$PatientDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _patientEntityInsertionAdapter = InsertionAdapter(
            database,
            'patients',
            (PatientEntity item) => <String, Object?>{
                  'id': item.id,
                  'remoteId': item.remoteId,
                  'year': item.year,
                  'spsStartDate': item.spsStartDate,
                  'townshipId': item.townshipId,
                  'rrCode': item.rrCode,
                  'drtbCode': item.drtbCode,
                  'spCode': item.spCode,
                  'uniqueId': item.uniqueId,
                  'name': item.name,
                  'age': item.age,
                  'sex': item.sex,
                  'diedBeforeTreatmentEnrollment':
                      item.diedBeforeTreatmentEnrollment,
                  'treatmentStartDate': item.treatmentStartDate,
                  'treatmentRegimen': item.treatmentRegimen,
                  'treatmentRegimenOther': item.treatmentRegimenOther,
                  'patientAddress': item.patientAddress,
                  'patientPhoneNo': item.patientPhoneNo,
                  'contactInfo': item.contactInfo,
                  'contactPhoneNo': item.contactPhoneNo,
                  'primaryLanguage': item.primaryLanguage,
                  'secondaryLanguage': item.secondaryLanguage,
                  'height': item.height,
                  'weight': item.weight,
                  'bmi': item.bmi,
                  'toStatus': item.toStatus,
                  'toYear': item.toYear,
                  'toDate': item.toDate,
                  'toRrCode': item.toRrCode,
                  'toDrtbCode': item.toDrtbCode,
                  'toUniqueId': item.toUniqueId,
                  'toTownshipId': item.toTownshipId,
                  'outcome': item.outcome,
                  'remark': item.remark,
                  'treatmentFinished': item.treatmentFinished,
                  'treatmentFinishedDate': item.treatmentFinishedDate,
                  'outcomeDate': item.outcomeDate,
                  'isReported': item.isReported,
                  'reportPeriod': item.reportPeriod,
                  'currentTownshipId': item.currentTownshipId,
                  'isSynced': item.isSynced ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<PatientEntity> _patientEntityInsertionAdapter;

  @override
  Future<List<PatientEntity>> findAllLocalPatients() async {
    return _queryAdapter.queryList('SELECT * FROM patients',
        mapper: (Map<String, Object?> row) => PatientEntity(
            id: row['id'] as int?,
            year: row['year'] as String,
            remoteId: row['remoteId'] as int?,
            spsStartDate: row['spsStartDate'] as String?,
            townshipId: row['townshipId'] as int,
            rrCode: row['rrCode'] as String?,
            drtbCode: row['drtbCode'] as String,
            spCode: row['spCode'] as String,
            uniqueId: row['uniqueId'] as String?,
            name: row['name'] as String,
            age: row['age'] as int,
            sex: row['sex'] as String,
            diedBeforeTreatmentEnrollment:
                row['diedBeforeTreatmentEnrollment'] as String?,
            treatmentStartDate: row['treatmentStartDate'] as String?,
            treatmentRegimen: row['treatmentRegimen'] as String,
            treatmentRegimenOther: row['treatmentRegimenOther'] as String?,
            patientAddress: row['patientAddress'] as String,
            patientPhoneNo: row['patientPhoneNo'] as String,
            contactInfo: row['contactInfo'] as String,
            contactPhoneNo: row['contactPhoneNo'] as String,
            primaryLanguage: row['primaryLanguage'] as String,
            secondaryLanguage: row['secondaryLanguage'] as String?,
            height: row['height'] as int,
            weight: row['weight'] as int,
            bmi: row['bmi'] as int,
            toStatus: row['toStatus'] as String?,
            toYear: row['toYear'] as int?,
            toDate: row['toDate'] as String?,
            toRrCode: row['toRrCode'] as String?,
            toDrtbCode: row['toDrtbCode'] as String?,
            toUniqueId: row['toUniqueId'] as String?,
            toTownshipId: row['toTownshipId'] as int?,
            outcome: row['outcome'] as String?,
            remark: row['remark'] as String?,
            treatmentFinished: row['treatmentFinished'] as String?,
            treatmentFinishedDate: row['treatmentFinishedDate'] as String?,
            outcomeDate: row['outcomeDate'] as String?,
            isReported: row['isReported'] as String?,
            reportPeriod: row['reportPeriod'] as String?,
            currentTownshipId: row['currentTownshipId'] as int,
            isSynced: (row['isSynced'] as int) != 0));
  }

  @override
  Future<PatientEntity?> findLocalPatientById(int id) async {
    return _queryAdapter.query('SELECT * FROM patients WHERE id = ?1',
        mapper: (Map<String, Object?> row) => PatientEntity(
            id: row['id'] as int?,
            year: row['year'] as String,
            remoteId: row['remoteId'] as int?,
            spsStartDate: row['spsStartDate'] as String?,
            townshipId: row['townshipId'] as int,
            rrCode: row['rrCode'] as String?,
            drtbCode: row['drtbCode'] as String,
            spCode: row['spCode'] as String,
            uniqueId: row['uniqueId'] as String?,
            name: row['name'] as String,
            age: row['age'] as int,
            sex: row['sex'] as String,
            diedBeforeTreatmentEnrollment:
                row['diedBeforeTreatmentEnrollment'] as String?,
            treatmentStartDate: row['treatmentStartDate'] as String?,
            treatmentRegimen: row['treatmentRegimen'] as String,
            treatmentRegimenOther: row['treatmentRegimenOther'] as String?,
            patientAddress: row['patientAddress'] as String,
            patientPhoneNo: row['patientPhoneNo'] as String,
            contactInfo: row['contactInfo'] as String,
            contactPhoneNo: row['contactPhoneNo'] as String,
            primaryLanguage: row['primaryLanguage'] as String,
            secondaryLanguage: row['secondaryLanguage'] as String?,
            height: row['height'] as int,
            weight: row['weight'] as int,
            bmi: row['bmi'] as int,
            toStatus: row['toStatus'] as String?,
            toYear: row['toYear'] as int?,
            toDate: row['toDate'] as String?,
            toRrCode: row['toRrCode'] as String?,
            toDrtbCode: row['toDrtbCode'] as String?,
            toUniqueId: row['toUniqueId'] as String?,
            toTownshipId: row['toTownshipId'] as int?,
            outcome: row['outcome'] as String?,
            remark: row['remark'] as String?,
            treatmentFinished: row['treatmentFinished'] as String?,
            treatmentFinishedDate: row['treatmentFinishedDate'] as String?,
            outcomeDate: row['outcomeDate'] as String?,
            isReported: row['isReported'] as String?,
            reportPeriod: row['reportPeriod'] as String?,
            currentTownshipId: row['currentTownshipId'] as int,
            isSynced: (row['isSynced'] as int) != 0),
        arguments: [id]);
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM patients');
  }

  @override
  Future<void> updatePatientSyncedStatus(
    int id,
    bool isSynced,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE patients SET isSynced = ?2 WHERE id = ?1',
        arguments: [id, isSynced ? 1 : 0]);
  }

  @override
  Future<void> insertMany(List<PatientEntity> patients) async {
    await _patientEntityInsertionAdapter.insertList(
        patients, OnConflictStrategy.replace);
  }

  @override
  Future<int> insertLocalPatient(PatientEntity patient) {
    return _patientEntityInsertionAdapter.insertAndReturnId(
        patient, OnConflictStrategy.replace);
  }
}

class _$SupportMonthDao extends SupportMonthDao {
  _$SupportMonthDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _supportMonthEntityInsertionAdapter = InsertionAdapter(
            database,
            'patient_support_months',
            (SupportMonthEntity item) => <String, Object?>{
                  'id': item.id,
                  'remoteId': item.remoteId,
                  'localPatientId': item.localPatientId,
                  'remotePatientId': item.remotePatientId,
                  'patientName': item.patientName,
                  'townshipId': item.townshipId,
                  'date': item.date,
                  'month': item.month,
                  'monthYear': item.monthYear,
                  'height': item.height,
                  'weight': item.weight,
                  'bmi': item.bmi,
                  'planPackages': item.planPackages,
                  'receivePackageStatus': item.receivePackageStatus,
                  'reimbursementStatus': item.reimbursementStatus,
                  'amount': item.amount,
                  'remark': item.remark,
                  'supportMonthSignature': item.supportMonthSignature,
                  'isSynced': item.isSynced ? 1 : 0
                }),
        _supportMonthEntityUpdateAdapter = UpdateAdapter(
            database,
            'patient_support_months',
            ['id'],
            (SupportMonthEntity item) => <String, Object?>{
                  'id': item.id,
                  'remoteId': item.remoteId,
                  'localPatientId': item.localPatientId,
                  'remotePatientId': item.remotePatientId,
                  'patientName': item.patientName,
                  'townshipId': item.townshipId,
                  'date': item.date,
                  'month': item.month,
                  'monthYear': item.monthYear,
                  'height': item.height,
                  'weight': item.weight,
                  'bmi': item.bmi,
                  'planPackages': item.planPackages,
                  'receivePackageStatus': item.receivePackageStatus,
                  'reimbursementStatus': item.reimbursementStatus,
                  'amount': item.amount,
                  'remark': item.remark,
                  'supportMonthSignature': item.supportMonthSignature,
                  'isSynced': item.isSynced ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SupportMonthEntity>
      _supportMonthEntityInsertionAdapter;

  final UpdateAdapter<SupportMonthEntity> _supportMonthEntityUpdateAdapter;

  @override
  Future<List<SupportMonthEntity>> getAllSupportMonths() async {
    return _queryAdapter.queryList('SELECT * FROM patient_support_months',
        mapper: (Map<String, Object?> row) => SupportMonthEntity(
            id: row['id'] as int?,
            remoteId: row['remoteId'] as int?,
            localPatientId: row['localPatientId'] as int,
            remotePatientId: row['remotePatientId'] as int?,
            patientName: row['patientName'] as String,
            townshipId: row['townshipId'] as int,
            date: row['date'] as String,
            month: row['month'] as int,
            monthYear: row['monthYear'] as String,
            height: row['height'] as int,
            weight: row['weight'] as int,
            bmi: row['bmi'] as int,
            planPackages: row['planPackages'] as String,
            receivePackageStatus: row['receivePackageStatus'] as String,
            reimbursementStatus: row['reimbursementStatus'] as String,
            amount: row['amount'] as int?,
            remark: row['remark'] as String?,
            supportMonthSignature: row['supportMonthSignature'] as Uint8List?,
            isSynced: (row['isSynced'] as int) != 0));
  }

  @override
  Future<List<SupportMonthEntity>> getSupportMonthsByLocalPatientId(
      int localPatientId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM patient_support_months WHERE localPatientId = ?1',
        mapper: (Map<String, Object?> row) => SupportMonthEntity(
            id: row['id'] as int?,
            remoteId: row['remoteId'] as int?,
            localPatientId: row['localPatientId'] as int,
            remotePatientId: row['remotePatientId'] as int?,
            patientName: row['patientName'] as String,
            townshipId: row['townshipId'] as int,
            date: row['date'] as String,
            month: row['month'] as int,
            monthYear: row['monthYear'] as String,
            height: row['height'] as int,
            weight: row['weight'] as int,
            bmi: row['bmi'] as int,
            planPackages: row['planPackages'] as String,
            receivePackageStatus: row['receivePackageStatus'] as String,
            reimbursementStatus: row['reimbursementStatus'] as String,
            amount: row['amount'] as int?,
            remark: row['remark'] as String?,
            supportMonthSignature: row['supportMonthSignature'] as Uint8List?,
            isSynced: (row['isSynced'] as int) != 0),
        arguments: [localPatientId]);
  }

  @override
  Future<List<SupportMonthEntity>> getSupportMonthsByTownshipId(
      int townshipId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM patient_support_months WHERE townshipId = ?1',
        mapper: (Map<String, Object?> row) => SupportMonthEntity(
            id: row['id'] as int?,
            remoteId: row['remoteId'] as int?,
            localPatientId: row['localPatientId'] as int,
            remotePatientId: row['remotePatientId'] as int?,
            patientName: row['patientName'] as String,
            townshipId: row['townshipId'] as int,
            date: row['date'] as String,
            month: row['month'] as int,
            monthYear: row['monthYear'] as String,
            height: row['height'] as int,
            weight: row['weight'] as int,
            bmi: row['bmi'] as int,
            planPackages: row['planPackages'] as String,
            receivePackageStatus: row['receivePackageStatus'] as String,
            reimbursementStatus: row['reimbursementStatus'] as String,
            amount: row['amount'] as int?,
            remark: row['remark'] as String?,
            supportMonthSignature: row['supportMonthSignature'] as Uint8List?,
            isSynced: (row['isSynced'] as int) != 0),
        arguments: [townshipId]);
  }

  @override
  Future<SupportMonthEntity?> getSupportMonthById(int id) async {
    return _queryAdapter.query(
        'SELECT * FROM patient_support_months WHERE id = ?1',
        mapper: (Map<String, Object?> row) => SupportMonthEntity(
            id: row['id'] as int?,
            remoteId: row['remoteId'] as int?,
            localPatientId: row['localPatientId'] as int,
            remotePatientId: row['remotePatientId'] as int?,
            patientName: row['patientName'] as String,
            townshipId: row['townshipId'] as int,
            date: row['date'] as String,
            month: row['month'] as int,
            monthYear: row['monthYear'] as String,
            height: row['height'] as int,
            weight: row['weight'] as int,
            bmi: row['bmi'] as int,
            planPackages: row['planPackages'] as String,
            receivePackageStatus: row['receivePackageStatus'] as String,
            reimbursementStatus: row['reimbursementStatus'] as String,
            amount: row['amount'] as int?,
            remark: row['remark'] as String?,
            supportMonthSignature: row['supportMonthSignature'] as Uint8List?,
            isSynced: (row['isSynced'] as int) != 0),
        arguments: [id]);
  }

  @override
  Future<void> deleteSupportMonthById(int id) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM patient_support_months WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> deleteSupportMonthsByPatientId(int patientId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM patient_support_months WHERE patientId = ?1',
        arguments: [patientId]);
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM patient_support_months');
  }

  @override
  Future<int> insertSupportMonth(SupportMonthEntity supportMonth) {
    return _supportMonthEntityInsertionAdapter.insertAndReturnId(
        supportMonth, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertMany(List<SupportMonthEntity> supportMonths) async {
    await _supportMonthEntityInsertionAdapter.insertList(
        supportMonths, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateSupportMonth(SupportMonthEntity supportMonth) async {
    await _supportMonthEntityUpdateAdapter.update(
        supportMonth, OnConflictStrategy.replace);
  }
}

class _$ReceivePackageDao extends ReceivePackageDao {
  _$ReceivePackageDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _receivePackageEntityInsertionAdapter = InsertionAdapter(
            database,
            'patient_support_packages',
            (ReceivePackageEntity item) => <String, Object?>{
                  'id': item.id,
                  'remoteId': item.remoteId,
                  'localPatientSupportMonthId': item.localPatientSupportMonthId,
                  'remotePatientPackageId': item.remotePatientPackageId,
                  'localPatientPackageId': item.localPatientPackageId,
                  'amount': item.amount,
                  'patientPackageName': item.patientPackageName,
                  'reimbursementMonth': item.reimbursementMonth,
                  'reimbursementMonthYear': item.reimbursementMonthYear
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ReceivePackageEntity>
      _receivePackageEntityInsertionAdapter;

  @override
  Future<List<ReceivePackageEntity>> getAllReceivePackages() async {
    return _queryAdapter.queryList('SELECT * FROM patient_support_packages',
        mapper: (Map<String, Object?> row) => ReceivePackageEntity(
            id: row['id'] as int?,
            remoteId: row['remoteId'] as int?,
            amount: row['amount'] as int,
            localPatientSupportMonthId:
                row['localPatientSupportMonthId'] as int?,
            remotePatientPackageId: row['remotePatientPackageId'] as int?,
            localPatientPackageId: row['localPatientPackageId'] as int?,
            patientPackageName: row['patientPackageName'] as String,
            reimbursementMonth: row['reimbursementMonth'] as int?,
            reimbursementMonthYear: row['reimbursementMonthYear'] as String?));
  }

  @override
  Future<void> deleteReceivePackage(int id) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM patient_support_packages WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<List<ReceivePackageEntity>> getReceivePackagesBySupportMonth(
      int supportMonthId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM patient_support_packages WHERE localPatientSupportMonthId = ?1',
        mapper: (Map<String, Object?> row) => ReceivePackageEntity(id: row['id'] as int?, remoteId: row['remoteId'] as int?, amount: row['amount'] as int, localPatientSupportMonthId: row['localPatientSupportMonthId'] as int?, remotePatientPackageId: row['remotePatientPackageId'] as int?, localPatientPackageId: row['localPatientPackageId'] as int?, patientPackageName: row['patientPackageName'] as String, reimbursementMonth: row['reimbursementMonth'] as int?, reimbursementMonthYear: row['reimbursementMonthYear'] as String?),
        arguments: [supportMonthId]);
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM patient_support_packages');
  }

  @override
  Future<void> insertReceivePackage(ReceivePackageEntity receivePackage) async {
    await _receivePackageEntityInsertionAdapter.insert(
        receivePackage, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertMany(List<ReceivePackageEntity> receivePackages) async {
    await _receivePackageEntityInsertionAdapter.insertList(
        receivePackages, OnConflictStrategy.replace);
  }
}

class _$PatientPackageDao extends PatientPackageDao {
  _$PatientPackageDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _patientPackageEntityInsertionAdapter = InsertionAdapter(
            database,
            'patient_packages',
            (PatientPackageEntity item) => <String, Object?>{
                  'id': item.id,
                  'remoteId': item.remoteId,
                  'localPatientId': item.localPatientId,
                  'remotePatientId': item.remotePatientId,
                  'packageName': item.packageName,
                  'eligibleAmount': item.eligibleAmount,
                  'updatedEligibleAmount': item.updatedEligibleAmount,
                  'remainingAmount': item.remainingAmount
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<PatientPackageEntity>
      _patientPackageEntityInsertionAdapter;

  @override
  Future<List<PatientPackageEntity>> getAllPatientPackages() async {
    return _queryAdapter.queryList('SELECT * FROM patient_packages',
        mapper: (Map<String, Object?> row) => PatientPackageEntity(
            id: row['id'] as int?,
            remoteId: row['remoteId'] as int?,
            localPatientId: row['localPatientId'] as int,
            remotePatientId: row['remotePatientId'] as int?,
            packageName: row['packageName'] as String,
            eligibleAmount: row['eligibleAmount'] as int,
            updatedEligibleAmount: row['updatedEligibleAmount'] as int?,
            remainingAmount: row['remainingAmount'] as int));
  }

  @override
  Future<List<PatientPackageEntity>> getPatientPackagesByPatientId(
      int patientId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM patient_packages WHERE localPatientId = ?1',
        mapper: (Map<String, Object?> row) => PatientPackageEntity(
            id: row['id'] as int?,
            remoteId: row['remoteId'] as int?,
            localPatientId: row['localPatientId'] as int,
            remotePatientId: row['remotePatientId'] as int?,
            packageName: row['packageName'] as String,
            eligibleAmount: row['eligibleAmount'] as int,
            updatedEligibleAmount: row['updatedEligibleAmount'] as int?,
            remainingAmount: row['remainingAmount'] as int),
        arguments: [patientId]);
  }

  @override
  Future<void> deletePatientPackage(int id) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM patient_packages WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM patient_packages');
  }

  @override
  Future<void> subtractFromRemainingAmount(
    int id,
    int amount,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE patient_packages SET remainingAmount = remainingAmount - ?2 WHERE id = ?1',
        arguments: [id, amount]);
  }

  @override
  Future<void> insertPatientPackage(PatientPackageEntity patientPackage) async {
    await _patientPackageEntityInsertionAdapter.insert(
        patientPackage, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertMany(List<PatientPackageEntity> patientPackages) async {
    await _patientPackageEntityInsertionAdapter.insertList(
        patientPackages, OnConflictStrategy.replace);
  }
}

class _$UserTownshipDao extends UserTownshipDao {
  _$UserTownshipDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _userTownshipEntityInsertionAdapter = InsertionAdapter(
            database,
            'user_townships',
            (UserTownshipEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'abbreviation': item.abbreviation
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UserTownshipEntity>
      _userTownshipEntityInsertionAdapter;

  @override
  Future<List<UserTownshipEntity>> getAllUserTownships() async {
    return _queryAdapter.queryList('SELECT * FROM user_townships',
        mapper: (Map<String, Object?> row) => UserTownshipEntity(
            id: row['id'] as int?,
            name: row['name'] as String,
            abbreviation: row['abbreviation'] as String));
  }

  @override
  Future<void> deleteAllUserTownships() async {
    await _queryAdapter.queryNoReturn('DELETE FROM user_townships');
  }

  @override
  Future<void> insertUserTownshipEntity(
      UserTownshipEntity userTownshipEntity) async {
    await _userTownshipEntityInsertionAdapter.insert(
        userTownshipEntity, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertAllUserTownships(
      List<UserTownshipEntity> userTownshipEntity) async {
    await _userTownshipEntityInsertionAdapter.insertList(
        userTownshipEntity, OnConflictStrategy.replace);
  }
}
